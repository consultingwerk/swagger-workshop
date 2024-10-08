/**********************************************************************
 * Copyright (C) 2006-2023 by Consultingwerk Ltd. ("CW") -            *
 * www.consultingwerk.de and other contributors as listed             *
 * below.  All Rights Reserved.                                       *
 *                                                                    *
 *  Software is distributed on an "AS IS", WITHOUT WARRANTY OF ANY    *
 *   KIND, either express or implied.                                 *
 *                                                                    *
 *  Contributors:                                                     *
 *   Thomas Hansen, appSolutions a|s                                  *
 **********************************************************************/
/*------------------------------------------------------------------------
    File        : DeserializationException
    Purpose     : Exception raised for issues during Deserialization
                  (e.g. JsonSerializable)
    Syntax      :
    Description :
    Author(s)   :
    Created     : 11.11.2023 16:10:24
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.*                          from propath .
using Consultingwerk.Exceptions.*               from propath .
using Consultingwerk.Exceptions.*               from propath .
using Progress.Lang.*                           from propath .

class Consultingwerk.Exceptions.DeserializationException
    inherits Exception
    {&SERIALIZABLE}:

     /**
     * Purpose: Returns the name of the property that caused the issue
     * Notes:
     */
    define public property PropertyName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the DeserializationException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public DeserializationException (pcErrorString as character,
                                                 piMessageNumber as integer):

        super (pcErrorString, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the DeserializationException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public DeserializationException (poInnerException as Error):

        super (poInnerException).

    end constructor.

    /**
     * Purpose: Constructor of the DeserializationException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public DeserializationException (poInnerException as Error,
                                                 pcErrorString as character,
                                                 piMessageNumber as integer):

        super (poInnerException, pcErrorString, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the DeserializationException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     * @param pcPropertyName The name of the property that caused the issue
     */
    constructor public DeserializationException (poInnerException as Error,
                                                 pcErrorString as character,
                                                 piMessageNumber as integer,
                                                 pcPropertyName as character):

        super (poInnerException, pcErrorString, piMessageNumber).

        this-object:PropertyName = pcPropertyName .

    end constructor.

end class.
