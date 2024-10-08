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
    File        : SystemTypeNotMappableToAblTypeException
    Purpose     : Exception thrown by DataTypeHelper:ToABLDataType (System.Type)
                  when the System.Type does not match an ABL primitive type
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Dec 18 10:09:12 CET 2014
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

{Consultingwerk/products.i}

class Consultingwerk.Util.Exceptions.SystemTypeNotMappableToAblTypeException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the name of the System.Type that caused the issue
     * Notes:
     */
    define public property TypeName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor for the SystemTypeNotMappableToAblTypeException class
     * Notes:
     * @param pcErrorMessage The error message for the exception
     * @param pcTypeName The type name for the exception
     */
    constructor public SystemTypeNotMappableToAblTypeException (pcErrorMessage as character,
                                                                pcTypeName as character):
        super (pcErrorMessage, 0).

        assign this-object:TypeName = pcTypeName .

    end constructor.

end class.
