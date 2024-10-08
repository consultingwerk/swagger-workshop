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
    File        : MissingIndexFieldValueException
    Purpose     : Exception thrown by BufferHelper:UniqueFindPredicateWithValueBuffer
                  when neither the Value Buffer of the MissingValues dictionary
                  provides the value for a required unique index field
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

class Consultingwerk.Util.Exceptions.MissingIndexFieldValueException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the name of the BufferName that caused the issue
     * Notes:
     */
    define public property BufferName as character no-undo
    get.
    private set.

    /**
     * Purpose: Returns the name of the FieldName that caused the issue
     * Notes:
     */
    define public property FieldName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor for the MissingIndexFieldValueException class
     * Notes:   The pcBufferName and pcFieldName will be substituted for &1 and &2 in
     *          the pcErrorMessage
     * @param pcErrorMessage The error message for the exception
     * @param pcBuffername The name of the buffer that caused the exception
     * @param pcFieldName The name of the field that caused the exception
     */
    constructor public MissingIndexFieldValueException (pcErrorMessage as character,
                                                        pcBufferName as character,
                                                        pcFieldName as character):

        super (substitute (pcErrorMessage, pcBufferName, pcFieldName), 0).

        assign this-object:FieldName = pcFieldName .

    end constructor.

end class.
