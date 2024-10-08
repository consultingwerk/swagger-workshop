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
    File        : FileNotFoundException
    Purpose     : Exception raised for files not found
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Oct 16 21:00:20 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

{Consultingwerk/products.i}

class Consultingwerk.Exceptions.FileNotFoundException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the File Name associated with this error
     * Notes:
     */
    define public property FileName as character no-undo
    get.
    protected set.

    /**
     * Purpose: Constructor of the FileNotFoundException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcFileName The file name associated with this exception
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public FileNotFoundException (poInnerException as Progress.Lang.Error,
                                              pcFileName as character,
                                              pcErrorString as character):
        super (poInnerException, pcErrorString).

        assign this-object:Filename = pcFileName .

    end constructor.

    /**
     * Purpose: Constructor of the FileNotFoundException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcFileName The file name associated with this exception
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public FileNotFoundException (poInnerException as Progress.Lang.Error,
                                              pcFileName as character,
                                              pcErrorString as character,
                                              piMessageNumber as integer):
        super (poInnerException, pcErrorString, piMessageNumber).

        assign this-object:Filename = pcFileName .

    end constructor.

    /**
     * Purpose: Constructor of the FileNotFoundException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcFileName The file name associated with this exception
     */
    constructor public FileNotFoundException (poInnerException as Progress.Lang.Error,
                                              pcFileName as character):
        super (poInnerException).

        assign this-object:Filename = pcFileName .

        this-object:AddMessagesFrom (poInnerException) .

    end constructor.

    /**
     * Purpose: Constructor of the FileNotFoundException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param pcFileName The file name associated with this exception
     */
    constructor public FileNotFoundException (pcFileName as character,
                                              pcErrorString as character):
        super (pcErrorString).

        assign this-object:Filename = pcFileName .

    end constructor.

    /**
     * Purpose: Constructor of the FileNotFoundException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param pcFileName The file name associated with this exception
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public FileNotFoundException (pcFileName as character,
                                              pcErrorString as character,
                                              piMessageNumber as integer):
        super (pcErrorString, piMessageNumber).

        assign this-object:Filename = pcFileName .

    end constructor.

    /**
     * Purpose: Constructor of the FileNotFoundException class
     * Notes:
     * @param pcFileName The file name associated with this exception
     */
    constructor public FileNotFoundException (pcFileName as character):
        super (substitute ("The file ~"&1~" cannot be found.":U, pcFileName), 0).

        assign this-object:Filename = pcFileName .

    end constructor.

end class.
