/**********************************************************************
 * Copyright (C) 2006-2018 by Consultingwerk Ltd. ("CW") -            *
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
    File        : Factory
    Purpose     : Generic Factory implementation
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Mar 24 09:31:45 CET 2018
    Notes       : Supports the Factory custom log entry type; Factory:3 for
                  detailled logging whenever an object is created, Factory:4
                  for more details; Factory:2 for loading Factory's from file
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Ccs.Common.*                          FROM PROPATH .
USING Ccs.Common.Support.*                  FROM PROPATH .
USING Consultingwerk.Assertion.*            FROM PROPATH .
USING Consultingwerk.Exceptions.*           FROM PROPATH .
USING Consultingwerk.Framework.*            FROM PROPATH .
USING Consultingwerk.Framework.Exceptions.* FROM PROPATH .
USING Consultingwerk.Util.*                 FROM PROPATH .
USING Progress.Lang.*                       FROM PROPATH .
USING Progress.Reflect.*                    FROM PROPATH .

{Consultingwerk/products.i}

CLASS Consultingwerk.Framework.Factory
    IMPLEMENTS IFactory, IFactoryRegistry, IService:

    DEFINE PRIVATE TEMP-TABLE ttFactory NO-UNDO
        FIELD FactoryType  AS Progress.Lang.Object
        FIELD FactoryAlias AS CHARACTER INITIAL "":U
        FIELD InstanceType AS Progress.Lang.Object
        INDEX Factory IS UNIQUE FactoryType FactoryAlias .

    DEFINE TEMP-TABLE ttFactoryLoader NO-UNDO
        FIELD FactoryType  AS CHARACTER
        FIELD FactoryAlias AS CHARACTER INITIAL "":U
        FIELD InstanceType AS CHARACTER
        INDEX Factory IS UNIQUE FactoryType FactoryAlias .

    DEFINE VARIABLE iLoggingLevel AS INTEGER NO-UNDO.

    /**
     * Purpose: Gets and sets the reference to the overloading factory
     * Notes:
     */
    DEFINE PUBLIC PROPERTY OverloadingFactory AS IFactory NO-UNDO
    GET.
    SET.

    /**
     * Purpose: Constructor for the Factory class
     * Notes:
     */
    CONSTRUCTOR PUBLIC Factory ():

        IF LogManager:IsCustomLogEntryTypeActive ("Factory:4":U) THEN
            ASSIGN iLoggingLevel = 4 .
        ELSE IF LogManager:IsCustomLogEntryTypeActive ("Factory:3":U) THEN
            ASSIGN iLoggingLevel = 3 .
        ELSE IF LogManager:IsCustomLogEntryTypeActive ("Factory:2":U) THEN
            ASSIGN iLoggingLevel = 2 .

    END CONSTRUCTOR.

    /**
     * Purpose: Creates an object instance
     * Notes:   Factory method for object instances referenced by the provided
     *          type (typically an interface)
     * @param poType The type to create an instance of
     * @return The created object instance
     */
    METHOD PUBLIC Progress.Lang.Object CreateInstance (poType AS Progress.Lang.Class):

        DEFINE VARIABLE oArray AS Progress.Lang.Object EXTENT NO-UNDO .

        RETURN THIS-OBJECT:CreateInstance (poType, ?, oArray) .

    END METHOD .

    /**
     * Purpose: Creates an object instance
     * Notes:   Factory method for object instances referenced by the provided
     *          type (typically an interface)
     * @param poType The type to create an instance of
     * @param pcAlias The alias of the object
     * @return The created object instance
     */
    METHOD PUBLIC Progress.Lang.Object CreateInstance (poType AS Progress.Lang.Class,
                                                       pcAlias AS CHARACTER):

        DEFINE VARIABLE oArray AS Progress.Lang.Object EXTENT NO-UNDO .

        RETURN THIS-OBJECT:CreateInstance (poType, pcAlias, oArray) .

    END METHOD .

    /**
     * Purpose: Creates an object instance
     * Notes:   Factory method for object instances referenced by the provided
     *          type (typically an interface)
     * @param poType The type to create an instance of
     * @param poParameters An array of parameters to pass to the object's constructor, Holder types will be passed as their Value to the constructor
     * @return The created object instance
     */
    METHOD PUBLIC Progress.Lang.Object CreateInstance (poType AS Progress.Lang.Class,
                                                       poParameters AS Progress.Lang.Object EXTENT):

        RETURN THIS-OBJECT:CreateInstance (poType, ?, poParameters) .

    END  METHOD .

    /**
     * Purpose: Creates an object instance
     * Notes:   Factory method for object instances referenced by the provided
     *          type (typically an interface)
     * @param poType The type to create an instance of
     * @param pcAlias The alias of the object
     * @param poParameters An array of parameters to pass to the object's constructor, Holder types will be passed as their Value to the constructor
     * @return The created object instance
     */
    METHOD PUBLIC Progress.Lang.Object CreateInstance (poType AS Progress.Lang.Class,
                                                       pcAlias AS CHARACTER,
                                                       poParameters AS Progress.Lang.Object EXTENT):

        DEFINE VARIABLE oType        AS Progress.Lang.Class  NO-UNDO .
        DEFINE VARIABLE oInstance    AS Progress.Lang.Object NO-UNDO .
