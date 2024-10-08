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
    File        : Sequence
    Purpose     : Default ISequence implementation
    Syntax      : 
    Description : Provides simple counter functionality with ability to 
                  increment and return a value in a single method call
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Jun 30 23:38:10 CEST 2014
    Notes       : 
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.*           from propath .  
using Consultingwerk.Assertion.* from propath . 
using Progress.Lang.*            from propath .

class Consultingwerk.Sequence 
    implements ISequence: 

    /**
     * Purpose: Returns the current sequence value
     * Notes:
     */
    define public property CurrentValue as int64 initial 0 no-undo
    get.
    private set .

    /**
     * Purpose: Returns the sequence increment
     * Notes:
     */
    define public property Increment as integer initial 1 no-undo 
    get.
    private set. 

    /**
     * Purpose: Return the sequence initial value
     * Notes:
     */
    define public property Initial as int64 initial 0 no-undo 
    get.
    private set. 
    
    /**
     * Purpose: Constructor for the Sequence class
     * Notes:
     */
    constructor public Sequence ():
        super ().
        
    end constructor.

    /**
     * Purpose: Constructor for the Sequence class
     * Notes:
     * @param piInitialValue The initial value to use for the sequence
     */
    constructor public Sequence (piInitialValue as int64):
        this-object (piInitialValue, 1).

    end constructor.

    /**
     * Purpose: Constructor for the Sequence class
     * Notes:
     * @param piInitialValue The initial value to use for the sequence
     * @param piIncrement The increment to use for the sequence (positive, negative)
     */
    constructor public Sequence (piInitialValue as int64,
                                 piIncrement as integer):
        super () .
        
        Assert:NotNullOrZero (piIncrement) .
        
        if piInitialValue = ? then 
            assign piInitialValue = 0 .        
        
        assign this-object:Initial   = piInitialValue
               this-object:Increment = piIncrement . 

    end constructor.
    
    /**
     * Purpose: Increments or decrements the sequence and returns the next value
     * Notes:
     * @return The new sequence value
     */
    method public int64 NextValue ():
        
        assign this-object:CurrentValue = this-object:CurrentValue +
                                          this-object:Increment . 
    
        return this-object:CurrentValue .
    
    end method . 

    /**
     * Purpose: Resets the sequence to its initial value
     * Notes:
     */
    method public void Reset ():

        assign this-object:CurrentValue = this-object:Initial .

    end method . 
    
end class.
