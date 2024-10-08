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
    File        : EventArgsAssert
    Purpose     : Provides generic methods for validating of EventArgs object references
    Syntax      :
    Description : Routines in this class typically raise an error condition
                  when the condition is not met.
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Jul 03 09:28:36 CEST 2011
    Notes       : Static methods, throw error on failed test.
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.Assertion.* from propath .
using Progress.Lang.*            from propath .

class Consultingwerk.Assertion.EventArgsAssert:

    /**
     * Purpose: Disallow instance creation
     * Notes:
     */
    constructor private EventArgsAssert ():
        super ().

    end constructor.

    /**
     * Purpose: Validates if the passed in Consultingwerk.EventArgs provides a valid reference
     * Notes:
     * Throws:  Consultingwerk.Assertion.AssertException
     * @param e The reference to a Consultingwerk.EventArgs derived object
     * @param pcEventName The name of the event that should be raised to include in the error message
     */
    method public static void IsValid (e as Consultingwerk.EventArgs,
                                       pcEventName as character):

        if not valid-object (e) then
            undo, throw new AssertException (substitute ("Unable to raise the &1 Event with no valid event argument."{&TRAN},
                                                         pcEventName),
                                             0) .
    end method.

&if DEFINED (DotNetAccessible) ne 0 &then
    /**
     * Purpose: Validates if the passed in System.EventArgs provides a valid reference
     * Notes:
     * Throws:  Consultingwerk.Assertion.AssertException
     * @param e The reference to a System.EventArgs derived object
     * @param pcEventName The name of the event that should be raised to include in the error message
     */
    method public static void IsValid (e as System.EventArgs,
                                       pcEventName as character):

        if not valid-object (e) then
            undo, throw new AssertException (substitute ("Unable to raise the &1 Event with no valid event argument."{&TRAN},
                                                         pcEventName),
                                             0) .
    end method.
&endif

end class.
