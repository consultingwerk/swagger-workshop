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
    File        : OeManagerTransportsApsvClient
    Purpose     : Client for OEManager Transports Apsv
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2024-06-10
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*                from propath.
using Consultingwerk.Assertion.*      from propath.
using Consultingwerk.Framework.Http.* from propath.
using Consultingwerk.Util.*           from propath.
using Demo.Swagger.oemanager.Client.* from propath.
using OpenEdge.Net.HTTP.*             from propath.
using Progress.Json.ObjectModel.*     from propath.

class Demo.Swagger.oemanager.Client.OeManagerTransportsApsvClient:

    define variable cBaseUrl as character no-undo.

    /**
     * Purpose: Default constructor for OeManagerTransportsApsvClient
     * Notes:
     */
    constructor public OeManagerTransportsApsvClient ():

        this-object ("https://localhost:8821/oemanager":u) .

    end constructor.

    /**`
     * Purpose: Constructor for OeManagerTransportsApsvClient
     * Notes:
     */
    constructor public OeManagerTransportsApsvClient (pcBaseUrl as character):

        super () .

        this-object:cBaseUrl = pcBaseUrl.

    end constructor.

    /**
     * Purpose: Returns an instance of an HTTP client
     * Notes:
     * @return An HTTP CLient instance
     */
    method protected IHttpClient GetClient():
        define variable oHttpClient as IHttpClient no-undo.

        oHttpClient = ClientBuilder:Build():Client.

        return oHttpClient.
    end method.

    /**
     * Purpose: Get APSV Transport properties by OEABL WebApp name
     * Notes:
     * @param poCredentials The credentials to use for the request
     * @param pcAppName The name of the application
     * @param pcWebAppName The name of the webapp
     * @return The request response (JsonObject)
     */
    method public JsonObject getProperties_1 (poCredentials as Credentials,
                                              pcAppName as character,
                                              pcWebAppName as character):

        define variable oRequest as IHttpRequest no-undo.
        define variable oResponse as IHttpResponse no-undo.

        oRequest = RequestBuilder:Get(substitute("&1/applications/&2/webapps/&3/transports/apsv/properties":u,
                                                 cBaseUrl, pcAppName, pcWebAppName))
                        :UsingCredentials(poCredentials)
                        :Request.

        oResponse = this-object:GetClient():Execute(oRequest).
        if type-of(oResponse:Entity, JsonObject) then
            return cast(oResponse:Entity, JsonObject).

        return ?.
    end method .

    /**
     * Purpose: Update APSV Transport properties by OEABL WebApp name
     * Notes:
     * @param poCredentials The credentials to use for the request
     * @param pcAppName The name of the application
     * @param pcWebAppName The name of the webapp
     * @param poApsvTransportProperties The properties to update
     * @return The request response (JsonObject)
     */
    method public JsonObject updateProperties_1 (poCredentials as Credentials,
                                                 pcAppName as character,
                                                 pcWebAppName as character,
                                                 poApsvTransportProperties as ApsvTransportProperties):

        define variable oRequest as IHttpRequest no-undo.
        define variable oResponse as IHttpResponse no-undo.

        oRequest = RequestBuilder:Post(substitute("&1/applications/&2/webapps/&3/transports/apsv/properties":u,
                                                  cBaseUrl, pcAppName, pcWebAppName))
                        :WithData(poApsvTransportProperties:ToJsonObject())
                        :ContentType("application/vnd.progress+json")
                        :UsingCredentials(poCredentials)
                        :Request.

        oResponse = this-object:GetClient():Execute(oRequest).
        if type-of(oResponse:Entity, JsonObject) then
            return cast(oResponse:Entity, JsonObject).

        return ?.

    end method .

end class.
