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
    File        : GuidType
    Purpose     : Provides helper functions for GUID types
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue May 20 14:07:46 CEST 2014
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.* from propath .
using Progress.Lang.* from propath .

class Consultingwerk.GuidType:

    /**
     * Purpose: Private constructor for the GuidType class
     * Notes:   Disallow instance creation
     */
    constructor private GuidType ():
        super ().

    end constructor.

    /**
     * Purpose: Tests if the provided value is a GUID
     * Notes:   Tests the format (lengths, position of -) and
     *          that the entries are 0..9 or a..f
     * @param pcGuid The Guid to test
     * @return Logical value indicating if the passed in value is a valid GUID
     */
    method public static logical IsGuid (pcGuid as character):

        define variable i as integer no-undo.

        /*
         * 123456789012345678901234567890123456
         * d1ab93dd-33bb-5aaf-1d14-25f184abc30b
         */

        if length (pcGuid, "CHARACTER":U) <> 36 then
            return false .

        if index (pcGuid, "-":U,
           index (pcGuid, "-":U,
           index (pcGuid, "-":U,
           index (pcGuid, "-":U) + 1) + 1) + 1) <> 24 then
           return false .

        assign pcGuid = substring (pcGuid, 1,  8, "CHARACTER":U) +
                        substring (pcGuid, 10, 4, "CHARACTER":U) +
                        substring (pcGuid, 15, 4, "CHARACTER":U) +
                        substring (pcGuid, 20, 4, "CHARACTER":U) +
                        substring (pcGuid, 25, -1, "CHARACTER":U) .

        do i = 1 to 32:
            if index ("1234567890abcdef":U, substring (pcGuid, i, 1, "CHARACTER":U)) = 0 then
                return false .
        end.

        return true .

    end method.

    /**
     * Purpose: Returns a new 36 character GUID value
     * Notes:
     * @return The 36 character GUID value
     */
    method public static character NewGuid ():

        return guid .

    end method .

    /**
     * Purpose: Returns the 22 character BASE64 representation of a new UUID value
     * Notes:   The BASE64 encoded UUID representation is shorter compared to the
     *          original GUID value. However, it can only be used for unique keys,
     *          when the comparison is may case-sensitive. BASE64 may return the
     *          same value (only distinguished by the case) for two different UUID
     *          values!
     * @return The 22 character BASE64 representation of a new UUID value
     */
    method public static character NewUuid ():

        define variable rawUUID as raw       no-undo .
        define variable cBase64 as character no-undo .

        {&_proparse_ prolint-nowarn(overflow)}
        assign rawUUID = generate-uuid
               cBase64 = base64-encode(rawUUID).

        return substring (cBase64, 1, 22, "CHARACTER":U) .

    end method .

end class.
