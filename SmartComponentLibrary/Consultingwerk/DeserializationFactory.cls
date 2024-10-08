/**********************************************************************
 * Copyright (C) 2006-2024 by Consultingwerk Ltd. ("CW") -            *
 * www.consultingwerk.de and other contributors as listed             *
 * below.  All Rights Reserved.                                       *
 *                                                                    *
 *  Software is distributed on an "AS IS", WITHOUT WARRANTY OF ANY    *
 *   KIND, either express or implied.                                 *
 *                                                                    *
 *  Contributors:                                                     *
 *                                                                    *
 **********************************************************************/
/*------------------------------------------------------------------------
    File        : DeserializationFactory
    Purpose     : Default IDeserializationFactory implementation
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Aug 25 00:03:15 CEST 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*            from propath .
using Consultingwerk.Exceptions.* from propath.
using Consultingwerk.Util.*       from propath .
using Progress.Json.ObjectModel.* from propath .
using Progress.Lang.*             from propath .
using Progress.IO.*               from propath .

class Consultingwerk.DeserializationFactory implements IDeserializationFactory:

    define static temp-table ttDeSerialization no-undo xml-node-name "Serialization":U
        field ClassName  as character
        field Properties as CLOB .

    /**
     * Purpose: Deserializes a LONGCHAR representation of an object to a new
     *          instance
     * Notes:   Supports XML and JSON Serialized objects
     * @param plcSerializable The serialized representation to be deserialized
     * @return The LONGCHAR representation of the ISerializable objects data
     */
    method public ISerializable DeserializeInstance (plcSerializable as longchar):

        define variable oInstance      as ISerializable              no-undo .
        define variable lFromTempTable as logical                    no-undo .
        define variable hDocument      as handle                     no-undo .
        define variable hRootNode      as handle                     no-undo .
        define variable cClassName     as character                  no-undo .
        define variable oFormat        as NumericFormat              no-undo .

        define variable oJsonError     as JsonSerializationException no-undo .

/* Mike Fechner, Consultingwerk Ltd. 19.11.2012
   JsonSerialization not available on OpenEdge 10.2B */
&if not proversion eq "10.2B" &then
        define variable oJsonInstance as IJsonSerializable no-undo .
        define variable oJsonObject   as JsonObject        no-undo .
        define variable oObjectModel  as ObjectModelParser no-undo .

        if plcSerializable begins "~{":U then do on error undo, throw:

&if not proversion begins "11.3" and not proversion begins "11.4" and not proversion begins "11.5" &then
            /* SCL-1817: Support for native serialization */
            if plcSerializable matches "*prods:version*":U and
               plcSerializable matches "*prods:objId*":U then

                return this-object:DeserializeNativeJson (plcSerializable) .
&endif

            /* SCL-514: Perform JSON Serialization/Deserialization with AMERICAN
                        numeric format to avoid issues with decimal point interpretation */
            oFormat = SessionHelper:GetNumericFormat() .
            SessionHelper:SetDefaultNumericFormat() .

            oObjectModel = new ObjectModelParser () .

            oJsonObject = cast (oObjectModel:Parse (plcSerializable), JsonObject).

            if not oJsonObject:Has ("SerializedType":U) then do:
                oJsonError = new JsonSerializationException ("Unable to deserialize from JsonString without SerializedType information."{&TRAN}, 0) .
                oJsonError:AddMessage ("You need to ensure that the JsonString provides the SerializedType attribute."{&TRAN}, 0) .

                undo, throw oJsonError .
            end.

            oJsonInstance = dynamic-new (oJsonObject:GetCharacter ("SerializedType":U)) ().
            oJsonInstance:DeserializeFromJsonObject (oJsonObject) .

            oInstance = oJsonInstance .

            finally:
                if valid-object (oFormat) then
                    SessionHelper:SetNumericFormat (oFormat) .

                GarbageCollectorHelper:DeleteObject (oObjectModel) .
                GarbageCollectorHelper:DeleteObject (oJsonObject) .
            end finally.
        end .
        else
&endif
        do:
            /* Mike Fechner, Consultingwerk Ltd. 25.02.2013
               Need to test of ttDesecialization Temp-Table is contained in the XML
               Temp-Table name 'ttDeSerialization' in namespace '' not found in XML Document. (13514) */
            do on error undo, throw:
                temp-table ttDeSerialization:read-xml ("LONGCHAR":U, plcSerializable, "EMPTY":U, ?, false) .

                assign lFromTempTable = true .

                catch err as Progress.Lang.Error:
                    if err:GetMessageNum (1) = 13514 then
                        lFromTempTable = false .
                    else
                       undo, throw err .
                end catch.
            end.

            if lFromTempTable = true then do:
                find first ttDeSerialization no-error .

                oInstance = dynamic-new (ttDeSerialization.ClassName) () .

                oInstance:Deserialize (plcSerializable) .
            end.
            /* XmlSerializable */
            else do:
/*                create x-document hDocument .
                create x-noderef hRootNode .

                hDocument:load ("LONGCHAR":U, plcSerializable, false) .
                hDocument:get-document-element (hRootNode) .

                cClassName = this-object:GetClassNameFromNode (hRootNode) .

                oInstance = dynamic-new (cClassName) () .

                cast (oInstance, XmlSerializable):DeserializeFromNode (hRootNode) */.
            end.
        end.

        return oInstance .

        finally:
            empty temp-table ttDeSerialization .

            GarbageCollectorHelper:DeleteObject (hRootNode) .
            GarbageCollectorHelper:DeleteObject (hDocument) .
        end finally.

    end method.

&if not proversion begins "11.3" and not proversion begins "11.4" and not proversion begins "11.5" &then
    /**
     * Purpose: Deserializes a LONGCHAR representation of an ABL native serializable
     *          object to a new instance
     * Notes:   Supports XML and JSON Serialized objects
     * @param plcSerializable The serialized representation to be deserialized
     * @return The LONGCHAR representation of the ISerializable objects data
     */
    method protected ISerializable DeserializeNativeJson (plcSerializable as longchar):

&if proversion begins "11" &then
        define variable oInputStream    as LongcharInputStream          no-undo .
        define variable oJsonSerializer as Progress.IO.JsonSerializer   no-undo .

        oInputStream = new LongcharInputStream (plcSerializable) .

        oJsonSerializer = new Progress.IO.JsonSerializer (true) .

        return cast (oJsonSerializer:Deserialize(oInputStream), ISerializable) .
&else
        define variable oInputStream    as MemoryInputStream            no-undo .
        define variable oJsonSerializer as Progress.IO.JsonSerializer   no-undo .
        define variable mptr            as memptr                       no-undo .

        copy-lob from plcSerializable to mptr .

        oInputStream = new MemoryInputStream (mptr) .

        oJsonSerializer = new Progress.IO.JsonSerializer (true) .

        return cast (oJsonSerializer:Deserialize(oInputStream), ISerializable) .

        finally:
            set-size (mptr) = 0 .
        end finally.
&endif

    end method.
&ENDIF

    /**
     * Purpose: Returns the ABL Class name that should be used to serialize from
     *          an XML Document (Consultingwerk.XmlSerializable).
     * Notes:   When the node does not contain the SerializedType attribute it may
     *          need to be required to overload this method in a derived class and
     *          provide a custom logic to return the class name base on the root node
     *          name
     * @param phRootNode The root document element
     * @return The class name to be used for the deserialization
     */
    method protected character GetClassNameFromNode (phRootNode as handle):

        return phRootNode:get-attribute ("SerializedType":U).

    end method .

end class.
