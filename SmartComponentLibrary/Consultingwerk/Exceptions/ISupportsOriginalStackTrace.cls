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
    File        : ISupportsOriginalStackTrace
    Purpose     : Supports the OriginalStackTrace pattern for error objects
    Syntax      :
    Description : Useful when errors are re-thrown as a different error
                  object (e.g. upgrading SysError to AppError)
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat May 11 20:53:54 CET 2017
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Progress.Lang.*.

{Consultingwerk/products.i}

interface Consultingwerk.Exceptions.ISupportsOriginalStackTrace:

    /**
     * Purpose: Returns the original stack trace of the exception
     * Notes:   Only supported to by SET-able when the property is empty or
     *          unknown
     */
    define public property OriginalStackTrace as character no-undo
    get.
    set.

end interface.
