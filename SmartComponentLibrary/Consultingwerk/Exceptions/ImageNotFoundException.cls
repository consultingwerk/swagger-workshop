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
    File        : ImageNotFoundException
    Purpose     : Exception raised when an image is not found by the
                  ImageHelper:Load method
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 18.07.2018 21:53:00
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.*                          from propath .
using Consultingwerk.Exceptions.*               from propath .
using Consultingwerk.Exceptions.*               from propath .
using Progress.Lang.*                           from propath .

class Consultingwerk.Exceptions.ImageNotFoundException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the FileName that caused the issue
     * Notes:
     */
    define public property FileName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the ImageNotFoundException class
     * Notes:
     * @param pcFileName The filename of the image that caused this issue
     */
    constructor public ImageNotFoundException (pcFileName as character):

        super (substitute ("Unable to load image &1!":U, pcFileName), 0) .

        assign this-object:FileName = pcFileName .

    end constructor.

end class.
