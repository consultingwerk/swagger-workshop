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

using Consultingwerk.*                     from propath.
using Consultingwerk.Exceptions.*          from propath.
using Consultingwerk.Studio.SwaggerToAbl.* from propath.
using Consultingwerk.Util.*                from propath.
using Progress.Json.ObjectModel.*          from propath.

{Consultingwerk/products.i}

class Consultingwerk.Studio.SwaggerToAbl.SwaggerToAblClassNameProvider
    implements ISwaggerToAblClassNameProvider:

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
                                          poGeneratorParameter as ISwaggerBasePackageParameter):

        return this-object:GetClassName (poApiSpec,
                                         pcJsonPath,
                                         poGeneratorParameter,
                                         false).

    end method .

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
                                          plResolveArrays as logical):

        define variable cClassName   as character  no-undo.
        define variable oSchema      as JsonObject no-undo.
        define variable cPath        as character  no-undo.
        define variable oPath        as JsonObject no-undo.
        define variable cOperation   as character  no-undo.
        define variable cRequest     as character  no-undo.
        define variable i            as integer    no-undo.
        define variable iCount       as integer    no-undo.
        define variable cSuffix      as character  no-undo.
        define variable iIndex       as integer    no-undo.
        define variable oClassName   as ClassName  no-undo.

        assign pcJsonPath = replace (pcJsonPath, "~~.":u, ".":u) .

        /*                    1234567890123456789 */
        if pcJsonPath begins "components/schemas/":u then do:
            cClassName = substitute ("&1.&2":u,
                                     poGeneratorParameter:BasePackage,
                                     replace (substring (pcJsonPath, 20, -1, "character":u),
                                                         "/":u, ".":u)).

            /* .NET generic type representation */
            assign iIndex = index (cClassName, "`":u) .

            if iIndex > 0 and
               substring (cClassName, iIndex + 2, 1, "character":U) = "[":u and
               substring (cClassName, length (cClassName, "character":u), 1, "character":U) = "]":u then do:
                if substring (cClassName, iIndex + 1, 1, "character":U) <> "1":u then
                    undo, throw new Exception (substitute ("Unsupported .NET generic type representation: &1":u,
                                                           cClassName), 0).

                assign cClassName = right-trim (cClassName, "]":u)
                       cClassName = substitute ("&1_&2":u,
                                                substring (cClassName, 1, iIndex - 1, "character":U),
                                                replace (substring (cClassName, iIndex + 3, -1, "character":U),
                                                         ".":u,
                                                         "_":u)) .
            end.

            return ClassHelper:SplitClassName(cClassName) .
        end.

        oSchema = JsonHelper:GetJsonObjectByPath(poApiSpec, pcJsonPath, "/":u).

        if oSchema:Has ("type":u) and oSchema:GetCharacter("type":u) = "array":u then do:
            assign oSchema = oSchema:GetJsonObject("items":u).

            if oSchema:Has ("$ref":u) then do:
                assign cPath = oSchema:GetCharacter("$ref":u).

                if cPath begins "#/":u then
                    assign cPath = substring (cPath, 3, -1, "character":u) .

                oClassName = this-object:GetClassName (poApiSpec,
                                                       cPath,
                                                       poGeneratorParameter,
                                                       false).

                oClassName:IsExtent = true.

                return oClassName.
            end.
        end.

        if oSchema:Has ("title":u) then do:
            assign cClassName = substitute ("&1.&2":u,
                                            poGeneratorParameter:BasePackage,
                                            oSchema:GetCharacter("title":u)).
            return ClassHelper:SplitClassName(cClassName) .
        end.

        if pcJsonPath begins "paths/":u then do:
            cPath = replace (pcJsonPath, "~~/":u, chr(1)) .

            if ListHelper:LastEntry(cPath, "/":u) = "schema":u and
               (entry (4, cPath, "/":u) = "requestBody":u or
                entry (4, cPath, "/":u) = "responses":u) then do:

                if entry (4, cPath, "/":u) = "requestBody":u then
                    assign cSuffix = "Body":U .
                else
                    assign cSuffix = "Response":U.

                oPath = JsonHelper:GetJsonObjectByPath (poApiSpec,
                                                        replace (ListHelper:ListToEntry(cPath, 3, "/":u),
                                                                 chr(1),
                                                                 "~~/":u),
                                                        "/":u).
                if oPath:Has ("operationId":u) then
                    cOperation = oPath:GetCharacter("operationId":u).

                if cOperation > "":u then
                    return ClassHelper:SplitClassName (substitute ("&1.&2&3":u,
                                                                   poGeneratorParameter:BasePackage,
                                                                   cOperation,
                                                                   cSuffix)) .

                assign cRequest   = StringHelper:CapitalizeFirstLetter(lc(entry (3, cPath, "/":u)))
                       cOperation = trim (replace (entry (2, cPath, "/":u), chr(1), ",":u), ",":u)
                       iCount     = num-entries (cOperation).

                do i = 2 to iCount:
                    assign entry (i, cOperation) = StringHelper:CapitalizeFirstLetter(entry (i, cOperation, ",":u)) .
                end.

                return ClassHelper:SplitClassName (substitute ("&1.&2&3&4":u,
                                                                poGeneratorParameter:BasePackage,
                                                                replace (cOperation, ",":u, "":u),
                                                                cRequest,
                                                                cSuffix)) .
            end.
        end.

        undo, throw new Exception (substitute ("Unable to determine ABL Class Name for path: &1"{&tran},
                                               pcJsonPath),
                                   0) .

    end method.

end class.
