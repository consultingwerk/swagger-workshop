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
    File        : NumericFormat
    Purpose     : Holder structure for SESSION numeric value settings
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Nov 15 23:11:47 CET 2012
    Notes       : Serializable class, so that it can be marshalled to an
                  AppServer
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.NumericFormat
    inherits JsonSerializable
    {&SERIALIZABLE}:

    {Consultingwerk/JsonSerializableProperty.i NumSeparator character}
    {Consultingwerk/JsonSerializableProperty.i DecimalPoint character}

end class.
