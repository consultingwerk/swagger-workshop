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
    File        : DataTypeEnum
    Purpose     : DATA-TYPE Constants (CHARACTER)
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Jan 07 23:43:36 CET 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Progress.Lang.*.

class Consultingwerk.DataTypeEnum:

    define public static property blob               as character no-undo initial "BLOB":U                 get .
    define public static property character          as character no-undo initial "CHARACTER":U            get .
    define public static property clob               as character no-undo initial "CLOB":U                 get .
    define public static property component-handle   as character no-undo initial "COM-HANDLE":U           get .
    define public static property date               as character no-undo initial "DATE":U                 get .
    define public static property datetime           as character no-undo initial "DATETIME":U             get .
    define public static property datetime-tz        as character no-undo initial "DATETIME-TZ":U          get .
    define public static property decimal            as character no-undo initial "DECIMAL":U              get .
    define public static property handle             as character no-undo initial "HANDLE":U               get .
    define public static property int64              as character no-undo initial "INT64":U                get .
    define public static property integer            as character no-undo initial "INTEGER":U              get .
    define public static property logical            as character no-undo initial "LOGICAL":U              get .
    define public static property ProgressLangObject as character no-undo initial "Progress.Lang.Object":U get .
    define public static property raw                as character no-undo initial "RAW":U                  get .
    define public static property recid              as character no-undo initial "RECID":U                get .
    define public static property rowid              as character no-undo initial "ROWID":U                get .

end class.
