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
    File        : CompileException
    Purpose     : Exception thrown from the CompileHelper:CompileFile method
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Apr 23 22:41:20 CEST 2013
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.CompileException
    inherits Exception
    implements IErrorTitle
    {&SERIALIZABLE}:

    /**
     * Purpose: Gets and sets the FileName that was compiled
     * Notes:
     */
    define public property FileName as character no-undo
    get.
    set.

    /**
     * Purpose: Returns the Title to be used in the Error Dialog or Message Box
     * Notes:
     */
    define public property Title as character no-undo initial "Error during compilation"{&TRAN}
    get.
    set.

    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public CompileException (poInnerException as Progress.Lang.Error,
                                         pcErrorString as character):
        super (poInnerException,
               pcErrorString).

    end constructor.


    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public CompileException (poInnerException as Progress.Lang.Error,
                                         pcErrorString as character,
                                         piMessageNumber as integer):
        super (poInnerException,
               pcErrorString,
               piMessageNumber).

    end constructor.


    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public CompileException (poInnerException as Progress.Lang.Error):
        super (poInnerException).

    end constructor.


    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public CompileException (pcErrorString as character):
        super (pcErrorString).

    end constructor.


    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public CompileException (pcErrorString as character,
                                         piMessageNumber as integer):
        super (pcErrorString,
               piMessageNumber).

    end constructor.


    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     */
    constructor public CompileException ():
        super ().

    end constructor.

end class.
