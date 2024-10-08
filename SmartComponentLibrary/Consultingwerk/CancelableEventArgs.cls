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
    File        : CancelableEventArgs
    Purpose     : Generic argument class for cancellable events 
    Syntax      : 
    Description : 
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Dec 19 21:42:29 CET 2009
    Notes       : Typically used in before events to allow a subscriber to 
                  cancel the following operation associated with the event
                  The SmartComponent Library does as of February 2012
                  by default use the .NET System.ComponentModel.CancelEventArgs
                  instead of Consultingwerk.CancellableEventArgs as in 
                  OpenEdge 11.0 the Visual Designer causes serious issues 
                  when editing components that use non .NET derived objects 
                  as event arguments.
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Progress.Lang.* from propath .

class Consultingwerk.CancelableEventArgs
    inherits Consultingwerk.EventArgs: 
    
    /**
     * Purpose: Gets or sets a value indicating whether the event should be canceled.
     * Notes:   This property can be used by event subscribers to signal that the
     *          operation following the before event should be cancelled
     */
    define public property Cancel as logical no-undo initial false  
    get.
    set.    

 end class.
 