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
    File        : DateType
    Purpose     : Contains supporting routines for ABL DATE Variables
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Oct 11 22:44:25 CEST 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.DateType:

    /**
     * Purpose: Constructor for the DateType class
     * Notes:   Disallow instance creation
     */
    constructor private DateType ():
        super ().

    end constructor.

    /**
     * Purpose: Returns the date of the first day of the month relatively to the given date
     * Notes:   When no date is passed in, the current month will be used
     * @param pdtDate The base date
     * @return The date of the first day of the year
     */
    method public static date FirstDayOfMonth (pdtDate as date):

        if pdtDate = ? then
            pdtDate = today .

        return date (month (pdtDate), 1, year (pdtDate)) .

    end method .

    /**
     * Purpose: Returns the date of the first day of the next month relatively to the given
     *          date
     * Notes:   When no date is passed in, the current month will be used
     * @param pdtDate The base date
     * @return The date of the first day of the year
     */
    method public static date FirstDayOfNextMonth (pdtDate as date):

        if pdtDate = ? then
            pdtDate = today .

        assign pdtDate = DateType:FirstDayOfMonth (pdtDate) .

        return DateType:FirstDayOfMonth (pdtDate + 31) .

    end method .

    /**
     * Purpose: Returns the date of the first day in the given week
     * Notes:   Follows the the ISO 8601 norm used in Germany and most European
     *          countries where the week starts with Monday
     * @param pdtDate The base date
     * @return The date of the first day of the week
     */
    method public static date FirstDayOfWeek (pdtDate as date):

        if pdtDate = ? then
            pdtDate = today .

        return pdtDate - IsoWeekDay (pdtDate) + 1 .

    end method .

    /**
     * Purpose: Returns the date of January 1st relatively to the given date
     * Notes:   When no date is passed in, the current year will be used
     * @param pdtDate The base date
     * @return The date of the first day of the year
     */
    method public static date FirstDayOfYear (pdtDate as date):

        if pdtDate = ? then
            pdtDate = today .

        return date (1, 1, year (pdtDate)) .

    end method .

    /**
     * Purpose: Returns true when the date of the given date is in a leap year
     * Notes:   When no date is passed in, the current month will be used
     * @param pdtDate The base date
     * @return Logical value indicating if the given date is in a leap year
     */
    method public static logical IsLeapYear (pdtDate as date):

        if pdtDate = ? then
            pdtDate = today .

        if LastDayOfYear (pdtDate) - FirstDayOfYear (pdtDate) = 365 then
            return true .
        else
            return false .

    end method .

    /**
     * Purpose: Returns the week day (1..7) using the ISO 8601 norm used in Germany
     *          and most European countries where the week starts with Monday
     * Notes:   http://en.wikipedia.org/wiki/ISO_week_date
     * @param pdtDate The date to use for the IsoWeekDay calculation
     * @return The weekday as a number from 1..7
     */
    method public static integer IsoWeekDay (pdtDate as date):

        define variable iWeekday as integer no-undo.

        if pdtDate = ? then
            pdtDate = today .

        assign iWeekday = weekday (pdtDate) - 1 .

        /* Sunday */
        if iWeekday = 0 then
            return 7 .

        return iWeekday .

    end method .

    /**
     * Purpose: Returns the date of the last day of the month relatively to the given date
     * Notes:   When no date is passed in, the current month will be used
     * @param pdtDate The base date
     * @return The date of the last day of the month
     */
    method public static date LastDayOfMonth (pdtDate as date):

        define variable iMonth as integer no-undo.
        define variable iYear  as integer no-undo.

        if pdtDate = ? then
            pdtDate = today .

        assign iMonth = month (pdtDate)
               iYear = year (pdtDate) .

        return date (iMonth, LastDayNumberOfMonth (pdtDate), iYear) .

    end method .

  /**
     * Purpose: Returns the day number of the last day of the month relatively
     *          to the given date
     * Notes:   When no date is passed in, the current month will be used
     * @param pdtDate The base date
     * @return The dya number of the last day of the month
     */
    method public static integer LastDayNumberOfMonth (pdtDate as date):

        define variable iMonth as integer no-undo.
        define variable iDays  as integer no-undo extent 12
            initial [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 ] .

        if pdtDate = ? then
            pdtDate = today .

        assign iMonth = month (pdtDate) .

        if iMonth = 2 and IsLeapYear (pdtDate) then
            return 29 .

        return iDays[iMonth] .

    end method .

    /**
     * Purpose: Returns the date of the last day in the given week
     * Notes:   Follows the the ISO 8601 norm used in Germany and most European
     *          countries where the week starts with Monday
     * @param pdtDate The base date
     * @return The date of the last day of the week
     */
    method public static date LastDayOfWeek (pdtDate as date):

        if pdtDate = ? then
            pdtDate = today .

        return pdtDate - IsoWeekDay (pdtDate) + 7 .

    end method .

    /**
     * Purpose: Returns the date of December 31st relatively to the given date
     * Notes:   When no date is passed in, the current year will be used
     * @param pdtDate The base date
     * @return The date of the first day of the year
     */
    method public static date LastDayOfYear (pdtDate as date):

        if pdtDate = ? then
            pdtDate = today .

        return date (12, 31, year (pdtDate)) .

    end method .

    /**
     * Purpose: Returns the week number of the given date
     * Notes:
     * @param pdtDate The base date
     * @return The week number of the given date
     */
    method public static integer WeekNumber (pdtDate as date):

        define variable dtStartWeek1 as date    no-undo.
        define variable iWeek        as integer no-undo.

        if pdtDate = ? then
            pdtDate = today .

        {&_proparse_ prolint-nowarn(overflow)}
        assign dtStartWeek1 = FirstDayOfWeek (date (1, 4, year (pdtDate)))
               iWeek        = integer ((FirstDayOfWeek (pdtDate) - dtStartWeek1) / 7) + 1 .

        return iWeek .

    end method .

end class.
