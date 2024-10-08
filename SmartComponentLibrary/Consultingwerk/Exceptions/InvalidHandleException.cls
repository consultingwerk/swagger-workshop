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
    File        : InvalidHandleException
    Purpose     : An error object thrown to signal an invalid widget handle
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Apr 28 13:09:05 CEST 2011
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.InvalidHandleException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the optional description of the invalid handle
     * Notes:
     */
    define public property HandleDescription as character no-undo initial ?
    get.
    protected set.

    /**
     * Purpose: Default constructor of the InvalidHandleException class
     * Notes:
     */
    constructor public InvalidHandleException ():

        super ("Invalid handle."{&TRAN}, 0) .

    end constructor.

    /**
     * Purpose: Constructor of the InvalidHandleException class
     * Notes:
     * @param pcDescription The Description of the invalid handle to be used in the error message
     */
    constructor public InvalidHandleException (pcDescription as character):

        super (substitute ("Invalid &1 handle."{&TRAN}, pcDescription), 0) .

        this-object:HandleDescription = pcDescription .

    end constructor.

    /**
     * Purpose: Default constructor of the InvalidHandleException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public InvalidHandleException (poInnerException as Error):

        super (poInnerException,
               "Invalid handle."{&TRAN}, 0) .

    end constructor.

    /**
     * Purpose: Constructor of the InvalidHandleException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcDescription The Description of the invalid handle to be used in the error message
     */
    constructor public InvalidHandleException (poInnerException as Error,
                                               pcDescription as character):

        super (poInnerException,
               substitute ("Invalid &1 handle."{&TRAN}, pcDescription),
               0) .

        this-object:HandleDescription = pcDescription .

    end constructor.

end class.
