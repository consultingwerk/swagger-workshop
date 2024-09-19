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
    File        : SwaggerSchemaObjectGenerator
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
using Consultingwerk.Exceptions.*            from propath.
using Consultingwerk.Framework.Collections.* from propath.
using Consultingwerk.Studio.SwaggerToAbl.*   from propath.
using Consultingwerk.Util.*                  from propath.
using Consultingwerk.Util.LoggingStream.*    from propath.
using Progress.Json.ObjectModel.*            from propath.

class Consultingwerk.Studio.SwaggerToAbl.SwaggerSchemaObjectGenerator
    implements ISwaggerSchemaObjectGenerator:

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
                                 poGeneratedFiles as CharacterList):

        this-object:Generate (pcClassName,
                              pcPackageName,
                              poSchema,
                              poApiSpec,
                              pcJsonPath,
                              poGeneratorParameter,
                              poLoggingStream,
                              poGeneratedClassNames,
                              poGeneratedFiles,
                              false) .

    end method.

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
     * @param plNested Generator called nested
     */
    method protected void Generate (pcClassName as character,
                                    pcPackageName as character,
                                    poSchema as JsonObject,
                                    poApiSpec as JsonObject,
                                    pcJsonPath as character,
                                    poGeneratorParameter as SwaggerSchemaTypeGeneratorParameter,
                                    poLoggingStream as ILoggingStream,
                                    poGeneratedClassNames as CharacterList,
                                    poGeneratedFiles as CharacterList,
                                    plNested as logical):

        define variable oClassNameProvider as ISwaggerToAblClassNameProvider no-undo.
        define variable oClassName         as ClassName                      no-undo.
        define variable oSchema            as JsonObject                     no-undo.
        define variable cGeneratedFile     as character                      no-undo.
        define variable oEnumGenerator     as ISwaggerSchemaEnumGenerator    no-undo.
        define variable oTempSchema        as JsonObject                     no-undo.
        define variable oProperties        as JsonObject                     no-undo.
        define variable lArray             as logical initial false          no-undo.

        if poGeneratorParameter:BasePackage > "":U and pcClassName begins poGeneratorParameter:BasePackage then
            assign pcClassName = substring (pcClassName,
                                            length(poGeneratorParameter:BasePackage, "character":u) + 2,
                                            -1,
                                            "character":u).

        if valid-object (poSchema) then
            assign oSchema = poSchema .
        else
            assign oSchema = JsonHelper:GetJsonObjectByPath(poApiSpec, pcJsonPath, "/":u).

        if oSchema:Has ("$ref":u) then do:
            assign pcJsonPath = oSchema:GetCharacter ("$ref":u) .

            if pcJsonPath begins "#/":u then
                assign pcJsonPath = substring (pcJsonPath, 3, -1, "character":u) .
            else
                undo, throw new Exception (substitute ("Cannot resolve reference: &1":u, pcJsonPath), 0) .

            oSchema = JsonHelper:GetJsonObjectByPath(poApiSpec, pcJsonPath, "/":u) .
        end.

        /* Invoke Enum Generator */
        if oSchema:Has ("enum":u) then do:
            if not valid-object (oEnumGenerator) then
                assign oEnumGenerator = {Consultingwerk/get-service.i ISwaggerSchemaEnumGenerator
                                            "new SwaggerSchemaEnumGenerator ()"}.

            oEnumGenerator:Generate (pcClassName,
                                     ? /* package name */,
                                     oSchema,
                                     poApiSpec,
                                     ? /* schema path */,
                                     poGeneratorParameter,
                                     poLoggingStream,
                                     poGeneratedFiles).

            return.
        end.

        if pcClassName > "":u then
            assign oClassName = ClassHelper:SplitClassName(substitute ("&1.&2":u,
                                                                       poGeneratorParameter:BasePackage,
                                                                       pcClassName)) .
        else do:
            assign oClassNameProvider = {Consultingwerk/get-service.i ISwaggerToAblClassNameProvider
                                            "new SwaggerToAblClassNameProvider ()"}
                   oClassName         = oClassNameProvider:GetClassName (poApiSpec, pcJsonPath, poGeneratorParameter) .
        end.

        /* Prevent recursion */
        if poGeneratedClassNames:ContainsValue(oClassName:FullName) then
            return.

        poGeneratedClassNames:Add(oClassName:FullName).

        /* Array as the outermost element*/
        if oSchema:Has ("type":u) and oSchema:GetCharacter ("type":u) = "array":u and oSchema:Has ("items":u)
        then do:
            assign oTempSchema = new JsonObject ()
                   oProperties = new JsonObject ()
                   lArray      = true.

            oTempSchema:Add ("properties":u, oProperties).
            oProperties:Add ("Items":u, oSchema) .

            oSchema = oTempSchema.
        end .

        /* Generate nested types */
        if oSchema:Has("properties":u) then
            this-object:GenerateNestedTypes (oClassName:ClassName,
                                             oSchema,
                                             poApiSpec,
                                             poGeneratorParameter,
                                             poLoggingStream,
                                             poGeneratedClassNames,
                                             poGeneratedFiles).

        if plNested or not lArray then
            cGeneratedFile = SwaggerToAblHelper:InvokeTemplate ("parameterclass.template":u,
                                                                oClassName,
                                                                oSchema,
                                                                poApiSpec,
                                                                poGeneratorParameter,
                                                                poLoggingStream) .

        if cGeneratedFile > "":u then
            poGeneratedFiles:Add(cGeneratedFile).

    end method.

    /**
     * Purpose: Generates the nested types
     * Notes:
     * @param pcClassName Then name of the class to generate
     * @param poSchema The Swagger Schema Object
     * @param poApiSpec The Swagger API Specification
     * @param poGeneratorParameter The Generator Parameter
     * @param poLoggingStream The Logging Stream
     * @param poGeneratedClassNames The List of generated class names
     * @param poGeneratedFiles The List of generated file names
     */
    method protected void GenerateNestedTypes (pcClassName as character,
                                               poSchema as JsonObject,
                                               poApiSpec as JsonObject,
                                               poGeneratorParameter as SwaggerSchemaTypeGeneratorParameter,
                                               poLoggingStream as ILoggingStream,
                                               poGeneratedClassNames as CharacterList,
                                               poGeneratedFiles as CharacterList):

        define variable oProperties         as JsonObject                     no-undo.
        define variable oProperty           as JsonObject                     no-undo.
        define variable i                   as integer                        no-undo.
        define variable iCount              as integer                        no-undo.
        define variable cNames              as character                      no-undo extent .
        define variable cPath      	        as character                      no-undo.
        define variable cTitle              as character                      no-undo .
        define variable lEnum               as logical                        no-undo initial false .
        define variable lArray              as logical                        no-undo initial false .
        define variable lObject             as logical                        no-undo initial false .
        define variable lAllOf              as logical                        no-undo initial false .
        define variable oAllOf              as JsonArray                      no-undo .
        define variable iItem               as integer                        no-undo .
        define variable iLength             as integer                        no-undo .
        define variable oItems              as JsonObject                     no-undo .
        define variable cClassName          as character                      no-undo .
        define variable oEnumGenerator      as ISwaggerSchemaEnumGenerator    no-undo .
        define variable oClassNameGenerator as ISwaggerToAblClassNameProvider no-undo .

        assign oProperties = poSchema:GetJsonObject ("properties":u)
               cNames      = oProperties:GetNames()
               iCount      = extent(cNames).

        do i = 1 to iCount:
            assign oProperty = oProperties:GetJsonObject(cNames[i])
                   cPath     = "":u
                   cTitle    = "":u .

            if oProperty:Has ("$ref":u) then do:
                assign cPath = oProperty:GetCharacter ("$ref":u) .

                if cPath begins "#/":u then
                    assign cPath = substring (cPath, 3, -1, "character":u) .
                else
                    undo, throw new Exception (substitute ("Cannot resolve reference: &1":u, cPath), 0) .

                oProperty = JsonHelper:GetJsonObjectByPath(poApiSpec, cPath, "/":u) .
            end.

            assign lAllOf = oProperty:Has ("allOf":u).

            if oProperty:Has ("title":u) then
                assign cTitle = oProperty:GetCharacter ("title":u) .

            assign lEnum = oProperty:Has ("enum":u) .

            if oProperty:Has ("type":u) then
                assign lArray  = oProperty:GetCharacter ("type":u)  = "array":u
                       lObject =  oProperty:GetCharacter ("type":u) = "object":u .
            else
                assign lArray  = false
                       lObject = false .

            if lEnum then do:
                if cTitle > "":u then
                    assign cClassName = cTitle .
                else if cPath > "":u then
                    assign cClassName = ListHelper:LastEntry(cPath, "/":u) .
                else
                    assign cClassName = substitute ("&1&2":u, pcClassName, StringHelper:CapitalizeFirstLetter(cNames[i])) .

                if not valid-object (oEnumGenerator) then
                    assign oEnumGenerator = {Consultingwerk/get-service.i ISwaggerSchemaEnumGenerator
                                                "new SwaggerSchemaEnumGenerator ()"}.

                oEnumGenerator:Generate (cClassName,
                                         ? /* package name */,
                                         oProperty,
                                         poApiSpec,
                                         ? /* schema path */,
                                         poGeneratorParameter,
                                         poLoggingStream,
                                         poGeneratedFiles).
            end.

            if lArray then do:
                assign oItems = oProperty:GetJsonObject ("items":u)
                       cPath  = ? .

                if oItems:Has ("$ref":u) then do:
                    assign cPath = oItems:GetCharacter ("$ref":u) .

                    if cPath begins "#/":u then
                        assign cPath = substring (cPath, 3, -1, "character":u) .
                    else
                        undo, throw new Exception (substitute ("Cannot resolve reference: &1":u, cPath), 0) .

                    oItems = JsonHelper:GetJsonObjectByPath(poApiSpec, cPath, "/":u) .
                end.

                case oItems:GetCharacter("type":u):
                    when "object":u then do:
                        if oItems:Has ("properties":u) then do:
                            if oItems:Has ("title":u) then
                                assign cTitle = oItems:GetCharacter ("title":u) .

                            if cTitle > "":u then
                                assign cClassName = cTitle .
                            else if cPath > "":u then
                                assign cClassName = ListHelper:LastEntry(cPath, "/":u) .
                            else
                                assign cClassName = substitute ("&1&2":u, pcClassName, StringHelper:CapitalizeFirstLetter(cNames[i])) .

                            this-object:Generate (cClassName,
                                                  ? /*pcPackageName*/,
                                                  oItems,
                                                  poApiSpec,
                                                  cPath,
                                                  poGeneratorParameter,
                                                  poLoggingStream,
                                                  poGeneratedClassNames,
                                                  poGeneratedFiles,
                                                  true) .
                        end.
                    end.
                end case.
            end.

            if lObject then do:
                if oProperty:Has ("properties":u) then do:
                    if oProperty:Has ("title":u) then
                        assign cTitle = oProperty:GetCharacter ("title":u) .

                    if cTitle > "":u then
                        assign cClassName = cTitle .
                    else if cPath > "":u then
                        assign cClassName = ListHelper:LastEntry(cPath, "/":u) .
                    else
                        assign cClassName = substitute ("&1&2":u, pcClassName, StringHelper:CapitalizeFirstLetter(cNames[i])) .

                    this-object:Generate (cClassName,
                                          ? /*pcPackageName*/,
                                          oProperty,
                                          poApiSpec,
                                          cPath,
                                          poGeneratorParameter,
                                          poLoggingStream,
                                          poGeneratedClassNames,
                                          poGeneratedFiles) .
                end.
            end.

            if lAllOf then do:
                assign oAllOf  = oProperty:GetJsonArray ("allOf":u)
                       iLength = oAllOf:Length .

                do iItem = 1 to iLength:
                    assign cPath = oAllOf:GetJsonObject(iItem):GetCharacter ("$ref":u) .

                    if cPath begins "#/":u then
                        assign cPath = substring (cPath, 3, -1, "character":u) .
                    else
                        undo, throw new Exception (substitute ("Cannot resolve reference: &1":u, cPath), 0) .

                    oProperty = JsonHelper:GetJsonObjectByPath(poApiSpec, cPath, "/":u) .

                    oClassNameGenerator = {Consultingwerk/get-service.i ISwaggerToAblClassNameProvider
                                                "new SwaggerToAblClassNameProvider ()"}.

                    cClassName = oClassNameGenerator:GetClassName (poApiSpec,
                                                            cPath,
                                                            poGeneratorParameter):FullName .

                    this-object:Generate (cClassName,
                                          ? /*pcPackageName*/,
                                          oAllOf:GetJsonObject(iItem),
                                          poApiSpec,
                                          cPath,
                                          poGeneratorParameter,
                                          poLoggingStream,
                                          poGeneratedClassNames,
                                          poGeneratedFiles,
                                          true) .
                end.
            end.
        end.

    end method .

end class.
