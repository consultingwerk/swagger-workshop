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
    File        : JsonParsingException
    Purpose     : Exception raised when parsing JSON Files
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 26.01.2024 14:33:40
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

using Consultingwerk.*                          from propath .
using Consultingwerk.Exceptions.*               from propath .
using Consultingwerk.Util.Exceptions.*          from propath .
using Progress.Lang.*                           from propath .

{Consultingwerk/products.i}

class Consultingwerk.Util.Exceptions.JsonParsingException
    inherits Exception
    serializable:

    /**
     * Purpose: Returns the file name that caused the issue
     * Notes:
     */
    define public property FileName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the JsonParsingException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcFileName The file name that caused the issue
     */
    constructor public JsonParsingException (poInnerException as Error,
                                             pcFileName as character):

        super (poInnerException).

        this-object:AddMessage (substitute ("Error parsing JSON file: &1"{&TRAN},
                                            pcFileName),
                                0) .

        this-object:AddMessagesFrom (poInnerException) .

        this-object:FileName = pcFileName .

    end constructor.

end class.