&IF DEFINED (AblReflection) NE 0 &THEN
        DEFINE VARIABLE oConstructor AS Constructor          NO-UNDO .
        DEFINE VARIABLE oParameters  AS ParameterList        NO-UNDO .
        DEFINE VARIABLE i            AS INTEGER              NO-UNDO .
&ENDIF

        ObjectAssert:IsValid (poType, "poType":U) .

        IF VALID-OBJECT (THIS-OBJECT:OverloadingFactory) THEN DO:
            IF TYPE-OF (THIS-OBJECT:OverloadingFactory, IFactoryRegistry) THEN DO:
                IF CAST (THIS-OBJECT:OverloadingFactory, IFactoryRegistry):HasFactory (poType, pcAlias) THEN
                    RETURN THIS-OBJECT:OverloadingFactory:CreateInstance (poType, pcAlias, poParameters) .
            END.
            ELSE DO ON ERROR UNDO, THROW:
                RETURN THIS-OBJECT:OverloadingFactory:CreateInstance (poType, pcAlias, poParameters) .

                CATCH uncaught AS FactoryNotRegisteredException:
                    /* noop */
                END CATCH.
            END.
        END.

        IF pcAlias = ? THEN
            ASSIGN pcAlias = "":U .

        IF NOT CAN-FIND (ttFactory WHERE ttFactory.FactoryType  = poType
                                     AND ttFactory.FactoryAlias = pcAlias) THEN
            UNDO, THROW NEW FactoryNotRegisteredException (SUBSTITUTE ("No factory registerd for &1 (&2)":U,
                                                                       poType:TypeName,
                                                                       pcAlias),
                                                           0,
                                                           poType:TypeName,
                                                           pcAlias) .

        {&_proparse_ prolint-nowarn(findnoerror)}
        FIND ttFactory WHERE ttFactory.FactoryType  = poType
                         AND ttFactory.FactoryAlias = pcAlias .

        oType = CAST (ttFactory.InstanceType, Progress.Lang.Class) .

        IF EXTENT (poParameters) = ? OR EXTENT (poParameters) = 0 THEN DO:
            IF iLoggingLevel >= 4 THEN
                LogManager:WriteFormattedMessage ("Creating instance for &1 (&2) of type &3 ()":U,
                                                  poType:TypeName,
                                                  pcAlias,
                                                  oType:TypeName) .

            oInstance = DYNAMIC-NEW (oType:TypeName) () .

            RETURN oInstance .
        END.

