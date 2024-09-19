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
    File        : SwaggerToAblHelper
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu May 02 10:27:30 CET 2024
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.*                     from propath.
using Consultingwerk.Exceptions.*          from propath.
using Consultingwerk.Studio.*              from propath.
using Consultingwerk.Studio.SwaggerToAbl.* from propath.
using Consultingwerk.Util.*                from propath.
using Consultingwerk.Util.LoggingStream.*  from propath.
using Progress.Json.ObjectModel.*          from propath.

{Consultingwerk/products.i}

class Consultingwerk.Studio.SwaggerToAbl.SwaggerToAblHelper:

    /**
     * Purpose: Returns the properties JsonObject
     * Notes:   Raises a qualified error message when properties is not available
     * @param poSchema The Swagger Schema Object
     * @param poApiSpec The API specification
     * @return The properties JsonObject
     */
    method public static JsonObject GetProperties (poSchema as JsonObject,
                                                   poApiSpec as JsonObject):

        define variable pcJsonPath as character no-undo.

        if poSchema:Has ("$ref":u) then do:
            assign pcJsonPath = poSchema:GetCharacter ("$ref":u) .

            if pcJsonPath begins "#/":u then
                assign pcJsonPath = substring (pcJsonPath, 3, -1, "character":u) .
            else
                undo, throw new Exception (substitute ("Cannot resolve reference: &1":u, pcJsonPath), 0) .

            poSchema = JsonHelper:GetJsonObjectByPath(poApiSpec, pcJsonPath, "/":u) .
        end.

        return SwaggerToAblHelper:GetJsonObject(poSchema, "properties":u) .

    end method .

    /**
     * Purpose: Returns the properties JsonObject
     * Notes:   Raises a qualified error message when properties is not available
     * @param poSchema The JSON Object
     * @param pcPropertyName The name of the property to return
     * @return The JsonObject
     */
    method public static JsonObject GetJsonObject (poSchema as JsonObject,
                                                   pcPropertyName as character):

        if poSchema:Has (pcPropertyName) then
            return poSchema:GetJsonObject(pcPropertyName) .

        undo, throw new Exception (substitute ("'&1' is not available in the JsonObject~n~n&2"{&tran},
                                               pcPropertyName,
                                               JsonHelper:ToCharacter(poSchema)), 0).

    end method .

    /**
     * Purpose: Invokes an active template for a schema type
     * Notes:
     * @param pcTemplateFile The template file
     * @param poClassName The class name
     * @param poSchema The Swagger Schema Object
     * @param poApiSpec The API documentation object
     * @param poGeneratorParameter The Generator Parameter
     * @param poLoggingStream The Logging Stream
     * @return The generated file name
     */
    method public static character InvokeTemplate (pcTemplateFile       as character,
                                                   poClassName          as ClassName,
                                                   poSchema             as JsonObject,
                                                   poApiSpec            as JsonObject,
                                                   poGeneratorParameter as SwaggerSchemaTypeGeneratorParameter,
                                                   poLoggingStream      as ILoggingStream):

        define variable cTemplateFile  as character no-undo.
        define variable cOptions       as character no-undo.
        define variable cOutputFile    as character no-undo.
        define variable cGeneratedFile as character no-undo.

        assign cTemplateFile = FileHelper:FindFile (FileHelper:CombinePath ("Consultingwerk/Studio/SwaggerToAbl/Templates":U,
                                                                            pcTemplateFile),
                                                    true)
               cOutputFile   = session:temp-directory + FileHelper:ReplaceFileExtension(pcTemplateFile, "w":u) .

        run Consultingwerk/Studio/SwaggerToAbl/template-gen.p (cTemplateFile,
                                                               input-output cOptions,
                                                               input-output cOutputFile,
                                                               "Consultingwerk/Studio/SwaggerToAbl/template-schema-type.i":u) .

        CompilerHelper:CompileFile (cOutputFile, session:temp-directory) .

        run value (cOutputFile) (poClassName,
                                 poSchema,
                                 poApiSpec,
                                 poGeneratorParameter,
                                 poLoggingStream,
                                 output cGeneratedFile) .

        return cGeneratedFile .

        finally:
            os-delete value (cOutputFile).
            os-delete value (FileHelper:ReplaceFileExtension(cOutputFile, "r":U)) .
        end finally.

    end method .

    /**
     * Purpose: Resolves as $ref
     * Notes:
     * @param poApiSpec The API documentation object
     * @param poProperty The JSON Object describing the current property
     * @return The resolved $ref
     */
    method public static JsonObject ResolveRef (poApiSpec as JsonObject,
                                                poProperty as JsonObject):

        define variable cPath as character no-undo.

        assign cPath = poProperty:GetCharacter ("$ref":u) .

        if cPath begins "#/":u then
            assign cPath = substring (cPath, 3, -1, "character":u) .
        else
            undo, throw new Exception (substitute ("Cannot resolve reference: &1":u, cPath), 0) .

        return JsonHelper:GetJsonObjectByPath(poApiSpec, cPath, "/":u) .

    end method .

    /**
     * Purpose: Returns the ABL DataType for the given properties of the JSON schema object
     * Notes:
     * @param pcBasePackage The base package for the API
     * @param pcClassName The name of the referencing class
     * @param pcPropertyName The name of the property
     * @param poSchema The JSON schema object
     * @param poApiSpec The API documentation object
     * @param poGeneratorParameter The Generator Parameter (ISwaggerBasePackageParameter)
     * @return The ABL data type
     */
    method public static character ToAblDataType (pcBasePackage as character,
                                                  pcClassName as character,
                                                  pcPropertyName as character,
                                                  poSchema as JsonObject,
                                                  poApiSpec as JsonObject,
                                                  poGeneratorParameter as ISwaggerBasePackageParameter):

        define variable oProperty          as JsonObject                     no-undo .
        define variable cType              as character                      no-undo .
        define variable cFormat            as character                      no-undo .
        define variable cTitle             as character                      no-undo .
        define variable lEnum              as logical                        no-undo initial false .
        define variable lArray             as logical                        no-undo initial false .
        define variable lObject            as logical                        no-undo initial false .
        define variable lAllOf             as logical                        no-undo initial false .
        define variable oAllOf             as JsonArray                      no-undo .
        define variable oItems             as JsonObject                     no-undo .
        define variable cPath              as character                      no-undo .
        define variable cClassName         as character                      no-undo .
        define variable oException         as Exception                      no-undo .
        define variable oClassNameProvider as ISwaggerToAblClassNameProvider no-undo .

        oProperty = poSchema:GetJsonObject (pcPropertyName) .

        if oProperty:Has ("$ref":u) then do:
            /* required by Enum */
            assign cPath = oProperty:GetCharacter ("$ref":u) .

            oProperty = SwaggerToAblHelper:ResolveRef(poApiSpec, oProperty).
        end.

        if oProperty:Has ("type":u) then
            assign cType = oProperty:GetCharacter ("type":u) .

        if oProperty:Has ("allOf":u) then
            assign lAllOf = true.

        if cType = "array":u then
            assign lArray = true .

        if cType = "object":u then
            assign lObject = true .

        if oProperty:Has ("format":u) then
            assign cFormat = oProperty:GetCharacter ("format":u) .

        assign lEnum = oProperty:Has ("enum":u) .

        if oProperty:Has ("title":u) then
            assign cTitle = oProperty:GetCharacter ("title":u) .

        if lEnum then do:
            if cTitle > "":u then
                return cTitle .

            if cPath > "":u then
                return ListHelper:LastEntry(cPath, "/":u) .

            return substitute ("&1&2":u, pcClassName, StringHelper:CapitalizeFirstLetter(pcPropertyName)) .
        end.

        if lArray then do:
            assign oItems = oProperty:GetJsonObject ("items":u) .

            if oItems:Has ("$ref":u) then do:
                assign cPath = oItems:GetCharacter ("$ref":u) .

                oItems = SwaggerToAblHelper:ResolveRef(poApiSpec, oItems).
            end.

            assign cType = oItems:GetCharacter ("type":u) .

            if oItems:Has ("format":u) then
                assign cFormat = oItems:GetCharacter ("format":u) .

            case oItems:GetCharacter ("type":u):
                when "object":u then do:
                    if oItems:Has ("title":u) then
                        return substitute ("&1 EXTENT":u, oItems:GetCharacter ("title":u)) .

                    if cPath > "" then do:
                        assign cClassName = ListHelper:LastEntry(cPath, "/":u) .

                        if index (cClassName, ".":u) > 0 then
                            assign cClassName = substitute ("&1.&2":u, pcBasePackage, cClassName) .

                        return substitute ("&1 EXTENT":u, cClassName) .
                    end.

                    return substitute ("&1&2 EXTENT":u, pcClassName, StringHelper:CapitalizeFirstLetter(pcPropertyName)) .
                end.
                when "array":u then do:
                    undo, throw new Exception ("Currently no support for nested arrays":u, 0) .
                end.
                otherwise
                    return substitute ("&1 EXTENT":u, SwaggerToAblHelper:ToAblDataType (cType, cFormat)) .
            end case.
        end.

        if lObject then do:
            if oProperty:Has ("$ref":u) then do:
                assign cPath = oProperty:GetCharacter ("$ref":u) .

                assign oProperty = SwaggerToAblHelper:ResolveRef(poApiSpec, oProperty) .
            end.

            if oProperty:Has ("additionalProperties":u) then
                return "Progress.Json.ObjectModel.JsonObject":u .

            if oProperty:Has ("title":u) then
                return oProperty:GetCharacter ("title":u) .

            if cPath > "" then do:
                assign cClassName = ListHelper:LastEntry(cPath, "/":u) .

                if index (cClassName, ".":u) > 0 then
                    assign cClassName = substitute ("&1.&2":u, pcBasePackage, cClassName) .

                return cClassName .
            end.

            return substitute ("&1&2":u, pcClassName, StringHelper:CapitalizeFirstLetter(pcPropertyName)) .
        end.

        if lAllOf then do:
            oAllOf = oProperty:GetJsonArray ("allOf":u) .

            if oAllOf:Length = 1 then do:
                assign cPath = oAllOf:GetJsonObject (1):GetCharacter ("$ref":u)
                       oClassNameProvider = {Consultingwerk/get-service.i ISwaggerToAblClassNameProvider
                                                    "NEW SwaggerToAblClassNameProvider()"}.

                if cPath begins "#/":u then
                    assign cPath = substring (cPath, 3, -1, "character":u) .

                return oClassNameProvider:GetClassName (poApiSpec,
                                                        cPath,
                                                        poGeneratorParameter):FullName .
            end.
            else
                return substitute ("&1.I&2&3":u,
                                    pcBasePackage,
                                    pcClassName,
                                    pcPropertyName) .
        end.

        return SwaggerToAblHelper:ToAblDataType (cType, cFormat) .

        catch err as Progress.Lang.Error:
            oException = new Exception (err,
                                        substitute ("Error processing property: &1:&2":u,
                                                    pcClassName,
                                                    pcPropertyName),
                                        0) .

            oException:AddMessagesFrom (err) .

            undo, throw oException  .
        end catch .

    end method .

    /**
     * Purpose: Returns the ABL DataType based on type and format
     * Notes:
     * @param pcType The type of the property
     * @param pcFormat The format of the property
     * @return The ABL DataType
     */
    method public static character ToAblDataType (pcType as character,
                                                  pcFormat as character):

        if pcType = "boolean":u then
            return "LOGICAL":u .

        if pcType = "integer":u then do:
            if pcFormat = "int32":u then
                return "INTEGER":u .
            else
                return "INT64":u .
        end.

        if pcType = "number":u then
            return "DECIMAL":u .

        if pcType = "string":u then do:
            case pcFormat:
                when "date-time":u then
                    return "DATETIME":u .
                when "date":u then
                    return "DATE":u .
                when "time":u then
                    return "CHARACTER":u .
                otherwise
                    return "CHARACTER":u .
            end case .
        end.

        undo, throw new Exception (substitute ("Unknown type: &1 &2":u, pcType, pcFormat), 0).

    end method.

end class .
