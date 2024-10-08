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
    File        : Enum
    Purpose     : Abstract base type for Enum classes
    Syntax      : 
    Description : 
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Aug 25 10:30:24 CEST 2010
    Notes       : http://blog.consultingwerk.de/consultingwerkblog/2010/08/a-pattern-for-enums
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Progress.Lang.*.

class Consultingwerk.Enum abstract: 

    /**
     * Purpose: Returns the character label associated with an enum member instance
     * Notes:   Instance member
     */
    define protected property Label as character no-undo
    get.
    set.
    
    /**
     * Purpose: Returns the integer value associated with an enum member instance
     * Notes:   Instance member
     */
    define public property Value as integer no-undo 
    get.
    protected set. 

    /**
     * Purpose: Compares this Enum member to another member of this Enum by Value
     * Notes:   Returns FALSE when the passed in object reference is not of this
     *          Enum type
     * @param poParam The object to compare by value and type with the current enum member
     * @return Logical value indicating if the two compared enum members are euqally
     */
    method override public logical Equals (input poParam as Progress.Lang.Object):
        
        /* Mike Fechner, Consultingwerk Ltd. 24.03.2011
           When poParam is invalid, Euquals returns FALSE */
        if (not valid-object (poParam)) or (not poParam:GetClass() = this-object:GetClass()) then 
            return false . 
        
        return cast (poParam, Consultingwerk.Enum):Value = this-object:Value .

    end method.

    /**
     * Purpose: Returns the Value of the Enum Member
     * Notes:   Introduced for compability with 11.6 native Enums
     * @return The Enum Memeber value
     */
    method public final int64 GetValue ():
        
        return this-object:Value .

    end method .

    /**
     * Purpose: Returns a CHARACTER representation (human readable) of the
     *          Enum member
     * Notes:
     * @return The CHARACTER representation of the enum member, identically to the Label property
     */
    method override public character ToString ():
        
        return this-object:Label .

    end method.

end class.