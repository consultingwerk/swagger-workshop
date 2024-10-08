&IF 1=0 &THEN
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
    File        : products.i
    Purpose     : Contains compile time flags indicating the available
                  Consultingwerk framework products / developer toolkits

    Syntax      : include file

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Feb 03 21:35:47 CET 2011
    Notes       : OERASI preprocessor controls the default path to the
                  service interface procedures in include files. Used
                  in the ServiceAdapter class and the proSI... procedures

                  The comments in this file are excluded from the preprocessed
                  source code to avoid influencing the class documentation
                  tools which work on preprocessed source code
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Mike Fechner, Consultingwerk Ltd. 08.08.2011
   The GUI for .NET products do require compilation on
   MS Windows anyhow - so this seems like a good practice */
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 13.09.2017
   Preprocessor variables for SmartComponentLibrary, WinKit and SmartFramework
   based on Consultingwerk/packages.i now */
&ENDIF
{ Consultingwerk/packages.i }

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 09.09.2022
   Preprocessor variables for OpenEdge releases */
&ENDIF
{ Consultingwerk/openedgeversion.i }

&IF "{&WINDOW-SYSTEM}":U BEGINS "MS-WIN":U &THEN

&IF 1=0 &THEN
/*&GLOBAL-DEFINE Dynamics4NET */
&ENDIF
&IF DEFINED (Consultingwerk-SmartComponents-Core) NE 0 &THEN
&GLOBAL-DEFINE SmartComponentLibrary
&ENDIF
&IF DEFINED (Consultingwerk-WindowIntegrationKit-Core) NE 0 &THEN
&GLOBAL-DEFINE WinKit
&ENDIF
&ENDIF
&IF DEFINED (Consultingwerk-SmartFramework-Core) NE 0 &THEN
&GLOBAL-DEFINE SmartFramework
&ENDIF
&IF 1=0 &THEN
/*&GLOBAL-DEFINE WinKitDemo */
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 28.02.2014
   SmartFrameworkBackend switch allows access to SmartFramework functionality on the
   Backend, e.g. ISecurityService */
&GLOBAL-DEFINE SmartFrameworkBackend
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 15.12.2011
   The use of the SimpleDynamicsRepositoryService is optional, requires an ICFDB */
/*&GLOBAL-DEFINE UseSimpleDynamicsRepositoryService*/
&ENDIF
&IF DEFINED (Consultingwerk-Framework-RepositoryServices-Dynamics) NE 0 &THEN
&GLOBAL-DEFINE UseSimpleDynamicsRepositoryService
&ENDIF

&IF 1=0 &THEN
/* default path to OERA Service Interface */
&ENDIF
&GLOBAL-DEFINE OERASI OERA/support

&IF 1=0 &THEN
/* Support for custom include files for the OERA/support/proSI...
   procedures. These include files can be in any directory, but
   by convention need to be called:
        proSIfetchDatasetCustom.i
        proSIinvokeMethodCustom.i
        proSIinvokeTaskCustom.i
        proSIretrieveCustom.i
        proSIsubmitCustom.i
        proSIvalidateEntityNameCustom.i

   The following custom include files are to support defining/setting SHARED variables
   for Service Interface operations.
        si-fetchdataset-custom.i
        si-fetchdata-custom.i
        si-savechanges-custom.i
        si-invokemethod-custom.i
        si-invoketask-custom.i
   */
/*&GLOBAL-DEFINE ProSIcustomIncludeDirectory OERA/Custom*/
&ENDIF

&IF 1=0 &THEN
/* Peter Judge / Consultingwerk Ltd.
   SCL-4161 : When defined, the Service Interface will run its FetchData, FetchDataset, InvokeMethod, InvokeTask*
   and SaveChanges methods from a .p instead of inline. The .p is intended to be customized in order to define
   NEW SHARED variables */
/*&GLOBAL-DEFINE ServiceInterfaceSupportsSharedVariables ServiceInterfaceSupportsSharedVariables*/
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner / Consultingwerk Ltd.
   SCL-4421 : Used together with ServiceInterfaceSupportsSharedVariables
              When defined, si-...p procedures will include a second include file at the end to support
              updating the session context from shared variables */
/*&GLOBAL-DEFINE ServiceInterfaceSupportsSharedVariablesEnd ServiceInterfaceSupportsSharedVariablesEnd*/
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 12.02.2015
   SCL-577 : Allow to disable the handling of ERROR-STATUS:ERROR in the
             service interface procedure - causing issues when
             FIND <record> WHERE ... NO-ERROR was the last statement
             executed with NO-ERROR before returning to the Service Interface
             Some customers may rely on this... */
