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
    File        : DatabaseAssert
    Purpose     : Provides database related validation routines
    Syntax      :
    Description : Routines in this class typically raise an error condition
                  when the condition is not met.
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Nov 30 20:05:43 CET 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Assertion.*  from propath .
using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Assertion.DatabaseAssert:

    /**
     * Purpose: Disallow instance creation.
     * Notes:
     */
    constructor private DatabaseAssert ():
        super ().

    end constructor.

    /**
     * Purpose: Verifies that the given database is connected
     * Notes:
     * Throws:  Consultingwerk.Exceptions.DatabaseNotConnectedException
     * @param pcDatabaseName The name of the database to verify
     */
    method public static void IsConnected (pcDatabaseName as character):

        if not connected (pcDatabaseName) then
            undo, throw new DatabaseNotConnectedException (pcDatabaseName) .

    end method .

end class.
