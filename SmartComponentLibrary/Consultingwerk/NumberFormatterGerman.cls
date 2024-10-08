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
    File        : NumberFormatterGerman
    Purpose     : Supports formatting numbersas human readable English strings
    Syntax      :
    Description : Based on http://rosettacode.org/wiki/Number_names#C.23
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Jan 18 21:13:51 CET 2015
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.*      from propath .
using Consultingwerk.Util.* from propath .
using Progress.Lang.*       from propath .

class Consultingwerk.NumberFormatterGerman
    implements INumberFormatter:

    define variable incrementsOfOne as character extent 20 no-undo
        initial ["null":U,     "ein":U,      "zwei":U,     "drei":U,     "vier":U,
                 "f�nf":U,     "sechs":U,    "sieben":U,   "acht":U,     "neun":U,
                 "zehn":U,     "elf":U,      "zw�lf":U,    "dreizehn":U, "vierzehn":U,
                 "f�nfzehn":U, "sechzehn":U, "siebzehn":U, "achtzehn":U, "neunzehn":U] .

    define variable incrementsOfTen as character extent 10 no-undo
        initial ["":U,        "":U,        "zwangig":U, "dreissig":U, "vierzig":U,
                 "f�nfzig":U, "sechzig":U, "siebzig":U, "achzig":U,   "neunzig":U].

    define variable millionName  as character no-undo initial "Millionen":U .
    define variable thousandName as character no-undo initial "Tausend":U .
    define variable hundredName  as character no-undo initial "Hundert":U .
    define variable andName      as character no-undo initial "und":U .

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

        define variable cHunderter as character no-undo.
        define variable cZehner    as character no-undo.
        define variable cEiner     as character no-undo.

        define variable cNumber as character no-undo .

        if piNumber >= 100 then do:
            assign cHunderter = incrementsOfOne[RoundNumber (piNumber / 100) + 1] .

            piNumber = piNumber modulo 100 .
        end.

        if piNumber >= 20 then do:
            assign cZehner = incrementsOfTen[RoundNumber (piNumber / 10) + 1] .

            piNumber = piNumber modulo 10 .
        end.

        if RoundNumber (piNumber) = 1 and cZehner = "":U then
            assign cEiner = "eins":U .
        else
            assign cEiner = incrementsOfOne[RoundNumber (piNumber) + 1] .

        if cHunderter > "":U then
            assign cNumber = cHunderter + hundredName .

        if cEiner > "":U then
            assign cNumber = cNumber + cEiner .

        if cZehner > "":U then do:
            if cNumber > "":U then
                assign cNumber = cNumber + andName .

            assign cNumber = cNumber + cZehner .
        end.

        return StringHelper:CamelCaseWord(cNumber) .

    end method .

end class.
