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
    File        : IsClonable
    Purpose     : Interface for classes which that have implemented the
                  Clone() method.
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat May 13 12:39:59 CEST 2017
    Notes       : Progress.Lang.Object:Clone() is available by default -
                  but not all classes may provide an actual implementation
  ----------------------------------------------------------------------*/

@lowercase.

using Progress.Lang.*.

interface Consultingwerk.IsClonable:

    /**
     * Purpose: Creates a copy of an object instance and returns an
     *          object reference of the copy.
     * Notes:
     * @return The new object instance
     */
    method public override Progress.Lang.Object Clone().

end interface.
