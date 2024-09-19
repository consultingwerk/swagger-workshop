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
    File        : ISwaggerSchemaObjectGenerator
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu May 02 10:27:30 CET 2024
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Consultingwerk.*                     from propath.
using Consultingwerk.Studio.SwaggerToAbl.* from propath.
using Progress.Json.ObjectModel.*          from propath.

interface Consultingwerk.Studio.SwaggerToAbl.ISwaggerToAblClassNameProvider:

    /**
     * Purpose: Returns the ABL Class Name for the selected JSON schema object
     * Notes:
     * @param poApiSpec The Swagger API Specification
     * @param pcJsonPath The Json Path of the Schema
     * @param poGeneratorParameter The Generator Parameter (ISwaggerBasePackageParameter)
     * @return The ABL Class Name
     */
    method public ClassName GetClassName (poApiSpec as JsonObject,
                                          pcJsonPath as character,
                                          poGeneratorParameter as ISwaggerBasePackageParameter) .

    /**
     * Purpose: Returns the ABL Class Name for the selected JSON schema object
     * Notes:
     * @param poApiSpec The Swagger API Specification
     * @param pcJsonPath The Json Path of the Schema
     * @param poGeneratorParameter The Generator Parameter (ISwaggerBasePackageParameter)
     * @param plResolveArrays Logical value indicating if arrays should be resolved into EXTENT parameters
     * @return The ABL Class Name
     */
    method public ClassName GetClassName (poApiSpec as JsonObject,
                                          pcJsonPath as character,
                                          poGeneratorParameter as ISwaggerBasePackageParameter,
                                          plResolveArrays as logical) .

end interface.
