&if 1=0 &then
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
    File        : NotNullOrEmpty.i
    Purpose     : Include File base Assertion for NotNullOrEmpty

    Syntax      : {Consultingwerk/Assertion/Assert/NotNullOrEmpty.i pcValue}
                  {Consultingwerk/Assertion/Assert/NotNullOrEmpty.i pcValue """Description"":U"}

    Description : Reduces runtime overhead of using the IsAvailable assertion

    Author(s)   :
    Created     : Thu Jun 25 21:33:03 CEST 2015
    Notes       : SCL-875
  ----------------------------------------------------------------------*/
&endif

    do:
        if {1} = "":U or {1} = ? then
            undo, throw new Consultingwerk.Exceptions.InvalidValueException (string({1}) &if "{2}" ne "" &then , {2} &endif) .
    end.