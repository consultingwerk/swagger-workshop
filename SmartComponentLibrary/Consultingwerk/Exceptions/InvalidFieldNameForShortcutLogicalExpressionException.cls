/**********************************************************************
 * Copyright (C) 2006-2023 by Consultingwerk Ltd. ("CW") -            *
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
    File        : InvalidFieldNameForShortcutLogicalExpressionException
    Purpose     :
    Syntax      :
    Description :
    Author(s)   :
    Created     : 09.04.2023 06:14:33
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.*                          from propath .
using Consultingwerk.Exceptions.*               from propath .
using Progress.Lang.*                           from propath .

class Consultingwerk.Exceptions.InvalidFieldNameForShortcutLogicalExpressionException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the field name that caused this Exception
     * Notes:
     */
    define public property FieldName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the InvalidFieldNameForShortcutLogicalExpressionException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     * @param pcFieldName The name of the field that caused this exception
     */
    constructor public InvalidFieldNameForShortcutLogicalExpressionException (pcErrorString as character,
                                                                              piMessageNumber as integer,
                                                                              pcFieldName as character):

        super (pcErrorString, piMessageNumber).

        assign this-object:FieldName = pcFieldName .

    end constructor.

end class.
