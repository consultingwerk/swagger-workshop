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
    File        : IJsonDateTypeFormatter
    Purpose     : Provides custom Json Date/DateTime/DateTime-TZ formatting
                  for the Json object mode. 
    Syntax      : 
    Description : Workaround for the fact, that there is no actual standard 
                  for date representation in Json and if may be required to provide
                  custom formatting based on the target system (e.g. JIRA)
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Jan 25 23:34:14 CET 2013
    Notes       : 
  ----------------------------------------------------------------------*/

@lowercase.

using Progress.Json.ObjectModel.* from propath .
using Progress.Lang.*             from propath .

interface Consultingwerk.IJsonDateTypeFormatter:  
  
    /**
     * Purpose: Adds a ABL Date property to the JsonObject
     * Notes:
     * @param poJsonObject The reference to the source JsonObject
     * @param pcProperty The name of the property in the JsonObject
     * @param pdtDate The date value
     */
    method public void Add (poJsonObject as JsonObject,
                            pcProperty as character,
                            pdtDate as date).

    /**
     * Purpose: Adds a ABL Date property to the JsonObject
     * Notes:
     * @param poJsonObject The reference to the source JsonObject
     * @param pcProperty The name of the property in the JsonObject
     * @param pdtDate The datetime value
     */
    method public void Add (poJsonObject as JsonObject,
                            pcProperty as character,
                            pdtDate as datetime).

    /**
     * Purpose: Adds a ABL Date property to the JsonObject
     * Notes:
     * @param poJsonObject The reference to the source JsonObject
     * @param pcProperty The name of the property in the JsonObject
     * @param pdtDate The datetime-tz value
     */
    method public void Add (poJsonObject as JsonObject,
                            pcProperty as character,
                            pdtDate as datetime-tz).

    /**
     * Purpose: Returns the ABL Date value for a Json property
     * Notes:
     * @param poJsonObject The reference to the source JsonObject
     * @param pcProperty The name of the property in the JsonObject
     * @return The resulting DATE value
     */
    method public date GetDate (poJsonObject as JsonObject,
                                pcProperty as character).

    /**
     * Purpose: Returns the ABL DateTime value for a Json property
     * Notes:
     * @param poJsonObject The reference to the source JsonObject
     * @param pcProperty The name of the property in the JsonObject
     * @return The resulting DATETIME value
     */
    method public datetime GetDateTime (poJsonObject as JsonObject,
                                        pcProperty as character).

    /**
     * Purpose: Returns the ABL DateTime-TZ value for a Json property
     * Notes:
     * @param poJsonObject The reference to the source JsonObject
     * @param pcProperty The name of the property in the JsonObject
     * @return The resulting DATETIME-TZ value
     */
    method public datetime-tz GetDateTimeTz (poJsonObject as JsonObject,
                                             pcProperty as character).

end interface.
