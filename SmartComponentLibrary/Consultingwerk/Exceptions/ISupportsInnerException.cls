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
    File        : ISupportsInnerException
    Purpose     : Supports the InnerException pattern for error objects
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Feb 11 00:17:25 CET 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Progress.Lang.*.

{Consultingwerk/products.i}

interface Consultingwerk.Exceptions.ISupportsInnerException:

    /**
     * Purpose: Returns the Error instance that caused the current exception.
     * Notes:
     */
    define public property InnerException as Error no-undo
    get.

end interface.
