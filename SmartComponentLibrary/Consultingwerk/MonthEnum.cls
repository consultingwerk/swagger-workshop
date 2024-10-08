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
    File        : MonthEnum
    Purpose     : Enumeration of the Months of a year
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Jun 06 13:59:57 CEST 2015
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
using Consultingwerk.*                       from propath .
using Progress.Lang.*                        from propath .

{&CLASS} Consultingwerk.MonthEnum
    &if "{&CLASS}" eq "class" &then
    inherits enum
    &endif
        :

&if "{&CLASS}" eq "enum" &then
    define enum
&endif

    {Consultingwerk/EnumMember.i January 1 MonthEnum}
    {Consultingwerk/EnumMember.i February 2 MonthEnum}
    {Consultingwerk/EnumMember.i March 3 MonthEnum}
    {Consultingwerk/EnumMember.i April 4 MonthEnum}
    {Consultingwerk/EnumMember.i May 5 MonthEnum}
    {Consultingwerk/EnumMember.i June 6 MonthEnum}
    {Consultingwerk/EnumMember.i July 7 MonthEnum}
    {Consultingwerk/EnumMember.i August 8 MonthEnum}
    {Consultingwerk/EnumMember.i September 9 MonthEnum}
    {Consultingwerk/EnumMember.i October 10 MonthEnum}
    {Consultingwerk/EnumMember.i November 11 MonthEnum}
    {Consultingwerk/EnumMember.i December 12 MonthEnum}

&if "{&CLASS}" eq "enum" &then
    .
&endif

&if "{&CLASS}" eq "class" &then

    /**
     * Purpose: Constructor for the MonthEnum members
     * Notes:
     * @param piValue The internal (numeric) representation of the Enumeration member
     * @param pcLabel The text label of the Enumaration member
     */
    constructor private MonthEnum (piValue as integer, pcLabel as character):
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

    {Consultingwerk/EnumFromString.i Consultingwerk.MonthEnum}

&endif

end {&CLASS} .