&IF DEFINED (AblReflection) NE 0 &THEN
        oParameters = NEW ParameterList (EXTENT (poParameters)) .

        DO i = 1 TO EXTENT (poParameters):

            IF NOT VALID-OBJECT (poParameters[i]) THEN
                oParameters:SetParameter (i, "Progress.Lang.Object":U, "INPUT":U, ?) .
            ELSE IF TYPE-OF (poParameters[i], ICharacterHolder) THEN
                oParameters:SetParameter (i, "CHARACTER":U, "INPUT":U, CAST(poParameters[i], ICharacterHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IDateHolder) THEN
                oParameters:SetParameter (i, "DATE":U, "INPUT":U, CAST(poParameters[i], IDateHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IDateTimeHolder) THEN
                oParameters:SetParameter (i, "DATETIME":U, "INPUT":U, CAST(poParameters[i], IDateTimeHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IDateTimeTzHolder) THEN
                oParameters:SetParameter (i, "DATETIME-TZ":U, "INPUT":U, CAST(poParameters[i], IDateTimeTzHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IDecimalHolder) THEN
                oParameters:SetParameter (i, "DECIMAL":U, "INPUT":U, CAST(poParameters[i], IDecimalHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IHandleHolder) THEN
                oParameters:SetParameter (i, "HANDLE":U, "INPUT":U, CAST(poParameters[i], IHandleHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IInt64Holder) THEN
                oParameters:SetParameter (i, "INT64":U, "INPUT":U, CAST(poParameters[i], IInt64Holder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IIntegerHolder) THEN
                oParameters:SetParameter (i, "INTEGER":U, "INPUT":U, CAST(poParameters[i], IIntegerHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], ILogicalHolder) THEN
                oParameters:SetParameter (i, "LOGICAL":U, "INPUT":U, CAST(poParameters[i], ILogicalHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], ILongcharHolder) THEN
                oParameters:SetParameter (i, "LONGCHAR":U, "INPUT":U, CAST(poParameters[i], ILongcharHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IMemptrHolder) THEN
                oParameters:SetParameter (i, "MEMPTR":U, "INPUT":U, CAST(poParameters[i], IMemptrHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IRowidHolder) THEN
                oParameters:SetParameter (i, "ROWID":U, "INPUT":U, CAST(poParameters[i], IRowidHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], ICharacterArrayHolder) THEN
                oParameters:SetParameter (i, "CHARACTER EXTENT":U, "INPUT":U, CAST(poParameters[i], ICharacterArrayHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IDateArrayHolder) THEN
                oParameters:SetParameter (i, "DATE EXTENT":U, "INPUT":U, CAST(poParameters[i], IDateArrayHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IDateTimeArrayHolder) THEN
                oParameters:SetParameter (i, "DATETIME EXTENT":U, "INPUT":U, CAST(poParameters[i], IDateTimeArrayHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IDateTimeTzArrayHolder) THEN
                oParameters:SetParameter (i, "DATETIME-TZ EXTENT":U, "INPUT":U, CAST(poParameters[i], IDateTimeTzArrayHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IDecimalArrayHolder) THEN
                oParameters:SetParameter (i, "DECIMAL EXTENT":U, "INPUT":U, CAST(poParameters[i], IDecimalArrayHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IHandleArrayHolder) THEN
                oParameters:SetParameter (i, "HANDLE EXTENT":U, "INPUT":U, CAST(poParameters[i], IHandleArrayHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IInt64ArrayHolder) THEN
                oParameters:SetParameter (i, "INT64 EXTENT":U, "INPUT":U, CAST(poParameters[i], IInt64ArrayHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IIntegerArrayHolder) THEN
                oParameters:SetParameter (i, "INTEGER EXTENT":U, "INPUT":U, CAST(poParameters[i], IIntegerArrayHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], ILogicalArrayHolder) THEN
                oParameters:SetParameter (i, "LOGICAL EXTENT":U, "INPUT":U, CAST(poParameters[i], ILogicalArrayHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], ILongcharArrayHolder) THEN
                oParameters:SetParameter (i, "LONGCHAR EXTENT":U, "INPUT":U, CAST(poParameters[i], ILongcharArrayHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IMemptrArrayHolder) THEN
                oParameters:SetParameter (i, "MEMPTR EXTENT":U, "INPUT":U, CAST(poParameters[i], IMemptrArrayHolder):Value) .
            ELSE IF TYPE-OF (poParameters[i], IRowidArrayHolder) THEN
                oParameters:SetParameter (i, "ROWID EXTENT":U, "INPUT":U, CAST(poParameters[i], IRowidArrayHolder):Value) .
            ELSE
                oParameters:SetParameter (i, poParameters[i]:GetClass():TypeName, "INPUT":U, poParameters[i]) .
        END.

        IF iLoggingLevel >= 4 THEN
            LogManager:WriteFormattedMessage ("Creating instance for &1 (&2) of type &3 (&4 Parameters)":U,
                                              poType:TypeName,
                                              pcAlias,
                                              oType:TypeName,
                                              STRING (oParameters:NumParameters),
                                              NEW MessageSubSystem("Factory:4":U)) .

        oConstructor = oType:GetConstructor (Progress.Reflect.Flags:Public, oParameters) .

        IF NOT VALID-OBJECT (oConstructor) THEN
            UNDO, THROW NEW FactoryMissingConstructorException (SUBSTITUTE ("Cannot find constructor for type &1 with &2 parameters.":U,
                                                                            oType:TypeName, oParameters:NumParameters),
                                                                0) .

        oInstance = oConstructor:Invoke (oParameters) .

        RETURN oInstance .
&ELSE
        UNDO, THROW NEW NotSupportedException ("CreateInstance":U, THIS-OBJECT:GetClass():TypeName) .
&ENDIF
    END METHOD .

    /**
     * Purpose: Registers an object factory type
     * Notes:
     * @param poType The type to register
     * @param poImplementation The implementation of the type
     */
    METHOD PUBLIC VOID RegisterFactory (poType AS Progress.Lang.Class,
                                        poImplementation AS Progress.Lang.Class):

        THIS-OBJECT:RegisterFactory (poType, "":U, poImplementation) .

    END METHOD .

    /**
     * Purpose: Registers an object factory type
     * Notes:
     * @param poType The type to register
     * @param pcAlias The type alias
     * @param poImplementation The implementation of the type
     */
    METHOD PUBLIC VOID RegisterFactory (poType AS Progress.Lang.Class,
                                        pcAlias AS CHARACTER,
                                        poImplementation AS Progress.Lang.Class):

        DEFINE BUFFER ttFactory FOR ttFactory .

        IF pcAlias = ? THEN
            ASSIGN pcAlias = "":U .

        ObjectAssert:IsValid (poType, "poType":U) .
        ObjectAssert:IsValid (poImplementation, "poImplementation":U) .

        IF iLoggingLevel >= 3 THEN DO:
            IF pcAlias > "":U THEN
                LogManager:WriteFormattedMessage ("Registering factory for &1 (&3) / &2":U,
                                                  poType:TypeName,
                                                  poImplementation:TypeName,
                                                  pcAlias,
                                                  NEW MessageSubSystem ("Factory:3":U)) .
            ELSE
                LogManager:WriteFormattedMessage ("Registering factory for &1 / &2":U,
                                                  poType:TypeName,
                                                  poImplementation:TypeName,
                                                  NEW MessageSubSystem ("Factory:3":U)) .
        END.

        IF CAN-FIND (ttFactory WHERE ttFactory.FactoryType  = poType
                                 AND ttFactory.FactoryAlias = pcAlias) THEN DO:

            DO FOR ttFactory:
                FIND ttFactory WHERE ttFactory.FactoryType  = poType
                                 AND ttFactory.FactoryAlias = pcAlias NO-ERROR .

                IF ttFactory.InstanceType = poImplementation THEN
                    RETURN .
            END.

            IF pcAlias > "":U THEN
                UNDO, THROW NEW FactoryAlreadyRegisteredException (SUBSTITUTE ("Factory is already registerd for &1 (&2)":U,
                                                                               poType:TypeName,
                                                                               pcAlias),
                                                               0,
                                                               poType:TypeName,
                                                               pcAlias) .
            ELSE
                UNDO, THROW NEW FactoryAlreadyRegisteredException (SUBSTITUTE ("Factory is already registerd for &1":U,
                                                                               poType:TypeName),
                                                               0,
                                                               poType:TypeName,
                                                               pcAlias) .

        END.

        DO FOR ttFactory:
            CREATE ttFactory.
            ASSIGN ttFactory.FactoryType  = poType
                   ttFactory.FactoryAlias = pcAlias
                   ttFactory.InstanceType = poImplementation .
        END.

    END METHOD .

    /**
     * Purpose: Returns if the given factory is registered
     * Notes:
     * @param poType The type of evaluate
     * @return Logical value indicating if the factory for the given type is registered
     */
    METHOD PUBLIC LOGICAL HasFactory (poType AS Progress.Lang.Class):

        RETURN THIS-OBJECT:HasFactory (poType, "":U) .

    END METHOD .

    /**
     * Purpose: Returns if the given factory is registered
     * Notes:
     * @param poType The type of evaluate
     * @param pcAlias The type alias
     * @return Logical value indicating if the factory for the given type is registered
     */
    METHOD PUBLIC LOGICAL HasFactory (poType AS Progress.Lang.Class,
                                      pcAlias AS CHARACTER):

        DEFINE VARIABLE oOverloading AS IFactoryRegistry NO-UNDO .

        IF VALID-OBJECT (THIS-OBJECT:OverloadingFactory) AND TYPE-OF (THIS-OBJECT:OverloadingFactory, IFactoryRegistry) THEN DO:
            ASSIGN oOverloading = CAST (THIS-OBJECT:OverloadingFactory, IFactoryRegistry) .

            IF oOverloading:HasFactory(poType, pcAlias) THEN
                RETURN TRUE .
        END.

        IF pcAlias = ? THEN
            ASSIGN pcAlias = "":U .

        RETURN CAN-FIND (ttFactory WHERE ttFactory.FactoryType  = poType
                                     AND ttFactory.FactoryAlias = pcAlias) .

    END METHOD .

    /**
     * Purpose: Registers object factories from the given file
     * Notes:
     * @param pcFileName The file naem to load factories from
     */
    METHOD PUBLIC VOID LoadFromFile (pcFileName AS CHARACTER):

        DEFINE VARIABLE cFileName AS CHARACTER NO-UNDO.

        IF iLoggingLevel >= 2 THEN
            LogManager:WriteFormattedMessage ("Loading factories from: &1":U,
                                              pcFileName,
                                              NEW MessageSubSystem ("Factory:2":U)) .

        FileAssert:Exists (pcFileName) .

        ASSIGN cFileName = FileHelper:FindFile (pcFileName) .

        TEMP-TABLE ttFactoryLoader:READ-XML ("file":U,
                                             cFileName,
                                             ?, ?, ?) .

        FOR EACH ttFactoryLoader:
            THIS-OBJECT:RegisterFactory (Progress.Lang.Class:GetClass (ttFactoryLoader.FactoryType),
                                         ttFactoryLoader.FactoryAlias,
                                         Progress.Lang.Class:GetClass (ttFactoryLoader.InstanceType)) .
        END.

        EMPTY TEMP-TABLE ttFactoryLoader .

    END METHOD .

    /**
     * Purpose: Registers an object factory type
     * Notes:
     * @param poType The type to register
     */
    METHOD PUBLIC VOID UnregisterFactory (poType AS Progress.Lang.Class):

        THIS-OBJECT:UnregisterFactory(poType, "":U) .

    END METHOD .

    /**
     * Purpose: Registers an object factory type
     * Notes:
     * @param poType The type to register
     * @param pcAlias The type alias
     */
    METHOD PUBLIC VOID UnregisterFactory (poType AS Progress.Lang.Class,
                                          pcAlias AS CHARACTER):

        DEFINE BUFFER ttFactory FOR ttFactory .

        IF pcAlias = ? THEN
            ASSIGN pcAlias = "":U .

        ObjectAssert:IsValid (poType, "poType":U) .

        IF iLoggingLevel >= 3 THEN DO:
            IF pcAlias > "":U THEN
                LogManager:WriteFormattedMessage ("Unregistering factory for &1 (&2)":U,
                                                  poType:TypeName,
                                                  pcAlias,
                                                  NEW MessageSubSystem ("Factory:3":U)) .
            ELSE
                LogManager:WriteFormattedMessage ("Unregistering factory for &1":U,
                                                  poType:TypeName,
                                                  NEW MessageSubSystem ("Factory:3":U)) .
        END.

        IF CAN-FIND (ttFactory WHERE ttFactory.FactoryType  = poType
                                 AND ttFactory.FactoryAlias = pcAlias) THEN DO:

            {&_proparse_ prolint-nowarn(findnoerror)}
            FIND ttFactory WHERE ttFactory.FactoryType  = poType
                             AND ttFactory.FactoryAlias = pcAlias .

            DELETE ttFactory .
        END.

    END METHOD .

    /**
     * Purpose: Destroy/Shutdown/Anti-Initializer
     * Notes:
     */
    METHOD PUBLIC VOID dispose ():

        /* noop */

    END METHOD.

    /**
     * Purpose: Initializer/Startup
     * Notes:
     */
    METHOD PUBLIC VOID initialize ():

        /* noop */

    END METHOD.

END CLASS.
