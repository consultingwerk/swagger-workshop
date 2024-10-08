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
    File        : WeekDayEnum
    Purpose     : Enumeration of WeekDays
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Mar 20 07:21:56 CET 2013
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.*                       from propath .
using Consultingwerk.Framework.Collections.* from propath .
using Progress.Lang.*                        from propath .

class Consultingwerk.WeekDayEnum inherits Enum:

    {Consultingwerk/EnumMember.i Monday 1 WeekDayEnum}
    {Consultingwerk/EnumMember.i Tuesday 2 WeekDayEnum}
    {Consultingwerk/EnumMember.i Wednesday 3 WeekDayEnum}
    {Consultingwerk/EnumMember.i Thursday 4 WeekDayEnum}
    {Consultingwerk/EnumMember.i Friday 5 WeekDayEnum}
    {Consultingwerk/EnumMember.i Saturday 6 WeekDayEnum}
    {Consultingwerk/EnumMember.i Sunday 7 WeekDayEnum}

    /**
     * Purpose: Constructor for the WeekDayEnum members
     * Notes:
     * @param piValue The internal (numeric) representation of the Enumeration member
     * @param pcLabel The text label of the Enumaration member
     */
    constructor private WeekDayEnum (piValue as integer, pcLabel as character):
        super ().

        assign this-object:Value = piValue
               this-object:Label = pcLabel .

    end constructor.

    /**
     * Purpose: Returns the WeekDayEnum member that matches the value of the ABL
     *          weekday function
     * Notes:
     * @param piAblWeekDay The value of the ABL weekday function
     * @return The WeekDay enum member matching the input value
     */
    method public static WeekDayEnum FromAblWeekDay (piAblWeekDay as integer):

        case piAblWeekDay:
            when 1 then
                return WeekDayEnum:Sunday .
            when 2 then
                return WeekDayEnum:Monday .
            when 3 then
                return WeekDayEnum:Tuesday .
            when 4 then
                return WeekDayEnum:Wednesday .
            when 5 then
                return WeekDayEnum:Thursday .
            when 6 then
                return WeekDayEnum:Friday .
            when 7 then
                return WeekDayEnum:Saturday .
        end case .

        return ? .

    end method .

    /**
     * Purpose: Returns the WeekDayEnum member that matches the value of the ISO
     *          weekday number
     * Notes:   Following the ISO 8601 norm used in Germany and most European countries
     *          where the week starts with Monday
     * @param piIsoWeekDay The number of the ISO weekday
     * @return The WeekDay enum member matching the input value
     */
    method public static WeekDayEnum FromIsoWeekDay (piIsoWeekDay as integer):

        case piIsoWeekDay:
            when 1 then
                return WeekDayEnum:Monday .
            when 2 then
                return WeekDayEnum:Tuesday .
            when 3 then
                return WeekDayEnum:Wednesday .
            when 4 then
                return WeekDayEnum:Thursday .
            when 5 then
                return WeekDayEnum:Friday .
            when 6 then
                return WeekDayEnum:Saturday .
            when 7 then
                return WeekDayEnum:Sunday .
        end case .

        return ? .

    end method .

    /**
     * Purpose: Returns the WeekDayEnum member that matches the passed in character
     *          value
     * Notes:   Only the first one or two characters are used for comparison:
     *          M, TU, W, TH, F, SA, SU
     * @param pcWeekDay The character value to return the weekday for
     * @return The WeekDay enum member matching the input value
     */
    method public static WeekDayEnum FromString (pcWeekDay as character):

        if pcWeekDay begins "M":U then
            return WeekDayEnum:Monday .
        if pcWeekDay begins "TU":U then
            return WeekDayEnum:Tuesday .
        if pcWeekDay begins "W":U then
            return WeekDayEnum:Wednesday .
        if pcWeekDay begins "TH":U then
            return WeekDayEnum:Thursday .
        if pcWeekDay begins "F":U then
            return WeekDayEnum:Friday .
        if pcWeekDay begins "SA":U then
            return WeekDayEnum:Saturday .
        if pcWeekDay begins "SU":U then
            return WeekDayEnum:Sunday .

        return ? .

    end method .

    /**
     * Purpose: Returns a CharacterList with the names of the Enum members
     * Notes:
     * @return The CharacterList with the names of the Enum members
     */
    method public static CharacterList GetNames ():

        return new CharacterList ('{&EnumMembers}':U).

    end method .

    /**
     * Purpose: Returns the Integer number of the day of the week matching the
     *          current WeekDayEnum member
     * Notes:   Using US week day norm, compatible to the ABL Weekday function
     * @return The Integer number of the day of the week
     */
    method public integer ToAblWeekDay ():

        define variable iDay as integer no-undo.

        assign iDay = this-object:Value + 1 .

        if iDay = 8 then
            return 1 .
        else
            return iDay .

    end method .

    /**
     * Purpose: Returns the Integer number of the day of the week matching the
     *          current WeekDayEnum member
     * Notes:   Following the ISO 8601 norm used in Germany and most European countries
     *          where the week starts with Monday
     * @return The Integer number of the day of the week
     */
    method public integer ToIsoWeekDay ():

        return this-object:Value .

    end method .

end class.
