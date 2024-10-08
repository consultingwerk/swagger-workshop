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
    File        : Serializable
    Purpose     : Implements serialization functionality i.e. for parameter
                  object to be passed around the AppServer boundary
    Syntax      :
    Description : Serialization based on a property temp-table
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Sep 15 18:25:22 CEST 2010
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{ Consultingwerk/products.i }

using Consultingwerk.*            from propath .
using Consultingwerk.Util.*       from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Serializable
    implements ISerializable
    {&SERIALIZABLE}
    abstract:

    define temp-table ttSerializeProperties no-undo
        field PropertyName     as character
        field PropertyType     as character
        field CharacterValue   as character
        field DateValue        as date
        field DateTimeValue    as datetime
        field DateTime-TZValue as datetime-tz
        field DecimalValue     as decimal
        field IntegerValue     as integer
        field Int64Value       as int64
        field LogicalValue     as logical
        field LongCharValue    as clob
        index PropertyName is unique PropertyName .

    define temp-table ttSerialization no-undo xml-node-name "Serialization":U
        field ClassName  as character
        field Properties as clob .

    /**
     * Purpose: Deserializes a LONGCHAR representation of an object to a new
     *          instance
     * Notes:   Uses IDeserializationFactory service to create deserialized object
     *          instance
     * @param plcSerializable The serialized representation to be deserialized
     * @return The LONGCHAR representation of the ISerializable objects data
     */
    method public static ISerializable DeserializeInstance (plcSerializable as longchar):

        define variable oDeserializationFactory as IDeserializationFactory no-undo .

        oDeserializationFactory = {Consultingwerk/get-service.i Consultingwerk.IDeserializationFactory "NEW Consultingwerk.DeserializationFactory ()"} .

        return oDeserializationFactory:DeserializeInstance (plcSerializable) .

    end method.

    /**
     * Purpose: Deserializes a LONGCHAR representation of the state of the class instance
     * Notes:
     * @param pcSerializedRepresentation The stored LONGCHAR representation of the objects data
     */
    method public void Deserialize (input pcSerializedRepresentation as longchar):

        define variable lcSerialization as longchar no-undo .

        temp-table ttSerialization:read-xml ("LONGCHAR":U, pcSerializedRepresentation, "EMPTY":U, ?, false) .

        find first ttSerialization no-error .

        if not available ttSerialization then
            undo, throw new AppError ("Invalid XML serialization."{&TRAN}, 0) .

        if ttSerialization.ClassName <> this-object:GetClass():TypeName then
            undo, throw new AppError ("The XML data does not contain a serialization of this type."{&TRAN}, 0).

        copy-lob from ttSerialization.Properties to lcSerialization .

        temp-table ttSerializeProperties:read-xml ("LONGCHAR":U, lcSerialization, "EMPTY":U, ?, false) .

        empty temp-table ttSerialization .

    end method.

    /**
     * Purpose: Returns a value from a CHARACTER property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @return The property value
     */
    method protected character GetCharacterProperty (pcPropertyName as character):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then
            return "":U . /* Default */
        else if ttSerializeProperties.PropertyType <> "CHARACTER":U  then
            undo, throw new AppError
              (substitute ("Property &1 is defined as &2"{&TRAN}, pcPropertyName,
                                                                  ttSerializeProperties.PropertyType),
                           0) .

        return ttSerializeProperties.CharacterValue .

    end method.

    /**
     * Purpose: Returns a value from a DATE property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @return The property value
     */
    method protected date GetDateProperty (pcPropertyName as character):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then
            return ? . /* Default */
        else if ttSerializeProperties.PropertyType <> "DATE":U  then
            undo, throw new AppError
              (substitute ("Property &1 is defined as &2"{&TRAN}, pcPropertyName,
                                                                  ttSerializeProperties.PropertyType),
                           0) .

        return ttSerializeProperties.DateValue .

    end method.

    /**
     * Purpose: Returns a value from a DATETIME property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @return The property value
     */
    method protected datetime GetDateTimeProperty (pcPropertyName as character):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then
            return ? . /* Default */
        else if ttSerializeProperties.PropertyType <> "DATETIME":U  then
            undo, throw new AppError
              (substitute ("Property &1 is defined as &2"{&TRAN}, pcPropertyName,
                                                                  ttSerializeProperties.PropertyType),
                           0) .

        return ttSerializeProperties.DateTimeValue .

    end method.

    /**
     * Purpose: Returns a value from a DATETIME-TZ property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @return The property value
     */
    method protected datetime-tz GetDateTime-TZProperty (pcPropertyName as character):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then
            return ? . /* Default */
        else if ttSerializeProperties.PropertyType <> "DATETIME-TZ":U  then
            undo, throw new AppError
              (substitute ("Property &1 is defined as &2"{&TRAN}, pcPropertyName,
                                                                  ttSerializeProperties.PropertyType),
                           0) .

        return ttSerializeProperties.DateTime-TZValue .

    end method.

    /**
     * Purpose: Returns a value from a DECIMAL property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @return The property value
     */
    method protected decimal GetDecimalProperty (pcPropertyName as character):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then
            return 0 . /* Default */
        else if ttSerializeProperties.PropertyType <> "DECIMAL":U  then
            undo, throw new AppError
              (substitute ("Property &1 is defined as &2"{&TRAN}, pcPropertyName,
                                                                  ttSerializeProperties.PropertyType),
                           0) .

        return ttSerializeProperties.DecimalValue .

    end method.

    /**
     * Purpose: Returns a value from a INTEGER property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @return The property value
     */
    method protected integer GetIntegerProperty (pcPropertyName as character):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then
            return 0 . /* Default */
        else if ttSerializeProperties.PropertyType <> "INTEGER":U  then
            undo, throw new AppError
              (substitute ("Property &1 is defined as &2"{&TRAN}, pcPropertyName,
                                                                  ttSerializeProperties.PropertyType),
                           0) .

        return ttSerializeProperties.IntegerValue .

    end method.

    /**
     * Purpose: Returns a value from a INTEGER property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @return The property value
     */
    method protected int64 GetInt64Property (pcPropertyName as character):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then
            return 0 . /* Default */
        else if ttSerializeProperties.PropertyType <> "INT64":U  then
            undo, throw new AppError
              (substitute ("Property &1 is defined as &2"{&TRAN}, pcPropertyName,
                                                                  ttSerializeProperties.PropertyType),
                           0) .

        return ttSerializeProperties.Int64Value .

    end method.

    /**
     * Purpose: Returns a value from a INTEGER property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @return The property value
     */
    method protected logical GetLogicalProperty (pcPropertyName as character):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then
            return false . /* Default */
        else if ttSerializeProperties.PropertyType <> "LOGICAL":U  then
            undo, throw new AppError
              (substitute ("Property &1 is defined as &2"{&TRAN}, pcPropertyName,
                                                                  ttSerializeProperties.PropertyType),
                           0) .

        return ttSerializeProperties.LogicalValue .

    end method.

    /**
     * Purpose: Returns a value from a LONGCHAR property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @return The property value
     */
    method protected longchar GetLongCharProperty (pcPropertyName as character):

        define variable lcReturn as longchar no-undo.

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then
            return "":U . /* Default */
        else if ttSerializeProperties.PropertyType <> "LONGCHAR":U  then
            undo, throw new AppError
              (substitute ("Property &1 is defined as &2"{&TRAN}, pcPropertyName,
                                                                  ttSerializeProperties.PropertyType),
                           0) .

        copy-lob from ttSerializeProperties.LongCharValue to lcReturn .

        return lcReturn .

    end method.

    /**
     * Purpose: Returns a LONGCHAR representation of the state of the class instance
     * Notes:   Returns the class name together with the XML serialization of the
     *          temp-table
     * @return The LONGCHAR representation of the ISerializable objects data
     */
    method public longchar Serialize ():

        define variable lcReturn as longchar no-undo .

        empty temp-table ttSerialization .

        create ttSerialization.
        assign ttSerialization.ClassName  = this-object:GetClass():TypeName .

        /* Mike Fechner, Consultingwerk Ltd. 10.01.2012
           Bug 2776: Unformatted WRITE-XML causes issues with READ-XML on OpenEdge 11.0 */
        temp-table ttSerializeProperties:write-xml ("LONGCHAR":U, lcReturn, true, "utf-8":U, ?, false) .

        copy-lob from lcReturn to ttSerialization.Properties .

        release ttSerialization .

        /* Mike Fechner, Consultingwerk Ltd. 10.01.2012
           Bug 2776: Unformatted WRITE-XML causes issues with READ-XML on OpenEdge 11.0 */
        temp-table ttSerialization:write-xml ("LONGCHAR":U, lcReturn, true, "utf-8":U, ?, false) .

        empty temp-table ttSerialization .

        return lcReturn .

    end method.

    /**
     * Purpose: Assigns a CHARACTER property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @param pcValue The value of the objects property
     */
    method protected void SetCharacterProperty (pcPropertyName as character,
                                                pcValue        as character):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then do:
            create ttSerializeProperties .
            assign ttSerializeProperties.PropertyName = pcPropertyName
                   ttSerializeProperties.PropertyType = "CHARACTER":U .
        end.
        else if ttSerializeProperties.PropertyType <> "CHARACTER":U  then
            undo, throw new AppError
              (substitute ("Property &1 is already defined as &2"{&TRAN}, pcPropertyName,
                                                                          ttSerializeProperties.PropertyType),
                           0) .

        assign ttSerializeProperties.CharacterValue = pcValue .
        release ttSerializeProperties .

    end method.

    /**
     * Purpose: Assigns a DATE property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @param pdaValue The value of the objects property
     */
    method protected void SetDateProperty (pcPropertyName as character,
                                           pdaValue       as date):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then do:
            create ttSerializeProperties .
            assign ttSerializeProperties.PropertyName = pcPropertyName
                   ttSerializeProperties.PropertyType = "DATE":U .
        end.
        else if ttSerializeProperties.PropertyType <> "DATE":U  then
            undo, throw new AppError
              (substitute ("Property &1 is already defined as &2"{&TRAN}, pcPropertyName,
                                                                          ttSerializeProperties.PropertyType),
                           0) .

        assign ttSerializeProperties.DateValue = pdaValue .
        release ttSerializeProperties .

    end method.

    /**
     * Purpose: Assigns a DATETIME property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @param pdtValue The value of the objects property
     */
    method protected void SetDateTimeProperty (pcPropertyName as character,
                                               pdtValue       as datetime):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then do:
            create ttSerializeProperties .
            assign ttSerializeProperties.PropertyName = pcPropertyName
                   ttSerializeProperties.PropertyType = "DATETIME":U .
        end.
        else if ttSerializeProperties.PropertyType <> "DATETIME":U  then
            undo, throw new AppError
              (substitute ("Property &1 is already defined as &2"{&TRAN}, pcPropertyName,
                                                                          ttSerializeProperties.PropertyType),
                           0) .

        assign ttSerializeProperties.DateTimeValue = pdtValue .
        release ttSerializeProperties .

    end method.

    /**
     * Purpose: Assigns a DATETIME-TZ property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @param pdtValue The value of the objects property
     */
    method protected void SetDateTime-TZProperty (pcPropertyName as character,
                                                  pdtValue       as datetime-tz):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then do:
            create ttSerializeProperties .
            assign ttSerializeProperties.PropertyName = pcPropertyName
                   ttSerializeProperties.PropertyType = "DATETIME-TZ":U .
        end.
        else if ttSerializeProperties.PropertyType <> "DATETIME-TZ":U  then
            undo, throw new AppError
              (substitute ("Property &1 is already defined as &2"{&TRAN}, pcPropertyName,
                                                                          ttSerializeProperties.PropertyType),
                           0) .

        assign ttSerializeProperties.DateTime-TZValue = pdtValue .
        release ttSerializeProperties .

    end method.

    /**
     * Purpose: Assigns a DECIMAL property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @param pdeValue The value of the objects property
     */
    method protected void SetDecimalProperty (pcPropertyName as character,
                                              pdeValue       as decimal):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then do:
            create ttSerializeProperties .
            assign ttSerializeProperties.PropertyName = pcPropertyName
                   ttSerializeProperties.PropertyType = "DECIMAL":U .
        end.
        else if ttSerializeProperties.PropertyType <> "DECIMAL":U  then
            undo, throw new AppError
              (substitute ("Property &1 is already defined as &2"{&TRAN}, pcPropertyName,
                                                                          ttSerializeProperties.PropertyType),
                           0) .

        assign ttSerializeProperties.DecimalValue = pdeValue .
        release ttSerializeProperties .

    end method.

    /**
     * Purpose: Assigns a INTEGER property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @param piValue The value of the objects property
     */
    method protected void SetIntegerProperty (pcPropertyName as character,
                                              piValue        as integer):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then do:
            create ttSerializeProperties .
            assign ttSerializeProperties.PropertyName = pcPropertyName
                   ttSerializeProperties.PropertyType = "INTEGER":U .
        end.
        else if ttSerializeProperties.PropertyType <> "INTEGER":U  then
            undo, throw new AppError
              (substitute ("Property &1 is already defined as &2"{&TRAN}, pcPropertyName,
                                                                          ttSerializeProperties.PropertyType),
                           0) .

        assign ttSerializeProperties.IntegerValue = piValue .
        release ttSerializeProperties .

    end method.

    /**
     * Purpose: Assigns a INTEGER property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @param piValue The value of the objects property
     */
    method protected void SetInt64Property (pcPropertyName as character,
                                            piValue as int64):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then do:
            create ttSerializeProperties .
            assign ttSerializeProperties.PropertyName = pcPropertyName
                   ttSerializeProperties.PropertyType = "INT64":U .
        end.
        else if ttSerializeProperties.PropertyType <> "INT64":U  then
            undo, throw new AppError
              (substitute ("Property &1 is already defined as &2"{&TRAN}, pcPropertyName,
                                                                          ttSerializeProperties.PropertyType),
                           0) .

        assign ttSerializeProperties.Int64Value = piValue .
        release ttSerializeProperties .

    end method.

    /**
     * Purpose: Assigns a LOGICAL property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @param plValue The value of the objects property
     */
    method protected void SetLogicalProperty (pcPropertyName as character,
                                              plValue as logical):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then do:
            create ttSerializeProperties .
            assign ttSerializeProperties.PropertyName = pcPropertyName
                   ttSerializeProperties.PropertyType = "LOGICAL":U .
        end.
        else if ttSerializeProperties.PropertyType <> "LOGICAL":U  then
            undo, throw new AppError
              (substitute ("Property &1 is already defined as &2"{&TRAN}, pcPropertyName,
                                                                          ttSerializeProperties.PropertyType),
                           0) .

        assign ttSerializeProperties.LogicalValue = plValue .
        release ttSerializeProperties .

    end method.

    /**
     * Purpose: Assigns a LOGICAL property in the property store
     * Notes:
     * @param pcPropertyName The name of the objects property
     * @param plcValue The value of the objects property
     */
    method protected void SetLongcharProperty (pcPropertyName as character,
                                               plcValue       as longchar):

        find ttSerializeProperties where ttSerializeProperties.PropertyName = pcPropertyName
            no-error .

        if not available ttSerializeProperties then do:
            create ttSerializeProperties .
            assign ttSerializeProperties.PropertyName = pcPropertyName
                   ttSerializeProperties.PropertyType = "LONGCHAR":U .
        end.
        else if ttSerializeProperties.PropertyType <> "LONGCHAR":U  then
            undo, throw new AppError
              (substitute ("Property &1 is already defined as &2"{&TRAN}, pcPropertyName,
                                                                          ttSerializeProperties.PropertyType),
                           0) .

        copy-lob from plcValue to ttSerializeProperties.LongCharValue .
        release ttSerializeProperties .

    end method.

end class.
