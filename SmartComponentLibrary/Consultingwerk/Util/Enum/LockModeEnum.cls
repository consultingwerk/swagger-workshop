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
    File        : LockModeEnum
    Purpose     : Enum for the record locking mode (no-lock, share-lock, exclusive-lock)
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Sep 21 18:10:48 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.Util.Enum.* from propath .
using Progress.Lang.*            from propath .

&if defined (NativeEnums) ne 0 &then
enum Consultingwerk.Util.Enum.LockModeEnum:

    define enum NoLock ShareLock ExclusiveLock .

end enum .

&else
class Consultingwerk.Util.Enum.LockModeEnum
    inherits Consultingwerk.Enum:

    {Consultingwerk/EnumMember.i NoLock 1 LockModeEnum}
    {Consultingwerk/EnumMember.i ShareLock 2 LockModeEnum}
    {Consultingwerk/EnumMember.i ExclusiveLock 3 LockModeEnum}

    /**
     * Purpose: Constructor for the LockModeEnum class
     * Notes:
     * @param piValue The integer enum value
     * @param pcLabel The character enum label
     */
    constructor private LockModeEnum (piValue as integer, pcLabel as character):
        super ().

        assign this-object:Value = piValue
               this-object:Label = pcLabel .

    end constructor.

    {Consultingwerk/EnumFromString.i Consultingwerk.Util.Enum.LockModeEnum}

end class.
&endif
