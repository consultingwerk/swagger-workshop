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
    File        : EventArgs
    Purpose     : Generic event argument class
    Syntax      : 
    Description : 
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Dec 19 15:09:13 CET 2009
    Notes       : The SmartComponent Library does as of February 2012
                  by default use the .NET System.EventArgs instead of 
                  Consultingwerk.EventArgs as in OpenEdge 11.0 the Visual 
                  Designer causes serious issues when editing components 
                  that use non .NET derived objects as event arguments.
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Progress.Lang.* from propath .

class Consultingwerk.EventArgs:

    define private static variable oEmpty as Consultingwerk.EventArgs no-undo . 

    /**
     * Purpose: Returns the default instance of the Consultingwerk.EventArgs class
     * Notes:
     */
    define public static property Empty as Consultingwerk.EventArgs no-undo 
    get:
        if not valid-object (oEmpty) then
            oEmpty = new Consultingwerk.EventArgs () .
             
        return oEmpty . 
    end get.

end class.
