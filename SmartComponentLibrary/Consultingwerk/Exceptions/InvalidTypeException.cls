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
    File        : InvalidTypeException
    Purpose     : An error object thrown to signal invalid types
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Apr 28 14:04:34 CEST 2011
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.InvalidTypeException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the (WIDGET-)TYPE that was expected by the code raising this
     *          error
     * Notes:
     */
    define public property ExpectedType as character no-undo
    get.
    protected set.

    /**
     * Purpose: Returns the (WIDGET-)TYPE that was received by the code raising this
     *          error
     * Notes:
     */
    define public property Type as character no-undo
    get.
    protected set.

    /**
     * Purpose: Constructor of the InvalidTypeException class
     * Notes:
     * @param pcExpectedType The expected type
     * @param pcType The current type
     */
    constructor public InvalidTypeException (pcExpectedType as character,
                                             pcType as character):

        super (substitute ("Type &1 should be &2."{&TRAN}, pcType, pcExpectedType), 0).

        assign this-object:ExpectedType = pcExpectedType
               this-object:Type         = pcType
               .

    end constructor.

    /**
     * Purpose: Constructor of the InvalidTypeException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcExpectedType The expected type
     * @param pcType The current type
     */
    constructor public InvalidTypeException (poInnerException as Error,
                                             pcExpectedType as character,
                                             pcType as character):

        super (poInnerException,
               substitute ("Type &1 should be &2."{&TRAN},
                           pcType,
                           pcExpectedType),
               0).

        assign this-object:ExpectedType = pcExpectedType
               this-object:Type         = pcType
               .

    end constructor.

end class.
