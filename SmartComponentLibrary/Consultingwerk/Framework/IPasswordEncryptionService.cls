/**********************************************************************
 * Copyright (C) 2006-2020 by Consultingwerk Ltd. ("CW") -            *
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
    File        : IPasswordEncryptionService
    Purpose     : Interface for services providing capability to encode and
                  decode passwords
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Aug 27 10:53:22 CEST 2020
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

INTERFACE Consultingwerk.Framework.IPasswordEncryptionService:

    /**
     * Purpose: Encodes a password
     * Notes:
     * @param pcPassword The password to encode
     * @return The encoded password
     */
    METHOD PUBLIC CHARACTER EncodePassword (pcPassword AS CHARACTER).

    /**
     * Purpose: Decodes a password
     * Notes:
     * @param pcEncodedPassword The encoded password to decode
     * @return The password
     */
    METHOD PUBLIC CHARACTER DecodePassword (pcEncodedPassword AS CHARACTER).

END INTERFACE.
