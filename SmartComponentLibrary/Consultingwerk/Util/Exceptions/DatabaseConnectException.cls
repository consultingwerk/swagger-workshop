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
    File        : DatabaseConnectException
    Purpose     : Exception raised for errors when connecting to a database
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

class Consultingwerk.Util.Exceptions.DatabaseConnectException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the connection parameters that caused this issue
     * Notes:
     */
    define public property ConnectParameter as character no-undo
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
     * Purpose: Constructor of the DatabaseConnectException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcDatabaseName The name of the database that caused the exception
     * @param pcConnectParameter The database connection parameters
     */
    constructor public DatabaseConnectException (poInnerException as Error,
                                                 pcDatabaseName as character,
                                                 pcConnectParameter as character):

        super (poInnerException,
               substitute ("Error connecting to database &1 using parameter: &2"{&TRAN},
                           pcDatabaseName,
                           pcConnectParameter),
               poInnerException:GetMessageNum(1)).

        assign this-object:DatabaseName     = pcDatabaseName
               this-object:ConnectParameter = pcConnectParameter .

        this-object:AddMessagesFrom(poInnerException) .

    end constructor.

end class.
