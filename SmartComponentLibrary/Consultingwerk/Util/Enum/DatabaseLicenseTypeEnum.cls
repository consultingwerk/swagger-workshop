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
    File        : DatabaseLicenseTypeEnum
    Purpose     : Return value for DatabaseHelper:DatabaseLicense
    Syntax      :
    Description :
    Author(s)   : Sebastian Wandel / Consultingwerk Ltd.
    Created     : Thu Sep 10 11:40:34 CEST 2020
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

{Consultingwerk/products.i}

&if defined (NativeEnums) ne 0 &then
enum Consultingwerk.Util.Enum.DatabaseLicenseTypeEnum :

    define enum Workgroup Enterprise.

end enum.

&else
block-level on error undo, throw.

using Consultingwerk.Util.Enum.* from propath .
using Progress.Lang.*            from propath .

class Consultingwerk.Util.Enum.DatabaseLicenseTypeEnum
    inherits Consultingwerk.Enum:

    {Consultingwerk/EnumMember.i Workgroup 1 DatabaseLicenseTypeEnum}
    {Consultingwerk/EnumMember.i Enterprise 2 DatabaseLicenseTypeEnum}

    /**
     * Purpose: Constructor for the DatabaseLicenseTypeEnum class
     * Notes:
     * @param piValue The integer enum value
     * @param pcLabel The character enum label
     */
    constructor public DatabaseLicenseTypeEnum (piValue as integer,
                                                pcLabel as character):
        super().

        assign this-object:Value = piValue
               this-object:Label = pcLabel .

    end constructor.

    {Consultingwerk/EnumFromString.i Consultingwerk.Util.Enum.DatabaseLicenseTypeEnum}

end class.
&endif