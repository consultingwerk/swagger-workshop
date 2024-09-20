/*------------------------------------------------------------------------
    File        : ApsvTransportProperties
    Purpose     :
    Syntax      :
    Description :
    Author(s)   :
    Created     : 20.09.2024 11:40:59
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

{Consultingwerk/products.i}

USING Consultingwerk.*                          FROM PROPATH .
USING Consultingwerk.Framework.Collections.*    FROM PROPATH .
USING Samples.OeManager.Client.*                FROM PROPATH .
USING Progress.Lang.*                           FROM PROPATH .

CLASS Samples.OeManager.Client.ApsvTransportProperties
    INHERITS ParameterObject
    IMPLEMENTS IValueObjectValidatorWithMessages
    SERIALIZABLE:

    DEFINE PUBLIC PROPERTY adapterEnabled AS CHARACTER NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY allowRuntimeUpdates AS CHARACTER NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY collectMetrics AS CHARACTER NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY enableRequestChunking AS CHARACTER NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY oepingEnabled AS CHARACTER NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY oepingProcedure AS CHARACTER NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY serviceFaultLevel AS CHARACTER NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY statusEnabled AS CHARACTER NO-UNDO
    GET.
    SET.

    DEFINE PUBLIC PROPERTY useHTTPSessions AS CHARACTER NO-UNDO
    GET.
    SET.

    /*------------------------------------------------------------------------------
        Purpose: Constructor for the ApsvTransportProperties class
        Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC ApsvTransportProperties ():
        SUPER ().

        THIS-OBJECT:UseSerializedTypeInformation = FALSE.

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Constructor for the ApsvTransportProperties class
        Notes:
        @param pAdapterEnabled The value for the adapterEnabled property
        @param pAllowRuntimeUpdates The value for the allowRuntimeUpdates property
        @param pCollectMetrics The value for the collectMetrics property
        @param pEnableRequestChunking The value for the enableRequestChunking property
        @param pOepingEnabled The value for the oepingEnabled property
        @param pOepingProcedure The value for the oepingProcedure property
        @param pServiceFaultLevel The value for the serviceFaultLevel property
        @param pStatusEnabled The value for the statusEnabled property
        @param pUseHTTPSessions The value for the useHTTPSessions property
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC ApsvTransportProperties (
        pAdapterEnabled AS CHARACTER,
        pAllowRuntimeUpdates AS CHARACTER,
        pCollectMetrics AS CHARACTER,
        pEnableRequestChunking AS CHARACTER,
        pOepingEnabled AS CHARACTER,
        pOepingProcedure AS CHARACTER,
        pServiceFaultLevel AS CHARACTER,
        pStatusEnabled AS CHARACTER,
        pUseHTTPSessions AS CHARACTER):

        THIS-OBJECT ().

        ASSIGN
            THIS-OBJECT:adapterEnabled = pAdapterEnabled
            THIS-OBJECT:allowRuntimeUpdates = pAllowRuntimeUpdates
            THIS-OBJECT:collectMetrics = pCollectMetrics
            THIS-OBJECT:enableRequestChunking = pEnableRequestChunking
            THIS-OBJECT:oepingEnabled = pOepingEnabled
            THIS-OBJECT:oepingProcedure = pOepingProcedure
            THIS-OBJECT:serviceFaultLevel = pServiceFaultLevel
            THIS-OBJECT:statusEnabled = pStatusEnabled
            THIS-OBJECT:useHTTPSessions = pUseHTTPSessions
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
        DEFINE VARIABLE oObject   AS ApsvTransportProperties NO-UNDO.

        ASSIGN oObject = CAST (poValueObject, ApsvTransportProperties).

        RETURN oMessages .

    END METHOD.

END CLASS.
