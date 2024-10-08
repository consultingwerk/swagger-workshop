&if 1=0 &then
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
    File        : EnumMember.i
    Purpose     : Defines an Enum Member property in an Enum class

    Syntax      : {Consultingwerk/EnumMember.i Label Value TypeName}

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Aug 25 12:24:36 CEST 2010
    Notes       :
  ----------------------------------------------------------------------*/
&endif

&if "{&CLASS}" ne "enum" &then
    define public static property {1} as {3} no-undo
    get:
        if not valid-object ({3}:{1}) then
            {3}:{1} = new {3} ({2}, "{1}":U) .

        return {3}:{1} .
    end get .
    private set.
&else
    {1} = {2}
&endif

&if "{&EnumMembers}":U ne "":U &then
&global-define EnumMembers {&EnumMembers},{1}
&else
&global-define EnumMembers {1}
&endif

&if "{&EnumValues}":U ne "":U &then
&global-define EnumValues {&EnumValues},{2}
&else
&global-define EnumValues {2}
&endif

&global-define {1} {2}
