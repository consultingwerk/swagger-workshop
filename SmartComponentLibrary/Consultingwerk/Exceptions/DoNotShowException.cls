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
    File        : DoNotShowException
    Purpose     : Common base error class for errors that do not need
                  to be shown using the ErrorHelper class
    Syntax      :
    Description : Useful for errors where the actual error message might
                  already have been shown to the user and the error is just
                  thrown to cancel further processing
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Feb 20 20:19:00 CET 2008
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.DoNotShowException
    inherits Exception
    implements ISupportsInnerException, IDoNotShowException
    {&SERIALIZABLE}:

    /**
     * Purpose: Constructor of the DoNotShowException class
     * Notes:
     */
    constructor public DoNotShowException ():

        super ().

    end constructor.

    /**
     * Purpose: Constructor of the DoNotShowException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public DoNotShowException (pcErrorString as character,
                                           piMessageNumber as integer):

        super (pcErrorString, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the DoNotShowException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public DoNotShowException (pcErrorString as character):

        super (pcErrorString).

    end constructor.

    /**
     * Purpose: Constructor of the DoNotShowException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public DoNotShowException (poInnerException as Error):

        super (poInnerException).

    end constructor.

    /**
     * Purpose: Constructor of the DoNotShowException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public DoNotShowException (poInnerException as Error,
                                           pcErrorString as character,
                                           piMessageNumber as integer):

        this-object (poInnerException, pcErrorString, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the DoNotShowException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public DoNotShowException (poInnerException as Error,
                                           pcErrorString as character):

        super (poInnerException, pcErrorString).

    end constructor.

end class.
