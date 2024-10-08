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
    File        : FilterByPrivateDataOperatorEnum
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Mar 14 09:52:12 CET 2013
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
using Consultingwerk.Util.Enum.*             from propath .
using Progress.Lang.*                        from propath .

{&CLASS} Consultingwerk.Util.Enum.FilterByPrivateDataOperatorEnum
    &if "{&CLASS}" eq "class" &then
    inherits enum
    &endif
        :

&if "{&CLASS}" eq "enum" &then
    define enum
&endif

    {Consultingwerk/EnumMember.i EQ 0 FilterByPrivateDataOperatorEnum}
    {Consultingwerk/EnumMember.i Begins 1 FilterByPrivateDataOperatorEnum}
    {Consultingwerk/EnumMember.i Matches 2 FilterByPrivateDataOperatorEnum}
    {Consultingwerk/EnumMember.i NE 3 FilterByPrivateDataOperatorEnum}
    {Consultingwerk/EnumMember.i BeginsNot 4 FilterByPrivateDataOperatorEnum}
    {Consultingwerk/EnumMember.i MatchesNot 5 FilterByPrivateDataOperatorEnum}

&if "{&CLASS}" eq "enum" &then
    .
&endif

&if "{&CLASS}" eq "class" &then

    /**
     * Purpose: Constructor for the FilterByPrivateDataOperatorEnum members
     * Notes:
     * @param piValue The internal (numeric) representation of the Enumeration member
     * @param pcLabel The text label of the Enumaration member
     */
    constructor private FilterByPrivateDataOperatorEnum (piValue as integer, pcLabel as character):
        super ().

        assign this-object:Value = piValue
               this-object:Label = pcLabel .

    end constructor.

    /**
     * Purpose: Returns a CharacterList with the names of the Enum members
     * Notes:
     * @return The CharacterList with the names of the Enum members
     */
    method public static CharacterList GetNames ():

        return new CharacterList ('{&EnumMembers}':U).

    end method .

    {Consultingwerk/EnumFromString.i Consultingwerk.Util.Enum.FilterByPrivateDataOperatorEnum}

&endif

end {&CLASS} .
