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
    File        : IInvalidResourceException
    Purpose     : Flag Interface used to return http status code 404
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Jul 24 06:15:08 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

interface Consultingwerk.Exceptions.IInvalidResourceException:

end interface.
