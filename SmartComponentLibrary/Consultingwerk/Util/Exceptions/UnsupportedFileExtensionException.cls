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
    File        : UnsupportedFileExtensionException
    Purpose     : Exception thrown by FileHelper:MimeTypeForFileExtension
                  when no mime type is known for a given extension
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Jan 08 10:09:12 CET 2014
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

{Consultingwerk/products.i}

class Consultingwerk.Util.Exceptions.UnsupportedFileExtensionException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the file extension that caused the error
     * Notes:
     */
    define public property Extension as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor for the UnsupportedFileExtensionException class
     * Notes:
     * @param pcErrorMessage The error message for the exception
     * @param pcExtension The file extension that caused the error
     */
    constructor public UnsupportedFileExtensionException (pcErrorMessage as character,
                                                          pcExtension as character):

        super (substitute (pcErrorMessage, pcExtension), 0).

        assign this-object:Extension = pcExtension .

    end constructor.

end class.
