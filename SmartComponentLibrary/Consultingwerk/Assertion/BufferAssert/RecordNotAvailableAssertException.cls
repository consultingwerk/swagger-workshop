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
    File        : RecordNotAvailableAssertException
    Purpose     : Error class for assertions
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Jun 14 14:48:55 CET 2017
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Assertion.*  from propath .
using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

{Consultingwerk/products.i}

class Consultingwerk.Assertion.BufferAssert.RecordNotAvailableAssertException
    inherits AssertException
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the Buffer Name associated with the error
     * Notes:
     */
    define public property BufferName as character no-undo
    get.
    set.

    /**
     * Purpose: Constructor of the RecordNotAvailableAssertException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param pcBufferName The name of the buffer associated with the error
     */
    constructor public RecordNotAvailableAssertException (poInnerException as Progress.Lang.Error,
                                                          pcErrorString as character,
                                                          pcBufferName as character):
        super (poInnerException, pcErrorString).

        assign this-object:BufferName = pcBufferName .

    end constructor.

    /**
     * Purpose: Constructor of the RecordNotAvailableAssertException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorMessage The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     * @param pcBufferName The name of the buffer associated with the error
     */
    constructor public RecordNotAvailableAssertException (poInnerException as Progress.Lang.Error,
                                                          pcErrorMessage as character,
                                                          piMessageNumber as integer,
                                                          pcBufferName as character):
        super (poInnerException, pcErrorMessage, piMessageNumber).

        assign this-object:BufferName = pcBufferName .

    end constructor.

    /**
     * Purpose: Constructor of the RecordNotAvailableAssertException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcBufferName The name of the buffer associated with the error
     */
    constructor public RecordNotAvailableAssertException (poInnerException as Progress.Lang.Error,
                                                          pcBufferName as character):
        super (poInnerException).

        assign this-object:BufferName = pcBufferName .

    end constructor.

    /**
     * Purpose: Constructor of the RecordNotAvailableAssertException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param pcBufferName The name of the buffer associated with the error
     */
    constructor public RecordNotAvailableAssertException (pcErrorString as character,
                                                          pcBufferName as character):
        super (pcErrorString).

        assign this-object:BufferName = pcBufferName .

    end constructor.

    /**
     * Purpose: Constructor of the RecordNotAvailableAssertException class
     * Notes:
     * @param pcErrorMessage The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     * @param pcBufferName The name of the buffer associated with the error
     */
    constructor public RecordNotAvailableAssertException (pcErrorMessage as character,
                                                          piMessageNumber as integer,
                                                          pcBufferName as character):

        super (pcErrorMessage, piMessageNumber).

        assign this-object:BufferName = pcBufferName .

    end constructor.

    /**
     * Purpose: Constructor of the RecordNotAvailableAssertException class
     * Notes:
     * @param pcBufferName The name of the buffer associated with the error
     */
    constructor public RecordNotAvailableAssertException (pcBufferName as character):
        super ().

        assign this-object:BufferName = pcBufferName .

    end constructor.

end class.
