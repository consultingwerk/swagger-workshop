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
    File        : NumberFormatterEnglish
    Purpose     : Supports formatting numbers as human readable English strings
    Syntax      :
    Description : Based on http://rosettacode.org/wiki/Number_names#C.23
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Jan 18 21:13:51 CET 2015
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.NumberFormatterEnglish
    implements INumberFormatter:

    define variable incrementsOfOne as character extent 20 no-undo
        initial ["zero":U,    "one":U,     "two":U,       "three":U,    "four":U,
              "five":U,    "six":U,     "seven":U,     "eight":U,    "nine":U,
              "ten":U,     "eleven":U,  "twelve":U,    "thirteen":U, "fourteen":U,
              "fifteen":U, "sixteen":U, "seventeen":U, "eighteen":U, "nineteen":U] .

    define variable incrementsOfTen as character extent 10 no-undo
        initial ["":U,      "":U,      "twenty":U,  "thirty":U, "fourty":U,
              "fifty":U, "sixty":U, "seventy":U, "eighty":U, "ninety":U].

    define variable millionName  as character no-undo initial "million":U .
    define variable thousandName as character no-undo initial "thousand":U .
    define variable hundredName  as character no-undo initial "hundred":U .
    define variable andName      as character no-undo initial "and":U .

    /**
     * Purpose: Rounds a number down to the closest lower integer number
     * Notes:
     * @param piNumber The number to round
     * @return The rounded number
     */
    method protected integer RoundNumber (piNumber as decimal):

        return integer (round (piNumber - .5, 0)) .

    end method .

    /**
     * Purpose: Formats a number as a string
     * Notes:
     * @param piNumber The number to format
     * @return The string representing the number in a human readable form
     */
    method public character FormatNumber (piNumber as integer):

        define variable cNumber as character initial "":U no-undo .

        if piNumber >= 1000000 then do:
            assign cNumber = cNumber + this-object:ParseTriplet (RoundNumber (piNumber / 1000000)) + " ":U + millionName .
            piNumber = piNumber modulo 1000000 .
            if (piNumber = 0) then
                return cNumber .
        end .

        if piNumber >= 1000 then do:
            if cNumber > "":U then
                assign cNumber = cNumber + ", ":U .

            assign cNumber = cNumber + this-object:ParseTriplet (RoundNumber (piNumber / 1000)) + " ":U + thousandName .
            piNumber = piNumber modulo 1000 .
            if (piNumber = 0) then
                return cNumber .
        end.

        if cNumber > "":U then
            assign cNumber = cNumber + ", ":U .

        assign cNumber = cNumber + this-object:ParseTriplet (piNumber) .

        return cNumber .

    end method .

    /**
     * Purpose: Formats a number triplet as a string
     * Notes:
     * @param piNumber The number to format
     * @return The string representing the number in a human readable form
     */
    method protected character ParseTriplet (piNumber as decimal):

        define variable cNumber as character no-undo .

        if piNumber >= 100 then do:
            assign cNumber = cNumber + incrementsOfOne[RoundNumber (piNumber / 100) + 1] + " ":U + hundredName .

            piNumber = piNumber modulo 100 .

            if piNumber = 0 then
                return cNumber .
        end.

        if cNumber > "":U then
            assign cNumber = cNumber + " ":U + andName + " ":U.

        if piNumber >= 20 then do:
            assign cNumber = cNumber + incrementsOfTen[RoundNumber (piNumber / 10) + 1] .

            piNumber = piNumber modulo 10 .

            if piNumber = 0 then
                return cNumber .
        end.

        if cNumber > "":U then
            cNumber = cNumber + " ":U .

        cNumber = cNumber + incrementsOfOne[integer (round (piNumber, 0)) + 1] .

        return cNumber .

    end method .

end class.
