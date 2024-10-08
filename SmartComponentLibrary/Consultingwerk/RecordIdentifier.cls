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
    File        : RecordIdentifier
    Purpose     : A structure that can holds a ROWID as well as a buffer
                  name
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Sep 03 15:24:44 CEST 2014
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*            from propath .
using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.RecordIdentifier
    {&SERIALIZABLE}:

    /**
     * Purpose: Gets and sets the Database Name component
     * Notes:
     */
    define public property DatabaseName as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the Buffer or Table Name component
     * Notes:
     */
    define public property BufferName as character no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the Rowid
     * Notes:
     */
    define public property Rowid as rowid no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the RowState
     * Notes:
     */
    define public property RowState as integer no-undo
    get.
    set.

    /**
     * Purpose: Constructor for the RecordIdentifier class
     * Notes:
     */
    constructor public RecordIdentifier ():
        super ().

    end constructor.

    /**
     * Purpose: Constructor for the RecordIdentifier class
     * Notes:
     * @param pcDatabaseName The database name
     * @param pcBufferName The buffer or table name
     * @param proRowid The rowid
     */
    constructor public RecordIdentifier (pcDatabaseName as character,
                                         pcBufferName as character,
                                         proRowid as rowid):

        assign
            this-object:DatabaseName = pcDatabaseName
            this-object:BufferName   = pcBufferName
            this-object:Rowid        = proRowid .

    end constructor.

    /**
     * Purpose: Constructor for the RecordIdentifier class
     * Notes:
     * @param pcDatabaseName The database name
     * @param pcBufferName The buffer or table name
     * @param proRowid The rowid
     * @param piRowState The RowState value
     */
    constructor public RecordIdentifier (pcDatabaseName as character,
                                         pcBufferName as character,
                                         proRowid as rowid,
                                         piRowState as integer):

        assign
            this-object:DatabaseName = pcDatabaseName
            this-object:BufferName   = pcBufferName
            this-object:Rowid        = proRowid
            this-object:RowState     = piRowState .

    end constructor.

    /**
     * Purpose: Constructor for the RecordIdentifier class
     * Notes:
     * @param pcBufferName The buffer or table name
     * @param proRowid The rowid
     */
    constructor public RecordIdentifier (pcBufferName as character,
                                         proRowid as rowid):

        assign
            this-object:BufferName   = pcBufferName
            this-object:Rowid        = proRowid .

    end constructor.

    /**
     * Purpose: Constructor for the RecordIdentifier class
     * Notes:
     * @param pcBufferName The buffer or table name
     * @param proRowid The rowid
     * @param piRowState The RowState value
     */
    constructor public RecordIdentifier (pcBufferName as character,
                                         proRowid as rowid,
                                         piRowState as integer):

        assign
            this-object:BufferName   = pcBufferName
            this-object:Rowid        = proRowid
            this-object:RowState     = piRowState .

    end constructor.

    /**
     * Purpose: Returns a string that represents the current object.
     * Notes:
     * @return A string that represents the current object.
     */
    method override public character ToString ():

        if this-object:DatabaseName > "":U then
            return substitute ("Database Name: &1&4Buffer Name: &2&4Rowid: &3"{&TRAN},
                               this-object:DatabaseName,
                               this-object:BufferName,
                               this-object:Rowid,
                               "~n":U) .
        else
            return substitute ("Buffer Name: &1&3Rowid: &2"{&TRAN},
                               this-object:BufferName,
                               this-object:Rowid,
                               "~n":U) .
    end method .

end class.
