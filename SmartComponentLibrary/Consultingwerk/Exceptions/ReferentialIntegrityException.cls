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
    File        : ReferentialIntegrityException
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Oct 27 20:09:07 CET 2013
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

using Consultingwerk.Exceptions.Exception.


using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.* from propath .

{Consultingwerk/products.i}

class Consultingwerk.Exceptions.ReferentialIntegrityException
     inherits Exception
     {&SERIALIZABLE}:

    /**
     * Purpose: Constructor of the ReferentialIntegrityException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public ReferentialIntegrityException (poInnerException as Progress.Lang.Error, pcErrorString as character):
        super (poInnerException, pcErrorString).

    end constructor.

    /**
     * Purpose: Constructor of the ReferentialIntegrityException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public ReferentialIntegrityException (poInnerException as Progress.Lang.Error, pcErrorString as character, piMessageNumber as integer):
        super (poInnerException, pcErrorString, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the ReferentialIntegrityException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public ReferentialIntegrityException (poInnerException as Progress.Lang.Error):
        super (poInnerException).

    end constructor.

    /**
     * Purpose: Constructor of the ReferentialIntegrityException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public ReferentialIntegrityException (pcErrorString as character):
        super (pcErrorString).

    end constructor.

    /**
     * Purpose: Constructor of the ReferentialIntegrityException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public ReferentialIntegrityException (pcErrorString as character, piMessageNumber as integer):
        super (pcErrorString, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the ReferentialIntegrityException class
     * Notes:
     */
    constructor public ReferentialIntegrityException ():
        super ().

    end constructor.

end class.
