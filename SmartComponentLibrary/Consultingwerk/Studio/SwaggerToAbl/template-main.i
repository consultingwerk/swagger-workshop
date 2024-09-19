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
    File        : template-main.i
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     : Tue Sep 05 22:26:07 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Main Block  *************************** */

assign pcOutputFile = FileHelper:SanitizePath(substitute ("&1~/&2.cls":U,
                                              replace (poClassName:PackageName, ".":u, "/":u),
                                              poClassName:ClassName)) .

if valid-object (poLoggingStream) then
    poLoggingStream:WriteFormattedMessage("Writing to: &1 &2":U, poClassName:ClassName, pcOutputFile) .

FileHelper:CreateDirectoryForFile(pcOutputFile) .

output stream out to value (pcOutputFile) .

function AblDataType returns character
    (pcPropertyName as character,
     oProperties as JsonObject):

    return SwaggerToAblHelper:ToAblDataType (poGeneratorParameter:BasePackage,
                                             poClassName:ClassName,
                                             pcPropertyName,
                                             oProperties,
                                             poApiSpec,
                                             poGeneratorParameter) .

end function.
