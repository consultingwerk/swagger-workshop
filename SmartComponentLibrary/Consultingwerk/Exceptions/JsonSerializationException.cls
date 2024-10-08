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
    File        : JsonSerializationException
    Purpose     : Exception thrown by Json-Serialization and Deserialization
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Jul 09 17:13:10 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

{Consultingwerk/products.i}

class Consultingwerk.Exceptions.JsonSerializationException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public JsonSerializationException (poInnerException as Progress.Lang.Error,
                                                   pcErrorString as character,
                                                   piMessageNumber as integer):
        super (poInnerException, pcErrorString, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public JsonSerializationException (pcErrorString as character,
                                                   piMessageNumber as integer):
        super (input pcErrorString, input piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     */
    constructor public JsonSerializationException ():
        super ().

    end constructor.

end class.
