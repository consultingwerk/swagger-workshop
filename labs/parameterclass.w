/*E4GL-W*/ {Consultingwerk/Studio/SwaggerToAbl/template-schema-type.i}  /*Tag=<%*/  DEFINE VARIABLE i              AS INTEGER          NO-UNDO. /*Tag=%>*/ 
 /*Tag=<%*/  DEFINE VARIABLE iCount         AS INTEGER          NO-UNDO. /*Tag=%>*/ 
 /*Tag=<%*/  DEFINE VARIABLE cProperties    AS CHARACTER EXTENT NO-UNDO. /*Tag=%>*/ 
 /*Tag=<%*/  DEFINE VARIABLE oProperties    AS JsonObject       NO-UNDO. /*Tag=%>*/ 
 /*Tag=<%*/  DEFINE VARIABLE oProperty      AS JsonObject       NO-UNDO. /*Tag=%>*/ 
 /*Tag=<%*/  DEFINE VARIABLE lcDescription  AS LONGCHAR         NO-UNDO. /*Tag=%>*/ 
 /*Tag=<%*/  DEFINE VARIABLE lcDescription2 AS LONGCHAR EXTENT  NO-UNDO. /*Tag=%>*/ 
 /*Tag=<%*/  FIX-CODEPAGE(lcDescription) = "UTF-8":U. /*Tag=%>*/ 
 /*Tag=<%*/  oProperties = SwaggerToAblHelper:GetProperties (poSchema, poApiSpec) . /*Tag=%>*/ 
 /*Tag=<%*/  cProperties = oProperties:GetNames() . /*Tag=%>*/ 
 /*Tag=<%*/  iCount = EXTENT (cProperties) . /*Tag=%>*/ 
 /*Tag=<%*/  EXTENT (lcDescription2) = iCount . /*Tag=%>*/ 
{&OUT} '/*------------------------------------------------------------------------~n'.
{&OUT} '    File        : ' /*Tag=<%=*/  poClassName:ClassName SKIP(0) /*Tag=%>*/ .
{&OUT} '    Purpose     :~n'.
{&OUT} '    Syntax      :~n'.
{&OUT} '    Description :~n'.
{&OUT} '    Author(s)   :~n'.
{&OUT} '    Created     : ' /*Tag=<%=*/  STRING(NOW, "99.99.9999 HH:MM:SS") SKIP(0) /*Tag=%>*/ .
{&OUT} '    Notes       :~n'.
{&OUT} '  ----------------------------------------------------------------------*/' /*Tag=<%=*/  SKIP(1) /*Tag=%>*/ .
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} 'BLOCK-LEVEL ON ERROR UNDO, THROW.~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} '~{Consultingwerk/products.i~}' /*Tag=<%=*/  SKIP(1) /*Tag=%>*/ .
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} 'USING Consultingwerk.*                          FROM PROPATH .~n'.
{&OUT} 'USING Consultingwerk.Framework.Collections.*    FROM PROPATH .~n'.
{&OUT} 'USING ' /*Tag=<%=*/  poClassName:PackageName /*Tag=%>*/ '.*' /*Tag=<%=*/  FILL (' ', MAX (1, 40 - LENGTH (poClassName:PackageName, "CHARACTER"))) /*Tag=%>*/ 'FROM PROPATH .~n'.
{&OUT} 'USING Progress.Lang.*                           FROM PROPATH .~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} 'CLASS ' /*Tag=<%=*/  poClassName:PackageName /*Tag=%>*/ '.' /*Tag=<%=*/  poClassName:ClassName SKIP (0) /*Tag=%>*/ .
{&OUT} '    INHERITS ParameterObject~n'.
{&OUT} '    IMPLEMENTS IValueObjectValidatorWithMessages~n'.
{&OUT} '    SERIALIZABLE:~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
 /*Tag=<%*/  DO i = 1 TO iCount: /*Tag=%>*/ 
 /*Tag=<%*/     ASSIGN oProperty = oProperties:GetJsonObject(cProperties[i]) . /*Tag=%>*/ 
 /*Tag=<%*/     IF oProperty:Has ("description":u) THEN DO: /*Tag=%>*/ 
 /*Tag=<%*/        ASSIGN lcDescription  = oProperty:GetLongchar ("description":u) no-error. /*Tag=%>*/ 
 /*Tag=<%*/        IF ERROR-STATUS:ERROR THEN /*Tag=%>*/ 
 /*Tag=<%*/           ASSIGN lcDescription  = oProperty:GetJsonText ("description":u) . /*Tag=%>*/ 

 /*Tag=<%*/        ASSIGN lcDescription2[i] = substring(StringHelper:Indent(replace(replace(replace (CodepageHelper:ConvertToCodePage (lcDescription,
                                                                                                                             SESSION:CPINTERNAL),
                                          "\n":u, "~n":u),
                                          "/*":u, "/ *":u),
                                          "*/":u, "* /":u),
                                          16),
                                          17, -1, "character") . /*Tag=%>*/ 
{&OUT} '    /**~n'.
{&OUT} '     * Purpose: ' /*Tag=<%=*/  right-trim(STRING(lcDescription2[i])) SKIP(0) /*Tag=%>*/ .
{&OUT} '     */~n'.
 /*Tag=<%*/     END. /*Tag=%>*/ 
{&OUT} '    DEFINE PUBLIC PROPERTY ' /*Tag=<%=*/  cProperties[i] /*Tag=%>*/ ' AS ' /*Tag=<%=*/  AblDataType (cProperties[i], oProperties) /*Tag=%>*/ ' NO-UNDO~n'.
{&OUT} '    GET.~n'.
{&OUT} '    SET.~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
 /*Tag=<%*/  END. /*Tag=%>*/ 
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} '    /*------------------------------------------------------------------------------~n'.
{&OUT} '        Purpose: Constructor for the ' /*Tag=<%=*/  poClassName:ClassName /*Tag=%>*/ ' class~n'.
{&OUT} '        Notes:~n'.
{&OUT} '    ------------------------------------------------------------------------------*/~n'.
{&OUT} '    CONSTRUCTOR PUBLIC ' /*Tag=<%=*/  poClassName:ClassName /*Tag=%>*/ ' ():~n'.
{&OUT} '        SUPER ().~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} '        THIS-OBJECT:UseSerializedTypeInformation = FALSE.~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} '    END CONSTRUCTOR.~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .

