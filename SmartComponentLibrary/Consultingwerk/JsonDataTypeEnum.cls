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
    File        : JsonDataTypeEnum
    Purpose     : Enum variant of the Progress.Json.ObjectModel.JsonDataType
                  class. The built in Progress class is just a collection
                  of INTEGER constants, not a true Enum
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat May 20 16:03:42 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

&if defined (NativeEnums) ne 0 &then
enum Consultingwerk.JsonDataTypeEnum:

    define enum String  = 1
                Number  = 2
                Boolean = 3
                Object  = 4
                Array   = 5
                Null    = 6 .

end enum .

&else
class Consultingwerk.JsonDataTypeEnum
    inherits Consultingwerk.Enum:

    {Consultingwerk/EnumMember.i String  1 JsonDataTypeEnum}
    {Consultingwerk/EnumMember.i Number  2 JsonDataTypeEnum}
    {Consultingwerk/EnumMember.i Boolean 3 JsonDataTypeEnum}
    {Consultingwerk/EnumMember.i Object  4 JsonDataTypeEnum}
    {Consultingwerk/EnumMember.i Array   5 JsonDataTypeEnum}
    {Consultingwerk/EnumMember.i Null    6 JsonDataTypeEnum}

    /**
     * Purpose: Constructor for the JsonDataTypeEnum class
     * Notes:
     * @param piValue The integer enum value
     * @param pcLabel The character enum label
     */
    constructor private JsonDataTypeEnum (piValue AS integer, pcLabel as character):
        super ().

        assign this-object:Value = piValue
               this-object:Label = pcLabel .

    end constructor.

    {Consultingwerk/EnumFromString.i Consultingwerk.JsonDataTypeEnum}

end class.
&endif
