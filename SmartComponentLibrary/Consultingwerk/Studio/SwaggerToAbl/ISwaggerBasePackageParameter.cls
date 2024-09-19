/**********************************************************************
 * Copyright (c) 2024-2024 by Consultingwerk Ltd. ("CW") -            *
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
    File        : Consultingwerk.Studio.SwaggerToAbl.ISwaggerClassNameParameter
    Purpose     : Interface for Parameter objects that contain class name arguments
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2024-09-13
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

{Consultingwerk/products.i}

using Consultingwerk.Studio.SwaggerToAbl.* from propath.

interface Consultingwerk.Studio.SwaggerToAbl.ISwaggerBasePackageParameter:

    /**
     * Purpose: Returns the base package name
     * Notes:
     */
    define public property BasePackage as character no-undo
    get.

end interface.
