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
    File        : UnsupportedMimeTypeException
    Purpose     : Exception thrown by FileHelper:FileExtensionForMimeType
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

class Consultingwerk.Util.Exceptions.UnsupportedMimeTypeException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the mime type that caused the error
     * Notes:
     */
    define public property MimeType as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor for the UnsupportedMimeTypeException class
     * Notes:
     * @param pcErrorMessage The error message for the exception
     * @param pcMimeType The mime type that caused the error
     */
    constructor public UnsupportedMimeTypeException (pcErrorMessage as character,
                                                     pcMimeType as character):

        super (substitute (pcErrorMessage, pcMimeType), 0).

        assign this-object:MimeType = pcMimeType .

    end constructor.

end class.
