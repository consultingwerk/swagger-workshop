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
    File        : ILoggingPresetProvider
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Sep 07 17:37:34 CEST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Consultingwerk.Framework.* FROM PROPATH .
USING Progress.Lang.*            FROM PROPATH .

INTERFACE Consultingwerk.Framework.ILoggingPresetProvider:

    /**
     * Purpose: Activates a logging preset
     * Notes:   Expected to ignore non existing logging presets
     * @param pcLoggingPreset The name of the logging preset
     */
    METHOD PUBLIC VOID ActivateLoggingPreset (pcLoggingPreset AS CHARACTER).

    /**
     * Purpose: Returns the names of the Logging Presets
     * Notes:
     * @return The Character array of logging presets
     */
    METHOD PUBLIC CHARACTER EXTENT GetLoggingPresets ().

END INTERFACE.