{&OUT} '    /*------------------------------------------------------------------------------~n'.
{&OUT} '        Purpose: Constructor for the ' /*Tag=<%=*/  poClassName:ClassName /*Tag=%>*/ ' class~n'.
{&OUT} '        Notes:~n'.
 /*Tag=<%*/  DO i = 1 TO iCount: /*Tag=%>*/ 
{&OUT} '        @param p' /*Tag=<%=*/  StringHelper:CapitalizeFirstLetter(cProperties[i]) /*Tag=%>*/ ' ' /*Tag=<%=*/  IF lcDescription2[i] > "" THEN RIGHT-TRIM (ENTRY(1, STRING(lcDescription2[i]), "~n")) ELSE SUBSTITUTE ("The value for the &1 property", cProperties[i]) SKIP(0) /*Tag=%>*/ .
 /*Tag=<%*/  END. /*Tag=%>*/ 
{&OUT} '    ------------------------------------------------------------------------------*/~n'.
{&OUT} '    CONSTRUCTOR PUBLIC ' /*Tag=<%=*/  poClassName:ClassName /*Tag=%>*/ ' (~n'.
 /*Tag=<%*/  DO i = 1 TO iCount: /*Tag=%>*/ 
{&OUT} '        p' /*Tag=<%=*/  StringHelper:CapitalizeFirstLetter(cProperties[i]) /*Tag=%>*/ ' AS ' /*Tag=<%=*/  AblDataType (cProperties[i], oProperties) /*Tag=%>*/ '' /*Tag=<%=*/  IF i < iCount THEN ",":u ELSE "):":u SKIP(0) /*Tag=%>*/ .
 /*Tag=<%*/  END. /*Tag=%>*/ 
{&OUT} '' /*Tag=<%=*/  '' SKIP(1) /*Tag=%>*/ .
{&OUT} '        THIS-OBJECT ().~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} '        ASSIGN~n'.
 /*Tag=<%*/  DO i = 1 TO iCount: /*Tag=%>*/ 
{&OUT} '            THIS-OBJECT:' /*Tag=<%=*/  cProperties[i] /*Tag=%>*/ ' = p' /*Tag=<%=*/  StringHelper:CapitalizeFirstLetter(cProperties[i]) /*Tag=%>*/ '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
 /*Tag=<%*/  END. /*Tag=%>*/ 
{&OUT} '            .~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} '    END CONSTRUCTOR.~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} '    /**~n'.
{&OUT} '     * Purpose: Validates the properties of the given value object~n'.
{&OUT} '     * Notes:~n'.
{&OUT} '     * @param poValueObject The value object to validate~n'.
{&OUT} '     * @return CharacterDictionary of validation messages, when the dictionary is unknown or empty, validation was successful~n'.
{&OUT} '     */~n'.
{&OUT} '    METHOD PUBLIC CharacterDictionary IsValid (poValueObject AS Progress.Lang.Object):~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} '        DEFINE VARIABLE oMessages AS CharacterDictionary NO-UNDO.~n'.
{&OUT} '        DEFINE VARIABLE oObject   AS ' /*Tag=<%=*/  poClassName:ClassName /*Tag=%>*/ ' NO-UNDO.~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} '        ASSIGN oObject = CAST (poValueObject, ' /*Tag=<%=*/  poClassName:ClassName /*Tag=%>*/ ').~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
 /*Tag=<%*/   DO i = 1 TO iCount:
        ASSIGN oProperty = oProperties:GetJsonObject(cProperties[i]) .

        IF oProperty:Has ("type") THEN DO:
            CASE oProperty:GetCharacter ("type"):
                WHEN "string" THEN DO:
                    IF oProperty:Has ("maxLength") THEN DO: /*Tag=%>*/ 
{&OUT} '        IF LENGTH (oObject:' /*Tag=<%=*/  cProperties[i] /*Tag=%>*/ ', "CHARACTER":U) > ' /*Tag=<%=*/  oProperty:GetInteger ("maxLength") /*Tag=%>*/ ' THEN~n'.
{&OUT} '            oMessages:Add ("' /*Tag=<%=*/  cProperties[i] /*Tag=%>*/ '":u, "Exceeds ' /*Tag=<%=*/  oProperty:GetInteger ("maxLength") /*Tag=%>*/ ' characters."~{&tran~}) .~n'.
 /*Tag=<%*/                   END.
                END.
            END CASE .
        END.
    END.

    DEFINE VARIABLE oRequired AS JsonArray NO-UNDO.
    DEFINE VARIABLE cRequired AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDataType AS CHARACTER NO-UNDO.

    IF poSchema:Has ("required") THEN DO:
        oRequired = poSchema:GetJsonArray ("required") .
        iCount = oRequired:Length .

        DO i = 1 TO iCount:
            ASSIGN cRequired = oRequired:GetCharacter(i)
                   cDataType = AblDataType (cRequired, oProperties) .

            IF NUM-ENTRIES (cDataType, " ":U) > 1 THEN DO: /*Tag=%>*/ 

