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
    File        : NoFieldMappingForRowidFunctionException
    Purpose     : Exception thrown by methods that rely on field mapping
                  for the ROWID function in the DATA-SOURCE-COMPLETE-MAP
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue May 24 01:06:32 CET 2022
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Util.Exceptions.NoFieldMappingForRowidFunctionException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the name of the buffer that caused this exception
     * Notes:
     */
    define public property BufferName as character no-undo
    get.
    protected set.

    /**
     * Purpose: Constructor of the NoFieldMappingForRowidFunctionException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param pcBufferName The name of the Buffer that caused this error
     */
    constructor public NoFieldMappingForRowidFunctionException (pcErrorString as character,
                                                                pcBufferName as character):
        super (pcErrorString, 0).

        this-object:BufferName = pcBufferName .

    end constructor.

    /**
     * Purpose: Constructor of the NoFieldMappingForRowidFunctionException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     * @param pcBufferName The name of the Buffer that caused this error
     */
    constructor public NoFieldMappingForRowidFunctionException (pcErrorString as character,
                                                                piMessageNumber as integer,
                                                                pcBufferName as character):
        super (pcErrorString, piMessageNumber).

        this-object:BufferName = pcBufferName .

    end constructor.

end class.
