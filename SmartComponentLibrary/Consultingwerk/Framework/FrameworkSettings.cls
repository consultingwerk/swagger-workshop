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
    File        : FrameworkSettings
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu May 07 10:15:20 CEST 2009
    Notes       : This class should only contain static members.
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW .

{ Consultingwerk/products.i }

USING Consultingwerk.*                                 FROM PROPATH.
USING Consultingwerk.Framework.*                       FROM PROPATH.
USING Consultingwerk.Framework.Exceptions.*            FROM PROPATH.
USING Consultingwerk.Framework.Server.SimpleProfiler.* FROM PROPATH.
USING Consultingwerk.Framework.Server.Telemetry.*      FROM PROPATH.
USING Consultingwerk.OERA.*                            FROM PROPATH.
USING Consultingwerk.Util.*                            FROM PROPATH.
USING Progress.Lang.*                                  FROM PROPATH.
&IF DEFINED (DotNetAccessible) NE 0 &THEN
USING System.Windows.Forms.* FROM ASSEMBLY.
&ENDIF

CLASS Consultingwerk.Framework.FrameworkSettings   :

    DEFINE PRIVATE STATIC VARIABLE oWaitStateManager AS IWaitStateManager NO-UNDO .

    /**
     * Purpose: Allows to override the DesignTime property
     * Notes:   This property should be handled with care! This property is only
     *          used by some of the SmartComponent Library controls.
     */
    DEFINE PUBLIC STATIC PROPERTY AllowDesignFeatures AS LOGICAL INITIAL FALSE NO-UNDO
    GET.
    SET.

    /**
     * Purpose: Gets and sets the Label of the current application
     * Notes:   Can be used in dialogs that should refer to the current application
     */
    DEFINE PUBLIC STATIC PROPERTY ApplicationLabel AS CHARACTER NO-UNDO
    GET:
        DEFINE VARIABLE iPos AS INTEGER NO-UNDO.

        IF FrameworkSettings:ApplicationLabel > "":U THEN
            RETURN FrameworkSettings:ApplicationLabel .

        &IF DEFINED (DotNetAccessible) NE 0 &THEN
        IF VALID-OBJECT (FrameworkSettings:MdiContainer) THEN DO:
            iPos = INDEX (FrameworkSettings:MdiContainer:Text, "<":U) .

            IF iPos > 1 THEN
                RETURN TRIM (SUBSTRING (FrameworkSettings:MdiContainer:Text, 1, iPos - 1, "CHARACTER":U)).
            ELSE
                RETURN TRIM (FrameworkSettings:MdiContainer:Text) .
        END.
        &ENDIF

        RETURN "SmartComponent Library":U .
    END.
    SET.

    /**
     * Purpose: Gets/Sets the reference to the current AppServerServiceManager
     *          instance
     * Notes:   A default SessionServiceManager instance is created in the static
     *          constructor.
     */
    DEFINE PUBLIC STATIC PROPERTY AppServerServiceManager AS IAppServerServiceManager NO-UNDO
    GET.
    SET.

    /**
     * Purpose: Gets and sets the name of the Banner file to be used for the AppServer
     *          startup and CLI tools
     * Notes:
     */
    DEFINE PUBLIC STATIC PROPERTY BannerFile AS CHARACTER NO-UNDO
        INITIAL "Consultingwerk/banner.txt":U
    GET.
    SET.

    /**
     * Purpose:  Gets and sets the base registry key used for storing settings
     *          from this application
     * Notes:
     */
    DEFINE PUBLIC STATIC PROPERTY BaseRegistryKey AS CHARACTER NO-UNDO
        INITIAL "Software~\Consultingwerk Ltd.~\Sample Applications~\":U
    GET.
    SET.

    /**
     * Purpose:  Gets and sets the Configuration Provider instance
     * Notes:    Once set, the property can no longer be modified
     */
    DEFINE PUBLIC STATIC PROPERTY ConfigurationProvider AS IConfigurationProvider NO-UNDO
    GET:
        RETURN  {Consultingwerk/get-service.i Consultingwerk.Framework.IConfigurationProvider} .
    END GET .
    SET (arg AS IConfigurationProvider):
        IF VALID-OBJECT ({Consultingwerk/get-service.i Consultingwerk.Framework.IConfigurationProvider}) THEN
            UNDO, THROW NEW CannotChangeConfigurationProviderException () .

        FrameworkSettings:ServiceContainer:AddNewService (GET-CLASS (IConfigurationProvider),
                                                          arg) .
    END SET.

    /**
     * Purpose: Gets/Sets if various debug messages (i.e. Stack Trace information)
     *          should be displayed
     * Notes:   Set to TRUE by default if SESSION:PARAMETER contains DebugMode
     */
    DEFINE PUBLIC STATIC PROPERTY DebugMode AS LOGICAL NO-UNDO INITIAL FALSE
    GET.
    SET.

    /**
     * Purpose: Gets/Sets if various dialogs should extend transparency (around
     *          filter fields ect.).
     * Notes:   Set to TRUE by default, allows to turn off extended transparency
     *          when this causes trouble (i.e. Terminal ServeR)
     */
    DEFINE PUBLIC STATIC PROPERTY ExtendedTransparency AS LOGICAL INITIAL TRUE NO-UNDO
    GET.
    SET.

