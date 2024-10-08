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
    File        : ttClassPath.i
    Purpose     : Temp-Table Definition to specify alternative folders
                  in which the class browser/class picker of the
                  SmartComponent Library should search for classes R-Code

    Syntax      :

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Oct 25 22:20:26 CEST 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

define {&ACCESS} temp-table {&PREFIX}ttClassPath no-undo {&REFERENCE-ONLY} xml-node-name "ClassPath":U
    field Directory as character xml-node-name "DirectoryEntry":U xml-node-type "ATTRIBUTE":U
    field ProcedureLibrary as character xml-node-name "ProcedureLibraryEntry":U xml-node-type "ATTRIBUTE":U initial ?
    field Prefix as character xml-node-name "PrefixWith":U xml-node-type "ATTRIBUTE":U
     .