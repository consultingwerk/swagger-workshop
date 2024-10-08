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
    File        : ArrayBaseEnum
    Purpose     : Enum with possible values for the base of an Array
                  (e.g. JsonHelper:GetJsonObjectByPath())

    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Apr 11 21:13:31 CEST 2011
    Notes       : Used for the AfterInitializeBusinessEntityAdapterEventArgs
                  class
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

&if defined (NativeEnums) ne 0 &then
&scoped-define CLASS enum
&else
&scoped-define CLASS class
&endif

using Consultingwerk.*                      from propath .
using Progress.Lang.*                       from propath .

{&CLASS} Consultingwerk.ArrayBaseEnum
    &if "{&CLASS}" eq "class" &then
    inherits enum
    &endif
        :

&if "{&CLASS}" eq "enum" &then
    define enum
&endif

    /**
     * Purpose: 1-based Array (ABL default)
     * Notes:
     */
    {Consultingwerk/EnumMember.i One 1 ArrayBaseEnum}

    /**
     * Purpose: 0-based Array (C#, Java, JavaScript)
     * Notes:
     */
    {Consultingwerk/EnumMember.i Zero 2 ArrayBaseEnum}

&if "{&CLASS}" eq "enum" &then
    .
&endif

&if "{&CLASS}" eq "class" &then

    /**
     * Purpose: Constructor for the ArrayBaseEnum class
     * Notes:
     * @param piValue The integer enum value
     * @param pcLabel The character enum label
     */
    constructor private ArrayBaseEnum (piValue AS integer, pcLabel AS character):
        super ().

        assign this-object:Value = piValue
               this-object:Label = pcLabel .

    end constructor.

    {Consultingwerk/EnumFromString.i Consultingwerk.ArrayBaseEnum}

&endif

end {&CLASS} .
