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
    File        : RecordLockedException
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Dec 31 10:26:27 CET 2016
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

{Consultingwerk/products.i}

class Consultingwerk.Exceptions.RecordLockedException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Gets and sets the name of the buffer that is locked
     * Notes:
     */
    define public property BufferName as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the ROWID of the record that is locked
     * Notes:
     */
    define public property Rowid as rowid no-undo
    get.
    set.

    /**
     * Purpose: Constructor for the RecordLockedException class
     * Notes:
     * @param pcErrorString The error message of this exception
     * @param piMessageNumber The error message number of this exception
     * @param pcBufferName The name of the buffer that caused this exception
     * @param proRowid The ROWID of the record that caused this exception
     */
    constructor public RecordLockedException (pcErrorString as character,
                                              piMessageNumber as integer,
                                              pcBufferName as character,
                                              proRowid as rowid):
        super (pcErrorString, piMessageNumber).

        assign this-object:BufferName = pcBufferName
               this-object:Rowid      = proRowid .

    end constructor.

    /**
     * Purpose: Constructor for the RecordLockedException class
     * Notes:
     * @param pcErrorString The error message of this exception
     * @param piMessageNumber The error message number of this exception
     */
    constructor public RecordLockedException (pcErrorString as character,
                                              piMessageNumber as integer):
        super (pcErrorString, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor for the RecordLockedException class
     * Notes:
     */
    constructor public RecordLockedException ():
        super ().

    end constructor.

end class.
