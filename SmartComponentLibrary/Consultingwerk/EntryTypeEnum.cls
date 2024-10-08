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
    File        : EntryTypeEnum
    Purpose     : Enum used by ProcedureHelper:HasEntry
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Mar 18 16:10:31 CET 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

&if defined (NativeEnums) ne 0 &then
&scoped-define CLASS enum 
&else
&scoped-define CLASS class
&endif

using Consultingwerk.*                       from propath .
using Consultingwerk.Framework.Collections.* from propath .
using Progress.Lang.*                        from propath .

{&CLASS} Consultingwerk.EntryTypeEnum
    &if "{&CLASS}" eq "class" &then
    inherits enum
    &endif
        :

&if "{&CLASS}" eq "enum" &then
    define enum
&endif

    /* Static members */
    {Consultingwerk/EnumMember.i Procedure 1 EntryTypeEnum}
    {Consultingwerk/EnumMember.i Function 2 EntryTypeEnum}
    {Consultingwerk/EnumMember.i Extern 3 EntryTypeEnum}
    {Consultingwerk/EnumMember.i DllEntry 4 EntryTypeEnum}

&if "{&CLASS}" eq "enum" &then
    .
&endif

&if "{&CLASS}" eq "class" &then

    /**
     * Purpose: Constructor for the EntryTypeEnum members
     * Notes:
     * @param piValue The internal (numeric) representation of the Enumeration member
     * @param pcLabel The text label of the Enumaration member
     */
    constructor private EntryTypeEnum (piValue AS integer, pcLabel as character):
        super ().

        assign this-object:Value = piValue
               this-object:Label = pcLabel .

    end constructor.

    /**
     * Purpose: Returns the string representation of the Enum member
     * Notes:
     * @return The CHARACTER value representing this enum member
     */
    method override public character ToString ():

        case this-object:Value:
            when 1 then
                return "PROCEDURE":U .
            when 2 then
                return "FUNCTION":U .
            when 3 then
                return "EXTERN":U .
            when 4 then
                return "DLL-ENTRY":U .
        end case .

        undo, throw new Consultingwerk.Exceptions.InvalidValueException
                            (string (this-object:Value),
                             "EntryTypeEnum":U) .

    end method.

    /**
     * Purpose: Returns a CharacterList with the names of the Enum members
     * Notes:
     * @return The CharacterList with the names of the Enum members
     */
    metho public static CharacterList GetNames ():

        return new CharacterList ('{&EnumMembers}':U).

    end method .

    {Consultingwerk/EnumFromString.i Consultingwerk.EntryTypeEnum}

&endif

end {&CLASS} .
