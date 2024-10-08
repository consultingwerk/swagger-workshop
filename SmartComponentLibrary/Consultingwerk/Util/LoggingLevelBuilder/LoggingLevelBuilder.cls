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
    File        : LogginLevelBuilder
    Purpose     : Static builder - like - class that allows to manipulate the
                  LOG-MANAGER:LOG-ENTRY-TYPES
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Nov 26 12:28:41 CET 2019
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Framework.Enum.*           from propath .
using Consultingwerk.Util.*                     from propath .
using Consultingwerk.Util.LoggingLevelBuilder.* from propath .
using Progress.Lang.*                           from propath .

class Consultingwerk.Util.LoggingLevelBuilder.LoggingLevelBuilder:

    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i 4GLMessages          FourGLMessages}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i 4GLTrace             FourGLTrace}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i 4GLTrans             FourGLTrans}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i ASDefault            ASDefault}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i ASPlumbing           ASPlumbing}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i DB.Connects          DB_Connects}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i DS.Cursor            DS_Cursor}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i DS.QryInfo           DS_QryInfo}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i DynObjects.Class     DynObjects_Class}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i DynObjects.DB        DynObjects_DB}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i DynObjects.XML       DynObjects_XML}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i DynObjects.Other     DynObjects_Other}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i DynObjects.UI        DynObjects_UI}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i FileID               FileID}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i IgnoredOps           IgnoredOps}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i ProEvents.UI.Char    ProEvents_UI_Char}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i ProEvents.UI.Command ProEvents_UI_Command}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i ProEvents.Other      ProEvents_Other}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i QryInfo              QryInfo}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i SAX                  SAX}
    {Consultingwerk/Util/LoggingLevelBuilder/set-logging-level.i DS.Performance       DS_Performance}

end class.
