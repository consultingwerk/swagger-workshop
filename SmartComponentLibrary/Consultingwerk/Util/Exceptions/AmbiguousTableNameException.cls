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
    File        : AmbiguousTableNameException
    Purpose     : Exception thrown by DatabaseHelper:UnabbreviatedTableName
                  when an invalid table name has been passed
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

class Consultingwerk.Util.Exceptions.AmbiguousTableNameException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the name of the TableName that caused the issue
     * Notes:
     */
    define public property TableName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor for the InvalidTableNameException class
     * Notes:
     * @param pcErrorMessage The error message for the exception
     * @param pcTableName The name of the table that caused the exception
     */
    constructor public AmbiguousTableNameException (pcErrorMessage as character,
                                                    pcTableName as character):

        super (substitute (pcErrorMessage, pcTableName), 0).

        assign this-object:TableName = pcTableName .

    end constructor.

end class.