&GLOBAL-DEFINE IgnoreErrorStatusErrorInServiceInterfaceProcedure
&ENDIF

&IF 1=0 &THEN
/* Compilation allowed that accesses .NET classes?
   In 10.2B it would be sufficient to test for
   "{&WINDOW-SYSTEM}". For OE11 support for .NET
   on the AppServer Character client is announced.
   Currently we do expect that in OE11 the test
   for "{&WINDOW-SYSTEM} would not be sufficient
   to know if .NET assemblies are accessible. */
&ENDIF
&IF "{&WINDOW-SYSTEM}":U BEGINS "MS-WIN":U &THEN
&GLOBAL-DEFINE DotNetAccessible
&ENDIF

&IF 1=0 &THEN
/* Include conditional compilation for Infragistics Controls, aka OpenEdge UltraControls */
&ENDIF
&GLOBAL-DEFINE Infragistics

&IF 1=0 &THEN
/* Include conditional compilation for Telerik Rad Controls, aka UI for WinForms */
&ENDIF
&GLOBAL-DEFINE TelerikRadControls

&IF 1=0 &THEN
/* Include conditional compilation for Telerik Kendo UI */
&ENDIF
&GLOBAL-DEFINE TelerikKendoUI

&IF 1=0 &THEN
/* Ability to exclude procedural OERA from proSI... procedures.

   The support for the procedural OERA is now optional in the
   service interface. To disable the support, please set the
   ExcludeProceduralOERA in Consultingwerk/products.i. When set,
   Business Entity Names without a . (dot) will be considered
   object-oriented. It's no longer required to deploy beSupport.p,
   daSupport.p and service.p when using this option.

   Note, the use of the procedural business entities is still
   supported. However we've received requests from customers just
   using the OO versions of the business entities that this is
   considered unnecessary legacy code... As the OO OERA backend
   has more functionality (e.g. FindOnServer, backwards batching)
   we do not intend to implement an "ExcludeObjectOrientedOERA"
   switch for customers that are not (yet) using OO business
   entities.

   With SCL-1171 we are making this option the new default to support
   the name mapping service in the ServiceManager */
&ENDIF
&GLOBAL-DEFINE ExcludeProceduralOERA

&IF 1=0 &THEN
/* SCL-1171 - optionally enable the service name mapping service
   from the ServiceManager. Customers that are not using the
   ServiceNameMappingService can deactivate it here and avoid
   any performance impact by the service name lookup done for
   every call to the service interface */
