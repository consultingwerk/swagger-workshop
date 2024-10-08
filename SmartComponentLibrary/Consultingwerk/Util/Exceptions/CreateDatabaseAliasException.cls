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
    File        : CreateDatabaseAliasException
    Purpose     : Exception raised for errors when creating a database alias
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 24.10.2023 12:03:24
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*                          from propath .
using Consultingwerk.Exceptions.*               from propath .
using Consultingwerk.Util.Exceptions.*          from propath .
using Progress.Lang.*                           from propath .

class Consultingwerk.Util.Exceptions.CreateDatabaseAliasException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the name of the alias
     * Notes:
     */
    define public property AliasName as character no-undo
    get.
    private set.

    /**
     * Purpose: Returns the database name that caused this issue
     * Notes:
     */
    define public property DatabaseName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the CreateDatabaseAliasException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcDatabaseName The name of the database that caused the exception
     * @param pcAliasName The name of the alias that caused the exception
     */
    constructor public CreateDatabaseAliasException (poInnerException as Error,
                                                     pcDatabaseName as character,
                                                     pcAliasName as character):

        super (poInnerException,
               substitute ("Error creating alias &2 for database &1"{&TRAN},
                           pcDatabaseName,
                           pcAliasName),
               poInnerException:GetMessageNum(1)).

        assign this-object:DatabaseName = pcDatabaseName
               this-object:AliasName    = pcAliasName .

        this-object:AddMessagesFrom(poInnerException) .

    end constructor.

end class.
