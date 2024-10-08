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
    File        : OperatorEnum
    Purpose     : Enumeration of Operators
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Oct 10 11:58:06 CEST 2012
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
using Consultingwerk.Exceptions.*            from propath .
using Consultingwerk.Framework.Collections.* from propath .
using Progress.Lang.*                        from propath .

{&CLASS} Consultingwerk.OperatorEnum
    &if "{&CLASS}" eq "class" &then
    inherits enum
    &endif
        :

&if "{&CLASS}" eq "enum" &then
    define enum
&endif

    {Consultingwerk/EnumMember.i EQ 0 OperatorEnum}
    {Consultingwerk/EnumMember.i Begins 1 OperatorEnum}
    {Consultingwerk/EnumMember.i Contains 2 OperatorEnum}
    {Consultingwerk/EnumMember.i Matches 3 OperatorEnum}
    {Consultingwerk/EnumMember.i GE 4 OperatorEnum}
    {Consultingwerk/EnumMember.i GT 5 OperatorEnum}
    {Consultingwerk/EnumMember.i LE 6 OperatorEnum}
    {Consultingwerk/EnumMember.i LT 7 OperatorEnum}
    {Consultingwerk/EnumMember.i NE 8 OperatorEnum}

    {Consultingwerk/EnumMember.i InRange 9 OperatorEnum}

    {Consultingwerk/EnumMember.i And 10 OperatorEnum}
    {Consultingwerk/EnumMember.i Or 11 OperatorEnum}

&if "{&CLASS}" eq "enum" &then
    .
&endif

&if "{&CLASS}" eq "class" &then

    /**
     * Purpose: Constructor for the OperatorEnum members
     * Notes:
     * @param piValue The internal (numeric) representation of the Enumeration member
     * @param pcLabel The text label of the Enumaration member
     */
    constructor private OperatorEnum (piValue as integer, pcLabel as character):
        super ().

        assign this-object:Value = piValue
               this-object:Label = pcLabel .

    end constructor.

    /**
     * Purpose: Returns the Enum member with the given name
     * Notes:   Supports the Enum member names as well as =, <>, >=, >, <= and <
     *          Method is duplicated on as Consultingwerk.QueryParser:OperatorFromString
     *          as this method here is not supported anymore from OpenEdge 11.6 on
     *          when using the native Enums
     * @param pcName The Name of the Enum member
     * @return The Enum member with the given name
     */
    method public static OperatorEnum FromString (pcName as character):

        return QueryParser:OperatorFromString (pcName) .

    end method .

    /**
     * Purpose: Returns the Character expression of the Enum
     * Notes:
     * @return The Character representation of the Enum
     */
    method override public character ToString ():

        return upper (super:ToString()) .

    end method .

    /**
     * Purpose: Returns a CharacterList with the names of the Enum members
     * Notes:
     * @return The CharacterList with the names of the Enum members
     */
    method public static CharacterList GetNames ():

        return new CharacterList ('{&EnumMembers}':U).

    end method .

&endif

end {&CLASS} .
