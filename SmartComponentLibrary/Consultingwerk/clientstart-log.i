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
    File        : clientstart-log.i
    Purpose     : Writes a startup header to the Client logfile

    Syntax      :

    Description :

    Author(s)   :
    Created     : Tue Jan 12 22:30:43 CET 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Main Block  *************************** */

log-manager:write-message (substitute ("########################################################################~n":U +
                                       "### SmartComponent Library Client Startup ~n":U +
                                       "### Framework Version: &1~n":U +
                                       "### OpenEdge Version:  &2&3~n":U +
                                       "### Client Type: &4~n":U +
                                       "### Working Directory: &6~n":U +
                                       "### &5~n":U +
                                       "########################################################################":U,
                                       (new Consultingwerk.FrameworkVersion()):GetVersionString(),
                                       proversion,
                                       Consultingwerk.Util.SessionHelper:GetPatchLevel(),
                                       session:client-type,
                                       (new Consultingwerk.FrameworkVersion()):GetCopyRights(),
                                       Consultingwerk.Util.FileHelper:FindFile (".":U)),
                                       "SCL":U) .
