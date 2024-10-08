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
    File        : AssertException
    Purpose     : Error class for assertions
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Mar 25 14:48:55 CET 2013
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Assertion.*  from propath .
using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

{Consultingwerk/products.i}

class Consultingwerk.Assertion.AssertException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Constructor of the AssertException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public AssertException (poInnerException as Progress.Lang.Error,
                                        pcErrorString as character):
        super (poInnerException, pcErrorString).

    end constructor.

    /**
     * Purpose: Constructor of the AssertException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorMessage The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public AssertException (poInnerException as Progress.Lang.Error,
                                        pcErrorMessage as character,
                                        piMessageNumber as integer):
        super (poInnerException, pcErrorMessage, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the AssertException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public AssertException (poInnerException as Progress.Lang.Error):
        super (poInnerException).

    end constructor.

    /**
     * Purpose: Constructor of the AssertException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public AssertException (pcErrorString as character):
        super (pcErrorString).

    end constructor.

    /**
     * Purpose: Constructor of the AssertException class
     * Notes:
     * @param pcErrorMessage The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public AssertException (pcErrorMessage as character,
                                        piMessageNumber as integer):

        super (pcErrorMessage, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the AssertException class
     * Notes:
     */
    constructor public AssertException ():
        super ().

    end constructor.

end class.
