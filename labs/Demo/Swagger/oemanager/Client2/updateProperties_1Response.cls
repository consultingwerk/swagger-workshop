/*------------------------------------------------------------------------
    File        : updateProperties_1Response
    Purpose     :
    Syntax      :
    Description :
    Author(s)   :
    Created     : 29.09.2024 21:44:09
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

{Consultingwerk/products.i}

USING Consultingwerk.*                          FROM PROPATH .
USING Consultingwerk.Framework.Collections.*    FROM PROPATH .
USING Demo.Swagger.oemanager.Client2.*          FROM PROPATH .
USING Progress.Lang.*                           FROM PROPATH .

CLASS Demo.Swagger.oemanager.Client2.updateProperties_1Response
    INHERITS ParameterObject
    IMPLEMENTS IValueObjectValidatorWithMessages
    SERIALIZABLE:

    DEFINE PUBLIC PROPERTY operation AS CHARACTER NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY outcome AS CHARACTER NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY result AS ApsvTransportProperties NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY errmsg AS CHARACTER NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY versionStr AS CHARACTER NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY versionNo AS CHARACTER NO-UNDO
    GET.
    SET.

    /*------------------------------------------------------------------------------
        Purpose: Constructor for the updateProperties_1Response class
        Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC updateProperties_1Response ():
        SUPER ().

        THIS-OBJECT:UseSerializedTypeInformation = FALSE.

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Constructor for the updateProperties_1Response class
        Notes:
        @param pOperation The value for the operation property
        @param pOutcome The value for the outcome property
        @param pResult The value for the result property
        @param pErrmsg The value for the errmsg property
        @param pVersionStr The value for the versionStr property
        @param pVersionNo The value for the versionNo property
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC updateProperties_1Response (
        pOperation AS CHARACTER,
        pOutcome AS CHARACTER,
        pResult AS ApsvTransportProperties,
        pErrmsg AS CHARACTER,
        pVersionStr AS CHARACTER,
        pVersionNo AS CHARACTER):

        THIS-OBJECT ().

        ASSIGN
            THIS-OBJECT:operation = pOperation
            THIS-OBJECT:outcome = pOutcome
            THIS-OBJECT:result = pResult
            THIS-OBJECT:errmsg = pErrmsg
            THIS-OBJECT:versionStr = pVersionStr
            THIS-OBJECT:versionNo = pVersionNo
            .

    END CONSTRUCTOR.

    /**
     * Purpose: Validates the properties of the given value object
     * Notes:
     * @param poValueObject The value object to validate
     * @return CharacterDictionary of validation messages, when the dictionary is unknown or empty, validation was successful
     */
    METHOD PUBLIC CharacterDictionary IsValid (poValueObject AS Progress.Lang.Object):

        DEFINE VARIABLE oMessages AS CharacterDictionary NO-UNDO.
        DEFINE VARIABLE oObject   AS updateProperties_1Response NO-UNDO.

        ASSIGN oObject = CAST (poValueObject, updateProperties_1Response).

        RETURN oMessages .

    END METHOD.

END CLASS.
