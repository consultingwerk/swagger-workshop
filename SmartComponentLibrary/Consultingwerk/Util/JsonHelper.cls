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
    File        : JsonHelper
    Purpose     : Helper class for handling Json Objects
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk
    Created     : Wed May 18 17:29:44 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*                       from propath .
using Consultingwerk.Assertion.*             from propath .
using Consultingwerk.Exceptions.*            from propath .
using Consultingwerk.Framework.Base.*        from propath .
using Consultingwerk.Framework.Collections.* from propath .
using Consultingwerk.Util.*                  from propath .
using Consultingwerk.Util.Exceptions.*       from propath .
using Progress.Json.ObjectModel.*            from propath .
using Progress.Lang.*                        from propath .

class Consultingwerk.Util.JsonHelper:

    /**
     * Purpose: Protected default constructor
     * Notes:   Disallow instance creation
     */
    constructor protected JsonHelper():
        /* Disallow instance creation */

    end constructor.

    /**
     * Purpose: Returns the JSON Type for the given ABL Data Type
     * Notes:
     * @param pcAblDataType The ABL Data Type to return the JSON Type for
     * @return The JsonDataTypeEnum member representing the JSON Data
     */
    method public static JsonDataTypeEnum AblDataTypeToJsonDataTypeEnum (pcAblDataType as character):

        case pcAblDataType:

            when "character":U   then
                return JsonDataTypeEnum:String .
            when "date":U        then
                return JsonDataTypeEnum:String .
            when "datetime":U    then
                return JsonDataTypeEnum:String .
            when "datetime-tz":U then
                return JsonDataTypeEnum:String .
            when "decimal":U     then
                return JsonDataTypeEnum:Number .
            when "handle":U      then
                return JsonDataTypeEnum:Number .
            when "int64":U       then
                return JsonDataTypeEnum:Number .
            when "integer":U     then
                return JsonDataTypeEnum:Number .
            when "logical":U     then
                return JsonDataTypeEnum:Boolean .
            when "longchar":U    then
                return JsonDataTypeEnum:String .
            when "memptr":U      then
                return JsonDataTypeEnum:String .
            when "raw":U         then
                return JsonDataTypeEnum:String .
            when "recid":U       then
                return JsonDataTypeEnum:Number .
            when "rowid":U       then
                return JsonDataTypeEnum:String .

            otherwise
                undo, throw new InvalidParameterValueException ("pcAblDataType":U, pcAblDataType, "Consultingwerk.Util.JsonHelper":U) .

        end case .

    end method.

    /**
     * Purpose: Adds the given fields of a buffer to an JSON Object
     * Notes:   Supports array fields, a record must be available
     * @param phBuffer The handle of the Buffer
     * @param poJsonObject The JsonObject to add the fields to
     * @param pcFields Comma delimited list of field names to add or * for all fields. Fields may be qualified with a buffer name or not. When the buffer does not match the current buffer name, the fields are ignored
     */
    method public static void AddBufferFields (phBuffer as handle,
                                               poJsonObject as JsonObject,
                                               pcFields as character):

        JsonHelper:AddBufferFields (phBuffer, poJsonObject, pcFields, false, false) .

    end method .

    /**
     * Purpose: Adds the given fields of a buffer to an JSON Object
     * Notes:   Supports array fields, a record must be available
     * @param phBuffer The handle of the Buffer
     * @param poJsonObject The JsonObject to add the fields to
     * @param pcFields Comma delimited list of field names to add or * for all fields. Fields may be qualified with a buffer name or not. When the buffer does not match the current buffer name, the fields are ignored
     * @param plIgnoreDuplicates Logical value indicating if duplicate attributes will be ignored
     */
    method public static void AddBufferFields (phBuffer as handle,
                                               poJsonObject as JsonObject,
                                               pcFields as character,
                                               plIgnoreDuplicates as logical):

        JsonHelper:AddBufferFields (phBuffer, poJsonObject, pcFields, plIgnoreDuplicates, false) .

    end method .


    /**
     * Purpose: Adds the given fields of a buffer to an JSON Object
     * Notes:   Supports array fields, a record must be available
     * @param phBuffer The handle of the Buffer
     * @param poJsonObject The JsonObject to add the fields to
     * @param pcFields Comma delimited list of field names to add or * for all fields. Fields may be qualified with a buffer name or not. When the buffer does not match the current buffer name, the fields are ignored
     * @param plIgnoreDuplicates Logical value indicating if duplicate attributes will be ignored
     * @param plIgnoreSerializeHidden Logical value indicating if fields marked with SERIALIZE-HIDDEN should be skipped during export
     */
    method public static void AddBufferFields (phBuffer as handle,
                                               poJsonObject as JsonObject,
                                               pcFields as character,
                                               plIgnoreDuplicates as logical,
                                               plIgnoreSerializeHidden as logical):

        define variable i          as integer   no-undo .
        define variable hField     as handle    no-undo .
        define variable mPtr       as memptr    no-undo .
        define variable lcLongchar as longchar  no-undo .
        define variable oArray     as JsonArray no-undo .
        define variable j          as integer   no-undo .
        define variable cFields    as character no-undo .
        define variable cField     as character no-undo .

        BufferAssert:IsAvailable (phBuffer).

        assign cFields = pcFields .

        do i = 1 to num-entries (cFields):
            assign cField = entry (i, cFields) .

            if index (cField, "[":U) > 0 then
                assign entry (i, cFields) = substring (cField, 1, index (cField, "[":U) - 1, "CHARACTER":U) .
        end.

        fieldLoop:
        do i = 1 to phBuffer:num-fields:
            assign hField     = phBuffer:buffer-field (i) .

            if plIgnoreSerializeHidden and hField:serialize-hidden then
                next fieldLoop .

            if not ListHelper:CanDo (cFields, hField:name) and
               not ListHelper:CanDo (cFields, substitute ("&1.&2":U, phBuffer:name, hField:name)) then
                next fieldLoop .

            if plIgnoreDuplicates and poJsonObject:Has (hField:serialize-name) then
                next fieldLoop .

            if hField:extent > 1 then do:
                if ListHelper:CanDo (pcFields, hField:name) or
                   ListHelper:CanDo (pcFields, substitute ("&1.&2":U, phBuffer:name, hField:name)) then do:

                    oArray = new JsonArray () .

                    do j = 1 to hField:extent:
                        /* No need to CASE for BLOB and CLOB as those fields cannot be EXTENT */
                        oArray:Add (hField:buffer-value(j)).
                    end.

                    poJsonObject:Add (hField:serialize-name, oArray) .
                end.
                else do:
                    do j = 1 to hField:extent:
                        if ListHelper:CanDo (pcFields, substitute ("&1[&2]":U, hField:name, j)) or
                           ListHelper:CanDo (pcFields, substitute ("&1.&2[&3]":U, phBuffer:name, hField:name, j)) then do:

                            assign cField = substitute ("&1[&2]":U, hField:serialize-name, j) .

                            /* No need to CASE for BLOB and CLOB as those fields cannot be EXTENT */
                            poJsonObject:Add (cField, hField:buffer-value[j]).
                        end.
                    end.
                end.
            end.
            else do:
                if hField:buffer-value = ? then
                    poJsonObject:AddNull (hField:serialize-name) .
                else case hField:data-type:
                    when "BLOB":U then do:
                        copy-lob from hField:buffer-value to mPtr .
                        poJsonObject:Add (hField:serialize-name, mPtr).
                        set-size (mPtr) = 0 .
                    end.
                    when "CLOB":U then do:
                        copy-lob from hField:buffer-value to lcLongchar .
                        poJsonObject:Add (hField:serialize-name, lcLongchar).
                        lcLongchar = ? .
                    end.
                    otherwise
                        poJsonObject:Add (hField:serialize-name, hField:buffer-value).

                end case .
            end.
        end.

    end method.

    /**
     * Purpose: Adds a new JsonArray to the given JsonObject
     * Notes:
     * @param poJsonObject The existing parent JSON Object
     * @param pcPropertyName The name of the property to add the new object to
     * @return The new JsonArray
     */
    method public static JsonArray AddNewJsonArray (poJsonObject as JsonObject,
                                                    pcPropertyName as character):

        define variable oJsonArray as JsonArray no-undo .

        oJsonArray = new JsonArray () .

        poJsonObject:Add (pcPropertyName, oJsonArray) .

        return oJsonArray .

    end method.

    /**
     * Purpose: Adds a new JsonObject to the given JsonArray
     * Notes:
     * @param poJsonArray The existing parent JSON Array
     * @return The new JsonObject
     */
    method public static JsonObject AddNewJsonObject (poJsonArray as JsonArray):

        define variable oJsonObject as JsonObject no-undo .

        oJsonObject = new JsonObject() .

        poJsonArray:Add (oJsonObject) .

        return oJsonObject .

    end method.
    /**
     * Purpose: Adds a new JsonObject to the given JsonObject
     * Notes:
     * @param poJsonObject The existing parent JSON Object
     * @param pcPropertyName The name of the property to add the new object to
     * @return The new JsonObject
     */
    method public static JsonObject AddNewJsonObject (poJsonObject as JsonObject,
                                                      pcPropertyName as character):

        define variable oJsonObject as JsonObject no-undo .

        oJsonObject = new JsonObject() .

        poJsonObject:Add (pcPropertyName, oJsonObject) .

        return oJsonObject .

    end method.

&if defined (AblReflection) ne 0 &then
    /**
     * Purpose: Adds the properties of the given ABL Object to the
     *          JSON Object
     * Notes:
     * @param poObject The ABL object to add properties from
     * @param poJson The JSON object to add properties to
     * @param pcExceptPropertyNames The property names to exclude from the result
     */
    method public static void AddObjectPropertiesToJson (poObject as Progress.Lang.Object,
                                                         poJson as JsonObject,
                                                         pcExceptPropertyNames as character):

        define variable oClass        as Progress.Lang.Class       no-undo .
        define variable oProperties   as Progress.Reflect.Property no-undo extent .
        define variable oProperty     as Progress.Reflect.Property no-undo .
        define variable i             as integer                   no-undo .
        define variable cValue        as character                 no-undo .
        define variable oValue        as Progress.Lang.Object      no-undo .
        define variable oValueJson    as JsonObject                no-undo .
        define variable oArray        as JsonArray                 no-undo .
        define variable oInstanceJson as JsonObject                no-undo .

        oClass = poObject:GetClass() .

        oProperties = oClass:GetProperties() .

        propertyLoop:
        do i = 1 to extent (oProperties):

            assign
                oProperty  = oProperties[i]
                oValue     = ?
                oValueJson = ? .

            if index (pcExceptPropertyNames, oProperty:Name) > 0 or
                oProperty:Name = "Next-Sibling":U or oProperty:Name = "Prev-Sibling":U
            then
                next propertyLoop .

            if index (pcExceptPropertyNames, oProperty:Name) > 0 then
                next propertyLoop .

            case oProperty:DataType:
                when Progress.Reflect.DataType:Object then do on error undo, throw:
                    oValue = oProperty:Get (poObject) .

                    if valid-object (oValue) then do:
                        oValueJson = new JsonObject () .

                        JsonHelper:AddObjectPropertiesToJson (oValue, oValueJson, pcExceptPropertyNames) .

                        poJson:Add (oProperty:Name, oValueJson) .
                    end.
                    else
                        cValue = "<invalid object reference>":U .

                    catch err as Progress.Lang.Error :
                        cValue = substitute ("Error: &1":U, err:GetMessage (1)) .
                        poJson:Add (oProperty:Name, cValue) .
                    end catch.
                end .
                otherwise do on error undo, throw:
                    cValue = string (oProperty:Get (poObject)) .

                    poJson:Add (oProperty:Name, cValue) .

                    catch err as Progress.Lang.Error:
                        cValue = substitute ("Error: &1":U, err:GetMessage (1)) .
                        poJson:Add (oProperty:Name, cValue) .
                    end catch.
                end.
            end case .
        end.

        if type-of (poObject, IEnumerable) then do:

            assign oArray = new JsonArray () .

            poJson:Add ("entries":U, oArray) .

            {Consultingwerk/foreachABL.i Progress.Lang.Object oInstance in poObject}
                oInstanceJson = new JsonObject () .

                oArray:Add (oInstanceJson) .

                if type-of (oInstance, Consultingwerk.NameValuePair) then do:
                    oInstanceJson:Add ("Name":U, cast (oInstance, Consultingwerk.NameValuePair):Name) .
                    oInstanceJson:Add ("Value":U, cast (oInstance, Consultingwerk.NameValuePair):Value) .
                end.
                else
                    JsonHelper:AddObjectPropertiesToJson (oInstance,
                                                          oInstanceJson,
                                                          pcExceptPropertyNames).
            end .
        end.

    end method.

    /**
     * Purpose: Adds the properties of the given ABL Object to the
     *          JSON Array as name/value pairs
     * Notes:
     * @param poObject The ABL object to add properties from
     * @param poJsonArray The JSON object to add properties to
     * @param pcExceptPropertyNames The property names to exclude from the result
     * @param pcKey The name of the json property to hold the ABL property name
     * @param pcValue The name of the json property to hold the ABL property value
     */
    method public static void AddObjectPropertiesToJsonArray (poObject as Progress.Lang.Object,
                                                              poJsonArray as JsonArray,
                                                              pcExceptPropertyNames as character,
                                                              pcKey as character,
                                                              pcValue as character):

        JsonHelper:AddObjectPropertiesToJsonArray (poObject, poJsonArray, pcExceptPropertyNames, pcKey, pcValue, "":U) .

    end method.

    /**
     * Purpose: Adds the properties of the given ABL Object to the
     *          JSON Array as name/value pairs
     * Notes:
     * @param poObject The ABL object to add properties from
     * @param poJsonArray The JSON object to add properties to
     * @param pcExceptPropertyNames The property names to exclude from the result
     * @param pcKey The name of the json property to hold the ABL property name
     * @param pcValue The name of the json property to hold the ABL property value
     * @param pcPrefix The property name prefix
     */
    method public static void AddObjectPropertiesToJsonArray (poObject as Progress.Lang.Object,
                                                              poJsonArray as JsonArray,
                                                              pcExceptPropertyNames as character,
                                                              pcKey as character,
                                                              pcValue as character,
                                                              pcPrefix as character):

        define variable oClass        as Progress.Lang.Class       no-undo .
        define variable oProperties   as Progress.Reflect.Property no-undo extent .
        define variable oProperty     as Progress.Reflect.Property no-undo .
        define variable i             as integer                   no-undo .
        define variable cValue        as character                 no-undo .
        define variable oValue        as Progress.Lang.Object      no-undo .
        define variable oEntry        as JsonObject                no-undo .

        oClass = poObject:GetClass() .

        oProperties = oClass:GetProperties() .

        propertyLoop:
        do i = 1 to extent (oProperties):

            assign
                oProperty  = oProperties[i]
                oValue     = ? .

            if index (pcExceptPropertyNames, oProperty:Name) > 0 or
                oProperty:Name = "Next-Sibling":U or oProperty:Name = "Prev-Sibling":U
            then
                next propertyLoop .

            assign oEntry     = new JsonObject () .

            oEntry:Add (pcKey, substitute ("&1&2":U, pcPrefix, oProperty:Name)) .
            poJsonArray:Add (oEntry) .

            case oProperty:DataType:
                when Progress.Reflect.DataType:Object then do on error undo, throw:
                    oValue = oProperty:Get (poObject) .

                    if valid-object (oValue) then do:
                        JsonHelper:AddObjectPropertiesToJsonArray (oValue,
                                                                   poJsonArray,
                                                                   pcExceptPropertyNames,
                                                                   pcKey,
                                                                   pcValue,
                                                                   substitute ("&1:":U, oProperty:Name)) .
                    end.
                    else
                        cValue = "<invalid object reference>":U .

                    catch err as Progress.Lang.Error :
                        cValue = substitute ("Error: &1":U, err:GetMessage (1)) .
                        oEntry:Add (pcValue, cValue) .
                    end catch.
                end .
                otherwise do on error undo, throw:
                    cValue = string (oProperty:Get (poObject)) .

                    oEntry:Add (pcValue, cValue) .

                    catch err as Progress.Lang.Error:
                        cValue = substitute ("Error: &1":U, err:GetMessage (1)) .
                        oEntry:Add (pcValue, cValue) .
                    end catch.
                end.
            end case .
        end.

        assign i = 0 .

        if type-of (poObject, IEnumerable) then do:
            {Consultingwerk/foreachABL.i Progress.Lang.Object oInstance in poObject}
                assign i = i + 1 .

                JsonHelper:AddObjectPropertiesToJsonArray (oInstance,
                                                           poJsonArray,
                                                           pcExceptPropertyNames,
                                                           pcKey,
                                                           pcValue,
                                                           substitute ("&1[&2]:":U, oProperty:Name, i)) .
            end .
        end.

    end method .
