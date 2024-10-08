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
    File        : QueryValidationException
    Purpose     : Exception raised by the QueryHelper:ValidateQuery method
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 28.11.2018 06:21:32
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*                          from propath .
using Consultingwerk.Exceptions.*               from propath .
using Consultingwerk.Util.Exceptions.*          from propath .
using Progress.Lang.*                           from propath .

class Consultingwerk.Util.Exceptions.QueryValidationException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Constructor of the QueryValidationException class
     * Notes:
     */
    constructor public QueryValidationException ():

        super ().

    end constructor.

    /**
     * Purpose: Constructor of the QueryValidationException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public QueryValidationException (pcErrorString as character,
                                                 piMessageNumber as integer):

        super (pcErrorString, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the QueryValidationException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public QueryValidationException (pcErrorString as character):

        super (pcErrorString).

    end constructor.

    /**
     * Purpose: Constructor of the QueryValidationException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public QueryValidationException (poInnerException as Error):

        super (poInnerException, "Query validation failed"{&TRAN}, 0).

        this-object:AssignFromError (poInnerException) .

    end constructor.

    /**
     * Purpose: Constructor of the QueryValidationException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public QueryValidationException (poInnerException as Error,
                                                 pcErrorString as character,
                                                 piMessageNumber as integer):

        super (poInnerException, pcErrorString, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the QueryValidationException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public QueryValidationException (poInnerException as Error,
                                                 pcErrorString as character):

        super (poInnerException, pcErrorString).

    end constructor.

end class.
