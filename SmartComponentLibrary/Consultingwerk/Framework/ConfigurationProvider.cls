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
    File        : ConfigurationProvider
    Purpose     : Configuration provider based on a JSON file or document
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Jan 20 16:22:28 CET 2013
    Notes       : Supported from OpenEdge 11.x only
                  Contents of the JSON file/document can be overridden using
                  the -param Startup parameter for the OpenEdge session.
                  The -param parameter is expected to contain value in the form of
                  -param @setting1=value1,@setting2=value2
                  The -param parameter may contain other settings as well. Settings not
                  starting with the @ sign will be ignored by the ConfigurationProvider
                  class. So a startup settings of -param @authenticationDb=sports2000
                  will override the setting from the JSON file
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Consultingwerk.*                       FROM PROPATH .
USING Consultingwerk.Framework.*             FROM PROPATH .
USING Consultingwerk.Framework.Collections.* FROM PROPATH.
USING Consultingwerk.Util.*                  FROM PROPATH .
USING Progress.Json.ObjectModel.*            FROM PROPATH .
USING Progress.Lang.*                        FROM PROPATH .

CLASS Consultingwerk.Framework.ConfigurationProvider
    IMPLEMENTS IConfigurationProvider:

    DEFINE VARIABLE oListNameValuePair AS ListNameValuePair NO-UNDO .
    DEFINE VARIABLE cNames             AS CHARACTER         NO-UNDO EXTENT .

    /**
     * Purpose: Constructor for the ConfigurationProvider class
     * Notes:
     * @param pcFileName The file name to read configuration data from
     */
    CONSTRUCTOR PUBLIC ConfigurationProvider (pcFileName AS CHARACTER):

        DEFINE VARIABLE oJsonObject AS JsonObject NO-UNDO .

        SUPER ().

        Consultingwerk.Assertion.FileAssert:Exists (pcFileName) .

        FILE-INFORMATION:FILE-NAME = pcFileName .

        LogManager:WriteMessage(SUBSTITUTE ("########################################################################~n":U +
                                            "### Loading configuration~n":U +
                                            "###    File Name:          &1~n":U +
                                            "###    Absolute File Name: &2~n":U +
                                            "########################################################################~n":U,
                                            pcFileName,
                                            FILE-INFORMATION:FULL-PATHNAME), "ConfigurationProvider":U) .

        oJsonObject = CAST (JsonHelper:ParseFile(FILE-INFORMATION:FULL-PATHNAME),
                            JsonObject) .

        THIS-OBJECT:Initialize (oJsonObject).

    END CONSTRUCTOR .

    /**
     * Purpose: Constructor for the ConfigurationProvider class
     * Notes:
     * @param poConfiguration The JSON Object with configuration values
     */
    CONSTRUCTOR PUBLIC ConfigurationProvider (poConfiguration AS JsonObject):

        THIS-OBJECT:Initialize (poConfiguration) .

    END CONSTRUCTOR .

    /**
     * Purpose: Returns a Character Array with all the configuration data names
     * Notes:
     * @return The ABL Character Array
     */
    METHOD PUBLIC CHARACTER EXTENT GetNames ():

        DEFINE VARIABLE i      AS INTEGER   NO-UNDO.

        IF EXTENT (cNames) <> ? THEN
            RETURN cNames .

        IF oListNameValuePair:Count > 0 THEN
            EXTENT (cNames) = oListNameValuePair:Count .

        DO i = 1 TO EXTENT (cNames):
            ASSIGN cNames[i] = oListNameValuePair:GetItem(i):Name .
        END.

        RETURN cNames .
    END METHOD .

    /**
     * Purpose: Initializes the Configuration Provider from a JsonObject
     * Notes:
     * @param poConfiguration The JSON Object with configuration values
     */
    METHOD PROTECTED VOID Initialize (poConfiguration AS JsonObject):

        oListNameValuePair = JsonHelper:JsonObjectToPropertyList (poConfiguration, ".":U) .

        THIS-OBJECT:OverrideFromStartupParameter (oListNameValuePair, SESSION:PARAMETER) .

        EXTENT (cNames) = ?.

    END METHOD .

    /**
     * Purpose: Overrides the settings from the -param Parameter
     * Notes:   The -param parameter is expected to contain value in the form of
     *          -param @setting1=value1,@setting2=value2
     *          The -param parameter may contain other settings as well. Settings not
     *          starting with the @ sign will be ignored by the ConfigurationProvider
     *          class
     * @param poSettings The ListNameValuePair with the current settings
     * @param pcParam The SESSION:PARAMETER (-param) value
     */
    METHOD PROTECTED VOID OverrideFromStartupParameter (poSettings AS ListNameValuePair,
                                                        pcParam    AS CHARACTER):

        DEFINE VARIABLE oParamDictionary       AS CharacterDictionary    NO-UNDO .
        DEFINE VARIABLE cSettingsKey           AS CHARACTER              NO-UNDO .

        /* A -param without an = sign is not relevant here, e.g. some customers
           may be passing a JSON document via -param which should not be parsed here */
        IF StringHelper:IndexUnquoted(pcParam, "=":U) = 0 AND
           StringHelper:IndexUnquoted(pcParam, "@":U) = 0 THEN
            RETURN .

        oParamDictionary = ListHelper:AlternatingListToDictionary (pcParam, ",":U, "=":U) .

        {Consultingwerk/foreachDelimitedList.i Character cKey in oParamDictionary:Keys oParamDictionary:KeyDelimiter}
            IF cKey BEGINS "@":U THEN DO:
                ASSIGN cSettingsKey = SUBSTRING (cKey, 2, -1, "character":U) .

                IF poSettings:ContainsName (cSettingsKey) THEN
                    poSettings:FindByName (cSettingsKey):Value = oParamDictionary:GetValue (cKey) .
                ELSE
                    poSettings:Add(cSettingsKey, oParamDictionary:GetValue (cKey)) .
            END.
        END.

    END METHOD.

    /**
     * Purpose: Returns a configuration setting
     * Notes:
     * @param pcName The configuration property name
     * @return The value for the configuration property or ? when not set
     */
    METHOD PUBLIC CHARACTER GetValue (pcName AS CHARACTER):

        DEFINE VARIABLE oPair AS NameValuePair NO-UNDO .

        oPair = oListNameValuePair:FindByName (pcName) .

        IF VALID-OBJECT (oPair) THEN
            RETURN oPair:Value .
        ELSE
            RETURN ? .

    END METHOD .

    /**
     * Purpose: Returns a configuration setting or the default value when the setting
     *          is not available
     * Notes:
     * @param pcName The configuration property name
     * @param pcDefault The default value to return when the setting is not available
     * @return The value for the configuration property
     */
    METHOD PUBLIC CHARACTER GetValue (pcName AS CHARACTER,
                                      pcDefault AS CHARACTER):

        DEFINE VARIABLE cValue AS CHARACTER NO-UNDO.

        ASSIGN cValue = THIS-OBJECT:GetValue (pcName) .

        IF cValue = ? THEN
            RETURN pcDefault .
        ELSE
            RETURN cValue .

    END METHOD .

END CLASS.
