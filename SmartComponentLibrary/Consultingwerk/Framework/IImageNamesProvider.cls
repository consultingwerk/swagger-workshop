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
    File        : IImageNamesProvider
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Oct 29 14:38:37 CET 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Json.ObjectModel.* FROM PROPATH .
USING Progress.Lang.*             FROM PROPATH .

INTERFACE Consultingwerk.Framework.IImageNamesProvider:

    /**
     * Purpose: Returns an JsonObject with the names of the product modules
     * Notes:
     * @param pcModuleCodes The character extent with the names of the Product Modules
     * @return The JsonObject with the names of the image files per product module
     */
    METHOD PUBLIC JsonObject GetImageNames (pcModuleCodes AS CHARACTER EXTENT).

END INTERFACE.
