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
    File        : JsonAssert
    Purpose     : Assertion Methods for JSON objects
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Nov 20 13:08:01 CET 2021
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Assertion.*  from propath.
using Progress.Json.ObjectModel.* from propath.
using Progress.Lang.*             from propath.

{Consultingwerk/products.i}

class Consultingwerk.Assertion.JsonAssert:

    /**
     * Purpose: Verifies that the provided JSON object has a property with
     *          the given name
     * Notes:
     * @param poJson The reference to the JSON object
     * @param pcDescription The description of the JSON object
     * @param pcPropertyName The name of the property to test for
     */
    method public static void HasProperty (poJson as JsonObject,
                                           pcDescription as character,
                                           pcPropertyName as character):

        ObjectAssert:IsValid(poJson, "poJson":U) .

        if not poJson:Has(pcPropertyName) then
            undo, throw new AssertException (substitute ("The JsonObject &1 does not have a property named &2."{&TRAN},
                                                         pcDescription,
                                                         pcPropertyName),
                                             0) .
    end method.

    /**
     * Purpose: Verifies that the property of the JSON object is of the given
     *          JSON data type
     * Notes:
     * @param poJson The reference to the JSON object
     * @param pcDescription The description of the JSON object
     * @param pcPropertyName The name of the property to test for
     * @param piJsonDataType The Progress.Json.ObjectModel.JsonDataType value
     */
    method public static void PropertyType (poJson as JsonObject,
                                            pcDescription as character,
                                            pcPropertyName as character,
                                            piJsonDataType as integer):

        JsonAssert:HasProperty(poJson, pcDescription, pcPropertyName) .

        if not poJson:GetType(pcPropertyName) = piJsonDataType then
            undo, throw new AssertException (substitute ("Incorrect property type for &2 in &1."{&TRAN},
                                                         pcDescription,
                                                         pcPropertyName),
                                             0) .
    end method.

    /**
     * Purpose: Verifies that the extent of the JSON array is of the given
     *          JSON data type
     * Notes:
     * @param poArray The reference to the JSON Array
     * @param pcDescription The description of the JSON object
     * @param piIndex The index of the array entry to check
     * @param piJsonDataType The Progress.Json.ObjectModel.JsonDataType value
     */
    method public static void ExtentType (poArray as JsonArray,
                                          pcDescription as character,
                                          piIndex as integer,
                                          piJsonDataType as integer):

        ObjectAssert:IsValid(poArray, "poArray":U).
        Assert:GT(piIndex, 0).
        Assert:LE(piIndex, poArray:Length).
        Assert:InRange("JSON data type"{&TRAN}, piJsonDataType, 1, 6).

        if not poArray:GetType(piIndex) = piJsonDataType then
            undo, throw new AssertException (substitute ("Incorrect property type for index &2 in &1."{&TRAN},
                                                         pcDescription,
                                                         piIndex),
                                             0) .
    end method.

end class.
