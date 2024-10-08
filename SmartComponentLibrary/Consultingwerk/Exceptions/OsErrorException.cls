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
    File        : OsErrorException
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Jan 30 14:53:35 CET 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

using Progress.Lang.*.
using Consultingwerk.Exceptions.Exception.

{Consultingwerk/products.i}

class Consultingwerk.Exceptions.OsErrorException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the OE-ERROR Value associated with this error
     * Notes:
     */
    define public property OS-ERROR as integer no-undo
    get.
    protected set.

    /**
     * Purpose: Returns the error message matching the OS-ERROR value
     * Notes:
     */
    define public property OS-ERROR-TEXT as character no-undo
    get.
    protected set.

    /**
     * Purpose: Constructor for the OsErrorException class
     * Notes:
     * @param piOsError The value of the OS-ERROR property
     */
    constructor public OsErrorException (piOsError as integer):
        super (substitute ("&1 (&2)":U,
                           Consultingwerk.Util.FileHelper:OS-ERROR-TEXT (piOsError),
                           piOSError), 0).

        assign this-object:OS-ERROR = piOsError
               this-object:OS-ERROR-TEXT = Consultingwerk.Util.FileHelper:OS-ERROR-TEXT(piOsError) .

    end constructor.

end class.