&IF DEFINED (DotNetAccessible) NE 0 &THEN
    /**
     * Purpose:  Gets and sets a reference to the main MdiContainer of the application
     * Notes:    Used by MdiChildren to the MdiContainer property of form.
     *          Type is System.Windows.Forms.Form
     */
    DEFINE PUBLIC STATIC PROPERTY MdiContainer AS Form NO-UNDO
    GET.
    SET.
&ENDIF

    /**
     * Purpose:  Gets or sets the instance of the ProgressManager
     * Notes:
     */
    DEFINE PUBLIC STATIC PROPERTY ProgressManager AS Consultingwerk.Framework.IProgressManager NO-UNDO
    GET.
    SET.

    /**
     * Purpose:  Gets or sets the instance of the framework default service container
     * Notes:
     */
    DEFINE PUBLIC STATIC PROPERTY ServiceContainer AS Consultingwerk.Framework.IServiceContainer NO-UNDO
    GET ():
        IF NOT VALID-OBJECT (FrameworkSettings:ServiceContainer) THEN

            FrameworkSettings:ServiceContainer = NEW ServiceContainer () .

        RETURN FrameworkSettings:ServiceContainer .
    END GET.
    SET.

    /**
     * Purpose: Return the session startup propath
     * Notes:   The session startup propath may be updated using the
     *          StoreStartupPropath method. This property is also set in the
     *          Constructor of the FrameworkSettings static class
     */
    DEFINE PUBLIC STATIC PROPERTY StartupPropath AS CHARACTER NO-UNDO
    GET.
    PRIVATE SET.

    /**
     * Purpose:  Gets or sets the instance of the StatusManager
     * Notes:
     */
    DEFINE PUBLIC STATIC PROPERTY StatusManager AS Consultingwerk.Framework.IStatusManager NO-UNDO
    GET.
    SET.

    /**
     * Purpose:  Gets and sets if the BaseForm should store the user selected tools
     *          of the Quick Access Toolbar in the Registry
     * Notes:
     */
    DEFINE PUBLIC STATIC PROPERTY StoreRibbonQuickAccessToolbar AS LOGICAL NO-UNDO
    GET.
    SET.

    /**
     * Purpose:  Gets and sets if the BaseForm should store the position of the
     *          UltraSplitterControls in the Registry
     * Notes:
     */
    DEFINE PUBLIC STATIC PROPERTY StoreUltraSplitterPosition AS LOGICAL NO-UNDO
    GET.
    SET.

    /**
     * Purpose:  Gets and sets if the BaseForm should store window position
     *          and size in the Registry
     * Notes:
     */
    DEFINE PUBLIC STATIC PROPERTY StoreWindowPosition AS LOGICAL NO-UNDO
    GET.
    SET.

    /**
     * Purpose: When set to True the OnLoad method will apply the current form (startup
     *          size) to the MinimumSize. This will be done before loading the stored
     *          Form size from the user profile (e.g. Windows Registry)
     * Notes:   Static property, allows to set UseStartupSizeAsMinSize for all new
     *          BaseForm instances
     */
    DEFINE PUBLIC STATIC PROPERTY UseStartupSizeAsMinSizeDefault AS LOGICAL NO-UNDO
    GET.
    SET.

    /**
     * Purpose: Gets/Sets the reference to the current WaitStateManager
     *          instance
     * Notes:   A default WaitStateManager instance is created in the static
     *          constructor.
     */
    DEFINE PUBLIC STATIC PROPERTY WaitStateManager AS IWaitStateManager NO-UNDO
    GET:
