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
    File        : CharacterType
    Purpose     : Contains supporting routines for ABL CHARACTER Variables
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Jun 02 10:58:12 CEST 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.CharacterType:

    /**
     * Purpose: Disallow instance creation
     * Notes:
     */
    constructor private CharacterType ():
        super ().

    end constructor.


    /**
     * Purpose: Returns the source string or "" when the source string was ?
     * Notes:
     * @param pcValue The source string
     * @return The source string or ""
     */
    method public static character EmptyStringForUnknown (pcValue as character):

        if pcValue = ? then
            return "":U .
        else
            return pcValue .

    end method.

    /**
     * Purpose: Verifies if the passed in character string is not unknown value
     *          or empty
     * Notes:
     * @param pcCharacter The character to compare
     * @return True when the passed in character value is not ? or Empty
     */
    method public static logical IsNotNullOrEmpty (pcCharacter as character):

        return pcCharacter <> ? and pcCharacter > "":U.

    end method .

    /**
     * Purpose: Verifies if the passed in character string is the unknown value
     *          or empty
     * Notes:
     * @param pcCharacter The character to compare
     * @return True when the passed in character value is ? or Empty
     */
    method public static logical IsNullOrEmpty (pcCharacter as character):

        return pcCharacter = ? or pcCharacter = "":U.

    end method .

    /**
     * Purpose: Parses a String for unknown value, returning ? for "?"
     * Notes:
     * @param pcValue The character string to parse
     * @return The character value of ? when the string was "?"
     */
    method public static character ParseUnknownValue (pcValue as character):

        if pcValue = "?":U then
            return ? .
        else
            return pcValue .

    end method .

end class.
