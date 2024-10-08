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
    File        : BufferAssert
    Purpose     : Provides generic methods for validating of BUFFER object handles
    Syntax      :
    Description : Routines in this class typically raise an error condition
                  when the condition is not met.
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Jul 20 00:41:51 CEST 2011
    Notes       : Static methods, throw error on failed test.
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*                   from propath .
using Consultingwerk.Assertion.*         from propath .
using Consultingwerk.Assertion.Support.* from propath.
using Consultingwerk.Exceptions.*        from propath .
using Consultingwerk.OERA.*              from propath .
using Consultingwerk.Util.*              from propath .
using Progress.Lang.*                    from propath .

class Consultingwerk.Assertion.BufferAssert:

    /**
     * Purpose: Disallow instance creation.
     * Notes:
     */
    constructor private BufferAssert ():
        super ().

    end constructor.

    /**
     * Purpose: Verifies the a record is available in that Buffer
     * Notes:   Verifies that a valid buffer is passed in first.
     * Throws:  Consultingwerk.Assertion.AssertException
     * @param phBuffer The handle of the Buffer to verify
     */
    method public static void IsAvailable (phBuffer as handle):

        {Consultingwerk/Assertion/BufferAssert/IsAvailable.i phBuffer}

    end method.

    /**
     * Purpose: Verifies the a record is available in that TableModel
     * Notes:   Verifies that a valid TableModel is passed in first.
     * Throws:  Consultingwerk.Assertion.AssertException
     * @param poTableModel The reference to the TableModel
     */
    method public static void IsAvailable (poTableModel as ISupportsAvailable):

        ObjectAssert:IsValid (poTableModel, "poTableModel":U) .

        if not poTableModel:Available then
            undo, throw new Consultingwerk.Assertion.BufferAssert.RecordNotAvailableAssertException (substitute ("No record is available in buffer &1."{&TRAN},
                                                                                                                 poTableModel:BufferName),
                                                                                                     0,
                                                                                                     poTableModel:BufferName) .

    end method.

    /**
     * Purpose: Verifies that a record is not available in that Buffer
     * Notes:   Verifies that a valid buffer is passed in first.
     * Throws:  Consultingwerk.Assertion.AssertException
     * @param phBuffer The handle of the Buffer to verify
     */
    method public static void IsNotAvailable (phBuffer as handle):

        {Consultingwerk/Assertion/BufferAssert/IsNotAvailable.i phBuffer}

    end method.

    /**
     * Purpose: Verifies the a record is not available in that TableModel
     * Notes:   Verifies that a valid TableModel is passed in first.
     * Throws:  Consultingwerk.Assertion.AssertException
     * @param poTableModel The reference to the TableModel
     */
    method public static void IsNotAvailable (poTableModel as ISupportsAvailable):

        ObjectAssert:IsValid (poTableModel, "poTableModel":U) .

        if poTableModel:Available then
            undo, throw new Consultingwerk.Assertion.AssertException (substitute ("Unexpected record is available in buffer &1."{&TRAN},
                                                                                  poTableModel:BufferName),
                                                                      0) .

    end method.

    /**
     * Purpose: Verifies that the passed in buffer handle belongs to a ProDataset
     *          member buffer
     * Notes:
     * Throws:  Consultingwerk.Assertion.AssertException
     * @param phBuffer The Buffer handle to verify
     */
    method public static void IsDatasetBuffer (phBuffer as handle):

        {Consultingwerk/Assertion/HandleAssert/WidgetType.i phBuffer WidgetTypeEnum:Buffer}

        if not valid-handle (phBuffer:dataset) then
            undo, throw new AssertException (substitute ("The Buffer &1 is not member of a ProDataset."{&TRAN},
                                                         phBuffer:name),
                                             0) .

    end method.

    /**
     * Purpose: Verifies that the passed in buffer handle belongs to a temp-table
     * Notes:
     * Throws:  Consultingwerk.Assertion.AssertException
     * @param phBuffer The Buffer handle to verify
     */
    method public static void IsTempTableBuffer (phBuffer as handle):

        {Consultingwerk/Assertion/HandleAssert/WidgetType.i phBuffer WidgetTypeEnum:Buffer}

        if not valid-handle (phBuffer:table-handle) then
            undo, throw new AssertException (substitute ("The Buffer &1 is not buffer of a temp-table."{&TRAN},
                                                         phBuffer:name),
                                             0) .

    end method.

end class.
