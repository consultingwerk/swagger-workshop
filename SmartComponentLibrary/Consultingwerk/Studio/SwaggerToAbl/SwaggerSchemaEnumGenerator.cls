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
    File        : SwaggerSchemaEnumGenerator
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu May 02 10:27:30 CET 2024
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.*                       from propath.
using Consultingwerk.Framework.Collections.* from propath.
using Consultingwerk.Studio.SwaggerToAbl.*   from propath.
using Consultingwerk.Util.*                  from propath.
using Consultingwerk.Util.LoggingStream.*    from propath.
using Progress.Json.ObjectModel.*            from propath.

class Consultingwerk.Studio.SwaggerToAbl.SwaggerSchemaEnumGenerator
    implements ISwaggerSchemaEnumGenerator:

    /**
     * Purpose: Generates an ABL Enum from a Swagger Schema Object
     * Notes:
     * @param pcClassName Then name of the Enum class to generate
     * @param pcPackageName The package name of the Enum class to generate
     * @param poSchema The Swagger Schema Object
     * @param poApiSpec The Swagger API Specification
     * @param pcJsonPath The Json Path of the Schema
     * @param poGeneratorParameter The Generator Parameter
     * @param poLoggingStream The Logging Stream
     * @param poGeneratedFiles The List of generated file names
     */
    method public void Generate (pcClassName as character,
                                 pcPackageName as character,
                                 poSchema as JsonObject,
                                 poApiSpec as JsonObject,
                                 pcJsonPath as character,
                                 poGeneratorParameter as SwaggerSchemaTypeGeneratorParameter,
                                 poLoggingStream as ILoggingStream,
                                 poGeneratedFiles as CharacterList):

        define variable oClassNameProvider as ISwaggerToAblClassNameProvider no-undo.
        define variable oClassName         as ClassName                      no-undo.
        define variable oSchema            as JsonObject                     no-undo.
        define variable cGeneratedFile     as character                      no-undo.

        if pcClassName > "":u then
            assign oClassName = ClassHelper:SplitClassName (substitute ("&1.&2":u,
                                                                        poGeneratorParameter:BasePackage,
                                                                        pcClassName)) .
        else do:
            assign oClassNameProvider = {Consultingwerk/get-service.i ISwaggerToAblClassNameProvider
                                            "new SwaggerToAblClassNameProvider ()"}
                   oClassName         = oClassNameProvider:GetClassName (poApiSpec, pcJsonPath, poGeneratorParameter) .
        end.

        if valid-object (poSchema) then
            assign oSchema = poSchema .
        else
            assign oSchema = JsonHelper:GetJsonObjectByPath(poApiSpec, pcJsonPath, "/":u).

        cGeneratedFile = SwaggerToAblHelper:InvokeTemplate ("enum.template":u,
                                                            oClassName,
                                                            oSchema,
                                                            poApiSpec,
                                                            poGeneratorParameter,
                                                            poLoggingStream) .

        if cGeneratedFile > "":u then
            poGeneratedFiles:Add(cGeneratedFile).

    end method .

end class.
