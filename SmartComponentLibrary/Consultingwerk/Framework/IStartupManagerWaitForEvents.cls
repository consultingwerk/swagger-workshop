/**********************************************************************
 * Copyright (C) 2006-2018 by Consultingwerk Ltd. ("CW") -            *
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
    File        : IStartupManagerWaitForEvents
    Purpose     : Describes events of the GUI Startup Manager around the WAIT-FOR
                  statement
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Aug 26 18:25:52 CEST 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

INTERFACE Consultingwerk.Framework.IStartupManagerWaitForEvents:

    /**
     * Purpose: Raised after the WAIT-FOR Application:Run() is executed
     * Notes:
     * @param sender The object that raised the AfterWaitFor event
     * @param e The Consultingwerk.EventArgs with the data for the event
     */
    DEFINE PUBLIC EVENT AfterWaitFor SIGNATURE VOID (sender AS Progress.Lang.Object,
                                                     e AS Consultingwerk.EventArgs).

    /**
     * Purpose: Raised before the WAIT-FOR Application:Run() is executed
     * Notes:
     * @param sender The object that raised the BeforeWaitFor event
     * @param e The Consultingwerk.EventArgs with the data for the event
     */
    DEFINE PUBLIC EVENT BeforeWaitFor SIGNATURE VOID (sender AS Progress.Lang.Object,
                                                      e AS Consultingwerk.EventArgs).

END INTERFACE.