&endif

    /**
     * Purpose: Adds or sets a property to a JsonObject
     * Notes:
     * @param poJson The reference to the JSON object
     * @param pcPropertyName The name of the property
     * @param pcPropertyValue The value to assign to the property
     */
    method public static void AddSetPropertyValue (poJson as JsonObject,
                                                   pcPropertyName as character,
                                                   pcPropertyValue as character):

        ObjectAssert:IsValid (poJson, "poJson":U) .
        Assert:NotNullOrEmpty(pcPropertyName, "pcPropertyName":U) .

        if poJson:Has (pcPropertyName) then
            poJson:Set (pcPropertyName, pcPropertyValue) .
        else
            poJson:Add (pcPropertyName, pcPropertyValue) .

    end method.

    /**
     * Purpose: Adds the properties of the given widget to the
     *          JSON Array as name/value pairs
     * Notes:
     * @param phWidget The handle of the widget to add properties from
     * @param poJsonArray The JSON object to add properties to
     * @param pcExceptPropertyNames The property names to exclude from the result
     * @param pcKey The name of the json property to hold the ABL property name
     * @param pcValue The name of the json property to hold the ABL property value
     */
    method public static void AddWidgetPropertiesToJsonArray (phWidget as handle,
                                                              poJsonArray as JsonArray,
                                                              pcExceptPropertyNames as character,
                                                              pcKey as character,
                                                              pcValue as character):

        define variable i           as integer    no-undo .
        define variable cAttributes as character  no-undo .
        define variable cAttribute  as character  no-undo .
        define variable hCall       as handle     no-undo .
        define variable oEntry      as JsonObject no-undo .

        if not valid-handle (phWidget) then
            return .

        assign cAttributes = ListHelper:SortList(list-query-attrs (phWidget)) .

        loop:
        do i = 1 to num-entries (cAttributes):
            assign cAttribute = entry (i, cAttributes) .

            /* Mike Fechner, Consultingwerk Ltd. 13.07.2015
               Need to verify as some methods called as attributes (like SERIALIZE-ROW on the buffer object handle)
               may kill the AVM (call #00318812)  */
            if not WidgetAttributes:IsValid (cAttribute) then
                next loop .

            oEntry = new JsonObject () .
            oEntry:Add (pcKey, cAttribute) .
            poJsonArray:Add (oEntry) .

            do on error undo, throw:
                create call hCall.

                assign hCall:in-handle = phWidget
                       hCall:call-type = get-attr-call-type
                       hCall:call-name = cAttribute .

                {&_proparse_ prolint-nowarn(avoidnoerror)}
                hCall:invoke () no-error .

                if error-status:num-messages > 0 then
                    next loop .

                oEntry:Add (pcValue, hCall:return-value) .

                catch err as Progress.Lang.Error:
                    LogManager:WriteIgnoredError (err) .

                    next loop .
                end catch.

                finally:
                    Consultingwerk.Util.GarbageCollectorHelper:DeleteObject (hCall) .
                end finally.
            end.
        end.

    end method .

    /**
     * Purpose: Assigns fields of the buffer from the values of the JSON object
     * Notes:
     * @param phBuffer The handle of the buffer to assign to
     * @param poJson The JsonObject to assign from
     * @param pcIgnoreProperties Comma delimited list of JSON properties to ignore
     * @param pcIncludeFields Comma delimited list of fields to include, if set only those fields will be handled, * (or empty) for all fields. Fields may be qualified with a buffer name or not. When the buffer does not match the current buffer name, the fields are ignored
     */
    method public static void AssignBufferFromJson (phBuffer as handle,
                                                    poJson as JsonObject,
                                                    pcIgnoreProperties as character,
                                                    pcIncludeFields as character):

        define variable cNames     as character no-undo extent .
        define variable i          as integer   no-undo .
        define variable hField     as handle    no-undo .
        define variable cFieldName as character no-undo .

        HandleAssert:WidgetType (phBuffer, WidgetTypeEnum:Buffer) .
        BufferAssert:IsAvailable (phBuffer) .
        ObjectAssert:IsValid(poJson, "poJson":U) .

        assign cNames = poJson:GetNames() .

        fieldLoop:
        do i = 1 to extent (cNames):

            if pcIgnoreProperties > "":U and lookup (cNames[i], pcIgnoreProperties) > 0 then
                next fieldLoop .

            assign cFieldName = BufferHelper:FieldWithSerializeName (phBuffer, cNames[i]) .

            if cFieldName = ? then
                next fieldLoop .

            assign hField = phBuffer:buffer-field (cFieldName) .

            if pcIncludeFields > "":U then
                if not ListHelper:CanDo (pcIncludeFields, hField:name) and
                   not ListHelper:CanDo (pcIncludeFields, substitute ("&1.&2":U, phBuffer:name, hField:name)) then
                    next fieldLoop .

            JsonHelper:AssignBufferFieldFromJson (hField, poJson) .
        end.

    end method.

    /**
     * Purpose: Assigns properties in the given JsonObject from a Character value
     * Notes:   The character value must be in the form of the html style attribute, e.g.:
     *          background-color:LightCyan; width:200; xyz: "otto"
     *          Does not support nested objects or arrays
     *          Supports integer and character properties
     * @param poJsonObject The JsonObject to add the properties to
     * @param pcProperties The string containing the properties
     */
    method public static void AssignJsonObjectPropertiesFromString (poJsonObject as JsonObject,
                                                                    pcProperties as character):

        define variable iPos       as integer   no-undo .
        define variable iSeparator as integer   no-undo .
        define variable cName      as character no-undo .
        define variable cValue     as character no-undo .
        define variable iValue     as integer   no-undo .

        ObjectAssert:IsValid (poJsonObject, "poJsonObject":U) .

        assign pcProperties = trim (pcProperties)
               pcProperties = trim (pcProperties, ";":U) .

        propertiesLoop:
        repeat:
            iPos = iPos + 1 .

            assign iSeparator = StringHelper:IndexUnquoted (pcProperties, ":":U, iPos) .

            if iSeparator = 0 then
                undo, throw new InvalidParameterValueException ("pcProperties":U,
                                                                "Consultingwerk.Util.JsonHelper":U,
                                                                substitute ("Missing : after position &1":U, iPos),
                                                                0) .

            assign cName      = StringHelper:Unquote (trim (substring (pcProperties, iPos, iSeparator - iPos, "CHARACTER":U)))
                   iSeparator = iSeparator + 1 .

            assign iPos = StringHelper:IndexUnquoted (pcProperties, ";":U, iSeparator) .

            if iPos = 0 then
                assign cValue = StringHelper:Unquote (trim (substring (pcProperties, iSeparator, -1, "CHARACTER":U))) .
            else
                assign cValue = StringHelper:Unquote (trim (substring (pcProperties, iSeparator, iPos - iSeparator, "CHARACTER":U))) .

            assign iValue = DataTypeHelper:ToInteger(cValue) .

            if iValue <> ? then do:
                if poJsonObject:Has (cName) then
                    poJsonObject:Set (cName, iValue) .
                else
                    poJsonObject:Add (cName, iValue) .
            end.
            else do:
                if poJsonObject:Has (cName) then
                    poJsonObject:Set (cName, cValue) .
                else
                    poJsonObject:Add (cName, cValue) .
            end.

            if iPos = 0 then
                leave propertiesLoop .
        end.

    end method.

    /**
     * Purpose: Builds a Character list of the property values in all objects of the array
     * Notes:
     * @param poJsonArray The JsonArray
     * @param pcPropertyName The name of the property to build a list of
     * @return The comma delimited list of property values
     */
    method public static character AttributeValueList (poJsonArray as JsonArray,
                                                       pcPropertyName as character):

        return JsonHelper:AttributeValueList(poJsonArray, pcPropertyName, ",":U) .

    end method.

    /**
     * Purpose: Builds a Character list of the property values in all objects of the array
     * Notes:
     * @param poJsonArray The JsonArray
     * @param pcPropertyName The name of the property to build a list of
     * @param pcDelimiter The list delimiter
     * @return The delimited list of property values
     */
    method public static character AttributeValueList (poJsonArray as JsonArray,
                                                       pcPropertyName as character,
                                                       pcDelimiter as character):

        define variable cList as character no-undo.

        define variable oObject as JsonObject no-undo .
        define variable i       as integer    no-undo .
        define variable cName   as character  no-undo .
        define variable lFirst  as logical    no-undo initial true .

        do i = 1 to poJsonArray:Length:
            assign oObject = poJsonArray:GetJsonObject (i)
                   cName   = JsonHelper:ExactPropertyName (oObject, pcPropertyName).

            if cName > "":U then do:

                case oObject:GetType (cName):
                    when JsonDataType:STRING then
                        assign cList = cList +
                                       (if lFirst = false then pcDelimiter else "":U) +
                                       oObject:GetCharacter(cName)
                               lFirst = false .

                    when JsonDataType:NULL then
                        assign cList = cList +
                                       (if lFirst = false then pcDelimiter else "":U) +
                                       "?":U
                               lFirst = false .

                    when JsonDataType:NUMBER then do:
                        if JsonHelper:IsIntegerProperty(oObject, cName) then
                            assign cList = cList +
                                           (if lFirst = false then pcDelimiter else "":U) +
                                           string (oObject:GetInteger(cName))
                                   lFirst = false .
                        else if JsonHelper:IsInt64Property(oObject, cName) then
                            assign cList = cList +
                                           (if lFirst = false then pcDelimiter else "":U) +
                                           string (oObject:GetInt64(cName))
                                   lFirst = false .
                        else assign cList = cList +
                                            (if lFirst = false then pcDelimiter else "":U) +
                                            string (oObject:GetDecimal(cName))
                                    lFirst = false .
                    end.

                    when JsonDataType:BOOLEAN then
                        assign cList = cList +
                                       (if lFirst = false then pcDelimiter else "":U) +
                                       string (oObject:GetLogical(cName))
                               lFirst = false .
                end case .
            end.
        end.

        return cList .

    end method.

    /**
     * Purpose: Returns a JsonObject populated from a CharacterDictionary
     * Notes:
     * @param poCharacterDictionary The CharacterDictionary to convert
     * @return The JsonObject
     */
    method public static JsonObject CharacterDictionaryToJsonObject (poCharacterDictionary as CharacterDictionary):

        define variable oJson  as JsonObject no-undo .
        define variable i      as integer    no-undo .
        define variable iCount as integer    no-undo .

        oJson = new JsonObject ().

        assign iCount = poCharacterDictionary:Count .

        do i = 1 to iCount:
            oJson:Add (entry (i, poCharacterDictionary:Keys, poCharacterDictionary:KeyDelimiter),
                       entry (i, poCharacterDictionary:Values, poCharacterDictionary:ValueDelimiter)) .
        end.

        return oJson .

    end method.

    /**
     * Purpose: Copies the given JSON Properties from the source JSON to
     *          the target JSON
     * Notes:
     * @param poSourceObject The source JSON object
     * @param poTargetObject The target JSON object
     * @param pcPropertyNames The names of the properties to copy
     */
    method public static void CopyProperties (poSourceObject as JsonObject,
                                              poTargetObject as JsonObject,
                                              pcPropertyNames as character):

        define variable i          as integer   no-undo.
        define variable cProperty  as character no-undo.

        propertyLoop:
        do i = 1 to num-entries (pcPropertyNames):
            assign cProperty = entry (i, pcPropertyNames) .

            if not poSourceObject:Has (cProperty) then do:
                if poTargetObject:Has (cProperty) then
                    poTargetObject:Remove (cProperty) .

                next propertyLoop .
            end.

            if poSourceObject:IsNull (cProperty) then do:
                if poTargetObject:Has (cProperty) then
                    poTargetObject:SetNull (cProperty) .
                else
                    poTargetObject:AddNull (cProperty) .

                next propertyLoop .
            end .

            case poSourceObject:GetType(cProperty):
                when JsonDataType:OBJECT then do:
                    if poTargetObject:Has (cProperty) then
                        poTargetObject:Set (cProperty, poSourceObject:GetJsonObject(cProperty)) .
                    else
                        poTargetObject:Add (cProperty, poSourceObject:GetJsonObject(cProperty)) .
                end.
                when JsonDataType:ARRAY then do:
                    if poTargetObject:Has (cProperty) then
                        poTargetObject:Set (cProperty, poSourceObject:GetJsonArray(cProperty)) .
                    else
                        poTargetObject:Add (cProperty, poSourceObject:GetJsonArray(cProperty)) .
                end.
                when JsonDataType:BOOLEAN then do:
                    if poTargetObject:Has (cProperty) then
                        poTargetObject:Set (cProperty, poSourceObject:GetLogical(cProperty)) .
                    else
                        poTargetObject:Add (cProperty, poSourceObject:GetLogical(cProperty)) .
                end.
                when JsonDataType:STRING then do:
                    if poTargetObject:Has (cProperty) then
                        poTargetObject:Set (cProperty, poSourceObject:GetCharacter(cProperty)) .
                    else
                        poTargetObject:Add (cProperty, poSourceObject:GetCharacter(cProperty)) .
                end.
                when JsonDataType:NUMBER then do:
                    if poTargetObject:Has (cProperty) then do:
                        if JsonHelper:IsIntegerProperty(poSourceObject, cProperty) then
                            poTargetObject:Set (cProperty, poSourceObject:GetInteger(cProperty)) .
                        else if JsonHelper:IsInt64Property(poSourceObject, cProperty) then
                            poTargetObject:Set (cProperty, poSourceObject:GetInt64(cProperty)) .
                        else
                            poTargetObject:Set (cProperty, poSourceObject:GetDecimal(cProperty)) .
                    end.
                    else do:
                        if JsonHelper:IsIntegerProperty(poSourceObject, cProperty) then
                            poTargetObject:Add (cProperty, poSourceObject:GetInteger(cProperty)) .
                        else if JsonHelper:IsInt64Property(poSourceObject, cProperty) then
                            poTargetObject:Add (cProperty, poSourceObject:GetInt64(cProperty)) .
                        else
                            poTargetObject:Add (cProperty, poSourceObject:GetDecimal(cProperty)) .
                    end.
                end.
            end case .
        end.

    end method.

    /**
     * Purpose: Assigns fields of the buffer from the values of the JSON object
     * Notes:
     * @param phBufferField The handle of the buffer to assign to
     * @param poJson The JsonObject to assign from
     */
    method public static void AssignBufferFieldFromJson (phBufferField as handle,
                                                         poJson as JsonObject):

        define variable cProperty as character no-undo .
        define variable oArray    as JsonArray no-undo .
        define variable i         as integer   no-undo .

        HandleAssert:WidgetType (phBufferField, WidgetTypeEnum:BufferField) .
        ObjectAssert:IsValid(poJson, "poJson":U) .

        assign cProperty = JsonHelper:ExactPropertyName (poJson, phBufferField:serialize-name) .

        if cProperty = ? then
            return .

        if phBufferField:extent > 1 then do:
            assign oArray = poJson:GetJsonArray (cProperty) .

            do i = 1 to phBufferField:extent:
                assign phBufferField:buffer-value (i) = ? .
            end.

            do i = 1 to oArray:Length:

                case phBufferField:data-type:

                    when "BLOB":U then do:
                        if oArray:GetType(i) = JsonDataType:NULL then
                            phBufferField:buffer-value (i) = ?.
                        else
                            copy-lob from oArray:GetMemptr(i) to phBufferField:buffer-value (i) .
                    end.
                    when "CHARACTER":U then
                        assign phBufferField:buffer-value (i) = oArray:GetCharacter(i) .
                    when "CLOB":U then
                        copy-lob from oArray:GetLongchar(i) to phBufferField:buffer-value (i) .
                    when "DATE":U then
                        assign phBufferField:buffer-value (i) = oArray:GetDate(i) .
                    when "DATETIME":U then
                        assign phBufferField:buffer-value (i) = oArray:GetDatetime(i) .
                    when "DATETIME-TZ":U then
                        assign phBufferField:buffer-value (i) = oArray:GetDatetimeTZ(i) .
                    when "DECIMAL":U then
                        assign phBufferField:buffer-value (i) = oArray:GetDecimal(i) .
                    when "INT64":U then
                        assign phBufferField:buffer-value (i) = oArray:GetInt64(i) .
                    when "INTEGER":U then
                        assign phBufferField:buffer-value (i) = oArray:GetInteger(i) .
                    when "LOGICAL":U then
                        assign phBufferField:buffer-value (i) = oArray:GetLogical(i) .
                    when "RAW":U then
                        assign phBufferField:buffer-value (i) = oArray:GetRaw(i) .
                    when "RECID":U then
                        assign phBufferField:buffer-value (i) = oArray:GetRecid(i) .
                    when "ROWID":U then
                        assign phBufferField:buffer-value (i) = oArray:GetRowid(i) .
                end case .
            end.
        end.
        else do:
            case phBufferField:data-type:
                when "BLOB":U then do:
                    if poJson:GetType(cProperty) = JsonDataType:NULL then
                        phBufferField:buffer-value = ?.
                    else
                        copy-lob from poJson:GetMemptr(cProperty) to phBufferField:buffer-value .
                end.
                when "CHARACTER":U then
                    assign phBufferField:buffer-value  = poJson:GetCharacter(cProperty) .
                when "CLOB":U then
                    phBufferField:buffer-value = poJson:GetLongchar(cProperty) .
                when "DATE":U then
                    assign phBufferField:buffer-value = poJson:GetDate(cProperty) .
                when "DATETIME":U then
                    assign phBufferField:buffer-value = poJson:GetDatetime(cProperty) .
                when "DATETIME-TZ":U then
                    assign phBufferField:buffer-value = poJson:GetDatetimeTZ(cProperty) .
                when "DECIMAL":U then
                    assign phBufferField:buffer-value = poJson:GetDecimal(cProperty) .
                when "INT64":U then
                    assign phBufferField:buffer-value = poJson:GetInt64(cProperty) .
                when "INTEGER":U then
                    assign phBufferField:buffer-value = poJson:GetInteger(cProperty) .
                when "LOGICAL":U then
                    assign phBufferField:buffer-value = poJson:GetLogical(cProperty) .
                when "RAW":U then
                    assign phBufferField:buffer-value = poJson:GetRaw(cProperty) .
                when "RECID":U then
                    assign phBufferField:buffer-value = poJson:GetRecid(cProperty) .
                when "ROWID":U then
                    assign phBufferField:buffer-value = poJson:GetRowid(cProperty) .
            end case .
        end.

    end method.

    /**
     * Purpose: Ensures that a primitive JSON property is a character
     * Notes:   Converts boolean and numeric properties to CHARACTER
     * @param poJsonObject The JSON object that contains the character
     * @param pcPropertyName The property to convert to character
     */
    method public static void EnsureCharacterProperty (poJsonObject as JsonObject,
                                                       pcPropertyName as character):

        define variable cPropertyName as character                      no-undo .
        define variable oError        as InvalidParameterValueException no-undo .
        define variable deValue       as decimal                        no-undo .
        define variable iValue        as integer                        no-undo .
        define variable i64Value      as int64                          no-undo .
        define variable lValue        as logical                        no-undo .

        assign cPropertyName = JsonHelper:ExactPropertyName(poJsonObject, pcPropertyName) .

        if cPropertyName = ? then
            return .

        case poJsonObject:GetType(cPropertyName):
            when JsonDataType:BOOLEAN then do:
                assign lValue = poJsonObject:GetLogical (cPropertyName) .

                poJsonObject:Remove(cPropertyName) .
                poJsonObject:Add (cPropertyName, string(lValue)) .
            end.
            when JsonDataType:NUMBER then do:
                if JsonHelper:IsIntegerProperty (poJsonObject, cPropertyName) then do:
                    assign iValue = poJsonObject:GetInteger (cPropertyName) .
                    poJsonObject:Remove(cPropertyName) .
                    poJsonObject:Add (cPropertyName, string (iValue)) .
                end.
                else if JsonHelper:IsInt64Property (poJsonObject, cPropertyName) then do:
                    assign i64Value = poJsonObject:GetInt64 (cPropertyName) .
                    poJsonObject:Remove(cPropertyName) .
                    poJsonObject:Add (cPropertyName, string (i64Value)) .
                end.
                else do:
                    assign deValue = poJsonObject:GetDecimal (cPropertyName) .
                    poJsonObject:Remove(cPropertyName) .
                    poJsonObject:Add (cPropertyName, string (deValue)) .
                end.
            end.
            when JsonDataType:ARRAY then do:
                oError = new InvalidParameterValueException (pcPropertyName, "Consultingwerk.Util.JsonHelper":U) .
                oError:AddMessage ("Unable to convert JSON array to Character."{&TRAN}, 0) .
                undo, throw oError .
            end.
            when JsonDataType:OBJECT then do:
                oError = new InvalidParameterValueException (pcPropertyName, "Consultingwerk.Util.JsonHelper":U) .
                oError:AddMessage ("Unable to convert JSON object to Character."{&TRAN}, 0) .
                undo, throw oError .
            end.

            /* String and Null to not require conversion */
       end case .

    end method.

    /**
     * Purpose: Returns the property name if found in the JSON object in the exact case
     *          as it appears in the JSON object
     * Notes:   Returns ? when the property is not available
     * @param poJsonObject The JsonObject to search for the property in
     * @param pcPropertyName The property name
     * @return The exact property name as it appears in the JSON object
     */
    method public static character ExactPropertyName (poJsonObject as JsonObject,
                                                      pcPropertyName as character):

        define variable iEntry           as integer    no-undo .
        define variable cNames           as character  no-undo .

        if poJsonObject:Has (pcPropertyName) then
            return pcPropertyName .

        assign cNames = ArrayHelper:ToList (poJsonObject:GetNames())
               iEntry = lookup (pcPropertyName, cNames) .

        if iEntry = 0 then
            return ? .
        else
            return entry (iEntry, cNames) /* exact casing as in JSON */.

    end method.

    /**
     * Purpose: Recursively searches the passed in JsonObject
     *          for an JsonObject or JsonArray (JsonConstruct) under
     *          a property with the given name
     * Notes:
     * @param poJson The input JsonConstruct
     * @param pcPropertyName The name of the property to locate
     * @return The matching JsonConstruct
     */
    method public static JsonConstruct FindJsonConstruct (poJson as JsonConstruct,
                                                          pcPropertyName as character):

        define variable oObject   as JsonObject    no-undo .
        define variable oArray    as JsonArray     no-undo .
        define variable cProperty as character     no-undo .
        define variable cNames    as character     no-undo extent .
        define variable i         as integer       no-undo .
        define variable oReturn   as JsonConstruct no-undo .

        if type-of (poJson, JsonObject) then do:
            oObject = cast (poJson, JsonObject) .

            assign cProperty = JsonHelper:ExactPropertyName (oObject, pcPropertyName) .

            if cProperty > "":U then do:
                if oObject:GetType (cProperty) = JsonDataType:OBJECT then
                    return oObject:GetJsonObject (cProperty) .

                if oObject:GetType (cProperty) = JsonDataType:ARRAY then
                    return oObject:GetJsonArray (cProperty) .
            end.

            assign cNames = oObject:GetNames() .

            do i = 1 to extent (cNames):
                assign cProperty = cNames[i] .

                if oObject:GetType (cProperty) = JsonDataType:OBJECT then
                    oReturn = JsonHelper:FindJsonConstruct (oObject:GetJsonObject (cProperty), pcPropertyName) .
                else if oObject:GetType (cProperty) = JsonDataType:ARRAY then
                    oReturn = JsonHelper:FindJsonConstruct (oObject:GetJsonArray (cProperty), pcPropertyName) .

                if valid-object (oReturn) then
                    return oReturn .
            end.
        end.
        else if type-of (poJson, JsonArray) then do:
            oArray = cast (poJson, JsonArray) .

            do i = 1 to oArray:Length:
                if oArray:GetType(i) = JsonDataType:OBJECT then
                    oReturn = JsonHelper:FindJsonConstruct (oArray:GetJsonObject (i), pcPropertyName) .
                else if oArray:GetType(i) = JsonDataType:ARRAY then
                    oReturn = JsonHelper:FindJsonConstruct (oArray:GetJsonArray (i), pcPropertyName) .

                if valid-object (oReturn) then
                    return oReturn .
            end.
        end.

        return ? .

    end method.

    /**
     * Purpose: Locates the JsonObject from a JsonArray with the requested
     *          integer value in a JsonArray property
     * Notes:
     * @param poJsonArray The JsonArray
     * @param pcPropertyName The name of the property
     * @param piPropertyValue The value of the property
     * @return The JsonObject or ? when the property value cannot be found
     */
    method public static JsonObject FindJsonObjectWithArrayValue (poJsonArray as JsonArray,
                                                                  pcPropertyName as character,
                                                                  piPropertyValue as integer):

        define variable oJsonObject as JsonObject no-undo .
        define variable oJsonArray  as JsonArray  no-undo .
        define variable i           as integer    no-undo .
        define variable j           as integer    no-undo .

        do i = 1 to poJsonArray:Length:
            oJsonObject = poJsonArray:GetJsonObject (i) .

            if oJsonObject:Has (pcPropertyName) then do:
                oJsonArray = oJsonObject:GetJsonArray (pcPropertyName).

                do j = 1 to oJsonArray:Length:
                    if oJsonArray:GetType(j) = JsonDataType:NUMBER then
                        if oJsonArray:GetInteger(j) = piPropertyValue then
                            return oJsonObject .
                end.
            end.
        end.

        return ? .

    end method.

    /**
     * Purpose: Locates the JsonObject from a JsonArray with the requested
     *          character property value
     * Notes:
     * @param poJsonArray The JsonArray
     * @param pcPropertyName The name of the property
     * @param pcPropertyValue The value of the property
     * @return The JsonObject or ? when the property value cannot be found
     */
    method public static JsonObject FindJsonObjectWithPropertyValue (poJsonArray as JsonArray,
                                                                     pcPropertyName as character,
                                                                     pcPropertyValue as character):

        define variable oJsonObject as JsonObject no-undo .
        define variable i           as integer    no-undo .
        define variable cName       as character  no-undo .

        do i = 1 to poJsonArray:Length:
            oJsonObject = poJsonArray:GetJsonObject (i) .

            if oJsonObject:Has (pcPropertyName) and
               oJsonObject:GetCharacter (pcPropertyName) = pcPropertyValue then

                return oJsonObject .

            assign cName = JsonHelper:ExactPropertyName (oJsonObject, pcPropertyName) .

            if cName > "":U then
                if oJsonObject:GetCharacter (cName) = pcPropertyValue then
                    return oJsonObject .
        end.

        return ? .

    end method.

    /**
     * Purpose: Locates the JsonObject from a JsonArray with the requested
     *          integer property value
     * Notes:
     * @param poJsonArray The JsonArray
     * @param pcPropertyName The name of the property
     * @param piPropertyValue The value of the property
     * @return The JsonObject or ? when the property value cannot be found
     */
    method public static JsonObject FindJsonObjectWithPropertyValue (poJsonArray as JsonArray,
                                                                     pcPropertyName as character,
                                                                     piPropertyValue as integer):

        define variable oJsonObject as JsonObject no-undo .
        define variable i           as integer    no-undo .
        define variable cName       as character  no-undo .

        do i = 1 to poJsonArray:Length:
            oJsonObject = poJsonArray:GetJsonObject (i) .

            if oJsonObject:Has (pcPropertyName) and
               oJsonObject:GetInteger (pcPropertyName) = piPropertyValue then

                return oJsonObject .

            assign cName = JsonHelper:ExactPropertyName (oJsonObject, pcPropertyName) .

            if cName > "":U then
                if oJsonObject:GetInteger (cName) = piPropertyValue then
                    return oJsonObject .
        end.

        return ? .

    end method.