&IF DEFINED (DotNetAccessible) NE 0 &THEN
        /* Default for Wait-State-Manager */
        IF NOT VALID-OBJECT (oWaitStateManager) THEN
            ASSIGN oWaitStateManager = NEW NotifyIconWaitStateManager ().
&ENDIF
        RETURN oWaitStateManager .
    END GET.
    SET (arg AS IWaitStateManager):
        IF VALID-OBJECT (oWaitStateManager) THEN
            DELETE OBJECT oWaitStateManager .

        oWaitStateManager = arg .
    END SET.

    /**
     * Purpose: Static constructor for the FrameworkSettings class
     * Notes:   Initializes SessionServiceManager as default AppServerServiceManager
     *          implementation
     */
    CONSTRUCTOR STATIC FrameworkSettings ():

        DEFINE VARIABLE oSettingsService AS Progress.Lang.Object NO-UNDO .

        /* Initialize the Environment class */
        {&_proparse_ prolint-nowarn(exprnofx)}
        Consultingwerk.Environment:TimeStarted .

        IF ListHelper:EntryIsInList ("DebugMode":U, SESSION:PARAMETER) /*OR
            StartupParameterHelper:GetStartupParameterValue ("p":U) MATCHES "*_debuglauncher.p":U*/
        THEN
            FrameworkSettings:DebugMode = TRUE .

        FrameworkSettings:StoreStartupPropath () .

&IF DEFINED (DotNetAccessible) NE 0 &THEN
        /* Mike Fechner, Consultingwerk Ltd. 03.08.2011
           On .NET Default to the Windows Registry */
        oSettingsService = FrameworkSettings:ServiceContainer:AddNewService (GET-CLASS (ISettingsService),
                                                                             NEW Consultingwerk.Windows.RegistrySettingsService()) .

        FrameworkSettings:ServiceContainer:AddService (GET-CLASS (ISettingsServiceLong),
                                                       oSettingsService) .
&ENDIF

        /* Mike Fechner, Consultingwerk Ltd. 10.12.2014
           SCL-103: Trial version mode, in build activated for the full XCODE build */
&IF DEFINED (DotNetAccessible) NE 0 &THEN
&IF DEFINED (TrialVersionMode) NE 0 &THEN
&IF NOT PROVERSION BEGINS "10" &THEN
        IF (ClientType:Is4GLClient() OR ClientType:IsWebClient())
           AND SESSION:BATCH-MODE    = FALSE
           AND SESSION:WINDOW-SYSTEM BEGINS "MS-WIN":U THEN DO ON ERROR UNDO, THROW:

            /* Mike Fechner, Consultingwerk Ltd. 10.12.2014
               SCL-103: Trial version message, when included in products.i */
            DEFINE VARIABLE cStackTrace    AS CHARACTER                               NO-UNDO .
            DEFINE VARIABLE oNagScreenForm AS Consultingwerk.Windows.TrialVersionForm NO-UNDO .
            DEFINE VARIABLE iCounter       AS INTEGER                                 NO-UNDO .

            ASSIGN cStackTrace = ErrorHelper:CurrentStacktrace .

            IF NOT cStackTrace MATCHES "*com.openedge.pdt.debug.core_*_debuglauncher.p*":U THEN DO:
                ASSIGN iCounter = DataTypeHelper:ToInteger (STRING (Registry:GetRegistryValue("CurrentUser":U,
                                                                                              "Software~\Consultingwerk Ltd.~\SmartComponent Library":U,
                                                                                              "Counter":U))) .

                IF iCounter = ? THEN
                    ASSIGN iCounter = 0 .

                Registry:SetRegistryValue("CurrentUser":U,
                                          "Software~\Consultingwerk Ltd.~\SmartComponent Library":U,
                                          "Counter":U,
                                          STRING (iCounter + 1)) .

                IF iCounter MODULO 10 = 0 THEN DO:
                    oNagScreenForm = NEW Consultingwerk.Windows.TrialVersionForm () .
                    WAIT-FOR oNagScreenForm:ShowDialog () .
                END.
            END.

            @SuppressUnusedWarnings.
            CATCH sysex AS System.Exception:
                /* Ignore .NET Exceptions from above */
            END CATCH.
        END.
&ENDIF
&ENDIF
&ENDIF

    END CONSTRUCTOR.

    /**
     * Purpose: Stores the current propath in the StartupPropath property
     * Notes:
     */
    METHOD PUBLIC STATIC VOID StoreStartupPropath ():

        ASSIGN FrameworkSettings:StartupPropath = PROPATH .

    END METHOD .

END CLASS.