{&OUT} '        IF EXTENT(oObject:' /*Tag=<%=*/  cRequired /*Tag=%>*/ ') = ? THEN~n'.
{&OUT} '            oMessages:Add ("' /*Tag=<%=*/  cRequired /*Tag=%>*/ '":u, "Missing value for ' /*Tag=<%=*/  cRequired /*Tag=%>*/ '."~{&tran~}) .~n'.

 /*Tag=<%*/   END.
            ELSE DO:
            CASE cDataType:
                WHEN "character":U THEN DO: /*Tag=%>*/ 
{&OUT} '        IF oObject:' /*Tag=<%=*/  cRequired /*Tag=%>*/ ' = "":U OR oObject:' /*Tag=<%=*/  cRequired /*Tag=%>*/ ' = ? THEN~n'.
{&OUT} '            oMessages:Add ("' /*Tag=<%=*/  cRequired /*Tag=%>*/ '":u, "Missing value for ' /*Tag=<%=*/  cRequired /*Tag=%>*/ '."~{&tran~}) .~n'.
 /*Tag=<%*/               END. /*Tag=%>*/ 
 /*Tag=<%*/               WHEN "date":U OR WHEN "datetime":U OR WHEN "datetime-tz":U OR WHEN "decimal":U OR WHEN "integer":U OR WHEN "int64" OR WHEN "logical" THEN DO: /*Tag=%>*/ 
{&OUT} '        IF oObject:' /*Tag=<%=*/  cRequired /*Tag=%>*/ ' = ? THEN~n'.
{&OUT} '            oMessages:Add ("' /*Tag=<%=*/  cRequired /*Tag=%>*/ '":u, "Missing value for ' /*Tag=<%=*/  cRequired /*Tag=%>*/ '."~{&tran~}) .~n'.
 /*Tag=<%*/               END. /*Tag=%>*/ 
 /*Tag=<%*/               OTHERWISE DO: /*Tag=%>*/ 
{&OUT} '        IF NOT VALID-OBJECT(oObject:' /*Tag=<%=*/  cRequired /*Tag=%>*/ ') THEN~n'.
{&OUT} '            oMessages:Add ("' /*Tag=<%=*/  cRequired /*Tag=%>*/ '":u, "Missing value for ' /*Tag=<%=*/  cRequired /*Tag=%>*/ '."~{&tran~}) .~n'.
 /*Tag=<%*/               END. /*Tag=%>*/ 
 /*Tag=<%*/           END CASE . /*Tag=%>*/ 
 /*Tag=<%*/           END. /*Tag=%>*/ 
 /*Tag=<%*/       END. /*Tag=%>*/ 
 /*Tag=<%*/   END. /*Tag=%>*/ 
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} '        RETURN oMessages .~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} '    END METHOD.~n'.
{&OUT} '' /*Tag=<%=*/  '' SKIP /*Tag=%>*/ .
{&OUT} 'END CLASS.~n'.
/************************* END OF HTML *************************/
/*
** File: C:\Work\SwaggerWorkshop\swagger-workshop\labs\parameterclass.w
** Generated on: 2024-09-19 23:41:14
** By: WebSpeed Embedded SpeedScript Preprocessor
** Version: 2
** Source file: C:\Work\SwaggerWorkshop\swagger-workshop\SmartComponentLibrary\Consultingwerk\Studio\SwaggerToAbl\Templates\parameterclass.template
** Options: web-object
**
** WARNING: DO NOT EDIT THIS FILE.  Make changes to the original
** HTML file and regenerate this file from it.
**
*/
/********************* Internal Definitions ********************/

/* This procedure returns the generation options at runtime.
   It is invoked by src/web/method/e4gl.i included at the start
   of this file. */
PROCEDURE local-e4gl-options :
  DEFINE OUTPUT PARAMETER p_version AS DECIMAL NO-UNDO
    INITIAL 2.0.
  DEFINE OUTPUT PARAMETER p_options AS CHARACTER NO-UNDO
    INITIAL "web-object":U.
  DEFINE OUTPUT PARAMETER p_content-type AS CHARACTER NO-UNDO
    INITIAL "text/html":U.
END PROCEDURE.

/* end */
