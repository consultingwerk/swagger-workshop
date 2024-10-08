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
    File        : BufferCompareModeEnum
    Purpose     : Compare Mode value for BufferHelper:BufferCompare method
    Syntax      :
    Description :
    Author(s)   : Robert Chelaru / Consultingwerk Ltd.
    Created     : Mon Mar 22 15:46:14 EET 2021
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

{Consultingwerk/products.i}

&if defined (NativeEnums) ne 0 &then
enum Consultingwerk.Util.Enum.BufferCompareModeEnum :

    define enum BufferValue StringValue.

end enum.

&else
block-level on error undo, throw.

using Consultingwerk.Util.Enum.* from propath .
using Progress.Lang.*            from propath .

class Consultingwerk.Util.Enum.BufferCompareModeEnum
    inherits Consultingwerk.Enum:

    {Consultingwerk/EnumMember.i BufferValue 1 BufferCompareModeEnum}
    {Consultingwerk/EnumMember.i StringValue 2 BufferCompareModeEnum}

    /**
     * Purpose: Constructor for the BufferCompareModeEnum class
     * Notes:
     * @param piValue The integer enum value
     * @param pcLabel The character enum label
     */
    constructor public BufferCompareModeEnum (piValue as integer,
                                              pcLabel as character):
        super().

        assign this-object:Value = piValue
               this-object:Label = pcLabel .

    end constructor.

    {Consultingwerk/EnumFromString.i Consultingwerk.Util.Enum.BufferCompareModeEnum}

end class.
&endif