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
    File        : DatasetControlStringEnum
    Purpose     : Return value for the DatasetHelper:DatasetControlString
                  method
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 15.03.2019 21:04:16
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

{Consultingwerk/products.i}

&if defined (NativeEnums) ne 0 &then
enum Consultingwerk.Util.Enum.DatasetControlStringEnum:

    define enum Cancel QuestionsPending  .

end enum .

&else
block-level on error undo, throw.

using Consultingwerk.Util.Enum.*                from propath .
using Progress.Lang.*                           from propath .

class Consultingwerk.Util.Enum.DatasetControlStringEnum
    inherits Consultingwerk.Enum:

    {Consultingwerk/EnumMember.i Cancel 1 DatasetControlStringEnum}
    {Consultingwerk/EnumMember.i QuestionsPending 2 DatasetControlStringEnum}

    /**
     * Purpose: Constructor for the DatasetControlStringEnum class
     * Notes:
     * @param piValue The integer enum value
     * @param pcLabel The character enum label
     */
    constructor private DatasetControlStringEnum (piValue as integer, pcLabel as character):
        super ().

        assign this-object:Value = piValue
               this-object:Label = pcLabel .

    end constructor.

    {Consultingwerk/EnumFromString.i Consultingwerk.Util.Enum.DatasetControlStringEnum}

end class.
&endif
