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
    File        : ExceptionWithTitle
    Purpose     : Common base error class, implementing inner exception
                  handling / access, returning the Error instance
                  that caused the current exception.
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Feb 20 20:19:00 CET 2008
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.ExceptionWithTitle
    inherits Exception
    implements ISupportsInnerException, IErrorTitle
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the Title associated with the Exception
     * Notes:
     */
    define public property Title as character no-undo
    get.
    set.

    /**
     * Purpose: Constructor of the ExceptionWithTitle class
     * Notes:
     * @param pcTitle The title for the Exception
     */
    constructor public ExceptionWithTitle (pcTitle as character):

        super ().

        assign this-object:Title = pcTitle .

    end constructor.

    /**
     * Purpose: Constructor of the ExceptionWithTitle class
     * Notes:
     * @param pcErrorString The error message associated with this ExceptionWithTitle object
     * @param piMessageNumber The error message number associated with this ExceptionWithTitle object
     * @param pcTitle The title for the Exception
     */
    constructor public ExceptionWithTitle (pcErrorString as character,
                                           piMessageNumber as integer,
                                           pcTitle as character):

        super (pcErrorString, piMessageNumber).

        assign this-object:Title = pcTitle .

    end constructor.

    /**
     * Purpose: Constructor of the ExceptionWithTitle class
     * Notes:
     * @param pcErrorString The error message associated with this ExceptionWithTitle object
     * @param pcTitle The title for the Exception
     */
    constructor public ExceptionWithTitle (pcErrorString as character,
                                           pcTitle as character):

        super (pcErrorString).

        assign this-object:Title = pcTitle .

    end constructor.

    /**
     * Purpose: Constructor of the ExceptionWithTitle class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcTitle The title for the Exception
     */
    constructor public ExceptionWithTitle (poInnerException as Error,
                                           pcTitle as character):

        super (poInnerException).

        assign this-object:Title          = pcTitle .

    end constructor.

    /**
     * Purpose: Constructor of the ExceptionWithTitle class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this ExceptionWithTitle object
     * @param piMessageNumber The error message number associated with this Exception object
     * @param pcTitle The title for the Exception
     */
    constructor public ExceptionWithTitle (poInnerException as Error,
                                           pcErrorString as character,
                                           piMessageNumber as integer,
                                           pcTitle as character):

        super (poInnerException, pcErrorString, piMessageNumber).

        this-object:Title = pcTitle .

    end constructor.

    /**
     * Purpose: Constructor of the ExceptionWithTitle class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param pcTitle The title for the Exception
     */
    constructor public ExceptionWithTitle (poInnerException as Error,
                                           pcErrorString as character,
                                           pcTitle as character):

        super (poInnerException, pcErrorString).

        assign this-object:Title          = pcTitle .

    end constructor.

end class.
