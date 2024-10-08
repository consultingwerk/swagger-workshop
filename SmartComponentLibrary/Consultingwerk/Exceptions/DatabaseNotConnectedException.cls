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
    File        : DatabaseNotConnectedException
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Nov 30 20:08:07 CET 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

{Consultingwerk/products.i}

class Consultingwerk.Exceptions.DatabaseNotConnectedException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Constructor for the DatabaseNotConnectedException class
     * Notes:
     * @param pcDatabaseName The database name to use in the error message
     */
    constructor public DatabaseNotConnectedException (pcDatabaseName as character):

        super (substitute ("Database ~"&1~" is not connected."{&TRAN}, pcDatabaseName), 0).

    end constructor.

end class.
