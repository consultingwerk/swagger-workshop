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
    File        : IJsonConfiguration
    Purpose     : Interface for services that return the JSON configuration
                  object
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Jun 25 13:58:31 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Json.ObjectModel.* FROM PROPATH.
USING Progress.Lang.*.

INTERFACE Consultingwerk.Framework.IJsonConfiguration:

    /**
     * Purpose: Returns the JsonObject with the configuration data
     * Notes:
     * @return The JsonObject with session configuration data
     */
    METHOD PUBLIC JsonObject GetConfiguration ().

END INTERFACE.
