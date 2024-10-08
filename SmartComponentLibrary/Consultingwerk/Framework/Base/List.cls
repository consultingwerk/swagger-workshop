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
    File        : List
    Purpose     : A List class for Progress.Lang.Object instances
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Dec 27 15:01:32 CET 2009
    Notes       :
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.

{ Consultingwerk/products.i }

USING Consultingwerk.Exceptions.*           FROM PROPATH .
USING Consultingwerk.Framework.Base.*       FROM PROPATH .
USING Consultingwerk.Framework.Enum.*       FROM PROPATH .
USING Consultingwerk.Framework.Exceptions.* FROM PROPATH .
USING Progress.Lang.*                       FROM PROPATH .

CLASS Consultingwerk.Framework.Base.List
    IMPLEMENTS IEnumerable, ISupportsListChanged, ISupportsListHash, IArrayList
    {&SERIALIZABLE}:

    DEFINE {&SERIALIZABLE} VARIABLE oList       AS Progress.Lang.Object NO-UNDO EXTENT .
    DEFINE {&SERIALIZABLE} VARIABLE iCount      AS INTEGER              NO-UNDO INITIAL 0 .

    /**
     * Purpose: Raised when the List is changed by adding or removing items or
     *          clearing the list
     * Notes:
     * @param sender The sender of the event
     * @param e The ListChangedEventArgs object instance with the data of the ListChanged event
     */
    DEFINE PUBLIC EVENT ListChanged SIGNATURE VOID (sender AS Progress.Lang.Object, e AS ListChangedEventArgs).

    /**
     * Purpose: Returns the Lists item count
     * Notes:
     */
    DEFINE PUBLIC PROPERTY Count AS INTEGER NO-UNDO
    GET:
        RETURN iCount .
    END GET.

    /**
     * Purpose: Returns a hash value representing the current list contents
     * Notes:
     */
    DEFINE PUBLIC PROPERTY ListHash AS CHARACTER NO-UNDO
    GET.
    PRIVATE SET.

    /**
     * Purpose: Constructor for the List class
     * Notes:
     */
    CONSTRUCTOR PUBLIC List ():
        SUPER ().

        ASSIGN THIS-OBJECT:ListHash = GUID  .

    END CONSTRUCTOR.

    /**
     * Purpose: Adds an Item to the List
     * Notes:
     * @param poItem The Item to add to the List
     * @return The item that was added to the List
     */
    METHOD PUBLIC Progress.Lang.Object Add (poItem AS Progress.Lang.Object):

        DEFINE VARIABLE oTempList AS Progress.Lang.Object NO-UNDO EXTENT .
        DEFINE VARIABLE i         AS INTEGER              NO-UNDO .

        IF EXTENT (oList) = ? OR EXTENT (oList) = iCount THEN DO:
            /* re-size array */
            ASSIGN oTempList = oList .

            EXTENT (oList) = ? .
            EXTENT (oList) = iCount + 10 .

            IF iCount > 0 THEN DO:
                DO i = 1 TO EXTENT (oTempList):
                    ASSIGN oList[i] = oTempList[i] .
                END.
            END.
        END.

        ASSIGN iCount         = iCount + 1
               oList [iCount] = poItem .

        THIS-OBJECT:OnListChanged (NEW ListChangedEventArgs (ListChangedTypeEnum:ListItemAdded)) .

        RETURN poItem .

    END METHOD.

    /**
     * Purpose: Adds the Items from an Array to the List
     * Notes:
     * @param poItem The Array of Items to add to the List
     */
    METHOD PUBLIC VOID Add (poItem AS Progress.Lang.Object EXTENT):

        DEFINE VARIABLE i AS INTEGER NO-UNDO.

        DO i = 1 TO EXTENT (poItem):
            THIS-OBJECT:Add (poItem[i]) .
        END.

    END METHOD.

    /**
     * Purpose: Adds an Item to the List only when it is not
     *          yet contained - silently ignores items that are already
     *          contained
     * Notes:
     * @param poItem The Item to add to the List
     * @return The item that was added to the List
     */
    METHOD PUBLIC Progress.Lang.Object AddWhenNotContained (poItem AS Progress.Lang.Object):

        IF NOT THIS-OBJECT:Contains (poItem) THEN
            RETURN THIS-OBJECT:Add (poItem) .
        ELSE
            RETURN poItem .

    END METHOD .

    /**
     * Purpose: Removes all items from the List
     * Notes:
     */
    METHOD PUBLIC VOID Clear ():

        ASSIGN EXTENT (oList) = ?
               iCount         = 0 .

        THIS-OBJECT:OnListChanged (NEW ListChangedEventArgs (ListChangedTypeEnum:ListCleared)) .

    END METHOD.

    /**
     * Purpose: Determines if an object is a member of the List
     * Notes:
     * @param poListItem The object to locate in the List
     * @return Logical value indicating if the object is contained in the list
     */
    METHOD PUBLIC LOGICAL Contains (poListItem AS Progress.Lang.Object):

        DEFINE VARIABLE iExtent AS INTEGER NO-UNDO .
        DEFINE VARIABLE i       AS INTEGER NO-UNDO .

        ASSIGN iExtent = EXTENT (oList) .

        DO i = 1 TO iExtent:
            IF oList [i] = poListItem THEN
                RETURN TRUE .
        END.

        RETURN FALSE .

    END METHOD.

    /**
     * Purpose: Returns a new IEnumerator instance for this object instance
     * Notes:
     * @return The IEnumerator instance for this object
     */
    METHOD PUBLIC IEnumerator GetEnumerator ():

        RETURN NEW ListEnumerator (THIS-OBJECT) .

    END METHOD.

    /**
     * Purpose: Returns the Item at the specified Index
     * Notes:
     * @param piIndex The index of the Item to be returned
     * @return The object at the specified list position
     */
    METHOD PUBLIC Progress.Lang.Object GetItem (piIndex AS INTEGER):

        IF piIndex > iCount THEN
            UNDO, THROW NEW InvalidListIndexException ("The specified index is not part of the List"{&TRAN}, 0) .

        RETURN oList [piIndex] .

        CATCH err AS Progress.Lang.Error:
            UNDO, THROW NEW InvalidListIndexException (err, "The specified index is not part of the List"{&TRAN}, 0) .
        END CATCH.

    END METHOD.

    /**
     * Purpose: Returns the Item at the specified Index
     * Notes:   This method is only intended to be used by the ListEnumerator
     *          Any other use of this method is not supported
     * @param piIndex The index of the Item to be returned
     * @return The object at the specified list position
     */
    METHOD PUBLIC Progress.Lang.Object GetItemInternal__ (piIndex AS INTEGER):

        RETURN oList [piIndex] .

        CATCH err AS Progress.Lang.Error:
            UNDO, THROW NEW InvalidListIndexException (err, "The specified index is not part of the List"{&TRAN}, 0) .
        END CATCH.

    END METHOD.

    /**
     * Purpose: Determines the index of a specific item in the List
     * Notes:
     * @param poListItem The object to locate in the List
     * @return Integer value indicating if position of the object in the list
     */
    METHOD PUBLIC INTEGER IndexOf (poListItem AS Progress.Lang.Object):

        DEFINE VARIABLE iExtent AS INTEGER NO-UNDO.
        DEFINE VARIABLE i       AS INTEGER NO-UNDO.

        ASSIGN iExtent = EXTENT (oList) .

        DO i = 1 TO iExtent:
            IF oList [i] = poListItem THEN
                RETURN i .
        END.

        RETURN -1 .

    END METHOD.

    /**
     * Purpose: Raises the ListChanged event
     * Notes:
     * @param e The ListChangedEventArgs object instance with the data of the ListChanged event
     */
    METHOD PROTECTED VOID OnListChanged (e AS ListChangedEventArgs):

        Consultingwerk.Assertion.EventArgsAssert:IsValid (e, "ListChanged":U) .

        THIS-OBJECT:ListHash = GUID  .

        THIS-OBJECT:ListChanged:Publish (THIS-OBJECT, e) .

    END METHOD.

    /**
     * Purpose: Removes the first occurrence of a specific object from the List
     * Notes:
     * @param poListItem The member to remove from the List
     * @return Logical value indicating if the item was removed
     */
    METHOD PUBLIC LOGICAL Remove (poListItem AS Progress.Lang.Object):

        DEFINE VARIABLE i       AS INTEGER NO-UNDO .
        DEFINE VARIABLE iPos    AS INTEGER NO-UNDO .

        DEFINE VARIABLE iExtent AS INTEGER NO-UNDO .

        ASSIGN iPos = THIS-OBJECT:IndexOf (poListItem) .

        IF iPos < 1 THEN
            RETURN FALSE .

        ASSIGN iExtent      = EXTENT (oList) - 1
               oList [iPos] = ? .

        DO i = iPos TO iExtent:
            ASSIGN oList [i] = oList [i + 1] .
        END.

        ASSIGN oList [iExtent + 1] = ?
               iCount              = iCount - 1 .

        THIS-OBJECT:OnListChanged (NEW ListChangedEventArgs (ListChangedTypeEnum:ListItemRemoved)) .

        RETURN TRUE .

    END METHOD .

    /**
     * Purpose: Removes the List item at the specified index.
     * Notes:
     * @param piIndex The Index of the Item to remove from the List
     * @return Logical value indicating if the item was removed
     */
    METHOD PUBLIC LOGICAL RemoveAt (piIndex AS INTEGER):

        DEFINE VARIABLE i       AS INTEGER NO-UNDO .

        DEFINE VARIABLE iExtent AS INTEGER NO-UNDO .

        IF piIndex < 1 THEN
            RETURN FALSE .

        IF piIndex > iCount THEN
            UNDO, THROW NEW InvalidListIndexException ("The specified index is not part of the List"{&TRAN}, 0) .

        ASSIGN iExtent         = EXTENT (oList) - 1
               oList [piIndex] = ? .

        DO i = piIndex TO iExtent:
            ASSIGN oList [i] = oList [i + 1] .
        END.

        ASSIGN oList [iExtent + 1] = ?
               iCount              = iCount - 1 .

        THIS-OBJECT:OnListChanged (NEW ListChangedEventArgs (ListChangedTypeEnum:ListItemRemoved)) .

        RETURN TRUE .

    END METHOD .

    /**
     * Purpose: Returns an Array with the elements of the List
     * Notes:
     * @return The array of the elements of the List
     */
    METHOD PUBLIC Progress.Lang.Object EXTENT ToArray ():

        DEFINE VARIABLE oArray AS Progress.Lang.Object NO-UNDO EXTENT .
        DEFINE VARIABLE i      AS INTEGER              NO-UNDO .

        IF iCount = 0 THEN DO:
            EXTENT (oArray) = ? .
            RETURN oArray .
        END.

        EXTENT (oArray) = iCount .

        DO i = 1 TO iCount:
            oArray[i] = oList[i].
        END.

        RETURN oArray .

    END METHOD .

    /**
     * Purpose: Destructor of the List class
     * Notes:
     */
    DESTRUCTOR PUBLIC List ():

        THIS-OBJECT:Clear () .

    END DESTRUCTOR.

END CLASS.
