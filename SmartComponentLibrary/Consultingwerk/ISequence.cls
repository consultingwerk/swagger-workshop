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
    File        : ISequence
    Purpose     : Interface for Sequence style classes
    Syntax      : 
    Description : Provides simple counter functionality with ability to 
                  increment and return a value in a single method call
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Jun 30 23:30:33 CEST 2014
    Notes       : 
  ----------------------------------------------------------------------*/

@lowercase.

using Consultingwerk.* from propath .  
using Progress.Lang.*  from propath .

interface Consultingwerk.ISequence:  

    /**
     * Purpose: Returns the current sequence value
     * Notes:
     */
    define public property CurrentValue as int64 no-undo 
    get.

    /**
     * Purpose: Increments or decrements the sequence and returns the next value
     * Notes:
     * @return The new sequence value
     */
    method public int64 NextValue ().

    /**
     * Purpose: Resets the sequence to its initial value
     * Notes:
     */
    method public void Reset ().

end interface.
