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
    File        : LogEntryTypesEnum
    Purpose     : Enum of ABL Log Entry Types
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Mar 14 09:52:12 CET 2013
    Notes       : Entries starting with "4" start with Four
                  . in the entry name is replaced with _
                  * in the entry name is replaced with #
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

{&CLASS} Consultingwerk.Util.Enum.LogEntryTypesEnum
    &if "{&CLASS}" eq "class" &then
    inherits enum
    &endif
        :

&if "{&CLASS}" eq "enum" &then
    define enum
&endif

    {Consultingwerk/EnumMember.i FourGLMessages 0 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i FourGLTrace 1 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i FourGLTrans 2 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i Actional 3 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i ASDefault 4 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i ASPlumbing 5 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i ASK 6 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DB_# 7 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DB_Connects 8 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DB_Encryption 9 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DS_# 10 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DS_Cursor 11 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DS_QryInfo 12 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DS_Performance 13 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DynObjects_# 14 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DynObjects_Class 15 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DynObjects_DB 16 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DynObjects_Other 17 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DynObjects_UI 18 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i DynObjects_XML 19 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i FileID 20 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i IgnoredOps 21 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i MSASAdmin 22 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i MSASSessions 23 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i MSASSignals 24 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i MSASSockets 25 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i ProEvents_# 26 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i ProEvents_UI_# 27 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i ProEvents_UI_Char 28 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i ProEvents_UI_Command 29 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i ProEvents_Other 30 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i QryInfo 31 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i SAX 32 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i Temp-Tables 33 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i TTStats 34 LogEntryTypesEnum}
    {Consultingwerk/EnumMember.i WSO 35 LogEntryTypesEnum}

&if "{&CLASS}" eq "enum" &then
    .
&endif

&if "{&CLASS}" eq "class" &then

    /**
     * Purpose: Constructor for the LogEntryTypesEnum members
     * Notes:
     * @param piValue The internal (numeric) representation of the Enumeration member
     * @param pcLabel The text label of the Enumaration member
     */
    constructor private LogEntryTypesEnum (piValue as integer, pcLabel as character):
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

    {Consultingwerk/EnumFromString.i Consultingwerk.Util.Enum.LogEntryTypesEnum}

&endif

end {&CLASS} .
