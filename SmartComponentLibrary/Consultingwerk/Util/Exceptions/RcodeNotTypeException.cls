/**********************************************************************
 * Copyright (C) 2023-2024 by Consultingwerk Ltd. ("CW") -            *
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
    File        : RcodeNotTypeException
    Purpose     : Exception thrown by ClassHelper:FileNameToClass
                  when an rcode file is not a class (IS=CLASS=FALSE)
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-05-19
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

{Consultingwerk/products.i}

class Consultingwerk.Util.Exceptions.RcodeNotTypeException
    inherits Exception
    serializable:

    /**
     * Purpose: Returns the file name that caused the error
     * Notes:
     */
    define public property FileName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor for the RcodeNotTypeException class
     * Notes:
     * @param pcFileName The name of the rcode file
     */
    constructor public RcodeNotTypeException (pcFileName as character):
        super (substitute("Rcode file &1 is not an OOABL type"{&TRAN}, quoter(pcFileName)), 0).

        assign this-object:FileName = pcFileName .

    end constructor.

end class.
