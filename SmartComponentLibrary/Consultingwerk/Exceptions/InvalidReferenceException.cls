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
    File        : InvalidReferenceException
    Purpose     : An error object thrown to signal an invalid widget handle
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Jan 20 07:17:13 CEST 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.InvalidReferenceException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the optional description of the invalid handle
     * Notes:
     */
    define public property ReferenceDescription as character no-undo initial ?
    get.
    protected set.

    /**
     * Purpose: Default constructor of the InvalidReferenceException class
     * Notes:
     */
    constructor public InvalidReferenceException ():

        super ("Invalid object reference."{&TRAN}, 0) .

    end constructor.

    /**
     * Purpose: Constructor of the InvalidReferenceException class
     * Notes:
     * @param pcDescription The Description of the invalid handle to be used in the error message
     */
    constructor public InvalidReferenceException (pcDescription as character):

        super (substitute ("Invalid &1 object reference."{&TRAN}, pcDescription), 0) .

        this-object:ReferenceDescription = pcDescription .

    end constructor.

    /**
     * Purpose: Default constructor of the InvalidReferenceException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public InvalidReferenceException (poInnerException as Error):

        super (poInnerException,
               "Invalid object reference."{&TRAN},
               0) .

    end constructor.

    /**
     * Purpose: Constructor of the InvalidReferenceException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcDescription The Description of the invalid handle to be used in the error message
     */
    constructor public InvalidReferenceException (poInnerException as Error,
                                                  pcDescription as character):

        super (poInnerException, substitute ("Invalid &1 object reference."{&TRAN}, pcDescription), 0) .

        this-object:ReferenceDescription = pcDescription .

    end constructor.

end class.
