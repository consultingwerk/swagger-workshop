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
    File        : ClientType
    Purpose     : An Enumeration of OpenEdge Client Types, see pseudo
                  Widget property SESSION:CLIENT-TYPE
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Jun 02 10:23:02 CEST 2012
    Notes       : https://knowledgebase.progress.com/articles/Article/P26277
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.* from propath .
using Progress.Lang.* from propath .

class Consultingwerk.ClientType:

    define public static property APPSERVER           as character no-undo initial "APPSERVER":U           get.
    define public static property FourGLCLIENT        as character no-undo initial "4GLCLIENT":U           get.
    define public static property WEBCLIENT           as character no-undo initial "WEBCLIENT":U           get.
    define public static property WEBSPEED            as character no-undo initial "WEBSPEED":U            get.
    define public static property MULTI-SESSION-AGENT as character no-undo initial "MULTI-SESSION-AGENT":U get.

    /**
     * Purpose: Disallow instance creation
     * Notes:
     */
    constructor private ClientType ():
        super ().
    end constructor.

    /**
     * Purpose: Determines if the current session is running in an 4GLClient
     * Notes:
     * @return True if the current session is running in an 4GLClient
     */
    method public static logical Is4GLClient ():

        return IsClient (Consultingwerk.ClientType:FourGLCLIENT) .

    end method .

    /**
     * Purpose: Determines if the current session is running in an AppServer
     * Notes:
     * @return True if the current session is running in an AppServer
     */
    method public static logical IsAppServer ():

        return IsClient (Consultingwerk.ClientType:APPSERVER) .

    end method .

    /**
     * Purpose: Determines if the current session is a known ABL client type
     * Notes:
     * @return True if the current session is a known ABL client type
     */
    method public static logical IsKnownClientType ():

        return Consultingwerk.ClientType:Is4GLClient() or
               Consultingwerk.ClientType:IsAppServer() or
               Consultingwerk.ClientType:IsWebClient() or
               Consultingwerk.ClientType:IsWebSpeed()  or
               Consultingwerk.ClientType:IsMultiSessionAgent() .

    end method.

    /**
     * Purpose: Determines if the given session is a known ABL client type
     * Notes:
     * @param pcClientType The value of the ABL SESSION:CLIENT-TYPE value for the session type to validate
     * @return True if the current session is a known ABL client type
     */
    method public static logical IsKnownClientType (pcClientType as character):

        return pcClientType = Consultingwerk.ClientType:FourGLCLIENT or
               pcClientType = Consultingwerk.ClientType:APPSERVER or
               pcClientType = Consultingwerk.ClientType:WEBCLIENT or
               pcClientType = Consultingwerk.ClientType:WEBSPEED or
               pcClientType = Consultingwerk.ClientType:MULTI-SESSION-AGENT .

    end method.


    /**
     * Purpose: Determines if the current session is running in PASOE
     * Notes:
     * @return True if the current session is running in an AppServer
     */
    method public static logical IsMultiSessionAgent ():

        return IsClient (Consultingwerk.ClientType:MULTI-SESSION-AGENT) .

    end method .

    /**
     * Purpose: Determines if the current session is running in an WebClient
     * Notes:
     * @return True if the current session is running in an WebClient
     */
    method public static logical IsWebClient ():

        return IsClient (Consultingwerk.ClientType:WEBCLIENT) .

    end method .

    /**
     * Purpose: Determines if the current session is running in an WebSpeed
     * Notes:
     * @return True if the current session is running in an WebSpeed
     */
    method public static logical IsWebSpeed ():

        return IsClient (Consultingwerk.ClientType:WEBSPEED) .

    end method .

    /**
     * Purpose: Determines if the current session is running in the specified client type
     * Notes:
     * @param pcClientType The value to match with the ABL SESSION:CLIENT-TYPE value
     * @return True if the current session is running in the specified client type
     */
    method public static logical IsClient (pcClientType as character):

        return session:client-type = pcClientType .

    end method .

end class.
