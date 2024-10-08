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
    File        : IErrorTitle
    Purpose     : Interface for Errors that support a Title property to
                  be used for error dialogs
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Jun 20 00:15:09 CEST 2013
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath.

interface Consultingwerk.Exceptions.IErrorTitle:

    /**
     * Purpose: Returns the Title to be used in the Error Dialog or Message Box
     * Notes:
     */
    define public property Title as character no-undo
    get.

end interface.