&ENDIF
&GLOBAL-DEFINE UseServiceNameMappingService

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 03.01.2012
   Title of the Progress IDE (OpenEdge Architect
   or Progress Developer Studio for OpenEdge */
&ENDIF
&IF PROVERSION GE "11" &THEN
&GLOBAL-DEFINE ProgressIDE Progress Developer Studio for OpenEdge
&ELSE
&GLOBAL-DEFINE ProgressIDE OpenEdge Architect
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 12.06.2012
   Ability to customize the Consultingwerk.Forms.BaseForm and
   Consultingwerk.WindowIntegrationKit.Forms.EmbeddedWindowBaseForm
   classes without having to modify the actual classes itself */
&ENDIF
&GLOBAL-DEFINE CustomBaseFormImplements
&GLOBAL-DEFINE CustomBaseFormInherits
&GLOBAL-DEFINE CustomBaseFormIncludeFile
&GLOBAL-DEFINE CustomBaseFormConstructorInclude
&GLOBAL-DEFINE CustomBaseFormDestructorInclude
&GLOBAL-DEFINE CustomBaseFormUsingInclude

&GLOBAL-DEFINE CustomEmbeddedWindowBaseFormImplements
&GLOBAL-DEFINE CustomEmbeddedWindowBaseFormIncludeFile
&GLOBAL-DEFINE CustomEmbeddedWindowBaseFormConstructorInclude
&GLOBAL-DEFINE CustomEmbeddedWindowBaseFormDestructorInclude
&GLOBAL-DEFINE CustomEmbeddedWindowBaseFormUsingInclude

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 24.11.2012
   Optional Support for ZeroMQ for inter process communication */
&ENDIF
&GLOBAL-DEFINE UseZeroMQ

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 12.02.2013
   Debug option */
&ENDIF
{Consultingwerk/debug.i}

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 25.08.2013
   Optionally enforce the use of XML Serialization for the SmartFramework parameter types.
   This was introduced to allow the usage of the SmartFramework backend on an OpenEdge
   10.2B AppServer. Note that to support this the actual serializable class needs to
   test for the FrameworkSerializationType preprocessor. Values should be JSON or XML */
&ENDIF
&IF PROVERSION GE "11" &THEN
&GLOBAL-DEFINE FrameworkSerializationType JSON
&ELSE
&GLOBAL-DEFINE FrameworkSerializationType XML
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 03.09.2013
   Avoid the usage of statics in hybrids, to avoid the issues with
   the combination of static and hybrids on 11.2 and 11.3, OE defect OE00240707
   http://knowledgebase.progress.com/articles/Article/000042229?popup=true */
&ENDIF
&IF PROVERSION BEGINS "11.2":U OR PROVERSION BEGINS "11.3" &THEN
&GLOBAL-DEFINE NoStaticsInHybrids
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 16.01.2014
   Ability to activate a workaround for OpenEdge core issues, where (still at one
   customer) on OpenEdge 11.3.1 the usage of static methods/properties/events in
   hybrid classes and/or the overriding of .NET event methods (On... methods)
   using an ABL method may cause a Progress.Lang.SysError with no message when
   starting the Form the first time */
/*&GLOBAL-DEFINE RetryFormLaunchingOnProgressLangSysError*/
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 18.09.2013
   A preprocessor to conditionally enable :U or :T for SmartComponent Library
   error messages/debug information. This still allows customers to use
   Translation Manager for these strings when the &GLOBAL-DEFINE is not
   set - or set to :T */
/*&GLOBAL-DEFINE TRAN :U*/
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 09.11.2013
   Optional ability to define a default batch size for use by the
   SmartBusinessEntityAdapter queries*/
&ENDIF
&GLOBAL-DEFINE DefaultBatchSize 100

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 09.11.2013
   Optional ability to define a default value for the STOP-AFTER
   behavior of the Service Adapter */
&ENDIF
&GLOBAL-DEFINE DefaultStopAfter 15

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 26.02.2014
   The list and label major version to use. This controls the cmllxx.i
   Include file to be used to declare the list and label DLL functions. */
&ENDIF
&GLOBAL-DEFINE ListAndLabelVersion 21

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 13.03.2014
   SCL-204: Ability to delay the deletion of the BaseForm instance during
   OnFormClosed by using a Timer event. Resolved crashes while closing some
   SmartComponent Library Forms at Interbos/Dynamics4.NET on Windows 8/Windows
   Server 2012 only */
/*&GLOBAL-DEFINE DelayFormDeletionOnFormClosed*/
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 19.03.2014
   Clear the Tools Collection of a ToolbarsManager in the BaseForm OnFormClosed
   method , to workaround error: Attempt to use an object that has been
   explicitly deleted (15580) when closing a Form that is using a
   ControlContainerTool hosting an UltraNumericEditor, issue experienced by one
   customer on OpenEdge 11.3 */
/*&GLOBAL-DEFINE ClearToolsCollectionOnFormClosed*/
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 19.05.2014
   SCL-283: Optionally do not register the BusinessEntityDesignerForm in the
   ServiceContainer while starting the Business Entity Designer. This is to
   workaround crashes occurring under 10.2B at a single customer only. */
/*&GLOBAL-DEFINE DoNotRegisterBusinessEntityDesignerForm*/
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 25.09.2014
   SCL-475: Customers integrating legacy code in unit tests may require the
            definition of NEW SHARED Variables or Buffers in the Unit Test
            runner Consultingwerk\SmartUnit\runtest.p */
&GLOBAL-DEFINE TestRunnerDefinition Name/And/Path/To/Your/include.i
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 25.09.2014
   SCL-490: Support for serializable classes (e.g. errors) on OpenEdge 11.4 */
&ENDIF
&IF PROVERSION BEGINS "10" OR PROVERSION BEGINS "11.0" OR PROVERSION BEGINS "11.1" OR PROVERSION BEGINS "11.2" OR PROVERSION BEGINS "11.3" &THEN
&GLOBAL-DEFINE SERIALIZABLE
&ELSE
&GLOBAL-DEFINE SERIALIZABLE SERIALIZABLE
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 10.12.2014
   SCL-103: Trial version mode */
/*&GLOBAL-DEFINE TrialVersionMode*/
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 19.02.2015
   SCL-665: Ability to turn the first version of the ICustomTypeDescriptor
            implementation back on. By default this implementation is disabled now,
            but can be turned on by customers that still require if for custom
            controls. The new ICustomTypeDescriptor implementation is based on the
            Consultingwerk.SmartComponents.TypeDescriptor package. */
/*&GLOBAL-DEFINE LegacyCustomTypeDescriptorImplementation */
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 25.09.2014
   SCL-489: Support for PASOE from OpenEdge 11.5 on */
&ENDIF
&IF PROVERSION BEGINS "10" OR PROVERSION BEGINS "11.0" OR PROVERSION BEGINS "11.1" OR PROVERSION BEGINS "11.2" OR PROVERSION BEGINS "11.3" OR PROVERSION BEGINS "11.4" &THEN
&GLOBAL-DEFINE NoPacificAppServer
&ELSE
&GLOBAL-DEFINE PacificAppServer
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 03.06.2016
   SCL-1217: Support for PASOE Web handlers from OpenEdge 11.6 on */
&ENDIF
&IF PROVERSION BEGINS "10" OR PROVERSION BEGINS "11.0" OR PROVERSION BEGINS "11.1" OR PROVERSION BEGINS "11.2" OR PROVERSION BEGINS "11.3" OR PROVERSION BEGINS "11.4" OR PROVERSION BEGINS "11.5" &THEN
&GLOBAL-DEFINE NoPacificWebSpeed
&ELSE
&GLOBAL-DEFINE PacificWebSpeed
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 25.09.2014
   SCL-751: Support for native Enums from OpenEdge 11.6 on */
&ENDIF
&IF PROVERSION BEGINS "10" OR PROVERSION BEGINS "11.0" OR PROVERSION BEGINS "11.1" OR PROVERSION BEGINS "11.2" OR PROVERSION BEGINS "11.3" OR PROVERSION BEGINS "11.4" OR PROVERSION BEGINS "11.5" &THEN
&GLOBAL-DEFINE NoNativeEnums NoNativeEnums
&ELSE
&GLOBAL-DEFINE NativeEnums NativeEnums
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 25.09.2014
   SCL-1128: Support for ABL Reflection from OpenEdge 11.6 on */
&ENDIF
&IF PROVERSION BEGINS "10" OR PROVERSION BEGINS "11.0" OR PROVERSION BEGINS "11.1" OR PROVERSION BEGINS "11.2" OR PROVERSION BEGINS "11.3" OR PROVERSION BEGINS "11.4" OR PROVERSION BEGINS "11.5" &THEN
&GLOBAL-DEFINE NoAblReflection NoAblReflection
&ELSE
&GLOBAL-DEFINE AblReflection AblReflection
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 22.12.2015
   SCL-1055: Workaround malicious code / .resx file generation for grid column header
   (labels). When the Grid (SmartBrowserControl) columns header caption is not changed and thus is the same
   as the BindingSource's ColumnLabel for the given column, the source code and the .resx
   file would not spell out the label for the grid column. Consequence is, that unmodified
   grid column labels would not be translatable using the resource file based
   localization. To work around this we add a space to unmodified column header captions
   when in the visual designer and thus causing the property label to be written to the
   .resx file and be available for translation. */
&ENDIF
&GLOBAL-DEFINE AddSpaceToDefaultGridColumnHeaders

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 05.08.2016
   SCL-1396: Compile switch for CCS Interface Types */
&ENDIF
&IF PROVERSION BEGINS "10" &THEN
&GLOBAL-DEFINE NoCommonComponentSpecification NoCommonComponentSpecification
&ELSE
&GLOBAL-DEFINE CommonComponentSpecification CommonComponentSpecification
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 05.08.2016
   SCL-1572: Ability to use an alternative alias for the SmartDB */
&ENDIF
&GLOBAL-DEFINE SmartDB SmartDB

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 05.08.2016
   SCL-3069: Allow a user group to inherit from multiple user groups
             To enable support for multiple group inheritance, set the following preprocessor
             to multiple. Reminder: When enabling this, don't forget to migrate existing
             Group inheritance from SmartGroup.ParentGroupGuid to records in the SmartParentGroup
             table. Supported values: single (default) and multiple */
&ENDIF
&GLOBAL-DEFINE SmartGroupInheritance single

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 15.09.2020
   SCL-3144: Suspends STAThread warnings for an UltraDockManager instance
             Workaround for an Issue with the Infragistics UltraDockManager of OpenEdge 12.3 CQC
             19.2.20192.381 */
&ENDIF
&IF PROVERSION BEGINS "12.2" OR PROVERSION BEGINS "12.3" &THEN
&GLOBAL-DEFINE UltraDockManagerSTAThreadWarningWorkaround UltraDockManagerSTAThreadWarningWorkaround
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 15.11.2020
   SCL-3241: Conditional PACKAGE-PROTECTED, resolves into PUBLIC on OpenEdge 11.6, 11.7, 12.0 and 12.1 */
&ENDIF
&IF PROVERSION BEGINS "11" OR PROVERSION BEGINS "12.0" OR PROVERSION BEGINS "12.1" &THEN
&GLOBAL-DEFINE PACKAGE-PROTECTED PUBLIC
&ELSE
&GLOBAL-DEFINE PACKAGE-PROTECTED PACKAGE-PROTECTED
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 02.03.2021
   SCL-2461: Support for -catchStop - on OpenEdge 11 */
&ENDIF
&IF NOT PROVERSION BEGINS "11" &THEN
&GLOBAL-DEFINE CATCH-STOP CATCH-STOP
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 19.04.2021
   SCL-3218: Workaround for SyncToSelectedRow property on Progress.Data.BindingSource
             Introduced in Service packs for OpenEdge 11.7 and 12.2 - missing in OpenEdge 12.1 */
&ENDIF
&IF PROVERSION BEGINS "12.1" &THEN
&GLOBAL-DEFINE SyncToSelectedRowWorkaround SyncToSelectedRowWorkaround
&ENDIF

&IF 1=0 &THEN
/* Mike Fechner, Consultingwerk Ltd. 27.12.2021
   SCL-3582: Ability to customize base class of SmartRadDataBrowser */
&GLOBAL-DEFINE SmartRadDataBrowserBaseClass Telerik.WinControls.UI.RadGridView
&ENDIF

&IF 1=0 &THEN
/* Peter Judge, Consultingwerk Ltd. 28.08.2022
   SCL-3604: Support for native Lists from OpenEdge 12.5+ */
&ENDIF
&IF PROVERSION BEGINS "11" OR PROVERSION BEGINS "12.0" OR PROVERSION BEGINS "12.1" OR PROVERSION BEGINS "12.2" OR PROVERSION BEGINS "12.3" OR PROVERSION BEGINS "12.4" &THEN
&GLOBAL-DEFINE NoNativeLists NoNativeLists
&ELSE
&GLOBAL-DEFINE NativeLists NativeLists
&ENDIF

&IF 1=0 &THEN
/* Peter Judge / Consultingwerk Ltd.
   SCL-3845 : ServiceAdapter:SubmitChanges should support native Serialization of the SaveChanges parameter object */
&ENDIF
&GLOBAL-DEFINE UsePLOforSmartBusinessEntityAdapterSaveChangesParameter UsePLOforSmartBusinessEntityAdapterSaveChangesParameter

&IF 1=0 &THEN
/* Mike Fechner / Consultingwerk Ltd.
   SCL-4037 : ListTableModel to support ITableModel as List type
              The value can be Interface or Class (default when setting is not present)
              This determines if the ListTableModel class is defined against the ITableModel
              Interface or the TableModel class */
&ENDIF
&GLOBAL-DEFINE ListTableModel Interface

&IF 1=0 &THEN
/* Peter Judge / Consultingwerk Ltd.
   SCL-4065 : Support dumping LOB values to files using primary unique keys
*/
&ENDIF
&GLOBAL-DEFINE LOBExportFileNameUsingUniqueKey LOBExportFileNameUsingUniqueKey

&IF 1=0 &THEN
/* Mike Fechner / Consultingwerk Ltd.
   SCL-4080 : Option to define default value for ServiceManager:StopBusinessService (..., NotRunningEnum/Throw/Ignore)
   When the ServiceManagerStopBusinessServiceNotRunning preprocessor variable is not set we default to IGNORE */
&ENDIF
&GLOBAL-DEFINE ServiceManagerStopBusinessServiceNotRunning IGNORE

&IF 1=0 &THEN
/* Mike Fechner / Consultingwerk Ltd.
   SCL-4454 : Returns the base href for the JSON schema of the SCLNG components
              This URL should reflect the current version of the SCLNG components
*/
&ENDIF
&GLOBAL-DEFINE SclngJsonSchemaBaseHref https://www.consultingwerk.com/schema/json/v17.0/
