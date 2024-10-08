/**********************************************************************
 * Copyright (C) 2006-2017 by Consultingwerk Ltd. ("CW") -            *
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
    File        : JsonConfiguration
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Jun 25 14:00:00 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Consultingwerk.Assertion.* FROM PROPATH.
USING Consultingwerk.Framework.*  FROM PROPATH .
USING Progress.Json.ObjectModel.* FROM PROPATH .
USING Progress.Lang.*             FROM PROPATH .

CLASS Consultingwerk.Framework.JsonConfiguration
    IMPLEMENTS IJsonConfiguration:

    DEFINE VARIABLE oConfiguration AS JsonObject NO-UNDO .

    /**
     * Purpose:
     * Notes:
     * @param poConfiguration The JSON Configuration object
     */
    CONSTRUCTOR PUBLIC JsonConfiguration (poConfiguration AS JsonObject):

        ObjectAssert:IsValid (poConfiguration, "poConfiguration":U) .

        ASSIGN oConfiguration = poConfiguration .

    END CONSTRUCTOR.

    /**
     * Purpose: Returns the JsonObject with the configuration data
     * Notes:
     * @return The JsonObject with session configuration data
     */
    METHOD PUBLIC JsonObject GetConfiguration ():

        RETURN oConfiguration .

    END METHOD .

END CLASS.
