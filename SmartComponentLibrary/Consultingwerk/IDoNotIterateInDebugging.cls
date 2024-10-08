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
    File        : IDoNotIterateInDebugging
    Purpose     : Marker Interface for set classes that should not be iterated
                  by debugging utility like the ProgressLangObjectPropertyControl
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Sep 13 20:03:33 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Progress.Lang.*.

interface Consultingwerk.IDoNotIterateInDebugging:

    /* Empty marker interface */

end interface.
