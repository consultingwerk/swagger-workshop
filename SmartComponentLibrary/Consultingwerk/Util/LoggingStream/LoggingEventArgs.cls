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
    File        : LoggingEventArgs
    Purpose     : Event Argument for the WriteMessage event of the
                  PubSubLoggingStream
    Syntax      :
    Description :
    Author(s)   : MIke Fechner / Consultingwerk Ltd.
    Created     : Tue Jan 23 15:52:48 CET 2018
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.Util.LoggingStream.LoggingEventArgs
    inherits EventArgs:

    /**
     * Purpose: Returns the message associated with the event
     * Notes:
     */
    define public property Message as character no-undo
    public get.
    protected set.

    /**
     * Purpose: Returns the message sub-system associated with the event
     * Notes:
     */
    define public property MessageSubSys as character no-undo
    public get.
    protected set.

    /**
     * Purpose: Constructor for the LoggingEventArgs classs
     * Notes:
     * @param pcMessage The message associated with the event
     * @param pcMessageSubSys The message sub system associated with the event
     */
    constructor public LoggingEventArgs (pcMessage as character,
                                         pcMessageSubSys as character):
        super ().

        assign this-object:Message       = pcMessage
               this-object:MessageSubSys = pcMessageSubSys .

    end constructor.

    /**
     * Purpose: Constructor for the LoggingEventArgs classs
     * Notes:
     * @param pcMessage The message associated with the event
     */
    constructor public LoggingEventArgs (pcMessage as character):
        super ().

        assign this-object:Message = pcMessage .

    end constructor.

    /**
     * Purpose: Constructor for the LoggingEventArgs classs
     * Notes:
     */
    constructor public LoggingEventArgs ():
        super ().

    end constructor.

end class.
