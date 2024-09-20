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
    File        : get-properties-p
    Purpose     : ${input#Procedure purpose#}
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2024-09-20
    Notes       :
  ----------------------------------------------------------------------*/

using Consultingwerk.Util.*.
using OpenEdge.Net.HTTP.* from propath.
using Progress.Json.ObjectModel.* from propath.
using Demo.Swagger.oemanager.Client.* from propath.
@lowercase.

block-level on error undo, throw.

define variable oOeManagerClient as OeManagerTransportsApsvClient no-undo.
define variable oCredentials as Credentials no-undo.
define variable oData as JsonObject no-undo.

oCredentials = new Credentials("oe-realm", "tomcat", "tomcat").
oOeManagerClient = new OeManagerTransportsApsvClient("http://localhost:8820/oemanager").

oData = oOeManagerClient:getProperties_1(oCredentials,
                                        "swaggerpas",
                                        "ROOT").

message JsonHelper:ToCharacter(oData).

catch oError as Progress.Lang.Error:
    message oError:GetMessage(1).
end catch.
