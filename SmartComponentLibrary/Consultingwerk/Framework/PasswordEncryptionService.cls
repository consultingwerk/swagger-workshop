/**********************************************************************
 * Copyright (C) 2006-2022 by Consultingwerk Ltd. ("CW") -            *
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
    File        : PasswordEncryptionService
    Purpose     : ABL implementation of the IPasswordEncryptionService
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Jan 29 14:51:01 CET 2022
    Notes       : This variant of the service has no dependencies on the .NET
                  Framework. This implementation is not meant to be compatible
                  to the Consultingwerk.Windows.Framework.PasswordEncryptionService
                  which relies on the .NET framework
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Consultingwerk.Framework.* FROM PROPATH.
USING Progress.Lang.*            FROM PROPATH.

CLASS Consultingwerk.Framework.PasswordEncryptionService
    IMPLEMENTS IPasswordEncryptionService:

    /**
     * Purpose: Encodes a password
     * Notes:
     * @param pcPassword The password to encode
     * @return The encoded password
     */
    METHOD PUBLIC CHARACTER EncodePassword (pcPassword AS CHARACTER):

        DEFINE VARIABLE mptr    AS MEMPTR    NO-UNDO .
        DEFINE VARIABLE cQuery  AS CHARACTER NO-UNDO INITIAL "FOR EACH eSmartUser NO-LOCK":U .
        DEFINE VARIABLE rKey    AS RAW       NO-UNDO .
        DEFINE VARIABLE cReturn AS CHARACTER NO-UNDO .

        ASSIGN rKey = GENERATE-PBE-KEY (cQuery) .

        mptr = ENCRYPT (pcPassword, rKey) .

        {&_proparse_ prolint-nowarn(overflow)}
        ASSIGN cReturn = STRING (BASE64-ENCODE (mptr))
               cReturn = SUBSTRING (cReturn, 1, LENGTH (cReturn, "CHARACTER":U) - 2, "CHARACTER":U) .

        RETURN cReturn .

        FINALLY:
            SET-SIZE (mptr) = 0 .
        END FINALLY.

    END METHOD.

    /**
     * Purpose: Decodes a password
     * Notes:
     * @param pcEncodedPassword The encoded password to decode
     * @return The password
     */
    METHOD PUBLIC CHARACTER DecodePassword (pcEncodedPassword AS CHARACTER):

        DEFINE VARIABLE mptr   AS MEMPTR    NO-UNDO .
        DEFINE VARIABLE mptr2  AS MEMPTR    NO-UNDO .
        DEFINE VARIABLE cQuery AS CHARACTER NO-UNDO INITIAL "FOR EACH eSmartUser NO-LOCK":U .
        DEFINE VARIABLE rKey   AS RAW       NO-UNDO .

        ASSIGN rKey = GENERATE-PBE-KEY (cQuery) .

        mptr = BASE64-DECODE (pcEncodedPassword + "==":U) .

        mptr2 = DECRYPT (mptr, rKey) .

        RETURN GET-STRING (mptr2, 1) .

        FINALLY:
            SET-SIZE (mptr) = 0 .
            SET-SIZE (mptr2) = 0 .
        END FINALLY.

    END METHOD.

END CLASS.
