/**********************************************************************
 * Copyright (C) 2006-2018 by Consultingwerk Ltd. ("CW") -            *
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
    File        : ImageNamesProvider
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Oct 29 14:42:27 CET 2018
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Consultingwerk.Framework.*  FROM PROPATH .
USING Consultingwerk.Util.*       FROM PROPATH .
USING Progress.Json.ObjectModel.* FROM PROPATH .
USING Progress.Lang.*             FROM PROPATH .

CLASS Consultingwerk.Framework.ImageNamesProvider
    IMPLEMENTS IImageNamesProvider:

    {Consultingwerk/Util/TempTables/ttFileNames.i}

    /**
     * Purpose: Returns an JsonObject with the names of the product modules
     * Notes:
     * @param pcModuleCodes The character extent with the names of the Product Modules
     * @return The JsonObject with the names of the image files per product module
     */
    METHOD PUBLIC JsonObject GetImageNames (pcModuleCodes AS CHARACTER EXTENT):

        DEFINE VARIABLE oConfiguration AS IConfigurationProvider NO-UNDO .
        DEFINE VARIABLE oResponse      AS JsonObject             NO-UNDO .
        DEFINE VARIABLE oImages        AS JsonArray              NO-UNDO .
        DEFINE VARIABLE cNames         AS CHARACTER EXTENT       NO-UNDO .
        DEFINE VARIABLE i              AS INTEGER                NO-UNDO .
        DEFINE VARIABLE j              AS INTEGER                NO-UNDO .
        DEFINE VARIABLE cEntry         AS CHARACTER              NO-UNDO .
        DEFINE VARIABLE cFolder        AS CHARACTER              NO-UNDO .
        DEFINE VARIABLE cFileName      AS CHARACTER              NO-UNDO .

        ASSIGN oConfiguration = {Consultingwerk/get-mandatory-service.i IConfigurationProvider}
               oResponse      = NEW JsonObject ()
               cNames         = oConfiguration:GetNames() .

        DO i = 1 TO EXTENT (pcModuleCodes):

            ASSIGN oImages = JsonHelper:AddNewJsonArray(oResponse, pcModuleCodes[i]) .

            EMPTY TEMP-TABLE ttFileNames .

            DO j = 1 TO EXTENT (cNames):
                IF cNames [j] BEGINS SUBSTITUTE ("imageNames.&1.":U, pcModuleCodes[i]) THEN DO:

                    ASSIGN cEntry    = oConfiguration:GetValue(cNames[j])
                           cFolder   = FileHelper:DirectoryName(cEntry)
                           cFileName = FileHelper:ShortFileName(cEntry) .

                    FileHelper:GetFileList (FileHelper:FindFile (cFolder, TRUE),
                                            cFileName,
                                            OUTPUT TABLE ttFileNames APPEND) .
                END.
            END.

            FOR EACH ttFileNames BY ttFileNames.FileName:
                oImages:Add (FileHelper:RelativeFileName(ttFileNames.FileName)) .
            END.
        END.

        RETURN oResponse .

    END METHOD.

END CLASS.