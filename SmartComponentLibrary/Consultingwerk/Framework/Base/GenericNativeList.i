&IF 1=0 &THEN
/**********************************************************************
 * Copyright (C) 2006-2022 by Consultingwerk Ltd. ("CW") -            *
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
    File        : GenericNativeList.i
    Purpose     : Generic List template for type safe Add and GetItem
                  methods

    Syntax      : { Consultingwerk/Framework/Base/GenericNativeList.i ItemType }

    Description : This include file is referenced by GenericList.i. The purpose
                  is to keep the two implementation based on the traditional
                  array based List and the native generic list seperate

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Jan 20 20:52:06 CET 2011
    Notes       :
  ----------------------------------------------------------------------*/
&ENDIF

&IF DEFINED (NativeLists) NE 0 &THEN
    /**
     * Purpose: The native/built-in List<T> that stores items
     * Notes:
     *
     */
    DEFINE SERIALIZABLE PRIVATE PROPERTY NativeList AS Progress.Collections.IList<{1}> NO-UNDO
    GET.
    SET.

    /**
     * Purpose: Returns the List's item count
     * Notes:
     */
    DEFINE OVERRIDE PUBLIC PROPERTY Count AS INTEGER NO-UNDO
    GET:
        RETURN THIS-OBJECT:NativeList:Count.
    END GET.

    /**
     * Purpose: Removes all items from the List
     * Notes:
     */
    METHOD OVERRIDE PUBLIC VOID Clear ():
        THIS-OBJECT:NativeList:Clear().
        THIS-OBJECT:ListHash = GUID  .
    END METHOD.

    /**
     * Purpose: Determines if an object is a member of the List
     * Notes:
     * @param poListItem The object to locate in the List
     * @return Logical value indicating if the object is contained in the list
     */
    METHOD OVERRIDE PUBLIC LOGICAL Contains (poListItem AS Progress.Lang.Object):
        IF TYPE-OF(poListItem, {1}) THEN
            RETURN THIS-OBJECT:Contains(CAST(poListItem, {1})).
        ELSE
            RETURN FALSE.
    END METHOD.

    /**
     * Purpose: Determines if an object is a member of the List
     * Notes:
     * @param poListItem The object to locate in the List
     * @return Logical value indicating if the object is contained in the list
     */
    METHOD PUBLIC LOGICAL Contains (poListItem AS {1}):
        RETURN THIS-OBJECT:NativeList:Contains(poListItem).
    END METHOD.

    /**
     * Purpose: Determines the index of a specific item in the List
     * Notes:
     * @param poListItem The object to locate in the List
     * @return Integer value indicating if position of the object in the list
     */
    METHOD OVERRIDE PUBLIC INTEGER IndexOf (poListItem AS Progress.Lang.Object):
        IF TYPE-OF(poListItem, {1}) THEN
            RETURN THIS-OBJECT:NativeList:IndexOf(CAST(poListItem, {1})).
        ELSE
            RETURN -1.
    END METHOD.

    /**
     * Purpose: Determines the index of a specific item in the List
     * Notes:
     * @param poListItem The object to locate in the List
     * @return Integer value indicating if position of the object in the list
     */
    METHOD PUBLIC INTEGER IndexOf (poListItem AS {1}):
        RETURN THIS-OBJECT:NativeList:IndexOf(poListItem).
    END METHOD.

    /**
     * Purpose: Removes the first occurrence of a specific object from the List
     * Notes:
     * @param poListItem The member to remove from the List
     * @return Logical value indicating if the item was removed
     */
    METHOD OVERRIDE PUBLIC LOGICAL Remove (poListItem AS Progress.Lang.Object):
        DEFINE VARIABLE lRemoved AS LOGICAL NO-UNDO.

        IF TYPE-OF(poListItem, {1}) THEN
        DO:
            ASSIGN lRemoved = THIS-OBJECT:NativeList:Remove(CAST(poListItem, {1})).
            /* Only update the hash after the Remove() succeeds */
            IF lRemoved THEN
                THIS-OBJECT:ListHash = GUID  .

            RETURN lRemoved.
        END.
        ELSE
            RETURN FALSE.
    END METHOD.

    /**
     * Purpose: Removes the first occurrence of a specific object from the List
     * Notes:
     * @param poListItem The member to remove from the List
     * @return Logical value indicating if the item was removed
     */
    METHOD PUBLIC LOGICAL Remove (poListItem AS {1}):
        DEFINE VARIABLE lRemoved AS LOGICAL NO-UNDO.

        ASSIGN lRemoved = THIS-OBJECT:NativeList:Remove(poListItem).
        /* Only update the hash after the Remove() succeeds */
        IF lRemoved THEN
            THIS-OBJECT:ListHash = GUID  .

        RETURN lRemoved.
    END METHOD.

    /**
     * Purpose: Removes the List item at the specified index.
     * Notes:
     * @param piIndex The Index of the Item to remove from the List
     * @return Logical value indicating if the item was removed
     */
    METHOD OVERRIDE PUBLIC LOGICAL RemoveAt (piIndex AS INTEGER):
        /* Same behaviour as GenericList.cls' RemoveAt() method */
        IF piIndex LT 1 THEN
            RETURN FALSE .

        THIS-OBJECT:NativeList:RemoveAt(piIndex).
        /* Only update the hash after the Remove() succeeds */
        THIS-OBJECT:ListHash = GUID  .

        RETURN TRUE.
        CATCH err AS Progress.Lang.Error :
            UNDO, THROW NEW Consultingwerk.Framework.Exceptions.InvalidListIndexException (err, "The specified index is not part of the List"{&TRAN}, 0) .
        END CATCH.
    END METHOD.

    /**
     * Purpose: Returns a native Progress.Collections.IIterator<T> instance for this list
     * Notes:
     * @return The Progress.Collections.IIterator<T> instance for this object
     */
    METHOD PUBLIC "Progress.Collections.IIterator<{1}>" GetGenericEnumerator():
        RETURN THIS-OBJECT:NativeList:GetIterator().
    END METHOD.

    /**
     * Purpose: Returns the Item at the specified Index
     * Notes:   This method is only intended to be used by the ListEnumerator
     *          Any other use of this method is not supported
     * @param piIndex The index of the Item to be returned
     * @return The object at the specified list position
     */
    METHOD OVERRIDE PUBLIC Progress.Lang.Object GetItemInternal__ (piIndex AS INTEGER):
        RETURN THIS-OBJECT:NativeList:Get(piIndex).

        CATCH err AS Progress.Lang.Error:
            UNDO, THROW NEW Consultingwerk.Framework.Exceptions.InvalidListIndexException(err, "The specified index is not part of the List"{&TRAN}, 0) .
        END CATCH.
    END METHOD.

    /**
     * Purpose: Initializes the Progress.Collections.List<T> instance that the generic list will use
     * Notes:
     */
    METHOD OVERRIDE PROTECTED VOID InitializeNativeList():
        ASSIGN THIS-OBJECT:NativeList = NEW Progress.Collections.List<{1}>().
    END METHOD.
&ENDIF
