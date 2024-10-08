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
    File        : ArrayAssert
    Purpose     : Assertion methods for ABL Arrays
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Sep 04 12:35:59 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.*           from propath .
using Consultingwerk.Assertion.* from propath .
using Progress.Lang.*            from propath .

{Consultingwerk/products.i}

class Consultingwerk.Assertion.ArrayAssert:

    /**
     * Purpose: Validates that the character array does not have ? or empty entries
     * Notes:
     * @param pcValue The array to verify
     * @param pcDescription The description of the array
     */
    method public static void NotNullOrEmptyEntriesOnly (pcValue as character extent,
                                                         pcDescription as character):

        define variable i as integer no-undo.

        do i = 1 to extent (pcValue):
            if CharacterType:IsNullOrEmpty(pcValue[i]) then
                undo, throw new AssertException(substitute ("Value for &1[&2] is invalid."{&TRAN}, pcDescription, i), 0) .
        end.

    end method.

    /**
     * Purpose: Validates that the array does have valid entries only (not ?)
     * Notes:
     * @param pcValue The array to verify
     * @param pcDescription The description of the array
     */
    method public static void ValidEntriesOnly (pcValue as character extent,
                                                pcDescription as character):

        define variable i as integer no-undo.

        do i = 1 to extent (pcValue):
            if pcValue[i] = ? then
                undo, throw new AssertException(substitute ("Value for &1[&2] is invalid."{&TRAN}, pcDescription, i), 0) .
        end.

    end method.

    /**
     * Purpose: Validates that the array does have valid entries only (not ?)
     * Notes:
     * @param pdtValue The array to verify
     * @param pcDescription The description of the array
     */
    method public static void ValidEntriesOnly (pdtValue as date extent,
                                                pcDescription as character):

        define variable i as integer no-undo.

        do i = 1 to extent (pdtValue):
            if pdtValue[i] = ? then
                undo, throw new AssertException(substitute ("Value for &1[&2] is invalid."{&TRAN}, pcDescription, i), 0) .
        end.

    end method.

    /**
     * Purpose: Validates that the array does have valid entries only (not ?)
     * Notes:
     * @param pdtValue The array to verify
     * @param pcDescription The description of the array
     */
    method public static void ValidEntriesOnly (pdtValue as datetime extent,
                                                pcDescription as character):

        define variable i as integer no-undo.

        do i = 1 to extent (pdtValue):
            if pdtValue[i] = ? then
                undo, throw new AssertException(substitute ("Value for &1[&2] is invalid."{&TRAN}, pcDescription, i), 0) .
        end.

    end method.

    /**
     * Purpose: Validates that the array does have valid entries only (not ?)
     * Notes:
     * @param pdtValue The array to verify
     * @param pcDescription The description of the array
     */
    method public static void ValidEntriesOnly (pdtValue as datetime-tz extent,
                                                pcDescription as character):

        define variable i as integer no-undo.

        do i = 1 to extent (pdtValue):
            if pdtValue[i] = ? then
                undo, throw new AssertException(substitute ("Value for &1[&2] is invalid."{&TRAN}, pcDescription, i), 0) .
        end.

    end method.

    /**
     * Purpose: Validates that the array does have valid entries only (not ?)
     * Notes:
     * @param pdeValue The array to verify
     * @param pcDescription The description of the array
     */
    method public static void ValidEntriesOnly (pdeValue as decimal extent,
                                                pcDescription as character):

        define variable i as integer no-undo.

        do i = 1 to extent (pdeValue):
            if pdeValue[i] = ? then
                undo, throw new AssertException(substitute ("Value for &1[&2] is invalid."{&TRAN}, pcDescription, i), 0) .
        end.

    end method.

    /**
     * Purpose: Validates that the array does have valid entries only
     * Notes:
     * @param phHandle The array of Handle references to verify
     * @param pcDescription The description of the array
     */
    method public static void ValidEntriesOnly (phHandle as handle extent,
                                                pcDescription as character):

        define variable i as integer no-undo.

        do i = 1 to extent (phHandle):
            if not valid-handle (phHandle[i]) then
                undo, throw new AssertException(substitute ("Value for &1[&2] is invalid."{&TRAN}, pcDescription, i), 0) .
        end.

    end method.

    /**
     * Purpose: Validates that the array does have valid entries only (not ?)
     * Notes:
     * @param piValue The array to verify
     * @param pcDescription The description of the array
     */
    method public static void ValidEntriesOnly (piValue as integer extent,
                                                pcDescription as character):

        define variable i as integer no-undo.

        do i = 1 to extent (piValue):
            if piValue[i] = ? then
                undo, throw new AssertException(substitute ("Value for &1[&2] is invalid."{&TRAN}, pcDescription, i), 0) .
        end.

    end method.

    /**
     * Purpose: Validates that the array does have valid entries only (not ?)
     * Notes:
     * @param plValue The array to verify
     * @param pcDescription The description of the array
     */
    method public static void ValidEntriesOnly (plValue as logical extent,
                                                pcDescription as character):

        define variable i as integer no-undo.

        do i = 1 to extent (plValue):
            if plValue[i] = ? then
                undo, throw new AssertException(substitute ("Value for &1[&2] is invalid."{&TRAN}, pcDescription, i), 0) .
        end.

    end method.

    /**
     * Purpose: Validates that the array does have valid entries only
     * Notes:
     * @param poObject The array of Progress.Lang.Object references to verify
     * @param pcDescription The description of the array
     */
    method public static void ValidEntriesOnly (poObject as Progress.Lang.Object extent,
                                                pcDescription as character):

        define variable i as integer no-undo.

        do i = 1 to extent (poObject):
            if not valid-object (poObject[i]) then
                undo, throw new AssertException(substitute ("Value for &1[&2] is invalid."{&TRAN}, pcDescription, i), 0) .
        end.

    end method.

    /**
     * Purpose: Protected default constructor for the ArrayAssert class
     * Notes:   Disallow instance creation
     */
    constructor protected ArrayAssert ():
        super () .
    end constructor.

end class.
