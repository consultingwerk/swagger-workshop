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
    File        : CharacterHolder
    Purpose     : A holder class for ABL primitive values
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Oct 10 01:15:43 CEST 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.CharacterHolder
    inherits JsonSerializable
    implements IPrimitiveHolder &if defined (CommonComponentSpecification) ne 0 &then , Ccs.Common.Support.ICharacterHolder &endif
    {&SERIALIZABLE}:

    {Consultingwerk/JsonSerializableProperty.i Value character}

    /**
     * Purpose: Returns a holder for the CHARACTER unknown value
     * Notes:
     */
    define public static property Empty as CharacterHolder no-undo
    get:
        return new CharacterHolder ("":U) .
    end get .

    /**
     * Purpose: Returns a holder for the CHARACTER unknown value
     * Notes:
     */
    define public static property UnknownValue as CharacterHolder no-undo
    get:
        return new CharacterHolder (?) .
    end get .

    /**
     * Purpose: Constructor for the CharacterHolder class
     * Notes:
     */
    constructor public CharacterHolder ():
        super ().
    end constructor.

    /**
     * Purpose: Constructor for the CharacterHolder class
     * Notes:
     * @param pcValue The initial Value
     */
    constructor public CharacterHolder (pcValue as character):

        this-object:Value = pcValue .

    end constructor.

    /**
     * Purpose: Clones the object instance
     * Notes:
     * @return The cloned object instance
     */
    method public override Object Clone():

        return new CharacterHolder (this-object:Value) .

    end method.

    /**
     * Purpose: Performs by-value comparison with another holder class
     * Notes:   The provided object for comparison needs to be of the same type
     * @param poObject The object to compare with the current instance
     * @return Logical value indicating if this object and the passed in object instance have the same value
     */
    method override public logical Equals (poObject as Progress.Lang.Object):

        Consultingwerk.Assertion.ObjectAssert:IsValid (poObject, "poObject":U) .

        if type-of (poObject, CharacterHolder) and cast (poObject, CharacterHolder):Value = this-object:Value then
            return true .

        return false .

    end method .

    /**
     * Purpose: Returns the Expression to be used in a Query String
     * Notes:   Quoted value
     * @return The CHARACTER Expression
     */
    method public character GetExpression ():

        return quoter (this-object:Value) .

    end method .

    /**
     * Purpose: Returns the Value of the Holder instance
     * Notes:   Unquoted value
     * @return The value as a CHARACTER
     */
    method public character GetValue ():

        return this-object:Value .

    end method .

    /**
     * Purpose: Assigns a value to the UseSerializedTypeInformation property
     * Notes:
     * @param plValue The value for the UseSerializedTypeInformation property
     * @return The reference to the object instance itself
     */
    method public CharacterHolder SetUseSerializedTypeInformation (plValue as logical):

        assign this-object:UseSerializedTypeInformation = plValue .

        return this-object .

    end method.

    /**
     * Purpose: Returns a Character representation of the value
     * Notes:
     * @return The Character representation of the value
     */
    method override public character ToString ():

        return substitute ("CharacterHolder (&1)":U, this-object:Value) .

    end method .

end class.
