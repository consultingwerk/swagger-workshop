/**********************************************************************
 * Copyright (C) 2006-2023 by Consultingwerk Ltd. ("CW") -            *
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
    File        : ProVersionEnum
    Purpose     : An enumeration of CHARACTER Constants with valid Progress
                  Version numbers from 10.1A on (first progress release with
                  support for OO code)
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Feb 14 18:19:25 CET 2012
    Notes       : Property names are prefixed with a "P" because a property
                  identifier cannot start with a digit
  ----------------------------------------------------------------------*/

@lowercase.

using Progress.Lang.*.

block-level on error undo, throw.

class Consultingwerk.ProVersionEnum:

    define public static property P101A as character no-undo initial "10.1A":U get.
    define public static property P101B as character no-undo initial "10.1B":U get.
    define public static property P101C as character no-undo initial "10.1C":U get.
    define public static property P102A as character no-undo initial "10.2A":U get.
    define public static property P102B as character no-undo initial "10.2B":U get.
    define public static property P110  as character no-undo initial "11.0":U  get.
    define public static property P111  as character no-undo initial "11.1":U  get.
    define public static property P112  as character no-undo initial "11.2":U  get.
    define public static property P113  as character no-undo initial "11.3":U  get.
    define public static property P114  as character no-undo initial "11.4":U  get.
    define public static property P115  as character no-undo initial "11.5":U  get.
    define public static property P116  as character no-undo initial "11.6":U  get.
    define public static property P117  as character no-undo initial "11.7":U  get.
    define public static property P120  as character no-undo initial "12.0":U  get.
    define public static property P121  as character no-undo initial "12.1":U  get.
    define public static property P122  as character no-undo initial "12.2":U  get.
    define public static property P123  as character no-undo initial "12.3":U  get.
    define public static property P124  as character no-undo initial "12.4":U  get.
    define public static property P125  as character no-undo initial "12.5":U  get.
    define public static property P126  as character no-undo initial "12.6":U  get.
    define public static property P127  as character no-undo initial "12.7":U  get.
    define public static property P128  as character no-undo initial "12.8":U  get.

    /**
     * Purpose: Disallow instance creation
     * Notes:
     */
    constructor private ProVersionEnum ():
        super ().
    end constructor.

    /**
     * Purpose: Converts a PROVERSION string to a decimal representation for simpler
     *          comparison
     * Notes:   See SCL-479 for details
     * @param pcVersionString The version string as returned by PROVERSION
     * @return The decimal representation of the OpenEdge Version Number
     */
    method public static decimal ToDecimal (pcVersionString as character):

        if pcVersionString begins "12.8":U then
            return 12.8 .
        if pcVersionString begins "12.7":U then
            return 12.7 .
        if pcVersionString begins "12.6":U then
            return 12.6 .
        if pcVersionString begins "12.5":U then
            return 12.5 .
        if pcVersionString begins "12.4":U then
            return 12.4 .
        if pcVersionString begins "12.3":U then
            return 12.3 .
        if pcVersionString begins "12.2":U then
            return 12.2 .
        if pcVersionString begins "12.1":U then
            return 12.1 .
        if pcVersionString begins "12.0":U then
            return 12.0 .
        if pcVersionString begins "11.7":U then
            return 11.7 .
        if pcVersionString begins "11.6":U then
            return 11.6 .
        if pcVersionString begins "11.5":U then
            return 11.5 .
        if pcVersionString begins "11.4":U then
            return 11.4 .
        if pcVersionString begins "11.3":U then
            return 11.3 .
        if pcVersionString begins "11.2":U then
            return 11.2 .
        if pcVersionString begins "11.1":U then
            return 11.1 .
        if pcVersionString begins "11.0":U then
            return 11.0 .
        if pcVersionString begins "10.2B":U then
            return 10.22 .
        if pcVersionString begins "10.2A":U then
            return 10.21 .
        if pcVersionString begins "10.1C":U then
            return 10.13 .
        if pcVersionString begins "10.1B":U then
            return 10.12 .
        if pcVersionString begins "10.1A":U then
            return 10.11 .

        return ? .

    end method.

end class.
