
using Consultingwerk.Util.*.
using OpenEdge.Net.HTTP.* from propath.
using Progress.Json.ObjectModel.* from propath.
using Samples.OeManager.Client.* from propath.
using Demo.Swagger.oemanager.Client.* from propath.
@lowercase.

block-level on error undo, throw.

define variable oOeManagerClient as OeManagerTransportsApsvClient no-undo.
define variable oCredentials as Credentials no-undo.
define variable oData as JsonObject no-undo.
define variable oApsvTransportProperties as ApsvTransportProperties no-undo.
define variable oApsvTransportResponse as ApsvTransportResponse no-undo.

oCredentials = new Credentials("oe-realm", "tomcat", "tomcat").
oOeManagerClient = new OeManagerTransportsApsvClient("http://localhost:8820/oemanager").

oApsvTransportProperties = new ApsvTransportProperties().
oApsvTransportProperties:adapterEnabled = string(1).

oApsvTransportResponse = oOeManagerClient:updateProperties_1(oCredentials,
                                                            "swaggerpas",
                                                            "ROOT",
                                                            oApsvTransportProperties).

message oApsvTransportResponse:outcome.

catch oError as Progress.Lang.Error:
    message oError:GetMessage(1).
end catch.