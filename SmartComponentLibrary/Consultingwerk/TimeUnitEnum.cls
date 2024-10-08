/**********************************************************************
 * Copyright (C) 2023-2023 by Consultingwerk Ltd. ("CW") -            *
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
    File        : TimeUnitEnum
    Purpose     : Time unit enumeration
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-09-21
    Notes       : * Based on the units the ABL uses for the INTERVAL and other functions.
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

enum Consultingwerk.TimeUnitEnum:

    define enum Years
                Months
                Weeks
                Days
                Hours
                Minutes
                Seconds
                Milliseconds .

end enum.
