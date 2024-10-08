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
    File        : Codepages
    Purpose     : Code page names constants
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Mar 13 05:53:58 CET 2015
    Notes       : This list may not be complete. Customers should report
                  missing code page names so that we can add them to the
                  constants
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Progress.Lang.*.

class Consultingwerk.Codepages:

    define public static property ISO8859-1  as character no-undo initial "ISO8859-1":U  get .
    define public static property ISO8859-2  as character no-undo initial "ISO8859-2":U  get .
    define public static property ISO8859-15 as character no-undo initial "ISO8859-15":U get .

    define public static property IBM850     as character no-undo initial "IBM850":U     get .
    define public static property IBM851     as character no-undo initial "IBM851":U     get .
    define public static property IBM852     as character no-undo initial "IBM852":U     get .

    define public static property UTF-8      as character no-undo initial "UTF-8":U      get .

    define public static property UTF-16     as character no-undo initial "UTF-16":U     get .
    define public static property UTF-16BE   as character no-undo initial "UTF-16BE":U   get .
    define public static property UTF-16LE   as character no-undo initial "UTF-16LE":U   get .

    /**
     * Purpose: Constructor for the Codepages class
     * Notes:   Disallow instance creation
     */
    constructor private Codepages ():
        super ().

    end constructor.

    /**
     * Purpose: Tests if the given code page name is valid
     * Notes:
     * @param pcCodepage :  character
     * @return Logical value indicating if the passed in code page is valid
     */
    method public static logical IsKnownCodepage (pcCodepage as character):

        return lookup (pcCodepage,
                       "ISO8859-1,ISO8859-2,ISO8859-15,IBM850,IBM851,IBM852,UTF-8,UTF-16,UTF-16BE,UTF-16LE":U) > 0 .

    end method.

end class.
