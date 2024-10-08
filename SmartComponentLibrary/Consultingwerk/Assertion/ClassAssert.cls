/**********************************************************************
 * Copyright (C) 2023-2024 by Consultingwerk Ltd. ("CW") -            *
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
    File        : ClassAssert
    Purpose     : Assertions for classes (ie types); distinct from objects
    Syntax      :
    Description :
    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : 2023-06-16
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath.

class Consultingwerk.Assertion.ClassAssert:

    /**
     * Purpose: Constructor
     * Notes: Disallow instance creation
     */
    constructor protected ClassAssert ():
        super ().

    end constructor.

    /**
     * Purpose: Validates an object reference for validity and the passed in typename
     *          and raises error when the tests fail
     * Notes: Use this method to test for ABL types only
     * Throws:  Consultingwerk.Exceptions.InvalidTypeException
     * @param poClass The class object reference to validate
     * @param pcClassName The object type (ABL class) to test against
     * @param pcObjectDesc The optional description of the object reference used in the Error
     */
    method public static void TypeOf (poClass as Progress.Lang.Class,
                                      pcClassName as character,
                                      pcObjectDesc as character):

        if pcObjectDesc > "":U then do:
            {Consultingwerk/Assertion/ObjectAssert/IsValid.i poClass pcObjectDesc}
        end.
        else do:
            {Consultingwerk/Assertion/ObjectAssert/IsValid.i poClass}
        end.

        if not poClass:IsA (pcClassName) then
            undo, throw new InvalidTypeException (pcClassName,
                                                  poClass:TypeName) .
    end method.

    /**
     * Purpose: Validates an object reference for validity and the passed in typename
     *          and raises error when the tests fail
     * Notes: Use this method to test for ABL types only
     * Throws:  Consultingwerk.Exceptions.InvalidTypeException
     * @param poClass The class object reference to validate
     * @param pcClassName The object type (ABL class) to test against
     */
    method public static void TypeOf (poClass as Progress.Lang.Class,
                                      pcClassName as character):

        {Consultingwerk/Assertion/ObjectAssert/IsValid.i poClass}

        if not poClass:IsA (pcClassName) then
            undo, throw new InvalidTypeException (pcClassName,
                                                  poClass:TypeName) .
    end method.

end class.
