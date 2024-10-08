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
    File        : IVariableValueProvider
    Purpose     : Interface for classes that can provide values for the given
                  variable name, see StringHelper:SubstituteVariable()
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Mar 12 12:31:11 CET 2023
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Progress.Lang.*.

interface Consultingwerk.IVariableValueProvider:

    /**
     * Purpose: Returns the value of the named variable
     * Notes:
     * @param pcVariableName The name of the variable to return the value for
     * @return The value of the variable
     */
    method public character ValueForVariable (pcVariableName as character).

end interface.
