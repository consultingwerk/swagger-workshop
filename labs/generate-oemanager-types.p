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
    File        : generate-oemanager-p
    Purpose     : Generator for types of the oemanager Swagger
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2024-09-19
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.*                       from propath.
using Consultingwerk.Assertion.*             from propath.
using Consultingwerk.Exceptions.*            from propath.
using Consultingwerk.Framework.Collections.* from propath.
using Consultingwerk.Studio.SwaggerToAbl.*   from propath.
using Consultingwerk.Util.LoggingStream.*    from propath.
using Progress.Json.ObjectModel.*            from propath.
using Consultingwerk.Util.*                  from propath.

define variable oSpec                as JsonObject                          no-undo.
define variable oGenerator           as SwaggerSchemaObjectGenerator        no-undo.
define variable oParameter           as SwaggerSchemaTypeGeneratorParameter no-undo.
define variable oLogging             as FileLoggingStream                   no-undo.
define variable oGeneratedClassNames as CharacterList                       no-undo.
define variable oGeneratedFiles      as CharacterList                       no-undo.
define variable oPaths               as JsonObject                          no-undo.
define variable oPath                as JsonObject                          no-undo.
define variable i                    as integer                             no-undo.
define variable j                    as integer                             no-undo.
define variable iCount               as integer                             no-undo.
define variable cPath                as character                           no-undo.

session:error-stack-trace = true.

oSpec = cast (JsonHelper:ParseFile ("specs\OeManager\openapi-128.json"),
                 JsonObject).

oLogging = new FileLoggingStream ("generator.log") .
oGeneratedFiles = new CharacterList() .
oGeneratedClassNames = new CharacterList() .

oGenerator = new SwaggerSchemaObjectGenerator().

oParameter = new SwaggerSchemaTypeGeneratorParameter() .

assign oParameter:BasePackage    = "Samples.OeManager.Client"
       oParameter:NestedPackages = true.

assign cPath = "paths/~~/applications~~/~{AppName}~~/webapps~~/~{WebAppName}~~/transports~~/apsv~~/properties/put/requestBody/content/application~~/vnd.progress+json/schema".

message "Processing:" cPath .

oGenerator:Generate (? /* class name*/,
                    ? /* package name*/,
                    ? /* schema */,
                    oSpec,
                    cPath,
                    oParameter,
                    oLogging,
                    oGeneratedClassNames,
                    oGeneratedFiles) .

catch paramserr as InvalidParameterValueException:
    if paramserr:ClassName = "Consultingwerk.Util.JsonHelper" then
        message "skipping" cPath "as it is not a valid path" .
    else
        undo, throw paramserr .
end.

catch err as Progress.Lang.Error:
    message err:GetMessage(1).
    message err:CallStack.
end catch.