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
    File        : AmbiguousFieldNameException
    Purpose     : Exception thrown by DatabaseHelper:UnabbreviatedFieldName
                  when an invalid field name has been passed
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Jan 08 10:09:12 CET 2014
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

{Consultingwerk/products.i}

class Consultingwerk.Util.Exceptions.AmbiguousFieldNameException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the name of the FieldName that caused the issue
     * Notes:
     */
    define public property FieldName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor for the InvalidFieldNameException class
     * Notes:
     * @param pcErrorMessage The error message for the exception
     * @param pcFieldName The name of the field that caused the exception
     */
    constructor public AmbiguousFieldNameException (pcErrorMessage as character,
                                                    pcFieldName as character):

        super (substitute (pcErrorMessage, pcFieldName), 0).

        assign this-object:FieldName = pcFieldName .

    end constructor.

end class.
