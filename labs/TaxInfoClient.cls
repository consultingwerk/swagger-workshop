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
    File        : TaxInfoClient
    Purpose     : Client for Tax Info Service
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 2024-07-10
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*                    from propath.
using Consultingwerk.Assertion.*          from propath.
using Consultingwerk.Framework.Http.*     from propath.
using Consultingwerk.Util.*               from propath.
using Demo.Swagger.CaliforniaTax.Client.* from propath.
using OpenEdge.Net.* from propath.
using OpenEdge.Net.HTTP.*                 from propath.
using Progress.Json.ObjectModel.*         from propath.

class Demo.Swagger.CaliforniaTax.Client.TaxInfoClient:

    define variable cBaseUrl as character no-undo.

    /**
     * Purpose: Default constructor for TaxInfoClient
     * Notes:
     */
    constructor public TaxInfoClient ():
        this-object("https://services.maps.cdtfa.ca.gov":u).
    end constructor.

    /**
     * Purpose: Constructor for TaxInfoClient
     * Notes:
     */
    constructor public TaxInfoClient (pcBaseUrl as character):
        super () .

        cBaseUrl = pcBaseUrl.
    end constructor.

    /**
     * Purpose: Get tax rate(s) by address...
     * Notes:
     * @param pcAddress The address of the location
     * @param pcCity The city of the location
     * @param pcZip The zip code of the location
     * @param plIncludeUpHierarchy Inude UpHierarchy?
     * @param pcToken Lat Long Token?
     * @return The request response
     */
    method public TaxRateDto GetRateByAddress (pcAddress as character,
                                               pcCity as character,
                                               pcZip as character,
                                               plIncludeUpHierarchy as logical,
                                               pcToken as character):

        define variable oRequest as IHttpRequest no-undo.
        define variable oResponse as IHttpResponse no-undo.
        define variable oHttpClient as IHttpClient no-undo.
        define variable oUrl as URI no-undo.
        define variable oJson as JsonObject no-undo.
        define variable oTaxRateDto as TaxRateDto no-undo.
        define variable oLibrary as IHttpClientLibrary no-undo.

        oUrl = URI:Parse(substitute("&1/api/taxrate/GetRateByAddress":u, cBaseUrl)).
        oUrl:AddQuery("Address":u, pcAddress).
        oUrl:AddQuery("City":u, pcCity).
        oUrl:AddQuery("Zip":u, pcZip).
        oUrl:AddQuery("IncludeUpHierarchy":u, if plIncludeUpHierarchy then "true":u else "false":u).
        oUrl:AddQuery("Token":u, pcToken).

        oRequest = RequestBuilder:Get(oUrl):Request.

        oHttpClient = ClientBuilder:Build():Client.
        oLibrary = ClientLibraryBuilder:Build()
                            :SslVerifyHost(false)
                            :Library.

        oClient = ClientBuilder:Build():UsingLibrary(oLibrary):Client .

        oResponse = oHttpClient:Execute(oRequest).

        oTaxRateDto = new TaxRateDto().

        if type-of(oResponse:Entity, JsonObject) then do:
            assign oJson = cast(oResponse:Entity, JsonObject).

            oTaxRateDto:DeserializeFromJsonObject(oJson).
        end.

        return oTaxRateDto.

    end method .

end class.
