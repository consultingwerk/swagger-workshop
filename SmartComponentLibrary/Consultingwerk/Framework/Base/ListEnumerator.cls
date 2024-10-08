/**********************************************************************
 * Copyright (C) 2006-2013 by Consultingwerk Ltd. ("CW") -            *
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
    File        : ListEnumerator
    Purpose     : Provides enumeration for the List class
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Jan 20 20:52:23 CET 2012
    Notes       :
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.

{Consultingwerk/products.i}

USING Consultingwerk.Framework.Base.*       FROM PROPATH .
USING Consultingwerk.Framework.Exceptions.* FROM PROPATH .
USING Progress.Lang.*                       FROM PROPATH .

CLASS Consultingwerk.Framework.Base.ListEnumerator
    IMPLEMENTS IEnumerator:

    DEFINE VARIABLE iPointer  AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cListHash AS CHARACTER NO-UNDO.

    /**
     * Purpose: Returns the current item in the List
     * Notes:
     */
    DEFINE PUBLIC PROPERTY Current AS Progress.Lang.Object NO-UNDO
    GET:
        IF iPointer > 0 AND iPointer <= THIS-OBJECT:List:Count THEN
            RETURN THIS-OBJECT:List:GetItemInternal__ (iPointer) .
    END GET .

    /**
     * Purpose: Returns the List enumerated by this ListEnumerator instance
     * Notes:
     */
    DEFINE PUBLIC PROPERTY List AS IArrayList NO-UNDO
    GET.
    PROTECTED SET.

    /**
     * Purpose: Constructor for the ListEnumerator class
     * Notes:
     * @param poList The reference to an implementation of the IArrayList interface that is enumerated by this object instance
     */
    CONSTRUCTOR PUBLIC ListEnumerator (poList AS IArrayList):
        SUPER ().

        {Consultingwerk/Assertion/ObjectAssert/IsValid.i poList """IEnumerable"":U"}

        ASSIGN THIS-OBJECT:List = poList .

        THIS-OBJECT:Reset () .

    END CONSTRUCTOR.

    /**
     * Purpose: Moves the enumerator to the next item
     * Notes:
     * @return True when the next item is available, false when not.
     */
    METHOD PUBLIC LOGICAL MoveNext ():

        IF THIS-OBJECT:List:ListHash <> cListHash THEN
            UNDO, THROW NEW Consultingwerk.Framework.Exceptions.CannotMoveNextOnChangedList () .

        ASSIGN iPointer = iPointer + 1 .

        IF iPointer <= THIS-OBJECT:List:Count THEN
            RETURN TRUE .
        ELSE
            RETURN FALSE .

    END METHOD.

    /**
     * Purpose: Resets the Enumerator (starts enumerating from the first item on)
     * Notes:
     */
    METHOD PUBLIC VOID Reset ():

        ASSIGN iPointer                = 0 .

        ASSIGN cListHash = THIS-OBJECT:List:ListHash .

    END METHOD.

END CLASS.
