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
    File        : Tokenizer
    Purpose     : A class that supports splitting a CHARACTER string into
                  tokens that might be quoted or not
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Mar 16 14:40:25 CET 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.*                       from propath .
using Consultingwerk.Framework.Collections.* from propath .
using Progress.Lang.*                        from propath .

class Consultingwerk.Tokenizer:

    /**
     * Purpose: Splits a string into individual tokens
     * Notes:   When plKeepQuotes is passed as TRUE, then leading ( and trailing ) on
     *          tokens will be added to the CharacterList as separate Tokens as it's expected
     *          that this will simplify the interpretation of a Query String
     * @param pcString The string to split into tokens
     * @param plKeepQuotes True to leave the quotes in the tokens, false to omit quotes
     * @param pcOtherDelimiters A single character string containing other characters that are used as additional token delimiters, e.g. ",="
     * @return A CharacterList of individual tokens
     */
    method public CharacterList Tokenize (pcString as character,
                                          plKeepQuotes as logical,
                                          pcOtherDelimiters as character):

        define variable oTokens    as CharacterList no-undo .
        define variable cQuoteChar as character     no-undo initial "":U.
        define variable iPos       as integer       no-undo.
        define variable cChar      as character     no-undo.
        define variable cToken     as character     no-undo.
        define variable lInQuote   as logical       no-undo initial false .

        oTokens = new CharacterList ("":U, chr (1)) .

        pcString = trim (pcString) .

        if CharacterType:IsNullOrEmpty(pcString) then
            return oTokens .

        do iPos = 1 to length (pcString, "CHARACTER":U):
            assign cChar = substring (pcString, iPos, 1, "CHARACTER":U) .

            if cChar = "~"":U or
               cChar = "'":U then do:
                if cQuoteChar = "":U then do:
                    assign cQuoteChar = cChar
                           lInQuote   = true .

                    if plKeepQuotes then
                        cToken = cToken + cChar .
                end.
                else if cQuoteChar = cChar then do:
                    assign lInQuote   = false
                           cQuoteChar = "":U .

                    if plKeepQuotes then
                        cToken = cToken + cChar .

                    if plKeepQuotes and length (cToken, "CHARACTER":U) > 1 and cToken begins "(":U then do:
                        oTokens:Add ("(":U) .
                        oTokens:Add (substring (cToken, 2, -1, "CHARACTER":U)) .
                        cToken = "":U .
                    end .
                    else if plKeepQuotes and length (cToken, "CHARACTER":U) > 1 and cToken matches "*)":U then do:
                        oTokens:Add (substring (cToken, 1, length (cToken, "CHARACTER":U) - 1, "CHARACTER":U)) .
                        oTokens:Add (")":U) .
                        cToken = "":U .
                    end.
                    else if length (cToken, "CHARACTER":U) > 0 then do:
                        oTokens:Add (cToken) .
                        cToken = "":U .
                    end.
                end.
                else
                    assign cToken = cToken + cChar .
            end. /* " or ' */
            else if cChar = " ":U
                 or cChar = chr (9)
                 or cChar = chr (10)
                 or cChar = chr (13)
                 or (pcOtherDelimiters > "":U and
                     index (pcOtherDelimiters, cChar) > 0) then do:
                if lInQuote = false then do:
                    if plKeepQuotes and length (cToken, "CHARACTER":U) > 1 and cToken begins "(":U then do:
                        oTokens:Add ("(":U) .
                        oTokens:Add (substring (cToken, 2, -1, "CHARACTER":U)) .
                        cToken = "":U .
                    end .
                    else if plKeepQuotes and length (cToken, "CHARACTER":U) > 1 and cToken matches "*)":U then do:
                        oTokens:Add (substring (cToken, 1, length (cToken, "CHARACTER":U) - 1, "CHARACTER":U)) .
                        oTokens:Add (")":U) .
                        cToken = "":U .
                    end.
                    else if length (cToken, "CHARACTER":U) > 0 then do:
                        oTokens:Add (cToken) .
                        cToken = "":U .
                    end.
                end.
                else
                    assign cToken = cToken + cChar .
            end.
            else
                assign cToken = cToken + cChar .
        end.

        if plKeepQuotes and length (cToken, "CHARACTER":U) > 1 and cToken begins "(":U then do:
            oTokens:Add ("(":U) .
            oTokens:Add (substring (cToken, 2, -1, "CHARACTER":U)) .
        end .
        else if plKeepQuotes and  length (cToken, "CHARACTER":U) > 1 and cToken matches "*)":U then do:
            oTokens:Add (substring (cToken, 1, length (cToken, "CHARACTER":U) - 1, "CHARACTER":U)) .
            oTokens:Add (")":U) .
        end.
        else if length (cToken, "CHARACTER":U) > 0 then
            oTokens:Add (cToken) .

        return oTokens .

    end method.

    /**
     * Purpose: Splits a string into individual tokens
     * Notes:   When plKeepQuotes is passed as TRUE, then leading ( and trailing ) on
     *          tokens will be added to the CharacterList as separate Tokens as it's expected
     *          that this will simplify the interpretation of a Query String
     * @param pcString The string to split into tokens
     * @param plKeepQuotes True to leave the quotes in the tokens, false to omit quotes
     * @return A CharacterList of individual tokens
     */
    method public CharacterList Tokenize (pcString as character,
                                          plKeepQuotes as logical):

        return this-object:Tokenize (pcString, plKeepQuotes, ?) .

    end method .

    /**
     * Purpose: Splits a string into individual tokens
     * Notes:
     * @param pcString The string to split into tokens
     * @return A CharacterList of individual tokens
     */
    method public CharacterList Tokenize (pcString as character):

        return this-object:Tokenize (pcString, false, ?) .

    end method .

end class.
