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
    File        : StatusChangedEventArgs
    Purpose     : General purpose StatusChanged event argument
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Nov 19 08:07:04 CET 2013
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.StatusChangedEventArgs inherits EventArgs:

    /**
     * Purpose: Gets and sets the status associated with the StatusChanged event
     * Notes:
     */
    define public property Status as character no-undo
    get.
    set.

    /**
     * Purpose: Constructor for the StatusChangedEventArgs class
     * Notes:
     */
    constructor public StatusChangedEventArgs ():
        super ().

    end constructor.

    /**
     * Purpose: Constructor for the StatusChangedEventArgs class
     * Notes:
     * @param pcStatus The value for the Status property
     */
    constructor public StatusChangedEventArgs (pcStatus as character):
        super ().

        this-object:Status = pcStatus .

    end constructor.

end class.
