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
    File        : HandleAssert
    Purpose     : Static class that provide standardized validation routines
                  for (WIDGET-)HANDLE parameters.
    Syntax      : Static methods only, private constructor to disallow
                  instance creation
    Description : Routines in this class typically raise an error condition
                  when the condition is not met.
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Apr 28 13:05:38 CEST 2011
    Notes       : Static methods, throw error on failed test.
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.Assertion.*  from propath .
using Consultingwerk.Exceptions.* from propath .
using Consultingwerk.Util.*       from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Assertion.HandleAssert:

    /**
     * Purpose: Disallow instance creation
     * Notes:
     */
    constructor private HandleAssert ():
        super ().

    end constructor.

    /**
     * Purpose: Validates that a (WIDGET-)HANDLE has the given property (writable)
     * Notes:
     * Throws: Consultingwerk.Exceptions.AssertException
     * @param phHandle The (WIDGET-)HANDLE to validate
     * @param pcProperty The name of the property
     */
    method public static void CanQuery (phHandle as handle,
                                        pcProperty as character):

        {Consultingwerk/Assertion/HandleAssert/ValidHandle.i phHandle}

        if not can-query (phHandle, pcProperty) then
            undo, throw new AssertException (substitute ("Property &1 can not be queried."{&TRAN},
                                                         pcProperty), 0) .

    end method.

    /**
     * Purpose: Validates that a (WIDGET-)HANDLE has the given property (writable)
     * Notes:
     * Throws: Consultingwerk.Exceptions.AssertException
     * @param phHandle The (WIDGET-)HANDLE to validate
     * @param pcProperty The name of the property
     */
    method public static void CanSet (phHandle as handle,
                                      pcProperty as character):

        {Consultingwerk/Assertion/HandleAssert/ValidHandle.i phHandle}

        if not can-set (phHandle, pcProperty) then
            undo, throw new AssertException (substitute ("Property &1 can not be set."{&TRAN},
                                                         pcProperty), 0) .

    end method.

    /**
     * Purpose: Validates a (WIDGET-)HANDLE and raises an AssertException
     *          when the widget is valid
     * Notes:
     * Throws: Consultingwerk.Assertion.AssertException
     * @param phHandle The (WIDGET-)HANDLE to validate
     */
    method public static void InValidHandle (phHandle as handle):

        if valid-handle (phHandle) then
            undo, throw new AssertException ("Handle should not be valid."{&TRAN}, 0) .

    end method.

    /**
     * Purpose: Validates a (WIDGET-)HANDLE and raises an AssertException
     *          when the widget is valid
     * Notes:
     * Throws: Consultingwerk.Assertion.AssertException
     * @param phHandle The (WIDGET-)HANDLE to validate
     * @param pcHandleDesc The optional description of the HANDLE used in the InvalidHandleException
     */
    method public static void InValidHandle (phHandle as handle, pcHandleDesc as character):

        if valid-handle (phHandle) then
            undo, throw new AssertException (substitute ("Handle &1 should not be valid."{&TRAN}, pcHandleDesc), 0) .

    end method.

    /**
     * Purpose: Validates a (WIDGET-)HANDLE and raises an InvalidHandleException
     *          when the widget is invalid
     * Notes:
     * Throws: Consultingwerk.Exceptions.InvalidHandleException
     * @param phHandle The (WIDGET-)HANDLE to validate
     */
    method public static void ValidHandle (phHandle as handle):

        {Consultingwerk/Assertion/HandleAssert/ValidHandle.i phHandle}

    end method.

    {Consultingwerk/Assertion/IsWidgetType.i AsyncRequest}
    {Consultingwerk/Assertion/IsWidgetType.i Browse}
    {Consultingwerk/Assertion/IsWidgetType.i BrowseColumn}
    {Consultingwerk/Assertion/IsWidgetType.i Buffer}
    {Consultingwerk/Assertion/IsWidgetType.i BufferField}
    {Consultingwerk/Assertion/IsWidgetType.i Button}
    {Consultingwerk/Assertion/IsWidgetType.i ComboBox}
    {Consultingwerk/Assertion/IsWidgetType.i ControlFrame}
    {Consultingwerk/Assertion/IsWidgetType.i DataRelation}
    {Consultingwerk/Assertion/IsWidgetType.i Dataset}
    {Consultingwerk/Assertion/IsWidgetType.i DataSource}
    {Consultingwerk/Assertion/IsWidgetType.i DialogBox}
    {Consultingwerk/Assertion/IsWidgetType.i Editor}
    {Consultingwerk/Assertion/IsWidgetType.i FillIn}
    {Consultingwerk/Assertion/IsWidgetType.i FieldGroup}
    {Consultingwerk/Assertion/IsWidgetType.i Frame}
    {Consultingwerk/Assertion/IsWidgetType.i Image}
    {Consultingwerk/Assertion/IsWidgetType.i Literal}
    {Consultingwerk/Assertion/IsWidgetType.i Menu}
    {Consultingwerk/Assertion/IsWidgetType.i MenuItem}
    {Consultingwerk/Assertion/IsWidgetType.i RadioSet}
    {Consultingwerk/Assertion/IsWidgetType.i Procedure}
    {Consultingwerk/Assertion/IsWidgetType.i Query}
    {Consultingwerk/Assertion/IsWidgetType.i Rectangle}
    {Consultingwerk/Assertion/IsWidgetType.i SaxAttributes}
    {Consultingwerk/Assertion/IsWidgetType.i SaxReader}
    {Consultingwerk/Assertion/IsWidgetType.i Server}
    {Consultingwerk/Assertion/IsWidgetType.i ServerSocket}
    {Consultingwerk/Assertion/IsWidgetType.i SelectionList}
    {Consultingwerk/Assertion/IsWidgetType.i Slider}
    {Consultingwerk/Assertion/IsWidgetType.i SoapFault}
    {Consultingwerk/Assertion/IsWidgetType.i SoapFaultDetail}
    {Consultingwerk/Assertion/IsWidgetType.i SoapHeader}
    {Consultingwerk/Assertion/IsWidgetType.i SoapHeaderEntryRef}
    {Consultingwerk/Assertion/IsWidgetType.i Socket}
    {Consultingwerk/Assertion/IsWidgetType.i Stream}
    {Consultingwerk/Assertion/IsWidgetType.i SubMenu}
    {Consultingwerk/Assertion/IsWidgetType.i TempTable}
    {Consultingwerk/Assertion/IsWidgetType.i Text}
    {Consultingwerk/Assertion/IsWidgetType.i ToggleBox}
    {Consultingwerk/Assertion/IsWidgetType.i Window}
    {Consultingwerk/Assertion/IsWidgetType.i XDocument}
    {Consultingwerk/Assertion/IsWidgetType.i XNodeRef}

    /**
     * Purpose: Validates a (WIDGET-)HANDLE and raises an InvalidHandleException
     *          when the widget is invalid
     * Notes:
     * Throws: Consultingwerk.Exceptions.InvalidHandleException
     * @param phHandle The (WIDGET-)HANDLE to validate
     * @param pcHandleDesc The optional description of the HANDLE used in the InvalidHandleException
     */
    method public static void ValidHandle (phHandle as handle, pcHandleDesc as character):

        {Consultingwerk/Assertion/HandleAssert/ValidHandle.i phHandle pcHandleDesc}

    end method.

    /**
     * Purpose: Validates the type of the given widget
     * Notes:
     * Throws:  Consultingwerk.Exceptions.InvalidTypeException or InvalidHandleException
     * @param phHandle The (WIDGET-)HANDLE to validate
     * @param pcType The expected Widget TYPE
     */
    method public static void WidgetType (phHandle as handle, pcType as character):

        {Consultingwerk/Assertion/HandleAssert/WidgetType.i phHandle pcType}

    end method.

end class.
