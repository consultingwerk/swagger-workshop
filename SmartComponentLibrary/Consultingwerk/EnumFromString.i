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
    File        : EnumFromString.i
    Purpose     : Default method to turn a CHARACTER Value into an
                  Enum member reference

    Syntax      : {Consultingwerk/EnumFromString.i EnumPackage.EnumClassName}

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Feb 12 16:17:11 CEST 2013
    Notes       :
  ----------------------------------------------------------------------*/
&endif

&if not proversion begins "10.2":U &then
    /*------------------------------------------------------------------------------
        Purpose: Returns the reference to the Enum member with the given name
        Notes:   Only supported from OpenEdge 11.0 on
        @param pcMemberName The name of the Enum member to return
        @return The reference to the Enum member
    ------------------------------------------------------------------------------*/
    method public static {1} FromString (pcMemberName as character):

        return dynamic-property ("{1}":U, pcMemberName) .

        /* Error handling, when invalid member name was passed in */
        catch uncaught as Progress.Lang.Error:
            return ? .
        end catch.

    end method .

    /*------------------------------------------------------------------------------
        Purpose: Returns the reference to the Enum member with the given value
        Notes:   Only supported from OpenEdge 11.0 on
        @param piValue The value of the Enum member to return
        @return The reference to the Enum member
    ------------------------------------------------------------------------------*/
    method static public {1} FromValue (input piValue as integer):

        define variable iEntry as integer no-undo.

        assign iEntry = lookup(string(piValue), "{&EnumValues}":U) .

        Consultingwerk.Assertion.Assert:GreaterThanZero (iEntry) .

        return {1}:FromString  (entry(iEntry, "{&EnumMembers}":U)).

    end  method.
&endif
