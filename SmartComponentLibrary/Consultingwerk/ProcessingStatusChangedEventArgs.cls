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
    File        : ProcessingStatusChangedEventArgs
    Purpose     : Cancelable Event Argument to be used for status events 
                  raised by batch like tasks
    Syntax      : 
    Description : May be used in the context of the GenericProcessingStatusWithCancelForm class  
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Jul 22 21:33:21 CEST 2014
    Notes       : 
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.* from propath .  
using Progress.Lang.*  from propath .

class Consultingwerk.ProcessingStatusChangedEventArgs 
    inherits CancelableEventArgs: 

    /**
     * Purpose: Returns the status message of this event
     * Notes:
     */
    define public property Message as character no-undo 
    get.
    protected set. 

    /**
     * Purpose: Constructor for the ProcessingStatusChangedEventArgs class
     * Notes:
     * @param pcMessage The message associated with this event
     */
    constructor public ProcessingStatusChangedEventArgs (pcMessage as character):
        super ().
        
        assign this-object:Message = pcMessage .
        
    end constructor.

end class.
