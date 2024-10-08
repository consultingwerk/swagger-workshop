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
    File        : Const
    Purpose     : Generic framework constants
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Sep 13 10:42:23 CEST 2011
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Progress.Lang.*.

class Consultingwerk.Const:

    /**
     * Purpose: The list of built in ABL data types
     * Notes:   BLOB,CHARACTER,CLOB,COM-HANDLE,DATE,DATETIME,DATETIME-TZ,DECIMAL
     *          HANDLE,INT64,INTEGER,LOGICAL,Progress.Lang.Object,RAW,RECID,ROWID
     */
    define public static property ABL_DATA_TYPES as character initial 'BLOB,CHARACTER,CLOB,COM-HANDLE,DATE,DATETIME,DATETIME-TZ,DECIMAL,HANDLE,INT64,INTEGER,LONGCHAR,LOGICAL,Progress.Lang.Object,RAW,RECID,ROWID':U no-undo
    get.

    /**
     * Purpose: Windows style CR/LF
     * Notes:
     */
    define public static property CRLF as character no-undo initial "~r~n":U
    get.

    /**
     * Purpose: The longest possible delimited list pattern for a SUBSTITUTE operation
     * Notes:   &9 (ampersand 9) represents the list delimiter
     *          &1&9&2&9&3&9&4&9&5&9&6&9&7&9&8
     */
    define public static property DELIMITED_LIST_FOR_SUBSTITUTE as character initial '&1&9&2&9&3&9&4&9&5&9&6&9&7&9&8':U no-undo
    get.

    /**
     * Purpose: Returns the UNIX Epoch value
     * Notes:
     */
    define public static property EPOCH as datetime-tz no-undo
    get.
    private set.

    /**
     * Purpose: Returns a comma delimited list of characters that are not allowed
     *          in file names on Windows
     * Notes:   https://msdn.microsoft.com/en-us/library/windows/desktop/aa365247(v=vs.85).aspx#naming_conventions
     */
    define public static property ILLEGAL_CHARACTERS_IN_FILENAMES as character initial '<,>,:,",/,~\,|,?,*':U no-undo
    get.

    /**
     * Purpose: Unix style LF
     * Notes:
     */
    define public static property LF as character no-undo initial "~n":U
    get.

    /**
     * Purpose: The maximum length of an ABL character value
     * Notes:   31991
     */
    define public static property MAX_CHARACTER as integer no-undo initial 31991
    get.

    /**
     * Purpose: The maximum value a 32 bit integer variable can hold
     * Notes:   2147483647
     */
    define public static property MAX_INTEGER as integer no-undo initial 2147483647
    get.

    /**
     * Purpose: The maximum value a 64 bit integer variable can hold
     * Notes:   9223372036854775807
     */
    define public static property MAX_INT64 as int64 no-undo initial 9223372036854775807
    get.

    /**
     * Purpose: The minimum value a 32 bit integer variable can hold
     * Notes:   -2147483648
     */
    define public static property MIN_INTEGER as integer no-undo initial -2147483648
    get.

    /**
     * Purpose: The minimum value a 64 bit integer variable can hold
     * Notes:   -9223372036854775808
     */
    define public static property MIN_INT64 as int64 no-undo initial -9223372036854775808
    get.

    /**
     * Purpose: The number of milliseconds per day
     * Notes:   86.400.000
     */
    define public static property MSECS_PER_DAY as integer no-undo initial 86400000
    get.

    /**
     * Purpose: The number of milliseconds per hour
     * Notes:   3.600.000
     */
    define public static property MSECS_PER_HOUR as integer no-undo initial 3600000
    get.

    /**
     * Purpose: The number of milliseconds per minute
     * Notes:   60.000
     */
    define public static property MSECS_PER_MINUTE as integer no-undo initial 60000
    get.

    /**
     * Purpose: The number of milliseconds per second
     * Notes:   1.000
     */
    define public static property MSECS_PER_SECOND as integer no-undo initial 1000
    get.


    /**
     * Purpose: Static constructor for the Const CLASS
     * Notes:
     */
    constructor static Const ():

        assign Consultingwerk.Const:EPOCH = datetime-tz (1, 1, 1970, 0, 0, 0, 0, 0) .

    end constructor.

    /**
     * Purpose: Constructor for the Const class
     * Notes:   Disallow instance creation
     */
    constructor private Const ():
        super ().

    end constructor.

end class.
