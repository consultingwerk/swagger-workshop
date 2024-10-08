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
    File        : IDoNotShowException
    Purpose     : Interface for Error classes that should not be causing
                  a message box/dialog when passed to the
                  Consultingwerk.Util.ErrorHelper methods. Those errors
                  could still be handled using then IErrorHandler implementation
    Syntax      :
    Description : Useful for errors where the actual error message might
                  already have been shown to the user and the error is just
                  thrown to cancel further processing
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Jun 19 23:54:44 CEST 2013
    Notes       : This Interface does not require any methods as it's only
                  needed for tagging error classes
  ----------------------------------------------------------------------*/

@lowercase.

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

interface Consultingwerk.Exceptions.IDoNotShowException:

end interface.
