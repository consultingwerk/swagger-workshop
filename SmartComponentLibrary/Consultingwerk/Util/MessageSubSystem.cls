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
    File        : MessageSubSystem
    Purpose     : Holder class for LogManager message sub system
    Syntax      : Represents a custom log entry type. Simplifies signatures
                  of the LogManager:WriteMessage... methods as this type
                  allows specific signatures for passing the custom logging
                  types
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon May 05 20:13:39 CEST 2014
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.*                from propath .
using Consultingwerk.Framework.Enum.* from propath .
using Consultingwerk.Util.*           from propath .
using Progress.Lang.*                 from propath .

{Consultingwerk/products.i}

class Consultingwerk.Util.MessageSubSystem
    inherits CharacterHolder:

    /**
     * Purpose: Gets and sets the Logging Level associated with this
     *          Custom Log entry type
     * Notes:
     */
    define public property LoggingLevel as LoggingLevelEnum no-undo
    get.
    set.

    /**
     * Purpose: Constructor for the MessageSubSystem class
     * Notes:
     * @param pcMessageSubSys The value for the Message Sub System
     * @param poLoggingLevel The LoggingLevelEnum value (None, Errors, Basic, Verbose, Extended)
     */
    constructor public MessageSubSystem (pcMessageSubSys as character,
                                         poLoggingLevel as LoggingLevelEnum):
        super (pcMessageSubSys).

        assign this-object:LoggingLevel = poLoggingLevel .

    end constructor.

    /**
     * Purpose: Constructor for the MessageSubSystem class
     * Notes:
     * @param pcMessageSubSys The value for the Message Sub System
     */
    constructor public MessageSubSystem (pcMessageSubSys as character):
        super (pcMessageSubSys).

    end constructor.

    /**
     * Purpose: Returns a Character representation of the value
     * Notes:
     * @return The Character representation of the value
     */
    method override public character ToString ():

        if valid-object (this-object:LoggingLevel) then
            return substitute ("&1:&2":U,
                               this-object:Value,
                               this-object:LoggingLevel:GetValue()) .
        else
            return this-object:Value .

    end method .

end class.
