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
    File        : ObjectAssert
    Purpose     : Provides generic methods for validating of object references
    Syntax      :
    Description : Routines in this class typically raise an error condition
                  when the condition is not met.
    Author(s)   : Mike Fechner
    Created     : Mon Dec 12 16:10:01 CET 2011
    Notes       : Static methods, throw error on failed test.
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.Assertion.*  from propath .
using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Assertion.ObjectAssert:

    /**
     * Purpose: Disallow instance creation
     * Notes:
     */
    constructor private ObjectAssert ():
        super ().

    end constructor.

    /**
     * Purpose: Validates an object reference and raises an Exception when the
     *          reference is valid
     * Notes:
     * Throws:  Consultingwerk.Assertion.AssertException
     * @param poObject The object reference to validate
     */
    method public static void IsNotValid (poObject as Progress.Lang.Object):

        if valid-object (poObject) then
            undo, throw new AssertException ("Object reference is valid."{&TRAN}, 0) .

    end method.

    /**
     * Purpose: Validates an object reference and raises an Exception when the
     *          reference is valid
     * Notes:
     * Throws:  Consultingwerk.Assertion.AssertException
     * @param poObject The object reference to validate
     * @param pcObjectDesc The optional description of the object reference used in the InvalidReferenceException
     */
    method public static void IsNotValid (poObject as Progress.Lang.Object,
                                          pcObjectDesc as character):

        if valid-object (poObject) then
            undo, throw new AssertException (substitute ("&1 reference is valid."{&TRAN}, pcObjectDesc),
                                             0) .

    end method.

    /**
     * Purpose: Validates an object reference and raises an InvalidReferenceException
     *          when the widget is invalid
     * Notes:
     * Throws:  Consultingwerk.Exceptions.InvalidReferenceException
     * @param poObject The object reference to validate
     */
    method public static void IsValid (poObject as Progress.Lang.Object):

        {Consultingwerk/Assertion/ObjectAssert/IsValid.i poObject}

    end method.

    /**
     * Purpose: Validates an object reference and raises an InvalidReferenceException
     *          when the widget is invalid
     * Notes:
     * Throws:  Consultingwerk.Exceptions.InvalidReferenceException
     * @param poObject The object reference to validate
     * @param pcObjectDesc The optional description of the object reference used in the InvalidReferenceException
     */
    method public static void IsValid (poObject as Progress.Lang.Object,
                                       pcObjectDesc as character):

        {Consultingwerk/Assertion/ObjectAssert/IsValid.i poObject pcObjectDesc}

    end method.

    /**
     * Purpose: Validates an object reference for validity and the passed in typename
     *          and raises error when the tests fail
     * Notes: Use this method to test for ABL types only
     * Throws:  Consultingwerk.Exceptions.InvalidTypeException
     * @param poObject The object reference to validate
     * @param pcClassName The object type (ABL class) to test against
     * @param pcObjectDesc The optional description of the object reference used in the Error
     */
    method public static void TypeOf (poObject as Progress.Lang.Object,
                                      pcClassName as character,
                                      pcObjectDesc as character):

        if pcObjectDesc > "":U then do:
            {Consultingwerk/Assertion/ObjectAssert/IsValid.i poObject pcObjectDesc}
        end.
        else do:
            {Consultingwerk/Assertion/ObjectAssert/IsValid.i poObject}
        end.

        if not poObject:GetClass ():IsA (pcClassName) then
            undo, throw new InvalidTypeException (pcClassName,
                                                  poObject:GetClass():TypeName) .

    end method .

    /**
     * Purpose: Validates an object reference for validity and the passed in typename
     *          and raises error when the tests fail
     * Notes: Use this method to test for ABL types only
     * Throws:  Consultingwerk.Exceptions.InvalidTypeException
     * @param poObject The object reference to validate
     * @param pcClassName The object type (ABL class) to test against
     */
    method public static void TypeOf (poObject as Progress.Lang.Object,
                                      pcClassName as character):

        Consultingwerk.Assertion.ObjectAssert:IsValid (poObject) .

        if not poObject:GetClass ():IsA (pcClassName) then
            undo, throw new InvalidTypeException (pcClassName,
                                                  poObject:GetClass():TypeName) .

    end method .

end class.
