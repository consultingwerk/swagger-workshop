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

using Consultingwerk.Framework.Collections.* from propath.
using Consultingwerk.Studio.SwaggerToAbl.*   from propath.
using Consultingwerk.Util.LoggingStream.*    from propath.
using Progress.Json.ObjectModel.*            from propath.

interface Consultingwerk.Studio.SwaggerToAbl.ISwaggerSchemaObjectGenerator:

    /**
     * Purpose: Generates an ABL type from a Swagger Schema Object
     * Notes:
     * @param pcClassName Then name of the class to generate
     * @param pcPackageName The package name of the class to generate
     * @param poSchema The Swagger Schema Object
     * @param poApiSpec The Swagger API Specification
     * @param pcJsonPath The Json Path of the Schema
     * @param poGeneratorParameter The Generator Parameter
     * @param poLoggingStream The Logging Stream
     * @param poGeneratedClassNames The List of generated class names
     * @param poGeneratedFiles The List of generated file names
     */
    method public void Generate (pcClassName as character,
                                 pcPackageName as character,
                                 poSchema as JsonObject,
                                 poApiSpec as JsonObject,
                                 pcJsonPath as character,
                                 poGeneratorParameter as SwaggerSchemaTypeGeneratorParameter,
                                 poLoggingStream as ILoggingStream,
                                 poGeneratedClassNames as CharacterList,
                                 poGeneratedFiles as CharacterList) .

end interface.
