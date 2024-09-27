/**********************************************************************
 * Copyright (C) 2006-2024 by Consultingwerk Ltd. ("CW") -            *
 * www.consultingwerk.de and other contributors as listed             *
 * below.  All Rights Reserved.                                       *
 *                                                                    *
 *  Software is distributed on an "AS IS", WITHOUT WARRANTY OF ANY    *
 *   KIND, either express or implied.                                 *
 *                                                                    *
 *  Contributors:                                                     *
 *   Thomas Hansen, appSolutions a|s                                  *
 **********************************************************************/
/*------------------------------------------------------------------------
    File        : JsonSerializable
    Purpose     : Implements serialization functionality i.e. for parameter
                  object to be passed around the AppServer boundary
    Syntax      :
    Description : Serialization based on the JSON object model (OpenEdge 11.0)
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Sep 15 18:25:22 CEST 2010
    Notes       : See comments in Consultingwerk/JsonSerializableProperty.i
                  for usage instructions
                  This class also supports XML output - which is used for
                  migrating SmartFramework data (e.g. menu functions) from
                  JSON to XML
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{ Consultingwerk/products.i }

using Consultingwerk.*                from propath .
using Consultingwerk.Exceptions.*     from propath .
using Consultingwerk.Framework.Base.* from propath .
using Consultingwerk.Util.*           from propath .
using Progress.Json.ObjectModel.*     from propath .
using Progress.Lang.*                 from propath .
using Progress.Reflect.*              from propath .

class Consultingwerk.JsonSerializable
    implements IJsonSerializable
    serializable
    abstract:

    define static temp-table ttSerializableProperties no-undo
        field ClassName as character
        field SerializableProperties as character
        index ClassName is primary unique ClassName.

    /**
     * Purpose: Gets and sets if the serializable properties should be initialized
     *          at first use
     * Notes:   Set this to FALSE after initialization of the serializable properties
     */
    define private property LazyInitializeSerializableProperties as logical initial true no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the reference to a custom JsonDateTypeFormatter
     * Notes:   Workaround for the fact, that there is no actual standard
     *          for date representation in Json and if may be required to provide
     *          custom formatting based on the target system (e.g. JIRA)
     */
    define public property JsonDateTypeFormatter as IJsonDateTypeFormatter no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets if during serialization empty lists (properties of type
     *          Consultingwerk.Framework.Base.IEnumerable) that do not contain any
     *          elements, will be serialized as an empty array into the Json output.
     * Notes:   Setting this to TRUE allows to restore the previous behavior on
     *          a case by case value
     */
    define public property SerializeEmptyLists as logical initial false no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets alternative JSON Names for ABL properties
     * Notes:   Similar to SERIALIZE-NAME of properties, this controls the
     *          JSON property name used for ABL property in the form of
     *          AblPropertyName1,JsonPropertyName1,AblPropertyName2,JsonPropertyName2,...
     *          ABL Properties not listed in this list are serialized with the ABL
     *          Property Name
     */
    define protected property SerializeNames as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets if Null-Values should be serialized
     * Notes:   Some REST servers may have issues with serializing Null values.
     *          Settings this property to TRUE will keep Null-Values from being
     *          Serialized
     */
    define public property SerializeNullValues as logical initial false no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the list of Serializable Properties
     * Notes:   Required as a workaround to full reflection only. We *may* remove this
     *          property once Progress Software has implemented full reflection
     *          You are not supposed to use the SerializableProperties
     *          for other purposes than using it in the JsonSerializable
     *          base class - as we may be changing the format of this
     *          property without warning.
     */
    define private property SerializableProperties as character no-undo
    get.
    set.

    /**
     * Purpose: Determines if the Serialization Routine will read and write the
     *          SerializedType attribute
     * Notes:
     */
    define public property UseSerializedTypeInformation as logical initial true no-undo
    get.
    set.

    &if defined (AblReflection) ne 0 &then
    /**
     * Purpose: Adds serializable properties from the calling class using ABL reflection.
     *          Supported from OpenEdge 11.6 on only.
     * Notes:
     */
    method protected void LazyAddSerializableProperties ():

        define variable oClass        as Progress.Lang.Class no-undo .
        define variable oSerializable as Progress.Lang.Class no-undo .
        define variable cClassName    as character           no-undo .

        define buffer ttSerializableProperties for ttSerializableProperties.

        assign oClass        = this-object:GetClass()
               cClassName    = oClass:TypeName .

        find ttSerializableProperties where ttSerializableProperties.ClassName = cClassName no-error.

        if available ttSerializableProperties then do:
            assign this-object:SerializableProperties = ttSerializableProperties.SerializableProperties.

            return.
        end.

        {&_proparse_ prolint-nowarn(avoidnoerror)}
        error-status:error = false no-error .

        assign oSerializable = get-class (Consultingwerk.JsonSerializable) .

        classLoop:
        repeat:
            if oClass = oSerializable then
                leave classLoop .

            this-object:AddSerializableProperties (oClass).

            oClass = oClass:SuperClass .
        end.

        create ttSerializableProperties.
        assign ttSerializableProperties.ClassName              = cClassName
               ttSerializableProperties.SerializableProperties = this-object:SerializableProperties.

    end method .

    /**
     * Purpose: Adds serializable properties from the calling class using ABL reflection.
     *          Supported from OpenEdge 11.6 on only.
     * Notes:   Adds properties of the following types, does not add properties of
     *          the base classes, adds only PUBLIC properties:
     *          - CHARACTER
     *          - CHARACTER EXTENT
     *          - DATE
     *          - DATE EXTENT
     *          - DATETIME
     *          - DATETIME EXTENT
     *          - DATETIME-TZ
     *          - DATETIME-TZ EXTENT
     *          - DECIMAL
     *          - DECIMAL EXTENT
     *          - INT64
     *          - INT64 EXTENT
     *          - INTEGER
     *          - INTEGER EXTENT
     *          - LOGICAL
     *          - LOGICAL EXTENT
     *          - LONGCHAR
     *          - LONGCHAR EXTENT
     *          - RAW
     *          - RAW EXTENT
     *          - RECID
     *          - RECID EXTENT
     *          - ROWID
     *          - ROWID EXTENT
     *          - Progress.Json.ObjectModel.JsonArray
     *          - Progress.Json.ObjectModel.JsonObject
     *          - ENUM
     *          - Consultingwerk.Enum
     *          - Consultingwerk.Framework.Base.IEnumerable
     *          - Consultingwerk.JsonSerializable
     *          - Consultingwerk.JsonSerializable EXTENT
     * @return The value of the SerializableProperties property
     */
    method protected character AddSerializableProperties ():

        define variable cClassName as character no-undo.

        assign cClassName = entry (2, program-name (2), " ":U) .

        return this-object:AddSerializableProperties (Progress.Lang.Class:GetClass (cClassName)) .

    end method .

    /**
     * Purpose: Adds serializable properties from the given class using ABL reflection.
     *          Supported from OpenEdge 11.6 on only.
     * Notes:   Adds properties of the following types, does not add properties of
     *          the base classes, adds only PUBLIC properties:
     *          - CHARACTER
     *          - CHARACTER EXTENT
     *          - DATE
     *          - DATE EXTENT
     *          - DATETIME
     *          - DATETIME EXTENT
     *          - DATETIME-TZ
     *          - DATETIME-TZ EXTENT
     *          - DECIMAL
     *          - DECIMAL EXTENT
     *          - INT64
     *          - INT64 EXTENT
     *          - INTEGER
     *          - INTEGER EXTENT
     *          - LOGICAL
     *          - LOGICAL EXTENT
     *          - LONGCHAR
     *          - LONGCHAR EXTENT
     *          - RAW
     *          - RAW EXTENT
     *          - RECID
     *          - RECID EXTENT
     *          - ROWID
     *          - ROWID EXTENT
     *          - Progress.Json.ObjectModel.JsonArray
     *          - Progress.Json.ObjectModel.JsonObject
     *          - ENUM
     *          - Consultingwerk.Enum
     *          - Consultingwerk.Framework.Base.IEnumerable
     *          - Consultingwerk.JsonSerializable
     *          - Consultingwerk.JsonSerializable EXTENT
     * @param poClass The declaring class
     * @return The value of the SerializableProperties property
     */
    method protected character AddSerializableProperties (poClass as Progress.Lang.Class):

        define variable oProperties as Progress.Reflect.Property extent no-undo .
        define variable oProperty   as Progress.Reflect.Property        no-undo .
        define variable cProperties as character                        no-undo .
        define variable i           as integer                          no-undo .
        define variable cDataType   as character                        no-undo .

        assign oProperties = this-object:GetClass():GetProperties (Progress.Reflect.Flags:Public
                                                                or Progress.Reflect.Flags:Instance) .

        propertiesLoop:
        do i = 1 to extent (oProperties):
            assign oProperty = oProperties[i] .

            if poClass <> oProperty:DeclaringClass then
                next propertiesLoop .

            if not oProperty:CanRead or not oProperty:CanWrite then
                next propertiesLoop .

            {&_proparse_ prolint-nowarn(recidkeyword)}
            if oProperty:DataType = Progress.Reflect.DataType:Character or
               oProperty:DataType = Progress.Reflect.DataType:Date or
               oProperty:DataType = Progress.Reflect.DataType:DateTime or
               oProperty:DataType = Progress.Reflect.DataType:DateTimeTZ or
               oProperty:DataType = Progress.Reflect.DataType:Decimal or
               oProperty:DataType = Progress.Reflect.DataType:Int64 or
               oProperty:DataType = Progress.Reflect.DataType:Integer or
               oProperty:DataType = Progress.Reflect.DataType:Logical or
               oProperty:DataType = Progress.Reflect.DataType:Longchar or
               oProperty:DataType = Progress.Reflect.DataType:Raw or
               oProperty:DataType = Progress.Reflect.DataType:Recid or
               oProperty:DataType = Progress.Reflect.DataType:Rowid then do:

                assign cDataType = upper (oProperty:DataType:ToString()) .

                if cDataType = "DATETIMETZ":U then
                    assign cDataType = "DATETIME-TZ":U .

                assign cProperties = cProperties + ",":U + oProperty:Name + ",":U + cDataType +
                                     (if oProperty:Extent <> 0 then " EXTENT":U else "":U) .
            end.

            else if oProperty:DataType = Progress.Reflect.DataType:Object and
                    oProperty:Extent   = 0 then
                assign cProperties = cProperties + ",":U + oProperty:Name + ",":U + oProperty:DataTypeName .

            else if oProperty:DataType = Progress.Reflect.DataType:Object and
                   (oProperty:Extent   > 0 or oProperty:Extent = ?) then

                assign cProperties = cProperties + ",":U + oProperty:Name + ",":U + oProperty:DataTypeName + " EXTENT":U.
        end.

        if cProperties > "":U then
            this-object:AddSerializableProperties (trim (cProperties, ",":U)) .

        return cProperties .

    end method.
    &endif

    /**
     * Purpose: Add a list of Serializable Properties to the SerializableProperties property
     * Notes:   Required as a workaround to full reflection only. We *may* remove this
     *          method once Progress Software has implemented full reflection
     * @param pcSerializableProperties A comma delimited list of serializable properties
     */
    method protected void AddSerializableProperties (pcSerializableProperties as character):

        assign this-object:SerializableProperties               = trim (this-object:SerializableProperties +
                                                                        ",":U +
                                                                        pcSerializableProperties, ",":U)
               this-object:LazyInitializeSerializableProperties = false.

    end method.

    /**
     * Purpose: Deserializes a LONGCHAR representation of the state of the class instance
     * Notes:
     * @param pcSerializedRepresentation The stored LONGCHAR representation of the objects data
     */
    method public void Deserialize (input pcSerializedRepresentation as longchar):

        define variable oJsonObject  as JsonObject        no-undo .
        define variable oObjectModel as ObjectModelParser no-undo .
        define variable oFormat      as NumericFormat     no-undo .

        /* SCL-514: Perform JSON Serialization/Deserialization with AMERICAN
                    numeric format to avoid issues with decimal point interpretation */
        oFormat = SessionHelper:GetNumericFormat() .
        SessionHelper:SetDefaultNumericFormat() .

        oObjectModel = new ObjectModelParser () .

        oJsonObject = cast (oObjectModel:Parse (pcSerializedRepresentation), JsonObject).

        this-object:DeserializeFromJsonObject (oJsonObject) .

        finally:
            if valid-object (oFormat) then
                SessionHelper:SetNumericFormat (oFormat) .

            GarbageCollectorHelper:DeleteObject (oObjectModel) .
            GarbageCollectorHelper:DeleteObject (oJsonObject) .
        end finally.

    end method.

    /**
     * Purpose: Initializes the object instance based on the passed in JsonObject
     *          representation of the object instance
     * Notes:
     * @param poJsonObject The stored JsonObject representation of the objects data
     */
    method public void DeserializeFromJsonObject (poJsonObject as JsonObject):

        define variable i               as integer              no-undo .
        define variable iCount          as integer              no-undo .
        define variable cProperty       as character            no-undo .
        define variable cProperties     as character            no-undo .
        define variable cJsonProperty   as character            no-undo .
        define variable cType           as character            no-undo .

        if this-object:LazyInitializeSerializableProperties then
            this-object:LazyAddSerializableProperties().

        assign cProperties = this-object:SerializableProperties
               iCount      = num-entries (cProperties) .

        propertiesLoop:
        do i = 1 to iCount by 2:
            assign cProperty = entry (i, cProperties)
                   cType     = entry (i + 1, cProperties).

            if this-object:SerializeNames > "":U then
                assign cJsonProperty = this-object:GetSerializeName(cProperty) .
            else
                assign cJsonProperty = cProperty .

            /* Mike Fechner, Consultingwerk Ltd. 14.09.2016
               SCL-1449: when exact property name is not there, use JsonHelper
                         to check for alternative casing */
            if not poJsonObject:Has (cJsonProperty) then do:
                assign cJsonProperty = JsonHelper:ExactPropertyName(poJsonObject, cJsonProperty) .

                if cJsonProperty = ? then
                    next propertiesLoop .
            end.

            /* Mike Fechner, Consultingwerk Ltd. 26.01.2013
               Moved to method DeserializeProperty to allow easier overriding of
               individual properties handling */
            this-object:DeserializeProperty (poJsonObject,
                                             cProperty,
                                             cJsonProperty,
                                             cType) .
        end.

    end method.

    /**
     * Purpose: Deserializes a single property value to the current JsonObject
     * Notes:   Allows to override the handling of individual properties during the
     *          JsonSerialization
     * Notes:
     * @param poJsonObject The reference to the source JsonObject
     * @param pcProperty The name of the property in the JsonObject
     * @param pcJsonProperty The name of the property in the JsonObject
     * @param pcType The type of the property
     */
    method protected void DeserializeProperty (poJsonObject as JsonObject,
                                               pcProperty as character,
                                               pcJsonProperty as character,
                                               pcType as character):

        define variable iItem           as integer              no-undo .
        define variable cItemType       as character            no-undo .

        define variable oNestedJson     as JsonObject           no-undo .
        define variable oNestedArray    as JsonArray            no-undo .
        define variable oNestedInstance as IJsonSerializable    no-undo .
        define variable oList           as Object               no-undo .
        define variable iIndex          as integer              no-undo .
        define variable iLength         as integer              no-undo .
        define variable oArray          as Progress.Lang.Object no-undo extent .
        define variable cTempType       as character            no-undo .
        define variable cEnumValue      as character            no-undo .
        define variable oClass          as Progress.Lang.Class  no-undo .

        define variable oNullReference  as Progress.Lang.Object no-undo .

        {Consultingwerk/Assertion/ObjectAssert/IsValid.i poJsonObject """Json Object"":U"}

        assign cTempType = DataTypeHelper:UnabbreviateDataTypeName (pcType) .

        if cTempType <> ? then
            assign pcType = cTempType .

        case pcType:
            when "CHARACTER":U then
                dynamic-property (this-object, pcProperty) = poJsonObject:GetCharacter (pcJsonProperty) .
            when "CHARACTER EXTENT":U then do:
                if poJsonObject:GetType (pcJsonProperty) = JsonDataType:ARRAY then
                    dynamic-property (this-object, pcProperty) = JsonHelper:JsonArrayToCharacterExtent(poJsonObject:GetJsonArray (pcJsonProperty)) .
                else
                    /* Ability to deserialize JSON String into String[1] Array */
                    dynamic-property (this-object, pcProperty) = ArrayHelper:Array(poJsonObject:GetCharacter (pcJsonProperty)) .
            end.
            when "DATE":U then do:
                if valid-object (this-object:JsonDateTypeFormatter) then
                    dynamic-property (this-object, pcProperty) = this-object:JsonDateTypeFormatter:GetDate (poJsonObject, pcJsonProperty) .
                else
                    dynamic-property (this-object, pcProperty) = poJsonObject:GetDate (pcJsonProperty) .
            end.
            when "DATE EXTENT":U then do:
                dynamic-property (this-object, pcProperty) = JsonHelper:JsonArrayToDateExtent(poJsonObject:GetJsonArray(pcJsonProperty)) .
            end.
            when "DATETIME":U then do:
                if valid-object (this-object:JsonDateTypeFormatter) then
                    dynamic-property (this-object, pcProperty) = this-object:JsonDateTypeFormatter:GetDateTime (poJsonObject, pcJsonProperty) .
                else
                    dynamic-property (this-object, pcProperty) = poJsonObject:GetDateTime (pcJsonProperty) .
            end.
            when "DATETIME EXTENT":U then do:
                dynamic-property (this-object, pcProperty) = JsonHelper:JsonArrayToDateTimeExtent(poJsonObject:GetJsonArray (pcJsonProperty)) .
            end.
            when "DATETIME-TZ":U then do:
                if valid-object (this-object:JsonDateTypeFormatter) then
                    dynamic-property (this-object, pcProperty) = this-object:JsonDateTypeFormatter:GetDateTimeTZ (poJsonObject, pcJsonProperty) .
                else
                    dynamic-property (this-object, pcProperty) = poJsonObject:GetDateTimeTZ (pcJsonProperty) .
            end.
            when "DATETIME-TZ EXTENT":U then do:
                dynamic-property (this-object, pcProperty) = JsonHelper:JsonArrayToDateTimeTzExtent(poJsonObject:GetJsonArray (pcJsonProperty)) .
            end.
            when "DECIMAL":U then
                dynamic-property (this-object, pcProperty) = poJsonObject:GetDecimal (pcJsonProperty) .
            when "DECIMAL EXTENT":U then
                dynamic-property (this-object, pcProperty) = JsonHelper:JsonArrayToDecimalExtent(poJsonObject:GetJsonArray (pcJsonProperty)) .
            when "INT64":U then
                dynamic-property (this-object, pcProperty) = poJsonObject:GetInt64 (pcJsonProperty) .
            when "INT64 EXTENT":U then
                dynamic-property (this-object, pcProperty) = JsonHelper:JsonArrayToInt64Extent (poJsonObject:GetJsonArray(pcJsonProperty)) .
            when "INTEGER":U then
                dynamic-property (this-object, pcProperty) = poJsonObject:GetInteger (pcJsonProperty) .
            when "INTEGER EXTENT":U then
                dynamic-property (this-object, pcProperty) = JsonHelper:JsonArrayToIntegerExtent(poJsonObject:GetJsonArray (pcJsonProperty)) .
            when "LOGICAL":U then
                dynamic-property (this-object, pcProperty) = poJsonObject:GetLogical (pcJsonProperty) .
            when "LOGICAL EXTENT":U then
                dynamic-property (this-object, pcProperty) = JsonHelper:JsonArrayToLogicalExtent (poJsonObject:GetJsonArray(pcJsonProperty)) .
            when "LONGCHAR":U then
                dynamic-property (this-object, pcProperty) = poJsonObject:GetLongchar (pcJsonProperty) .
            when "LONGCHAR EXTENT":U then
                dynamic-property (this-object, pcProperty) = JsonHelper:JsonArrayToLongcharExtent (poJsonObject:GetJsonArray(pcJsonProperty)) .
            when "RAW":U then
                dynamic-property (this-object, pcProperty) = poJsonObject:GetRaw (pcJsonProperty) .
            when "RECID":U then
                dynamic-property (this-object, pcProperty) = poJsonObject:GetRecid (pcJsonProperty) .
            when "ROWID":U then
                dynamic-property (this-object, pcProperty) = poJsonObject:GetRowid (pcJsonProperty) .
            when "JsonArray":U or when "Progress.Json.ObjectModel.JsonArray":U then do:
                assign oNestedArray = cast (poJsonObject:GetJsonArray (pcJsonProperty):Clone (), JsonArray) .

                dynamic-property (this-object, pcProperty) = oNestedArray .
            end.
            when "JsonObject":U or when "Progress.Json.ObjectModel.JsonObject":U then do:
                assign oNestedJson = cast (poJsonObject:GetJsonObject (pcJsonProperty):Clone (), JsonObject) .

                dynamic-property (this-object, pcProperty) = oNestedJson .
            end.
            when "Enum":U or when "Progress.Lang.Enum":U then do:
                if poJsonObject:GetType(pcJsonProperty) = JsonDataType:Null then
                    dynamic-property (this-object, pcProperty) = ? .
                else do:
                    cEnumValue = poJsonObject:GetCharacter(pcJsonProperty) .

                    dynamic-property (this-object, pcProperty) = Progress.Lang.Enum:ToObject (entry (1, cEnumValue, ":":U),
                                                                                              entry (2, cEnumValue, ":":U)) .
                end.
            end.
            otherwise do:
                /* extent property */
                if poJsonObject:Has (pcJsonProperty) and not poJsonObject:IsNull (pcJsonProperty) and
                   num-entries (pcType, " ":U) = 2 and entry (2, pcType, " ":U) = "EXTENT":U then do:

                    assign
                        oNestedArray = poJsonObject:GetJsonArray(pcJsonProperty)
                        iLength      = oNestedArray:Length .

                    if iLength > 0 then do:

                        extent (oArray) = ?.
                        extent (oArray) = iLength .

                        do iIndex = 1 to iLength:

                            oNestedJson = oNestedArray:GetJsonObject (iIndex) .

                            /* Mike Fechner, Consultingwerk Ltd. 02.01.2013
                               When we are using the type information from the JsonObject,
                               this is a mandatory attribute in the JsonObject. */
                            if this-object:UseSerializedTypeInformation then do:
                                if not oNestedJson:Has ("SerializedType":U) then
                                    undo, throw new JsonSerializationException (substitute ("Unable to deserialize property &1 of &2 as it does not contain a Json Serialized object."{&TRAN},
                                                                                            pcProperty,
                                                                                            this-object:GetClass ():TypeName), 0) .
                                else
                                    assign cItemType = oNestedJson:GetCharacter ("SerializedType":U) .
                            end.
                            else
                                cItemType = entry (1, pcType, " ":U) .

                            oNestedInstance = dynamic-new (cItemType) ().
                            oNestedInstance:DeserializeFromJsonObject (oNestedJson) .

                            oArray [iIndex] = oNestedInstance .
                        end.

                        dynamic-property (this-object, pcProperty) = oArray .
                    end.
                end.
                else do:
                    if poJsonObject:Has (pcJsonProperty) and not poJsonObject:IsNull (pcJsonProperty) then do:
                        {&_proparse_ prolint-nowarn(avoidnoerror)}
                        assign oClass = Progress.Lang.Class:GetClass (pcType) no-error .

                        /* When class is not valid from JSON Serializable property definition, try JSON DeserializedTypeInformation */
                        if error-status:error then do:
                            {&_proparse_ prolint-nowarn(avoidnoerror)}
                            error-status:error = false no-error .

                            oNestedJson = poJsonObject:GetJsonObject (pcJsonProperty) .

                            if not oNestedJson:Has ("SerializedType":U) then
                                undo, throw new JsonSerializationException (substitute ("Unable to deserialize property &1 of &2 as it does not contain a Json Serialized object."{&TRAN},
                                                                                        pcProperty,
                                                                                        this-object:GetClass ():TypeName), 0) .

                            oClass = Progress.Lang.Class:GetClass (oNestedJson:GetCharacter("SerializedType":U)) .
                        end.

                        &if defined (NativeEnums) ne 0 &then
                        if oClass:IsEnum() then do:
                            dynamic-property (this-object, pcProperty) =
                                Progress.Lang.Enum:ToObject (pcType, poJsonObject:GetCharacter (pcJsonProperty)) .
                        end.
                        else
                        &endif
                        /* Test for Enum */
                        if oClass:IsA ("Consultingwerk.Enum":U) then do:
                            dynamic-property (this-object, pcProperty) =
                                dynamic-property (pcType, poJsonObject:GetCharacter (pcJsonProperty)) .
                        end.
                        else if oClass:IsA ("Consultingwerk.Framework.Base.IEnumerable":U) then do:
                            oNestedArray = poJsonObject:GetJsonArray (pcJsonProperty) .

                            oList = this-object:GetEnumerableInstance (pcProperty) .

                            do iItem = 1 to oNestedArray:Length:
                                oNestedJson = oNestedArray:GetJsonObject (iItem) .

                                if not oNestedJson:Has ("SerializedType":U) then
                                    undo, throw new JsonSerializationException (substitute ("Unable to deserialize property &1 of &2 as it does not contain a Json Serialized object."{&TRAN},
                                                                                            pcProperty,
                                                                                            this-object:GetClass ():TypeName), 0) .

                                oNestedInstance = dynamic-new (oNestedJson:GetCharacter ("SerializedType":U)) ().
                                oNestedInstance:DeserializeFromJsonObject (oNestedJson) .

                                dynamic-invoke (oList, "Add":U, oNestedInstance) .
                            end.
                        end.
                        else do:
                            oNestedJson = poJsonObject:GetJsonObject (pcJsonProperty) .

                            /* Mike Fechner, Consultingwerk Ltd. 02.01.2013
                               When we are using the type information from the JsonObject,
                               this is a mandatory attribute in the JsonObject. */
                            if this-object:UseSerializedTypeInformation then do:
                                if not oNestedJson:Has ("SerializedType":U) then
                                    undo, throw new JsonSerializationException (substitute ("Unable to deserialize property &1 of &2 as it does not contain a Json Serialized object."{&TRAN},
                                                                                            pcProperty,
                                                                                            this-object:GetClass ():TypeName), 0) .
                                else
                                    assign pcType = oNestedJson:GetCharacter ("SerializedType":U) .
                            end.

                            oNestedInstance = dynamic-new (pcType) ().
                            oNestedInstance:DeserializeFromJsonObject (oNestedJson) .

                            dynamic-property (this-object, pcProperty) = oNestedInstance .
                        end.
                    end.
                    else
                        /* Mike Fechner, Consultingwerk Ltd. 21.08.2013
                           OpenEdge 11.3 raises an issue, when assigning ? here,
                           so we are instead assigning a variable with no object
                           reference */
                        dynamic-property (this-object, pcProperty) = oNullReference .
                end.
            end.
        end case .

        catch err as Progress.Lang.Error:
            undo, throw new DeserializationException (err,
                                                      err:GetMessage(1),
                                                      err:GetMessageNum(1),
                                                      pcProperty) .
        end catch .

    end method .

    /**
     * Purpose: Returns an instance of the enumerable type
     * Notes:   When the property value is referencing a value list instance, this
     *          instance is returned. If not, we attempt to create a new instance
     * @param pcProperty The name of the List property
     * @return The instance of the enumerable type
     */
    method protected IEnumerable GetEnumerableInstance (pcProperty as character):

        define variable cListType as character                 no-undo .
        define variable oListType as Progress.Lang.Class       no-undo .
        define variable oList     as IEnumerable               no-undo .
        define variable oProperty as Progress.Reflect.Property no-undo .

        assign oList = dynamic-property (this-object, pcProperty) .

        if valid-object (oList) then
            return oList .

        oProperty = this-object:GetClass():GetProperty(pcProperty) .

        if oProperty:CanWrite = false then
            undo, throw new JsonSerializationException (substitute ("Unable to deserialize property &1 of &2 as property is not referencing a valid list instance and is read-only."{&TRAN},
                                                                    pcProperty,
                                                                    this-object:GetClass ():TypeName), 0) .


        assign cListType = oProperty:DataTypeName
               oListType = Progress.Lang.Class:GetClass (cListType).

        if oListType:IsAbstract() or oListType:IsInterface() then
            undo, throw new JsonSerializationException (substitute ("Unable to deserialize property &1 of &2 as property is not referencing a valid list instance and property type is abstract."{&TRAN},
                                                                    pcProperty,
                                                                    this-object:GetClass ():TypeName), 0) .

        oList = dynamic-new (cListType) () .

        dynamic-property (this-object, pcProperty) = oList .

        return oList .

    end method.

    /**
     * Purpose: Returns the meta data of the serializable properties
     * Notes:
     * @return The serializable properties meta data as a comma delimited list
     */
    method public character GetSerializableProperties():

        if this-object:LazyInitializeSerializableProperties then
            this-object:LazyAddSerializableProperties().

        return this-object:SerializableProperties .

    end method.

    /**
     * Purpose: Returns a LONGCHAR representation of the state of the class instance
     * Notes:   Returns the classname together with the Json serialization
     * @return The LONGCHAR representation of the ISerializable objects data
     */
    method public longchar Serialize ():

        define variable lcReturn    as longchar      no-undo .
        define variable oJsonObject as JsonObject    no-undo .
        define variable oFormat     as NumericFormat no-undo .

        /* SCL-514: Perform JSON Serialization/Deserialization with AMERICAN
                    numeric format to avoid issues with decimal point interpretation */
        oFormat = SessionHelper:GetNumericFormat() .
        SessionHelper:SetDefaultNumericFormat() .

        oJsonObject = this-object:ToJsonObject() .

        oJsonObject:Write (input-output lcReturn, true)  .

        return lcReturn .

        finally:
            if valid-object (oFormat) then
                SessionHelper:SetNumericFormat (oFormat) .

            GarbageCollectorHelper:DeleteObject (oJsonObject) .
        end finally.

    end method.

    /**
     * Purpose: Returns the SerializeName of a property
     * Notes:   See property SerializeNames for details
     * @param pcPropertyName The name of the property
     * @return The SerializeName of the property
     */
    method public character GetSerializeName (pcPropertyName as character):

        define variable iCount as integer no-undo.
        define variable i      as integer no-undo.

        assign iCount = num-entries (this-object:SerializeNames) .

        do i = 1 to iCount by 2:
            if entry (i, this-object:SerializeNames) = pcPropertyName then
                return entry (i + 1, this-object:SerializeNames) .
        end.

        return pcPropertyName .

    end method.

    /**
     * Purpose: Serializes a single property value to the current JsonObject
     * Notes:   Allows to override the handling of individual properties during the
     *          JsonSerialization
     * @param poJsonObject The reference to the target JsonObject
     * @param pcProperty The name of the property in the JsonObject
     * @param pcJsonProperty The name of the property in the JsonObject
     * @param pcType The type of the property
     */
    method protected void SerializeProperty (poJsonObject as JsonObject,
                                             pcProperty as character,
                                             pcJsonProperty as character,
                                             pcType as character):

        define variable oJsonArray    as JsonArray            no-undo .
        define variable oJsonItem     as JsonObject           no-undo .
        define variable oList         as IEnumerable          no-undo .

        define variable cValue        as character            no-undo .
        define variable dtValue       as date                 no-undo .
        define variable dttValue      as datetime             no-undo .
        define variable dtttzValue    as datetime-tz          no-undo .
        define variable deValue       as decimal              no-undo .
        define variable i64Value      as int64                no-undo .
        define variable iValue        as integer              no-undo .
        define variable lValue        as logical              no-undo .
        define variable lcValue       as longchar             no-undo .
        define variable roValue       as rowid                no-undo .
        define variable rawValue      as raw                  no-undo .
        {&_proparse_ prolint-nowarn(recidkeyword)}
        define variable recidValue    as recid                no-undo .

        define variable oObject       as Progress.Lang.Object no-undo .
        define variable oObjectExt    as Progress.Lang.Object no-undo extent .

        define variable cValueExt     as character   extent   no-undo .
        define variable dtValueExt    as date        extent   no-undo .
        define variable dttValueExt   as datetime    extent   no-undo .
        define variable dtttzValueExt as datetime-tz extent   no-undo .
        define variable deValueExt    as decimal     extent   no-undo .
        define variable i64ValueExt   as int64       extent   no-undo .
        define variable iValueExt     as integer     extent   no-undo .
        define variable lValueExt     as logical     extent   no-undo .
        define variable lcValueExt    as longchar    extent   no-undo .
        define variable roValueExt    as rowid       extent   no-undo .
        define variable rawValueExt   as raw         extent   no-undo .
        {&_proparse_ prolint-nowarn(recidkeyword)}
        define variable recidValueExt as recid       extent   no-undo .

        define variable i             as integer              no-undo .
        define variable cTempType     as character            no-undo .

        assign cTempType = DataTypeHelper:UnabbreviateDataTypeName (pcType) .

        if cTempType <> ? then
            assign pcType = cTempType .

        {Consultingwerk/Assertion/ObjectAssert/IsValid.i poJsonObject """Json Object"":U"}

        case pcType:
            when "CHARACTER":U then do:
                assign cValue = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or cValue > "":U then
                    poJsonObject:Add (pcJsonProperty, cValue) .
            end.
            when "CHARACTER EXTENT":U then do:
                assign cValueExt = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or extent (cValueExt) > 0 then do:
                    assign oJsonArray = new JsonArray () .

                    if extent (cValueExt) <> ? then
                        oJsonArray:Add (cValueExt) .
                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                    oJsonArray = ? .
                end.
            end.
            when "DATE":U then do:
                assign dtValue = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or dtValue <> ? then
                    if valid-object (this-object:JsonDateTypeFormatter) then
                        this-object:JsonDateTypeFormatter:Add (poJsonObject, pcJsonProperty, dtValue) .
                    else
                        poJsonObject:Add (pcJsonProperty, dtValue) .
            end.
            when "DATE EXTENT":U then do:
                assign dtValueExt = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or extent (dtValueExt) > 0 then do:
                    assign oJsonArray = new JsonArray () .

                    if extent (dtValueExt) <> ? then
                        oJsonArray:Add (dtValueExt) .
                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                    oJsonArray = ? .
                end.
            end.
            when "DATETIME":U then do:
                assign dttValue = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or dttValue <> ? then
                    if valid-object (this-object:JsonDateTypeFormatter) then
                        this-object:JsonDateTypeFormatter:Add (poJsonObject, pcJsonProperty, dttValue) .
                    else
                        poJsonObject:Add (pcJsonProperty, dttValue) .
            end.
            when "DATETIME EXTENT":U then do:
                assign dttValueExt = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or extent (dttValueExt) > 0 then do:
                    assign oJsonArray = new JsonArray () .

                    if extent (dttValueExt) <> ? then
                        oJsonArray:Add (dttValueExt) .
                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                    oJsonArray = ? .
                end.
            end.
            when "DATETIME-TZ":U then do:
                assign dtttzValue = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or dtttzValue <> ? then
                    if valid-object (this-object:JsonDateTypeFormatter) then
                        this-object:JsonDateTypeFormatter:Add (poJsonObject, pcJsonProperty, dtttzValue) .
                    else
                        poJsonObject:Add (pcJsonProperty, dtttzValue) .
            end.
            when "DATETIME-TZ EXTENT":U then do:
                assign dtttzValueExt = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or extent (dtttzValueExt) > 0 then do:
                    assign oJsonArray = new JsonArray () .

                    if extent (dtttzValueExt) <> ? then
                        oJsonArray:Add (dtttzValueExt) .
                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                    oJsonArray = ? .
                end.
            end.
            when "DECIMAL":U then do:
                assign deValue = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or deValue <> ? then
                    poJsonObject:Add (pcJsonProperty, deValue) .
            end.
            when "DECIMAL EXTENT":U then do:
                assign deValueExt = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or extent (deValueExt) > 0 then do:
                    assign oJsonArray = new JsonArray () .

                    if extent (deValueExt) <> ? then
                        oJsonArray:Add (deValueExt) .
                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                    oJsonArray = ? .
                end.
            end.
            when "INT64":U then do:
                assign i64Value = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or i64Value <> ? then
                    poJsonObject:Add (pcJsonProperty, i64Value) .
            end.
            when "INT64 EXTENT":U then do:
                assign i64ValueExt = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or extent (i64ValueExt) > 0 then do:
                    assign oJsonArray = new JsonArray () .

                    if extent (i64ValueExt) <> ? then
                        oJsonArray:Add (i64ValueExt) .
                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                    oJsonArray = ? .
                end.
            end.
            when "INTEGER":U then do:
                assign iValue = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or iValue <> ? then
                    poJsonObject:Add (pcJsonProperty, iValue) .
            end.
            when "INTEGER EXTENT":U then do:
                assign iValueExt = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or extent (iValueExt) > 0 then do:
                    assign oJsonArray = new JsonArray () .

                    if extent (iValueExt) <> ? then
                        oJsonArray:Add (iValueExt) .
                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                    oJsonArray = ? .
                end.
            end.
            when "LOGICAL":U then do:
                assign lValue = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or lValue <> ? then
                    poJsonObject:Add (pcJsonProperty, lValue) .
            end.
            when "LOGICAL EXTENT":U then do:
                assign lValueExt = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or extent (lValueExt) > 0 then do:
                    assign oJsonArray = new JsonArray () .

                    if extent (lValueExt) <> ? then
                        oJsonArray:Add (lValueExt) .
                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                    oJsonArray = ? .
                end.
            end.
            when "LONGCHAR":U then do:
                assign lcValue  = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or lcValue > "":U then
                    poJsonObject:Add (pcJsonProperty, lcValue) .
            end.
            when "LONGCHAR EXTENT":U then do:
                assign lcValueExt = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or extent (lcValueExt) > 0 then do:
                    assign oJsonArray = new JsonArray () .

                    if extent (lcValueExt) <> ? then
                        oJsonArray:Add (lcValueExt) .
                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                    oJsonArray = ? .
                end.
            end.
            when "RAW":U then do:
                assign rawValue = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or rawValue <> ? then
                    poJsonObject:Add (pcJsonProperty, rawValue) .
            end.
            when "RAW EXTENT":U then do:
                assign rawValueExt = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or extent (rawValueExt) > 0 then do:
                    assign oJsonArray = new JsonArray () .

                    if extent (rawValueExt) <> ? then
                        oJsonArray:Add (rawValueExt) .
                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                    oJsonArray = ? .
                end.
            end.
            when "RECID":U then do:
                assign recidValue = integer (dynamic-property (this-object, pcProperty)) .

                if this-object:SerializeNullValues or recidValue <> ? then
                    poJsonObject:Add (pcJsonProperty, recidValue) .
            end.
            when "RECID EXTENT":U then do:
                assign recidValueExt = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or extent (recidValueExt) > 0 then do:
                    assign oJsonArray = new JsonArray () .

                    if extent (recidValueExt) <> ? then
                        oJsonArray:Add (recidValueExt) .
                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                    oJsonArray = ? .
                end.
            end.
            when "ROWID":U then do:
                assign roValue = dynamic-property (this-object, pcProperty).

                if this-object:SerializeNullValues or roValue <> ? then
                    poJsonObject:Add (pcJsonProperty, roValue) .
            end.
            when "ROWID EXTENT":U then do:
                assign roValueExt = dynamic-property (this-object, pcProperty) .

                if this-object:SerializeNullValues or extent (roValueExt) > 0 then do:
                    assign oJsonArray = new JsonArray () .

                    if extent (roValueExt) <> ? then
                        oJsonArray:Add (roValueExt) .
                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                    oJsonArray = ? .
                end.
            end.
            when "JsonArray":U or when "Progress.Json.ObjectModel.JsonArray":U then do:
                assign oJsonArray = dynamic-property (this-object, pcProperty) .

                if valid-object (oJsonArray) then do:
                    assign oJsonArray = cast (oJsonArray:Clone (), JsonArray) .

                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                end.
            end.
            when "JsonObject":U or when "Progress.Json.ObjectModel.JsonObject":U then do:
                assign oJsonItem = dynamic-property (this-object, pcProperty) .

                if valid-object (oJsonItem) then do:
                    assign oJsonItem = cast (oJsonItem:Clone (), JsonObject) .

                    poJsonObject:Add (pcJsonProperty, oJsonItem) .
                end.
            end.
            when "Enum":U or when "Progress.Lang.Enum":U then do:
                oObject = dynamic-property (this-object, pcProperty) .

                if valid-object (oObject) then do:
                    poJsonObject:Add (pcJsonProperty,
                                      substitute ("&1:&2":U,
                                                  oObject:GetClass():TypeName,
                                                  oObject:ToString())) .
                end.
                else if this-object:SerializeNullValues then
                    poJsonObject:AddNull (pcJsonProperty) .
            end.
            otherwise do:
                /* Serialization of object arrays */
                if pcType matches "* EXTENT":U then do:

                    oObjectExt = dynamic-property (this-object, pcProperty) .

                    if extent (oObjectExt) > 0 or this-object:SerializeNullValues then do:
                        oJsonArray = new JsonArray () .

                        poJsonObject:Add (pcJsonProperty, oJsonArray) .

                        do i = 1 to extent (oObjectExt):
                            assign oObject = oObjectExt[i] .

                            if valid-object (oObject) then do:
                                &if defined (NativeEnums) ne 0 &then
                                if oObject:GetClass():IsEnum() then do:
                                    if this-object:SerializeNullValues or oObject:ToString() > "":U then
                                        oJsonArray:Add (oObject:ToString ()) .
                                end.
                                else
                                &endif
                                if type-of (oObject, enum) then do:
                                    if this-object:SerializeNullValues or oObject:ToString() > "":U then
                                        oJsonArray:Add (oObject:ToString ()) .
                                end.
                                else do:
                                    if type-of (oObject, IJsonSerializable) then
                                        oJsonArray:Add (cast (oObject,IJsonSerializable):ToJsonObject()) .
                                    else
                                        undo, throw new JsonSerializationException (substitute ("Unable to serialize property &1 of &2 as it does not contain a Json Serializable object."{&TRAN},
                                                                                                pcProperty,
                                                                                                this-object:GetClass():TypeName), 0) .
                                end.
                            end.
                            else
                                if this-object:SerializeNullValues then
                                    poJsonObject:AddNull (pcJsonProperty) .
                        end.
                    end.
                end.
                else do:
                    oObject = dynamic-property (this-object, pcProperty) .

                    if valid-object (oObject) then do:
                        &if defined (NativeEnums) ne 0 &then
                        if oObject:GetClass():IsEnum() then do:
                            if this-object:SerializeNullValues or oObject:ToString() > "":U then
                                poJsonObject:Add (pcJsonProperty, oObject:ToString ()) .
                        end.
                        else
                        &endif
                        if type-of (oObject, enum) then do:
                            if this-object:SerializeNullValues or oObject:ToString() > "":U then
                                poJsonObject:Add (pcJsonProperty, oObject:ToString ()) .
                        end.
                        else if type-of (oObject, IEnumerable) then
                        do on error undo, throw:
                            assign oJsonArray = new JsonArray ()
                                   oList      = cast (oObject, IEnumerable).

                            {Consultingwerk/foreachABL.i Progress.Lang.Object oItem in oList}
                                if type-of (oItem, IJsonSerializable) then do:
                                    oJsonItem = cast (oItem, IJsonSerializable):ToJsonObject () .

                                    oJsonArray:Add (oJsonItem) .
                                end.
                                else
                                    undo, throw new JsonSerializationException (substitute ("Unable to serialize item in property &1 of &2."{&TRAN},
                                                                                            pcProperty, this-object:GetClass():TypeName),
                                                                                0) .
                            end.

                            finally:
                                if valid-object (oJsonArray) and (oJsonArray:Length > 0 or this-object:SerializeEmptyLists) then
                                    poJsonObject:Add (pcJsonProperty, oJsonArray) .
                                else
                                    if this-object:SerializeNullValues then
                                        poJsonObject:AddNull (pcJsonProperty) .
                            end finally.
                        end.
                        else do:
                            if type-of (oObject, IJsonSerializable) then
                                poJsonObject:Add (pcJsonProperty, cast (oObject,IJsonSerializable):ToJsonObject()) .
                            else
                                undo, throw new JsonSerializationException (substitute ("Unable to serialize property &1 of &2 as it does not contain a Json Serializable object."{&TRAN},
                                                                                        pcProperty,
                                                                                        this-object:GetClass():TypeName), 0) .
                        end.
                    end.
                    else
                        if this-object:SerializeNullValues then
                            poJsonObject:AddNull (pcJsonProperty) .
                end.
            end.
        end case .

    end method .

    /**
     * Purpose: Returns a JsonObject representation of the state of the class instance
     * Notes:   Returns the classname together with the Json serialization of the
     *          object
     * @return The Progress.Json.ObjectModel.JsonObject representation of the ISerializable objects data
     */
    method public Progress.Json.ObjectModel.JsonObject ToJsonObject ():

        define variable oJsonObject   as JsonObject no-undo .
        define variable i             as integer    no-undo .
        define variable iCount        as integer    no-undo .
        define variable cProperty     as character  no-undo .
        define variable cProperties   as character  no-undo .
        define variable cJsonProperty as character  no-undo .
        define variable cType         as character  no-undo .

        oJsonObject = new JsonObject () .

        if this-object:LazyInitializeSerializableProperties then
            this-object:LazyAddSerializableProperties().

        assign cProperties = this-object:SerializableProperties
               iCount      = num-entries (cProperties) .

        if this-object:UseSerializedTypeInformation then
            oJsonObject:Add ("SerializedType":U, this-object:GetClass():TypeName) .

        do i = 1 to iCount by 2:
            assign cProperty = entry (i, cProperties)
                   cType     = entry (i + 1, cProperties).

            if this-object:SerializeNames > "":U then
                assign cJsonProperty = this-object:GetSerializeName(cProperty) .
            else
                assign cJsonProperty = cProperty .

            /* Mike Fechner, Consultingwerk Ltd. 26.01.2013
               Moved to method SerializeProperty to allow easier overriding of
               individual properties handling */
            this-object:SerializeProperty (oJsonObject,
                                           cProperty,
                                           cJsonProperty,
                                           cType) .

        end.

        return oJsonObject .

    end method .

    /**
     * Purpose: Returns a LONGCHAR representation of the state of the class instance
     * Notes:   Returns the classname together with the Json serialization
     *          This method is a facade to the JsonSerializable:Serialize method
     * @return The LONGCHAR representation of the ISerializable objects data
     */
    method public longchar WriteJson ():

        return this-object:Serialize () .

    end method.

end class.