&if not proversion begins "10" and not proversion eq "11.0" and not proversion eq "11.1" and not proversion eq "11.2" and not proversion eq "11.3" &then
    /**
     * Purpose: Returns the JSON Object with the contents of the given ProDataset
     * Notes:   Workaround, as the Dataset'S WRITE-JSON method does not support
     *          writing to a JsonObject directly
     * @param phDataset The handle of the dataset to return as JSON
     * @param plIncludeBeforeImage Logical value indicating if the ProDataset before-tables should should be written as well
     * @return The resulting JsonObject
     */
    method public static JsonObject FromDataset (phDataset as handle,
                                                 plIncludeBeforeImage as logical):

        define variable oJsonObject as JsonObject no-undo .

        oJsonObject = new JsonObject ().

        oJsonObject:Read (phDataset, false, plIncludeBeforeImage) .

        return oJsonObject .

    end method .

    /**
     * Purpose: Returns the JSON Object with the contents of the given ProDataset
     * Notes:   Workaround, as the Dataset'S WRITE-JSON method does not support
     *          writing to a JsonObject directly
     * @param phDataset The handle of the dataset to return as JSON
     * @return The resulting JsonObject
     */
    method public static JsonObject FromDataset (phDataset as handle):

        return JsonHelper:FromDataset (phDataset, true) .

    end method .

    /**
     * Purpose: Returns the JSON Object with the contents of the given Temp-Table
     * Notes:   Workaround, as the Temp-Table'S WRITE-JSON method does not support
     *          writing to a JsonObject directly
     * @param phTempTable The handle of the Temp-Table to return as JSON
     * @return The resulting JsonObject
     */
    method public static JsonObject FromTempTable (phTempTable as handle):

        define variable oJsonObject as JsonObject no-undo .

        oJsonObject = new JsonObject ().

        oJsonObject:Read (phTempTable, false) .

        return oJsonObject .

    end method .

    /**
     * Purpose: Returns the Character Value specified by the given path
     * Notes:   Based on GetJsonObjectByPath, the last part of the path specifies
     *          the property name
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @return The character value or ? when the path is not valid
     */
    method public static character GetCharacterByPath (poSourceJsonObject as JsonObject,
                                                       pcPath as character):

        return JsonHelper:GetCharacterByPath (poSourceJsonObject, pcPath, ".":u, ArrayBaseEnum:One) .

    end method .

    /**
     * Purpose: Returns the Character Value specified by the given path
     * Notes:   Based on GetJsonObjectByPath, the last part of the path specifies
     *          the property name
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The character specifying the path delimiter
     * @return The character value or ? when the path is not valid
     */
    method public static character GetCharacterByPath (poSourceJsonObject as JsonObject,
                                                       pcPath as character,
                                                       pcPathDelimiter as character):

        return JsonHelper:GetCharacterByPath (poSourceJsonObject, pcPath, pcPathDelimiter, ArrayBaseEnum:One) .

    end method .

    /**
     * Purpose: Returns the Character Value specified by the given path
     * Notes:   Based on GetJsonObjectByPath, the last part of the path specifies
     *          the property name
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param poArrayBase The array base (one or zero)
     * @return The character value or ? when the path is not valid
     */
    method public static character GetCharacterByPath (poSourceJsonObject as JsonObject,
                                                       pcPath as character,
                                                       poArrayBase as ArrayBaseEnum):

        return JsonHelper:GetCharacterByPath (poSourceJsonObject, pcPath, ".":U, poArrayBase) .

    end method .

    /**
     * Purpose: Returns the Character Value specified by the given path
     * Notes:   Based on GetJsonObjectByPath, the last part of the path specifies
     *          the property name
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The character specifying the path delimiter
     * @param poArrayBase The array base (one or zero)
     * @return The character value or ? when the path is not valid
     */
    method public static character GetCharacterByPath (poSourceJsonObject as JsonObject,
                                                       pcPath as character,
                                                       pcPathDelimiter as character,
                                                       poArrayBase as ArrayBaseEnum):

        define variable cProperty as character no-undo .
        define variable oObject   as JsonObject no-undo .

        JsonHelper:GetObjectAndPropertyName (poSourceJsonObject,
                                             pcPath,
                                             pcPathDelimiter,
                                             poArrayBase,
                                             output oObject,
                                             output cProperty) .

        if cProperty = ? then
            return ? .

        if cProperty > "":U and oObject:Has (cProperty) then
            return oObject:GetCharacter (cProperty) .

        return ? .

    end method.

    /**
     * Purpose: Returns the Integer Value specified by the given path
     * Notes:   Based on GetJsonObjectByPath, the last part of the path specifies
     *          the property name
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @return The character value or ? when the path is not valid
     */
    method public static integer GetIntegerByPath (poSourceJsonObject as JsonObject,
                                                   pcPath as character):

        return JsonHelper:GetIntegerByPath (poSourceJsonObject, pcPath, ".":U, ArrayBaseEnum:One) .

    end method .

    /**
     * Purpose: Returns the Integer Value specified by the given path
     * Notes:   Based on GetJsonObjectByPath, the last part of the path specifies
     *          the property name
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The character specifying the path delimiter
     * @return The character value or ? when the path is not valid
     */
    method public static integer GetIntegerByPath (poSourceJsonObject as JsonObject,
                                                   pcPath as character,
                                                   pcPathDelimiter as character):

        return JsonHelper:GetIntegerByPath (poSourceJsonObject, pcPath, pcPathDelimiter, ArrayBaseEnum:One) .

    end method .

    /**
     * Purpose: Returns the Integer Value specified by the given path
     * Notes:   Based on GetJsonObjectByPath, the last part of the path specifies
     *          the property name
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param poArrayBase The array base (one or zero)
     * @return The character value or ? when the path is not valid
     */
    method public static integer GetIntegerByPath (poSourceJsonObject as JsonObject,
                                                   pcPath as character,
                                                   poArrayBase as ArrayBaseEnum):

        return JsonHelper:GetIntegerByPath (poSourceJsonObject, pcPath, ".":U, poArrayBase) .

    end method.

    /**
     * Purpose: Returns the Integer Value specified by the given path
     * Notes:   Based on GetJsonObjectByPath, the last part of the path specifies
     *          the property name
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The character specifying the path delimiter
     * @param poArrayBase The array base (one or zero)
     * @return The character value or ? when the path is not valid
     */
    method public static integer GetIntegerByPath (poSourceJsonObject as JsonObject,
                                                   pcPath as character,
                                                   pcPathDelimiter as character,
                                                   poArrayBase as ArrayBaseEnum):

        define variable cProperty as character no-undo .
        define variable oObject   as JsonObject no-undo .

        JsonHelper:GetObjectAndPropertyName (poSourceJsonObject,
                                             pcPath,
                                             pcPathDelimiter,
                                             poArrayBase,
                                             output oObject,
                                             output cProperty) .

        if cProperty = ? then
            return ? .

        if cProperty > "":U and oObject:Has (cProperty) then
            return oObject:GetInteger (cProperty) .

        return ? .

    end method.

    /**
     * Purpose: Returns the Logical Value specified by the given path
     * Notes:   Based on GetJsonObjectByPath, the last part of the path specifies
     *          the property name
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @return The character value or ? when the path is not valid
     */
    method public static logical GetLogicalByPath (poSourceJsonObject as JsonObject,
                                                   pcPath as character):

        return JsonHelper:GetLogicalByPath (poSourceJsonObject, pcPath, ".":U, ArrayBaseEnum:One) .

    end method .

    /**
     * Purpose: Returns the Logical Value specified by the given path
     * Notes:   Based on GetJsonObjectByPath, the last part of the path specifies
     *          the property name
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The character specifying the path delimiter
     * @return The character value or ? when the path is not valid
     */
    method public static logical GetLogicalByPath (poSourceJsonObject as JsonObject,
                                                   pcPath as character,
                                                   pcPathDelimiter as character):

        return JsonHelper:GetLogicalByPath (poSourceJsonObject, pcPath, pcPathDelimiter, ArrayBaseEnum:One) .

    end method .

    /**
     * Purpose: Returns the Logical Value specified by the given path
     * Notes:   Based on GetJsonObjectByPath, the last part of the path specifies
     *          the property name
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param poArrayBase The array base (one or zero)
     * @return The character value or ? when the path is not valid
     */
    method public static logical GetLogicalByPath (poSourceJsonObject as JsonObject,
                                                   pcPath as character,
                                                   poArrayBase as ArrayBaseEnum):

        return JsonHelper:GetLogicalByPath (poSourceJsonObject, pcPath, ".":U, poArrayBase) .

    end method .

    /**
     * Purpose: Returns the Logical Value specified by the given path
     * Notes:   Based on GetJsonObjectByPath, the last part of the path specifies
     *          the property name
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The character specifying the path delimiter
     * @param poArrayBase The array base (one or zero)
     * @return The character value or ? when the path is not valid
     */
    method public static logical GetLogicalByPath (poSourceJsonObject as JsonObject,
                                                   pcPath as character,
                                                   pcPathDelimiter as character,
                                                   poArrayBase as ArrayBaseEnum):

        define variable cProperty as character no-undo .
        define variable oObject   as JsonObject no-undo .

        JsonHelper:GetObjectAndPropertyName (poSourceJsonObject,
                                             pcPath,
                                             pcPathDelimiter,
                                             poArrayBase,
                                             output oObject,
                                             output cProperty) .

        if cProperty = ? then
            return ? .

        if cProperty > "":U and oObject:Has (cProperty) then
            return oObject:GetLogical (cProperty) .

        return ? .

    end method.

    /**
     * Purpose: Returns the JSON object that is referenced by the path and the
     *          Property name
     * Notes:   Helper method for GetCharacterByPath, GetIntegerByPath, GetLogicalByPath
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The character to use as path delimiter
     * @param poArrayBase The array base (one or zero)
     * @param poObject OUTPUT The object that contains the property
     * @param pcProperty OUTPUT The name of the property
     */
    method protected static void GetObjectAndPropertyName (poSourceJsonObject as JsonObject,
                                                           pcPath as character,
                                                           pcPathDelimiter as character,
                                                           poArrayBase as ArrayBaseEnum,
                                                           output poObject as JsonObject,
                                                           output pcProperty as character):

        define variable cPath     as character no-undo .
        define variable iPos      as integer   no-undo .

        assign pcPath = JsonHelper:SanitizePath (pcPath)
               pcPath = replace (pcPath, "/":U, pcPathDelimiter)
               pcPath = replace (pcPath, "~\":U, pcPathDelimiter) .

        assign iPos = r-index (pcPath, pcPathDelimiter) .

        if iPos > 1 then
            assign cPath      = substring (pcPath, 1, iPos - 1, "CHARACTER":U)
                   pcProperty = JsonHelper:RestorePathEntry(substring (pcPath, iPos + 1, -1, "CHARACTER":U))
                   poObject   = JsonHelper:GetJsonObjectByPath(poSourceJsonObject, cPath, pcPathDelimiter, poArrayBase) .
        else
            assign cPath      = ""
                   pcProperty = JsonHelper:RestorePathEntry(left-trim (pcPath, pcPathDelimiter))
                   poObject   = poSourceJsonObject .

        if not valid-object (poObject) then do:
            pcProperty = ? .
            return .
        end.

        if not poObject:Has (pcProperty) then
            assign pcProperty = JsonHelper:ExactPropertyName (poObject, pcProperty) .

    end method.

&endif

    /**
     * Purpose: Returns the Json Array represented by a path in the source
     *          Json Object
     * Notes:   The path entries can be delimited by either period (.), slash (/)
     *          or back-slash (\)
     *          Defaults to 1 based arrays (ABL default), Sample path:
     *          dsCustomer.eCustomer[1].eSalesRep[1]
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @return The target Json object
     */
    method public static JsonArray GetJsonArrayByPath (poSourceJsonObject as JsonObject,
                                                       pcPath as character):

        return JsonHelper:GetJsonArrayByPath (poSourceJsonObject, pcPath, ".":U, ArrayBaseEnum:One) .

    end method.

    /**
     * Purpose: Returns the Json Array represented by a path in the source
     *          Json Object
     * Notes:   The path entries can be delimited by either period (.), slash (/)
     *          or back-slash (\)
     *          Defaults to 1 based arrays (ABL default), Sample path:
     *          dsCustomer.eCustomer[1].eSalesRep[1]
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The character to use as path delimiter
     * @return The target Json object
     */
    method public static JsonArray GetJsonArrayByPath (poSourceJsonObject as JsonObject,
                                                       pcPath as character,
                                                       pcPathDelimiter as character):

        return JsonHelper:GetJsonArrayByPath (poSourceJsonObject, pcPath, pcPathDelimiter, ArrayBaseEnum:One) .

    end method.

    /**
     * Purpose: Returns the Json Array represented by a path in the source
     *          Json Object
     * Notes:   The path entries can be delimited by either period (.), slash (/)
     *          or back-slash (\)
     *          dsCustomer.eCustomer[1].eSalesRep[1]
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param poArrayBase The array base (one or zero)
     * @return The target Json object
     */
    method public static JsonArray GetJsonArrayByPath (poSourceJsonObject as JsonObject,
                                                       pcPath as character,
                                                       poArrayBase as ArrayBaseEnum):

        return JsonHelper:GetJsonArrayByPath (poSourceJsonObject, pcPath, ".":U, poArrayBase) .

    end method.

    /**
     * Purpose: Returns the Json Array represented by a path in the source
     *          Json Object
     * Notes:   The path entries can be delimited by either period (.), slash (/)
     *          or back-slash (\)
     *          dsCustomer.eCustomer[1].eSalesRep[1]
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The character to use as path delimiter
     * @param poArrayBase The array base (one or zero)
     * @return The target Json object
     */
    method public static JsonArray GetJsonArrayByPath (poSourceJsonObject as JsonObject,
                                                       pcPath as character,
                                                       pcPathDelimiter as character,
                                                       poArrayBase as ArrayBaseEnum):

        define variable i           as integer    no-undo .
        define variable cEntry      as character  no-undo .
        define variable cEntry2     as character  no-undo .
        define variable oJsonObject as JsonObject no-undo .
        define variable iIndex      as integer    no-undo .

        assign pcPath = JsonHelper:SanitizePath (pcPath)
               pcPath = replace (pcPath, "/":U, pcPathDelimiter)
               pcPath = replace (pcPath, "~\":U, pcPathDelimiter)

               oJsonObject = poSourceJsonObject .

        do i = 1 to num-entries (pcPath, pcPathDelimiter) - 1:
            assign cEntry = JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter))
                   cEntry2 = cEntry .

            if not oJsonObject:Has (cEntry) then
                assign cEntry = JsonHelper:ExactPropertyName (oJsonObject, cEntry) .

            if cEntry = ? and index (cEntry, "[":U) = 0 then
                undo, throw new InvalidParameterValueException ("pcPath":U,
                                                                "Consultingwerk.Util.JsonHelper":U,
                                                                substitute ("Invalid entry &1 in path &2."{&TRAN},
                                                                            JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter)),
                                                                            JsonHelper:RestorePathEntry (pcPath)),
                                                                0) .

            if cEntry > "":U then
                oJsonObject = oJsonObject:GetJsonObject (cEntry) .
            else do:
                assign cEntry = cEntry2
                       iIndex = DataTypeHelper:ToInteger(trim (substring (cEntry, index (cEntry, "[":U) + 1, -1, "CHARACTER":U), "]":U))
                       cEntry = substring (cEntry, 1, index (cEntry, "[":U) - 1, "CHARACTER":U) .

                if not oJsonObject:Has (cEntry) then
                    assign cEntry = JsonHelper:ExactPropertyName (oJsonObject, cEntry) .

                if cEntry = ? then
                    undo, throw new InvalidParameterValueException ("pcPath":U,
                                                                    "Consultingwerk.Util.JsonHelper":U,
                                                                    substitute ("Invalid entry &1 in path &2."{&TRAN},
                                                                                JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter)),
                                                                                JsonHelper:RestorePathEntry (pcPath)),
                                                                    0) .

                if iIndex >= 0 then do:
                    if poArrayBase = ArrayBaseEnum:Zero then
                        assign iIndex = iIndex + 1 .

                    assign oJsonObject = oJsonObject:GetJsonArray (cEntry):GetJsonObject (iIndex) .
                end.
                else
                    undo, throw new InvalidParameterValueException ("pcPath":U,
                                                                    "Consultingwerk.Util.JsonHelper":U,
                                                                    substitute ("Invalid entry &1 in path &2."{&TRAN},
                                                                                JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter)),
                                                                                JsonHelper:RestorePathEntry (pcPath)),
                                                                    0) .
            end.
        end.

        assign cEntry = entry (num-entries (pcPath, pcPathDelimiter), pcPath, pcPathDelimiter) .

        if not oJsonObject:Has (cEntry) then
            assign cEntry = JsonHelper:ExactPropertyName (oJsonObject, cEntry) .

        if cEntry = ? then
            undo, throw new InvalidParameterValueException ("pcPath":U,
                                                            "Consultingwerk.Util.JsonHelper":U,
                                                            substitute ("Invalid entry &1 in path &2.":U,
                                                                        JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter)),
                                                                        JsonHelper:RestorePathEntry (pcPath)),
                                                            0) .

        return oJsonObject:GetJsonArray (cEntry).

    end method.

    /**
     * Purpose: Returns the Json Object represented by a path in the source
     *          Json Object
     * Notes:   The path entries can be delimited by either period (.), slash (/)
     *          or back-slash (\)
     *          Defaults to 1 based arrays (ABL default), Sample path:
     *          dsCustomer.eCustomer[1].eSalesRep[1]
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @return The target Json object
     */
    method public static JsonObject GetJsonObjectByPath (poSourceJsonObject as JsonObject,
                                                         pcPath as character):

        return JsonHelper:GetJsonObjectByPath (poSourceJsonObject, pcPath, ".":U, ArrayBaseEnum:One) .

    end method.

    /**
     * Purpose: Returns the Json Object represented by a path in the source
     *          Json Object
     * Notes:   The path entries can be delimited by either period (.), slash (/)
     *          or back-slash (\)
     *          Defaults to 1 based arrays (ABL default), Sample path:
     *          dsCustomer.eCustomer[1].eSalesRep[1]
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The character specifying the path delimiter
     * @return The target Json object
     */
    method public static JsonObject GetJsonObjectByPath (poSourceJsonObject as JsonObject,
                                                         pcPath as character,
                                                         pcPathDelimiter as character):

        return JsonHelper:GetJsonObjectByPath (poSourceJsonObject, pcPath, pcPathDelimiter, ArrayBaseEnum:One) .

    end method.

    /**
     * Purpose: Returns the Json Object represented by a path in the source
     *          Json Object
     * Notes:   The path entries can be delimited by either period (.), slash (/)
     *          or back-slash (\)
     *          dsCustomer.eCustomer[1].eSalesRep[1]
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param poArrayBase The array base (one or zero)
     * @return The target Json object
     */
    method public static JsonObject GetJsonObjectByPath (poSourceJsonObject as JsonObject,
                                                         pcPath as character,
                                                         poArrayBase as ArrayBaseEnum):

        return JsonHelper:GetJsonObjectByPath (poSourceJsonObject, pcPath, ".":U, poArrayBase) .

    end method .

    /**
     * Purpose: Returns the Json Object represented by a path in the source
     *          Json Object
     * Notes:   The path entries can be delimited by either period (.), slash (/)
     *          or back-slash (\)
     *          dsCustomer.eCustomer[1].eSalesRep[1]
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The character specifying the path delimiter
     * @param poArrayBase The array base (one or zero)
     * @return The target Json object
     */
    method public static JsonObject GetJsonObjectByPath (poSourceJsonObject as JsonObject,
                                                         pcPath as character,
                                                         pcPathDelimiter as character,
                                                         poArrayBase as ArrayBaseEnum):

        define variable i           as integer    no-undo .
        define variable cEntry      as character  no-undo .
        define variable cEntry2     as character  no-undo .
        define variable oJsonObject as JsonObject no-undo .
        define variable iIndex      as integer    no-undo .

        assign pcPath = JsonHelper:SanitizePath (pcPath)
               pcPath = replace (pcPath, "/":U, pcPathDelimiter)
               pcPath = replace (pcPath, "~\":U, pcPathDelimiter)

               oJsonObject = poSourceJsonObject .

        do i = 1 to num-entries (pcPath, pcPathDelimiter):
            assign cEntry  = JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter))
                   cEntry2 = cEntry.

            if not oJsonObject:Has (cEntry) then
                assign cEntry = JsonHelper:ExactPropertyName (oJsonObject, cEntry) .

            if cEntry = ? and index (cEntry, "[":U) = 0 then
                undo, throw new InvalidParameterValueException ("pcPath":U,
                                                                "Consultingwerk.Util.JsonHelper":U,
                                                                substitute ("Invalid entry &1 in path &2."{&TRAN},
                                                                            JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter)),
                                                                            JsonHelper:RestorePathEntry (pcPath)),
                                                                0) .

            if cEntry > "":U then
                oJsonObject = oJsonObject:GetJsonObject (cEntry) .
            else do:
                assign cEntry = cEntry2
                       iIndex = DataTypeHelper:ToInteger(trim (substring (cEntry, index (cEntry, "[":U) + 1, -1, "CHARACTER":U), "]":U))
                       cEntry = substring (cEntry, 1, index (cEntry, "[":U) - 1, "CHARACTER":U) .

                if not oJsonObject:Has (cEntry) then
                    assign cEntry = JsonHelper:ExactPropertyName (oJsonObject, cEntry) .

                if cEntry = ? then
                    undo, throw new InvalidParameterValueException ("pcPath":U,
                                                                    "Consultingwerk.Util.JsonHelper":U,
                                                                    substitute ("Invalid entry &1 in path &2."{&TRAN},
                                                                                JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter)),
                                                                                JsonHelper:RestorePathEntry (pcPath)),
                                                                    0) .

                if iIndex >= 0 then do:
                    if poArrayBase = ArrayBaseEnum:Zero then
                        assign iIndex = iIndex + 1 .

                    assign oJsonObject = oJsonObject:GetJsonArray (cEntry):GetJsonObject (iIndex) .
                end.
                else
                    undo, throw new InvalidParameterValueException ("pcPath":U,
                                                                    "Consultingwerk.Util.JsonHelper":U,
                                                                    substitute ("Invalid entry &1 in path &2."{&TRAN},
                                                                                JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter)),
                                                                                JsonHelper:RestorePathEntry (pcPath)),
                                                                    0) .
            end.
        end.

        return oJsonObject .

    end method.

    /**
     * Purpose: Returns the Json Data Type represented by a path in the source
     *          Json Object
     * Notes:   The path entries can be delimited by either period (.), slash (/)
     *          or back-slash (\)
     *          Defaults to 1 based arrays (ABL default), Sample path:
     *          dsCustomer.eCustomer[1].eSalesRep[1]
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @return The Integer value representing the JsonDataType
     */
    method public static integer GetJsonDataTypeByPath (poSourceJsonObject as JsonObject,
                                                        pcPath as character):

        return JsonHelper:GetJsonDataTypeByPath (poSourceJsonObject, pcPath, ".":U, ArrayBaseEnum:One) .

    end method.

    /**
     * Purpose: Returns the Json Data Type represented by a path in the source
     *          Json Object
     * Notes:   The path entries can be delimited by either period (.), slash (/)
     *          or back-slash (\)
     *          Defaults to 1 based arrays (ABL default), Sample path:
     *          dsCustomer.eCustomer[1].eSalesRep[1]
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The path delimiter
     * @return The Integer value representing the JsonDataType
     */
    method public static integer GetJsonDataTypeByPath (poSourceJsonObject as JsonObject,
                                                        pcPath as character,
                                                        pcPathDelimiter as character):

        return JsonHelper:GetJsonDataTypeByPath (poSourceJsonObject, pcPath, pcPathDelimiter, ArrayBaseEnum:One) .

    end method.

    /**
     * Purpose: Returns the Json Data Type represented by a path in the source
     *          Json Object
     * Notes:   The path entries can be delimited by either period (.), slash (/)
     *          or back-slash (\)
     *          dsCustomer.eCustomer[1].eSalesRep[1]
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param poArrayBase The array base (one or zero)
     * @return The Integer value representing the JsonDataType
     */
    method public static integer GetJsonDataTypeByPath (poSourceJsonObject as JsonObject,
                                                        pcPath as character,
                                                        poArrayBase as ArrayBaseEnum):

        return JsonHelper:GetJsonDataTypeByPath (poSourceJsonObject, pcPath, ".":U, poArrayBase) .

    end method.

    /**
     * Purpose: Returns the Json Data Type represented by a path in the source
     *          Json Object
     * Notes:   The path entries can be delimited by either period (.), slash (/)
     *          or back-slash (\)
     *          dsCustomer.eCustomer[1].eSalesRep[1]
     *          Supports tilde for escaping path delimiters
     * @param poSourceJsonObject The source Json object that contains the target Json object
     * @param pcPath The path specifying the target object
     * @param pcPathDelimiter The path delimiter
     * @param poArrayBase The array base (one or zero)
     * @return The Integer value representing the JsonDataType
     */
    method public static integer GetJsonDataTypeByPath (poSourceJsonObject as JsonObject,
                                                        pcPath as character,
                                                        pcPathDelimiter as character,
                                                        poArrayBase as ArrayBaseEnum):

        define variable i           as integer    no-undo .
        define variable cEntry      as character  no-undo .
        define variable cEntry2     as character  no-undo .
        define variable oJsonObject as JsonObject no-undo .
        define variable iIndex      as integer    no-undo .
        define variable iCount      as integer    no-undo .

        assign pcPath      = JsonHelper:SanitizePath (pcPath)
               pcPath      = replace (pcPath, "/":U, pcPathDelimiter)
               pcPath      = replace (pcPath, "~\":U, pcPathDelimiter)

               oJsonObject = poSourceJsonObject

               iCount      = num-entries (pcPath, pcPathDelimiter).

        do i = 1 to iCount:
            assign cEntry  = JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter))
                   cEntry2 = cEntry .

            if not oJsonObject:Has (cEntry) then
                assign cEntry = JsonHelper:ExactPropertyName (oJsonObject, cEntry) .

            if cEntry = ? and index (cEntry, "[":U) = 0 then
                undo, throw new InvalidParameterValueException ("pcPath":U,
                                                                "Consultingwerk.Util.JsonHelper":U,
                                                                substitute ("Invalid entry &1 in path &2."{&TRAN},
                                                                            JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter)),
                                                                            JsonHelper:RestorePathEntry (pcPath)),
                                                                0) .

            if cEntry > "":U then do:
                if i = iCount then
                    return oJsonObject:GetType (cEntry) .

                oJsonObject = oJsonObject:GetJsonObject (cEntry) .
            end.
            else do:
                assign cEntry = cEntry2
                       iIndex = DataTypeHelper:ToInteger(trim (substring (cEntry, index (cEntry, "[":U) + 1, -1, "CHARACTER":U), "]":U))
                       cEntry = substring (cEntry, 1, index (cEntry, "[":U) - 1, "CHARACTER":U) .

                if not oJsonObject:Has (cEntry) then
                    assign cEntry = JsonHelper:ExactPropertyName (oJsonObject, cEntry) .

                if cEntry = ? then
                    undo, throw new InvalidParameterValueException ("pcPath":U,
                                                                    "Consultingwerk.Util.JsonHelper":U,
                                                                    substitute ("Invalid entry &1 in path &2."{&TRAN},
                                                                                JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter)),
                                                                                JsonHelper:RestorePathEntry (pcPath)),
                                                                    0) .

                if iIndex >= 0 then do:
                    if poArrayBase = ArrayBaseEnum:Zero then
                        assign iIndex = iIndex + 1 .

                    if i = iCount then
                        return oJsonObject:GetJsonArray (cEntry):GetType (iIndex) .

                    assign oJsonObject = oJsonObject:GetJsonArray (cEntry):GetJsonObject (iIndex) .
                end.
                else
                    undo, throw new InvalidParameterValueException ("pcPath":U,
                                                                    "Consultingwerk.Util.JsonHelper":U,
                                                                    substitute ("Invalid entry &1 in path &2."{&TRAN},
                                                                                JsonHelper:RestorePathEntry (entry (i, pcPath, pcPathDelimiter)),
                                                                                JsonHelper:RestorePathEntry (pcPath)),
                                                                    0) .
            end.
        end.

    end method.

    /**
     * Purpose: Returns if the given property is an Integer value
     * Notes:   As JSON does not distinguish between Integer and Decimal
     *          it is required to test values for type compatibility
     * @param poJsonObject The JSON object
     * @param pcPropertyName The property to test for integer
     * @return Logical value indicating if the given property is Integer
     */
    method public static logical IsIntegerProperty (poJsonObject as JsonObject,
                                                    pcPropertyName as character):

        if not poJsonObject:Has (pcPropertyName) then
            return false .

        if not poJsonObject:GetType (pcPropertyName) = JsonDataType:NUMBER then
            return false .

        poJsonObject:GetInteger (pcPropertyName) .

        return true .

        catch uncaught as Progress.Lang.Error:
            return false .
        end catch.

    end method.

    /**
     * Purpose: Returns if the given property is an Integer value
     * Notes:   As JSON does not distinguish between Integer and Decimal
     *          it is required to test values for type compatibility
     * @param poJsonArray The JSON array
     * @param piIndex The array index to test for integer
     * @return Logical value indicating if the given property is Integer
     */
    method public static logical IsIntegerProperty (poJsonArray as JsonArray,
                                                    piIndex as integer):

        if not poJsonArray:GetType (piIndex) = JsonDataType:NUMBER then
            return false .

        poJsonArray:GetInteger (piIndex) .

        return true .

        catch uncaught as Progress.Lang.Error:
            return false .
        end catch.

    end method.

    /**
     * Purpose: Returns if the given property is an Int64 value
     * Notes:   As JSON does not distinguish between Integer and Decimal
     *          it is required to test values for type compatibility
     * @param poJsonObject The JSON object
     * @param pcPropertyName The property to test for integer
     * @return Logical value indicating if the given property is Integer
     */
    method public static logical IsInt64Property (poJsonObject as JsonObject,
                                                  pcPropertyName as character):

        if not poJsonObject:Has (pcPropertyName) then
            return false .

        if not poJsonObject:GetType (pcPropertyName) = JsonDataType:NUMBER then
            return false .

        poJsonObject:GetInt64 (pcPropertyName) .

        return true .

        catch uncaught as Progress.Lang.Error:
            return false .
        end catch.

    end method.

    /**
     * Purpose: Returns if the given property is an Int64 value
     * Notes:   As JSON does not distinguish between Integer and Decimal
     *          it is required to test values for type compatibility
     * @param poJsonArray The JSON array
     * @param piIndex The array index to test for integer
     * @return Logical value indicating if the given property is Integer
     */
    method public static logical IsInt64Property (poJsonArray as JsonArray,
                                                  piIndex as integer):

        if not poJsonArray:GetType (piIndex) = JsonDataType:NUMBER then
            return false .

        poJsonArray:GetInt64 (piIndex) .

        return true .

        catch uncaught as Progress.Lang.Error:
            return false .
        end catch.

    end method.

    /**
     * Purpose: Converts a JsonArray into the Character Extent
     * Notes:   Will error, when the values are not compatible to character
     * @param poArray The JsonArray to convert
     * @return The Character Extent field
     */
    method public static character extent JsonArrayToCharacterExtent (poArray as JsonArray):

        define variable cReturn as character no-undo extent .
        define variable i       as integer   no-undo .

        if poArray:Length = 0 then
            return cReturn .

        extent (cReturn) = poArray:Length .

        do i = 1 to poArray:Length:

            if poArray:IsNull(i) then
                assign cReturn [i] = ? .
            else
                assign cReturn [i] = poArray:GetCharacter (i) .
        end.

        return cReturn.

    end method.

    /**
     * Purpose: Converts a JsonArray into the Date Extent
     * Notes:   Will error, when the values are not compatible to date
     * @param poArray The JsonArray to convert
     * @return The Date Extent field
     */
    method public static date extent JsonArrayToDateExtent (poArray as JsonArray):

        define variable dtReturn as date    no-undo extent .
        define variable i       as integer no-undo .

        if poArray:Length = 0 then
            return dtReturn .

        extent (dtReturn) = poArray:Length .

        do i = 1 to poArray:Length:

            if poArray:IsNull(i) then
                assign dtReturn [i] = ? .
            else
                assign dtReturn [i] = poArray:GetDate(i) .
        end.

        return dtReturn.

    end method.

    /**
     * Purpose: Converts a JsonArray into the DateTime Extent
     * Notes:   Will error, when the values are not compatible to DateTime
     * @param poArray The JsonArray to convert
     * @return The DateTime Extent field
     */
    method public static datetime extent JsonArrayToDateTimeExtent (poArray as JsonArray):

        define variable dtReturn as datetime no-undo extent .
        define variable i       as integer  no-undo .

        if poArray:Length = 0 then
            return dtReturn .

        extent (dtReturn) = poArray:Length .

        do i = 1 to poArray:Length:

            if poArray:IsNull(i) then
                assign dtReturn [i] = ? .
            else
                assign dtReturn [i] = poArray:GetDateTime(i) .
        end.

        return dtReturn.

    end method.

    /**
     * Purpose: Converts a JsonArray into the DateTime-TZ Extent
     * Notes:   Will error, when the values are not compatible to DateTime-TZ
     * @param poArray The JsonArray to convert
     * @return The DateTime-TZ Extent field
     */
    method public static datetime-tz extent JsonArrayToDateTimeTzExtent (poArray as JsonArray):

        define variable dtReturn as datetime-tz no-undo extent .
        define variable i       as integer     no-undo .

        if poArray:Length = 0 then
            return dtReturn .

        extent (dtReturn) = poArray:Length .

        do i = 1 to poArray:Length:

            if poArray:IsNull(i) then
                assign dtReturn [i] = ? .
            else
                assign dtReturn [i] = poArray:GetDateTimeTZ(i) .
        end.

        return dtReturn.

    end method.

    /**
     * Purpose: Converts a JsonArray into the Decimal Extent
     * Notes:   Will error, when the values are not compatible to decimal
     * @param poArray The JsonArray to convert
     * @return The Decimal Extent field
     */
    method public static decimal extent JsonArrayToDecimalExtent (poArray as JsonArray):

        define variable deReturn as decimal no-undo extent .
        define variable i        as integer no-undo .

        if poArray:Length = 0 then
            return deReturn .

        extent (deReturn) = poArray:Length .

        do i = 1 to poArray:Length:

            if poArray:IsNull(i) then
                assign deReturn [i] = ? .
            else
                assign deReturn [i] = poArray:GetDecimal(i) .
        end.

        return deReturn.

    end method.

    /**
     * Purpose: Converts a JsonArray into the INT64 Extent
     * Notes:   Will error, when the values are not compatible to INT64
     * @param poArray The JsonArray to convert
     * @return The INT64 Extent field
     */
    method public static int64 extent JsonArrayToInt64Extent (poArray as JsonArray):

        define variable iReturn as int64   no-undo extent .
        define variable i       as integer no-undo .

        if poArray:Length = 0 then
            return iReturn .

        extent (iReturn) = poArray:Length .

        do i = 1 to poArray:Length:

            if poArray:IsNull(i) then
                assign iReturn [i] = ? .
            else
                assign iReturn [i] = poArray:GetInt64(i) .
        end.

        return iReturn.

    end method.

    /**
     * Purpose: Converts a JsonArray into the Integer Extent
     * Notes:   Will error, when the values are not compatible to integer
     * @param poArray The JsonArray to convert
     * @return The Integer Extent field
     */
    method public static integer extent JsonArrayToIntegerExtent (poArray as JsonArray):

        define variable iReturn as integer no-undo extent .
        define variable i       as integer no-undo .

        if poArray:Length = 0 then
            return iReturn .

        extent (iReturn) = poArray:Length .

        do i = 1 to poArray:Length:

            if poArray:IsNull(i) then
                assign iReturn [i] = ? .
            else
                assign iReturn [i] = poArray:GetInteger (i) .
        end.

        return iReturn.

    end method.

    /**
     * Purpose: Converts a JsonArray into the Logical Extent
     * Notes:   Will error, when the values are not compatible to logical
     * @param poArray The JsonArray to convert
     * @return The Logical Extent field
     */
    method public static logical extent JsonArrayToLogicalExtent (poArray as JsonArray):

        define variable lReturn as logical no-undo extent .
        define variable i       as integer no-undo .

        if poArray:Length = 0 then
            return lReturn .

        extent (lReturn) = poArray:Length .

        do i = 1 to poArray:Length:

            if poArray:IsNull(i) then
                assign lReturn [i] = ? .
            else
                assign lReturn [i] = poArray:GetLogical(i) .
        end.

        return lReturn.

    end method.

    /**
     * Purpose: Converts a JsonArray into the Longchar Extent
     * Notes:   Will error, when the values are not compatible to longchar
     * @param poArray The JsonArray to convert
     * @return The Longchar Extent field
     */
    method public static longchar extent JsonArrayToLongcharExtent (poArray as JsonArray):

        define variable lcReturn as longchar no-undo extent .
        define variable i       as integer  no-undo .

        if poArray:Length = 0 then
            return lcReturn .

        extent (lcReturn) = poArray:Length .

        do i = 1 to poArray:Length:

            if poArray:IsNull(i) then
                assign lcReturn [i] = ? .
            else
                assign lcReturn [i] = poArray:GetLongchar(i) .
        end.

        return lcReturn.

    end method.

    /**
     * Purpose: Returns the JsonDataTypeEnum member matching the provided
     *          Progress.Json.ObjectModel.JsonDataType integer value
     * Notes:   OpenEdge is providing an integer constant to qualify JSON data type
     * @param piJsonDataType The JsonDataType integer value
     * @return The matching JsonDataTypoToEnum enum member
     */
    method public static JsonDataTypeEnum JsonDataTypeToEnum (piJsonDataType as integer):

        case piJsonDataType:

            when 1 then
                return JsonDataTypeEnum:String .
            when 2 then
                return JsonDataTypeEnum:Number .
            when 3 then
                return JsonDataTypeEnum:Boolean .
            when 4 then
                return JsonDataTypeEnum:Object .
            when 5 then
                return JsonDataTypeEnum:Array .
            when 6 then
                return JsonDataTypeEnum:Null .
            otherwise
                undo, throw new InvalidParameterValueException ("piJsonDataType":U, string (piJsonDataType), "Consultingwerk.Util.JsonHelper":U) .

        end case .

    end method.

    /**
     * Purpose: Converts a JsonObject to a property list
     * Notes:   { a: 123, b: { c: 456, d: 789 } } will be turned into
     *          a = 123
     *          b.c = 456
     *          b.d = 789
     * @param poJson The JsonObject to convert
     * @param pcDelimiter The delimiter to use when processing nested objects
     * @return The ListNameValuePair with the properties
     */
    method public static ListNameValuePair JsonObjectToPropertyList (poJson as JsonObject,
                                                                     pcDelimiter as character):

        define variable oList as ListNameValuePair no-undo .

        oList = new ListNameValuePair() .

        JsonHelper:JsonObjectToPropertyList (poJson,
                                             pcDelimiter,
                                             oList,
                                             "":U) .

        return oList .

    end method.

    @SuppressUnusedWarnings.
    /**
     * Purpose: Converts a JsonObject to a property list
     * Notes:   { a: 123, b: { c: 456, d: 789 } } will be turned into
     *          a = 123
     *          b.c = 456
     *          b.d = 789
     * @param poJson The JsonObject to convert
     * @param pcDelimiter The delimiter to use when processing nested objects
     * @param poList The list to add properties to
     * @param pcPrefix The prefix to use for the name
     */
    method private static void JsonObjectToPropertyList (poJson as JsonObject,
                                                         pcDelimiter as character,
                                                         poList as ListNameValuePair,
                                                         pcPrefix as character):

        define variable cNames as character no-undo extent .
        define variable i      as integer   no-undo .

        assign cNames = poJson:GetNames() .

        do i = 1 to extent (cNames):
            case poJson:GetType(cNames[i]):
                when JsonDataType:OBJECT then
                    JsonHelper:JsonObjectToPropertyList (poJson:GetJsonObject(cNames[i]),
                                                         pcDelimiter,
                                                         poList,
                                                         pcPrefix +
                                                            (if pcPrefix > "":U then pcDelimiter else "") +
                                                            cNames[i]
                                                         ) .
                when JsonDataType:STRING then
                    poList:Add (pcPrefix +
                                (if pcPrefix > "":U then pcDelimiter else "":U) +
                                 cNames [i],
                                poJson:GetCharacter(cNames[i])) .
                when JsonDataType:BOOLEAN then
                    poList:Add (pcPrefix +
                                (if pcPrefix > "":U then pcDelimiter else "":U) +
                                 cNames [i],
                                string (poJson:GetLogical(cNames[i]))) .
                when JsonDataType:NUMBER then
                    poList:Add (pcPrefix +
                                (if pcPrefix > "":U then pcDelimiter else "":U) +
                                 cNames [i],
                                string (poJson:GetDecimal(cNames[i]))) .
                when JsonDataType:NULL then
                    poList:Add (pcPrefix +
                                (if pcPrefix > "":U then pcDelimiter else "":U) +
                                 cNames [i],
                                ?) .

            end case .
        end.

    end method .

    /**
     * Purpose: Returns a delimited list with the values of the given
     *          attributes of the JsonObject
     * Notes:
     * @param poJsonObject The reference to the JsonObject
     * @param pcAttributeNames The comma delimited list with the names of the JSON attributes
     * @return The delimited list with the values
     */
    method public static character ListFromAttributeValues (poJsonObject as JsonObject,
                                                            pcAttributeNames as character):

        return JsonHelper:ListFromAttributeValues(poJsonObject, pcAttributeNames, ",":U) .

    end method .

    /**
     * Purpose: Returns a delimited list with the values of the given
     *          attributes of the JsonObject
     * Notes:
     * @param poJsonObject The reference to the JsonObject
     * @param pcAttributeNames The comma delimited list with the names of the JSON attributes
     * @param pcDelimiter The list delimited
     * @return The delimited list with the values
     */
    method public static character ListFromAttributeValues (poJsonObject as JsonObject,
                                                            pcAttributeNames as character,
                                                            pcDelimiter as character):

        define variable cList  as character no-undo .
        define variable lFirst as logical   no-undo initial true .
        define variable cName  as character no-undo .
        define variable i      as integer   no-undo .

        do i = 1 to num-entries (pcAttributeNames):

            assign cName = entry (i, pcAttributeNames) .

            case poJsonObject:GetType (cName):
                when JsonDataType:STRING then
                    assign cList = cList +
                                   (if lFirst = false then pcDelimiter else "":U) +
                                   poJsonObject:GetCharacter(cName)
                           lFirst = false .

                when JsonDataType:NULL then
                    assign cList = cList +
                                   (if lFirst = false then pcDelimiter else "":U) +
                                   "?":U
                           lFirst = false .

                when JsonDataType:NUMBER then do:
                    if JsonHelper:IsIntegerProperty(poJsonObject, cName) then
                        assign cList = cList +
                                       (if lFirst = false then pcDelimiter else "":U) +
                                       string (poJsonObject:GetInteger(cName))
                               lFirst = false .
                    else if JsonHelper:IsInt64Property(poJsonObject, cName) then
                        assign cList = cList +
                                       (if lFirst = false then pcDelimiter else "":U) +
                                       string (poJsonObject:GetInt64(cName))
                               lFirst = false .
                    else assign cList = cList +
                                        (if lFirst = false then pcDelimiter else "":U) +
                                        string (poJsonObject:GetDecimal(cName))
                                lFirst = false .
                end.

                when JsonDataType:BOOLEAN then
                    assign cList = cList +
                                   (if lFirst = false then pcDelimiter else "":U) +
                                   string (poJsonObject:GetLogical(cName))
                           lFirst = false .
            end case .

            assign lFirst = false .

        end.

        return cList.

    end method.

    /**
     * Purpose: Copies the entries of the source JsonArray to the Target JsonArray
     * Notes:   Treats all numbers as Integer
     * @param poSource The source JsonArray
     * @param poTarget The target JsonArray
     */
    method public static void MergeJsonArrays (poSource as JsonArray,
                                               poTarget as JsonArray):

        define variable i as integer no-undo.

        do i = 1 to poSource:Length:
            case poSource:GetType(i):
                when JsonDataType:NULL then
                    poTarget:AddNull () .
                when JsonDataType:BOOLEAN then
                    poTarget:Add (poSource:GetLogical(i)) .
                when JsonDataType:NUMBER then do:
                    if JsonHelper:IsIntegerProperty(poSource, i) then
                        poTarget:Add (poSource:GetInteger (i)) .
                    else if JsonHelper:IsInt64Property(poSource, i) then
                        poTarget:Add (poSource:GetInt64 (i)) .
                    else
                        poTarget:Add (poSource:GetDecimal (i)) .
                end.
                when JsonDataType:STRING then
                    poTarget:Add (poSource:GetCharacter (i)) .
                when JsonDataType:OBJECT then
                    poTarget:Add (poSource:GetJsonObject (i)) .
                when JsonDataType:ARRAY then
                    poTarget:Add (poSource:GetJsonArray (i)) .
            end case.
        end.

    end method.

    /**
     * Purpose: Copies the properties of the source JsonObject to the Target JsonObject
     * Notes:   Treats all numbers as Integer
     * @param poSource The source JsonObject
     * @param poTarget The target JsonObject
     */
    method public static void MergeJsonObjects (poSource as JsonObject,
                                                poTarget as JsonObject):

        define variable cNames     as character no-undo extent .
        define variable i          as integer   no-undo .
        define variable cProperty  as character no-undo.
        define variable cProperty2 as character no-undo.

        assign cNames = poSource:GetNames() .

        /* Iterate the configuration properties */
        propertyLoop:
        do i = 1 to extent (cNames):

            assign cProperty  = cNames[i]
                   cProperty2 = JsonHelper:ExactPropertyName (poTarget, cProperty) .

            if cProperty2 = ? then
                assign cProperty2 = cProperty .

            if poTarget:Has (cProperty2) then
                case poSource:GetType (cProperty):
                    when JsonDataType:NULL then
                        poTarget:SetNull (cProperty2) .
                    when JsonDataType:BOOLEAN then
                        poTarget:Set (cProperty2, poSource:GetLogical(cProperty)) .
                    when JsonDataType:NUMBER then do:
                        if JsonHelper:IsIntegerProperty(poSource, cProperty) then
                            poTarget:Set (cProperty2, poSource:GetInteger (cProperty)) .
                        else if JsonHelper:IsInt64Property(poSource, cProperty) then
                            poTarget:Set (cProperty2, poSource:GetInt64 (cProperty)) .
                        else
                            poTarget:Set (cProperty2, poSource:GetDecimal (cProperty)) .
                    end.
                    when JsonDataType:STRING then
                        poTarget:Set (cProperty2, poSource:GetCharacter (cProperty)) .
                    when JsonDataType:OBJECT then
                        poTarget:Set (cProperty2, poSource:GetJsonObject (cProperty)) .
                    when JsonDataType:ARRAY then
                        poTarget:Set (cProperty2, poSource:GetJsonArray (cProperty)) .
                end case.
            else
                case poSource:GetType (cProperty):
                    when JsonDataType:NULL then
                        poTarget:AddNull (cProperty2) .
                    when JsonDataType:BOOLEAN then
                        poTarget:Add (cProperty2, poSource:GetLogical(cProperty)) .
                    when JsonDataType:NUMBER then do:
                        if JsonHelper:IsIntegerProperty(poSource, cProperty) then
                            poTarget:Add (cProperty2, poSource:GetInteger (cProperty)) .
                        else if JsonHelper:IsInt64Property(poSource, cProperty) then
                            poTarget:Add (cProperty2, poSource:GetInt64 (cProperty)) .
                        else
                            poTarget:Add (cProperty2, poSource:GetDecimal (cProperty)) .
                    end.
                    when JsonDataType:STRING then
                        poTarget:Add (cProperty2, poSource:GetCharacter (cProperty)) .
                    when JsonDataType:OBJECT then
                        poTarget:Add (cProperty2, poSource:GetJsonObject (cProperty)) .
                    when JsonDataType:ARRAY then
                        poTarget:Add (cProperty2, poSource:GetJsonArray (cProperty)) .
                end case.
        end.

    end method.

    /**
     * Purpose: Parses a JSON File
     * Notes:   Provides improved error handling and PROPATH lookup for the file
     * @param pcFileName The JSON File to Parse
     * @return The JsonConstruct
     */
    method public static JsonConstruct ParseFile (pcFileName as character):

        define variable cFileName          as character         no-undo .
        define variable oObjectModelParser as ObjectModelParser no-undo .

        assign cFileName          = FileHelper:FindFile (pcFileName, true)
               oObjectModelParser = new ObjectModelParser () .

        do on error undo, throw:
            return oObjectModelParser:ParseFile (cFileName) .

            catch err as Progress.Lang.SysError:
                undo, throw new JsonParsingException (err, cFileName) .
            end catch.
        end.

    end method.

    /**
     * Purpose: Removes empty nested JSON Arrays
     * Notes:   SCL-1796, removed eSalesrep: [ {} ] from the JSON
     *          Object, recursively processes the JSON data
     * @param poJsonObject The JsonObject to remove
     * @return Logical value indicating if the JSON has been modified
     */
    method public static logical RemoveEmptyNestedArrays (poJsonObject as JsonObject):

        define variable cProperties  as character  no-undo extent .
        {&_proparse_ prolint-nowarn(varusage)}
        define variable cProperties2 as character  no-undo extent .
        define variable i            as integer    no-undo .
        define variable j            as integer    no-undo .
        define variable iLength      as integer    no-undo .
        define variable oArray       as JsonArray  no-undo .
        define variable oObject      as JsonObject no-undo .
        define variable lReturn      as logical    no-undo initial false .

        assign cProperties = poJsonObject:GetNames() .

        do i = 1 to extent (cProperties):

            if poJsonObject:GetType (cProperties[i]) = JsonDataType:OBJECT then do:
                if JsonHelper:RemoveEmptyNestedArrays (poJsonObject:GetJsonObject(cProperties[i]))
                    then lReturn = true .
            end.

            else if poJsonObject:GetType (cProperties[i]) = JsonDataType:ARRAY then do:

                assign oArray  = poJsonObject:GetJsonArray (cProperties[i])
                       iLength = oArray:Length .

                if iLength = 0 then do:
                    poJsonObject:Remove (cProperties[i]) .
                    assign lReturn = true .
                end.
                else do:
                    do j = iLength to 1 by -1:
                        if oArray:GetType(j) = JsonDataType:OBJECT then do:
                            assign oObject               = oArray:GetJsonObject(j)
                                   extent (cProperties2) = ?
                                   cProperties2          = oObject:GetNames() .

                            if extent (cProperties2) > 0 then do:
                                if JsonHelper:RemoveEmptyNestedArrays (oObject) then
                                    assign lReturn = true .
                            end.
                            else do:
                                oArray:Remove(j) .
                                assign lReturn = true .
                            end.
                        end.
                    end.

                    /* In case the array is now empty */
                    if oArray:Length = 0 then do:
                        poJsonObject:Remove(cProperties[i]) .
                        assign lReturn = true .
                    end.
                end.
            end.
        end.

        return lReturn .

    end method.

    /**
     * Purpose: Restores a path entry by reversing the SanitizePath
     * Notes:
     * @param pcEntry An entry of the JSON Path
     * @return The restored variant
     */
    method protected static character RestorePathEntry (pcEntry as character):

        return replace (replace (replace (pcEntry,
                        chr(3), "~\":U),
                        chr(2), "/":U),
                        chr(1), ".":U) .

    end method.

    /**
     * Purpose: Sanitizes the JSON path
     * Notes:   Replaces ~. ~/ and ~\ with CHR(1) CHR(2) and CHR(3)
     * @param pcPath The original path
     * @return The sanitized path
     */
    method protected static character SanitizePath (pcPath as character):

        return replace (replace (replace (pcPath,
                        "~~~\":U, chr(3)),
                        "~~/":U,  chr(2)),
                        "~~.":U,  chr(1)) .

    end method.

    /**
     * Purpose: Assigns a property value to (nested) JSON Objects based on a path
     * Notes:   Can be used to assign the Serialized Type Information to a set of
     *          JSON Objects
     *          Will assign the SerializedType to the JsonObject referenced by the Abc property in the given JsonObject:
     *          JsonHelper:SetCharacterProperty SetPropertyByPath (oJson, "Abc", "SerializedType", "Consultingwerk.CharacterHelper").
     *          Will assign the SerializedType to all JsonObjects contained in the JsonArray referenced by the Abc property in the given JsonObject:
     *          JsonHelper:SetCharacterProperty SetPropertyByPath (oJson, "Abc[]", "SerializedType", "Consultingwerk.CharacterHelper").
     *          Will first iterate all JsonObjects in the Abc JsonArray, and for each JsonObject in that array, iterate all objects in the Def JsonArray.
     *          JsonHelper: SetCharacterProperty SetPropertyByPath (oJson, "Abc[].Def[]", "SerializedType", "Consultingwerk.CharacterHelper")
     * @param poJson The reference to the JSON Object to process
     * @param pcPropertyPath The path of the JSON Objects to assign the property to
     * @param pcPropertyName The name of the property to assign/set
     * @param pcPropertyValue The value for the property
     */
    method public static void SetPropertyByPath (poJson as JsonObject,
                                                 pcPropertyPath as character,
                                                 pcPropertyName as character,
                                                 pcPropertyValue as character):

        ObjectAssert:IsValid (poJson, "poJson":U) .
        Assert:NotNullOrEmpty (pcPropertyPath, "pcPropertyName":U) .
        Assert:NotNullOrEmpty (pcPropertyPath, "pcPropertyName":U) .

        assign pcPropertyPath = replace (pcPropertyPath, "/":U, ".":U)
               pcPropertyPath = replace (pcPropertyPath, "~\":U, ".":U) .

        JsonHelper:SetPropertyByPath (poJson,
                                      pcPropertyPath,
                                      1,
                                      pcPropertyName,
                                      pcPropertyValue) .

    end method.

    @SuppressUnusedWarnings.
    /**
     * Purpose: Assigns a property value to (nested) JSON Objects based on a path
     * Notes:   Internal worker method for PUBLIC STATIC SetPropertyByPath
     * @param poJson The reference to the JSON construct to process
     * @param pcPropertyPath The path of the JSON Objects to assign the property to
     * @param piLevel The position in the path to process
     * @param pcPropertyName The name of the property to assign/set
     * @param pcPropertyValue The value for the property
     */
    method private static void SetPropertyByPath (poJson as JsonObject,
                                                  pcPropertyPath as character,
                                                  piLevel as integer,
                                                  pcPropertyName as character,
                                                  pcPropertyValue as character):

        define variable cPathEntry as character  no-undo .
        define variable lIsArray   as logical    no-undo .
        define variable oObject    as JsonObject no-undo .
        define variable oArray     as JsonArray  no-undo .
        define variable i          as integer    no-undo .

        assign cPathEntry = entry (piLevel, pcPropertyPath, ".":U)
               lIsArray   = cPathEntry matches "*[]":U .

        if lIsArray then
            assign cPathEntry = substring (cPathEntry, 1, length (cPathEntry, "CHARACTER":U) - 2, "CHARACTER":U) .

        /* Last entry -> Assign property */
        if piLevel = num-entries (pcPropertyPath, ".":U) then do:
            if lIsArray then do:
                assign oArray = poJson:GetJsonArray (cPathEntry) .

                do i = 1 to oArray:Length:
                    if oArray:GetType (i) = JsonDataType:OBJECT then do:
                        oObject = oArray:GetJsonObject (i) .

                        JsonHelper:AddSetPropertyValue (oObject, pcPropertyName, pcPropertyValue) .
                    end.
                end.
            end.
            else do:
                oObject = poJson:GetJsonObject (cPathEntry) .

                JsonHelper:AddSetPropertyValue (oObject, pcPropertyName, pcPropertyValue) .
            end.
        end.
        /* Recursion to next level */
        else do:
            if lIsArray then do:
                assign oArray = poJson:GetJsonArray (cPathEntry) .

                do i = 1 to oArray:Length:
                    if oArray:GetType (i) = JsonDataType:OBJECT then do:
                        oObject = oArray:GetJsonObject (i) .

                        JsonHelper:SetPropertyByPath (oObject,
                                                      pcPropertyPath,
                                                      piLevel + 1,
                                                      pcPropertyName,
                                                      pcPropertyValue) .
                    end.
                end.
            end.
            else do:
                oObject = poJson:GetJsonObject (cPathEntry) .

                JsonHelper:SetPropertyByPath (oObject,
                                              pcPropertyPath,
                                              piLevel + 1,
                                              pcPropertyName,
                                              pcPropertyValue) .
            end.
        end.

    end method.

    /**
     * Purpose: Returns the CHARACTER representation of the given JsonConstruct
     * Notes:   Truncates the JSON String to 20000 characters
     * @param poJsonObject The JsonConstruct to return the longchar representation of
     * @return The Character representation of the given string
     */
    method public static character ToCharacter (poJsonObject as JsonConstruct):

        define variable lcJsonString as longchar no-undo .

        fix-codepage (lcJsonString) = Codepages:UTF-8 .
        
        if not valid-object(poJsonObject) then 
            return ?.
        
        poJsonObject:Write (input-output lcJsonString, true) .

        return string (substring (lcJsonString, 1, 20000, "CHARACTER":U)) .

    end method.

    /**
     * Purpose: Returns the values (string, number, boolean, null) of the given JsonArray
     *          as a delimited list
     * Notes:
     * @param poJsonArray The JsonArray to process
     * @return The delimited list of values
     */
    method public static character ToDelimitedList (poJsonArray as JsonArray):

        return JsonHelper:ToDelimitedList (poJsonArray, ",":U) .

    end method.

    /**
     * Purpose: Returns the values (string, number, boolean, null) of the given JsonArray
     *          as a delimited list
     * Notes:
     * @param poJsonArray The JsonArray to process
     * @param pcDelimiter The list delimiter
     * @return The delimited list of values
     */
    method public static character ToDelimitedList (poJsonArray as JsonArray,
                                                    pcDelimiter as character):

        define variable i     as integer no-undo.
        define variable cList as character no-undo.

        do i = 1 to poJsonArray:Length:
            case poJsonArray:GetType (i):
                when JsonDataType:BOOLEAN then
                    assign cList = cList + pcDelimiter + string (poJsonArray:GetLogical(i)) .
                when JsonDataType:NULL then
                    assign cList = cList + pcDelimiter + "?":U .
                when JsonDataType:NUMBER then
                    assign cList = cList + pcDelimiter + string (poJsonArray:GetDecimal(i)) .
                when JsonDataType:STRING then
                    assign cList = cList + pcDelimiter + poJsonArray:GetCharacter(i) .
            end case .
        end.

        return trim (cList, pcDelimiter) .

    end method.

    /**
     * Purpose: Returns an ABL delimited list with the values of the given
     *          JsonObject property.
     * Notes:   The value of the property must either be a single string or
     *          an JsonArray of strings or null
     * @param poJsonObject The source JsonObject
     * @param pcPropertyName The name of the property of the JsonObject to return
     * @return The delimited list
     */
    method public static character ToDelimitedList (poJsonObject as JsonObject,
                                                    pcPropertyName as character):

        return JsonHelper:ToDelimitedList(poJsonObject, pcPropertyName, ",":U) .

    end method.

    /**
     * Purpose: Returns an ABL delimited list with the values of the given
     *          JsonObject property.
     * Notes:   The value of the property must either be a single string or
     *          an JsonArray of strings or null
     * @param poJsonObject The source JsonObject
     * @param pcPropertyName The name of the property of the JsonObject to return
     * @param pcDelimiter The delimiter for the list to return
     * @return The delimited list
     */
    method public static character ToDelimitedList (poJsonObject as JsonObject,
                                                    pcPropertyName as character,
                                                    pcDelimiter as character):

        define variable oArray  as JsonArray no-undo .
        define variable i       as integer   no-undo .
        define variable cReturn as character no-undo.

        case poJsonObject:GetType (pcPropertyName):
            when JsonDataType:NULL then
                return ? .
            when JsonDataType:STRING then
                return poJsonObject:GetCharacter(pcPropertyName) .
            when JsonDataType:ARRAY then do:
                oArray = poJsonObject:GetJsonArray(pcPropertyName) .

                do i = 1 to oArray:Length:
                    case oArray:GetType(i):
                        when JsonDataType:NULL then
                            assign cReturn = cReturn + "?":U + pcDelimiter .
                        when JsonDataType:STRING then
                            assign cReturn = cReturn + oArray:GetCharacter(i) + pcDelimiter .
                        otherwise
                            undo, throw new InvalidValueException (string (poJsonObject:GetType (pcPropertyName)),
                                                                   "JSON Datatype":U) .
                    end case.
                end.

                return trim (cReturn, pcDelimiter) .
            end.
            otherwise
                undo, throw new InvalidValueException (string (poJsonObject:GetType (pcPropertyName)),
                                                       "JSON Datatype":U) .
        end case .

    end method.

    /**
     * Purpose: Turns an ABL extent of JsonSerializable objects into an JsonArray
     * Notes:
     * @param poJsonSerializable The Array of JsonSerializable objects
     * @return The JsonArray
     */
    method public static JsonArray ToJsonArray (poJsonSerializable as IJsonSerializable extent):

        define variable oReturn as JsonArray no-undo .
        define variable i       as integer   no-undo.
        define variable iCount  as integer   no-undo.

        oReturn = new JsonArray () .

        assign iCount = extent (poJsonSerializable) .

        do i = 1 to iCount:
            if valid-object (poJsonSerializable[i]) then
                oReturn:Add (poJsonSerializable[i]:ToJsonObject()) .
            else
                oReturn:AddNull () .
        end.

        return oReturn .

    end method.

    /**
     * Purpose: Returns the LONGCHAR representation of the given JsonObject
     * Notes:
     * @param poJsonObject The JsonObject to return the longchar representation of
     * @return The Longchar representation of the given string
     */
    method public static longchar ToLongchar (poJsonObject as JsonObject):

        define variable lcJsonString as longchar no-undo .

        fix-codepage (lcJsonString) = Codepages:UTF-8 .

        poJsonObject:Write (input-output lcJsonString, true) .

        return lcJsonString .

    end method.

end class.
