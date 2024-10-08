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
    File        : GenericList
    Purpose     : Abstract base class for generic lists
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Jan 20 20:48:40 CET 2011
    Notes       : Uses a single static temp-table for all GenericList instances
                  On OpenEdge 10 to avoid too many temp-tables issues
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.

{Consultingwerk/products.i}

USING Consultingwerk.Exceptions.*           FROM PROPATH .
USING Consultingwerk.Framework.Base.*       FROM PROPATH .
USING Consultingwerk.Framework.Enum.*       FROM PROPATH .
USING Consultingwerk.Framework.Exceptions.* FROM PROPATH .
USING Progress.Lang.*                       FROM PROPATH .

&IF DEFINED(NativeLists) NE 0 &THEN
&SCOPED-DEFINE ABSTRACT-MEMBER ABSTRACT
&ENDIF
CLASS Consultingwerk.Framework.Base.GenericList
    IMPLEMENTS &IF DEFINED(NativeLists) EQ 0 &THEN ISupportsListHash, ISupportsListChanged, &ENDIF
               IEnumerable,
               IArrayList
    ABSTRACT
    {&SERIALIZABLE}:

    &IF DEFINED(NativeLists) EQ 0 &THEN
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
    &ENDIF

    /**
     * Purpose: Returns the Lists item count
     * Notes:
     */
    DEFINE {&ABSTRACT-MEMBER} PUBLIC PROPERTY Count AS INTEGER NO-UNDO
    &IF DEFINED(NativeLists) EQ 0 &THEN
    GET:
        RETURN iCount .
    END GET.
    &ELSE
    GET.
    &ENDIF

    /**
     * Purpose: Returns a hash value representing the current list contents
     * Notes:
     */
    DEFINE PUBLIC PROPERTY ListHash AS CHARACTER NO-UNDO
    GET.
    &IF DEFINED(NativeLists) EQ 0 &THEN
    PRIVATE SET.
    &ELSE
    PROTECTED SET.
    &ENDIF

    /**
     * Purpose: Constructor for the GenericList class
     * Notes:
     */
    CONSTRUCTOR PROTECTED GenericList ():
        SUPER ().

        ASSIGN THIS-OBJECT:ListHash = GUID  .

        &IF DEFINED(NativeLists) NE 0 &THEN
        THIS-OBJECT:InitializeNativeList().
        &ENDIF
    END CONSTRUCTOR.

    &IF DEFINED(NativeLists) NE 0 &THEN
    /**
     * Purpose: Initializes the Progress.Collections.List<T> instance that the generic list will use
     * Notes:
     */
    METHOD ABSTRACT PROTECTED VOID InitializeNativeList().
    &ENDIF

    /**
     * Purpose: Removes all items from the List
     * Notes:
     */
    METHOD {&ABSTRACT-MEMBER} PUBLIC VOID Clear ()
    &IF DEFINED(NativeLists) EQ 0 &THEN
    :

        ASSIGN EXTENT (oList) = ?
               iCount         = 0 .

        THIS-OBJECT:OnListChanged (NEW ListChangedEventArgs (ListChangedTypeEnum:ListCleared)) .

    END METHOD.
    &ELSE
    .
    &ENDIF

    /**
     * Purpose: Determines if an object is a member of the List
     * Notes:
     * @param poListItem The object to locate in the List
     * @return Logical value indicating if the object is contained in the list
     */
    METHOD {&ABSTRACT-MEMBER} PUBLIC LOGICAL Contains (poListItem AS Progress.Lang.Object)
    &IF DEFINED(NativeLists) EQ 0 &THEN
    :

        DEFINE VARIABLE iExtent AS INTEGER NO-UNDO .
        DEFINE VARIABLE i       AS INTEGER NO-UNDO .

        ASSIGN iExtent = EXTENT (oList) .

        DO i = 1 TO iExtent:
            IF oList [i] = poListItem THEN
                RETURN TRUE .
        END.

        RETURN FALSE .

    END METHOD.
    &ELSE
    .
    &ENDIF

    /**
     * Purpose: Returns a new IEnumerator instance for this object instance
     * Notes:
     * @return The IEnumerator instance for this object
     */
    METHOD PUBLIC IEnumerator GetEnumerator ():

        RETURN NEW ListEnumerator (THIS-OBJECT) .

    END METHOD.

    /**
     * Purpose: Determines the index of a specific item in the List
     * Notes:
     * @param poListItem The object to locate in the List
     * @return Integer value indicating if position of the object in the list
     */
    METHOD {&ABSTRACT-MEMBER} PUBLIC INTEGER IndexOf (poListItem AS Progress.Lang.Object)
    &IF DEFINED(NativeLists) EQ 0 &THEN
    :

        DEFINE VARIABLE iExtent AS INTEGER NO-UNDO.
        DEFINE VARIABLE i       AS INTEGER NO-UNDO.

        ASSIGN iExtent = EXTENT (oList) .

        DO i = 1 TO iExtent:
            IF oList [i] = poListItem THEN
                RETURN i .
        END.

        RETURN -1 .

    END METHOD.
    &ELSE
    .
    &ENDIF

    &IF DEFINED(NativeLists) EQ 0 &THEN
    /**
     * Purpose: Adds an Item to the List
     * Notes:   Protected method to be overridden in the actual generic List class
     * @param poItem The Item to add to the List
     */
    METHOD PROTECTED VOID InternalAdd (poItem AS Progress.Lang.Object):
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
    END METHOD.
    &ENDIF

    &IF DEFINED(NativeLists) EQ 0 &THEN
    /**
     * Purpose: Adds the Items from an Array to the List
     * Notes:   Protected method to be overridden in the actual generic List class
     * @param poItem The Array of Items to add to the List
     */
    METHOD PROTECTED VOID InternalAdd (poItem AS Progress.Lang.Object EXTENT):

        DEFINE VARIABLE i AS INTEGER NO-UNDO.

        DO i = 1 TO EXTENT (poItem):
            THIS-OBJECT:InternalAdd (poItem[i]) .
        END.

    END METHOD.
    &ENDIF

    &IF DEFINED(NativeLists) EQ 0 &THEN
    /**
     * Purpose: Returns the Item at the specified Index
     * Notes:   Protected method to be overridden in the actual generic List class
     * @param piIndex The 1 based index of the Item to be returned
     * @return The object at the specified list position
     */
    METHOD PROTECTED Progress.Lang.Object InternalGetItem (piIndex AS INTEGER):

        IF piIndex > iCount THEN
            UNDO, THROW NEW InvalidListIndexException ("The specified index is not part of the List"{&TRAN}, 0) .

        RETURN oList [piIndex] .

        CATCH err AS Progress.Lang.Error:
            UNDO, THROW NEW InvalidListIndexException (err, "The specified index is not part of the List"{&TRAN}, 0) .
        END CATCH.

    END METHOD.
    &ENDIF

    /**
     * Purpose: Returns the Item at the specified Index
     * Notes:   This method is only intended to be used by the ListEnumerator
     *          Any other use of this method is not supported
     * @param piIndex The index of the Item to be returned
     * @return The object at the specified list position
     */
    METHOD {&ABSTRACT-MEMBER} PUBLIC Progress.Lang.Object GetItemInternal__ (piIndex AS INTEGER)
    &IF DEFINED(NativeLists) EQ 0 &THEN
    :

        RETURN oList [piIndex] .

        CATCH err AS Progress.Lang.Error:
            UNDO, THROW NEW InvalidListIndexException (err, "The specified index is not part of the List"{&TRAN}, 0) .
        END CATCH.

    END METHOD.
    &ELSE
    .
    &ENDIF

    &IF DEFINED(NativeLists) EQ 0 &THEN
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
    &ENDIF

    /**
     * Purpose: Removes the first occurrence of a specific object from the List
     * Notes:
     * @param poListItem The member to remove from the List
     * @return Logical value indicating if the item was removed
     */
    METHOD {&ABSTRACT-MEMBER} PUBLIC LOGICAL Remove (poListItem AS Progress.Lang.Object)
    &IF DEFINED (NativeLists) EQ 0 &THEN
    :

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
    &ELSE
    .
    &ENDIF

    /**
     * Purpose: Removes the List item at the specified index.
     * Notes:
     * @param piIndex The Index of the Item to remove from the List
     * @return Logical value indicating if the item was removed
     */
    METHOD {&ABSTRACT-MEMBER} PUBLIC LOGICAL RemoveAt (piIndex AS INTEGER)
    &IF DEFINED (NativeLists) EQ 0 &THEN
    :

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
    &ELSE
    .
    &ENDIF

    /**
     * Purpose: Destructor of the Generic List class
     * Notes:
     */
    DESTRUCTOR PUBLIC GenericList ():

        THIS-OBJECT:Clear () .

    END DESTRUCTOR.

END CLASS.
