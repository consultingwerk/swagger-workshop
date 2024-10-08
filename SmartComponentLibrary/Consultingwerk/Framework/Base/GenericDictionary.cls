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
    File        : GenericDictionary
    Purpose     : Am abstract generic dictionary foundation
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Dec 27 15:01:32 CET 2009
    Notes       :
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.

{ Consultingwerk/products.i }

USING Consultingwerk.Exceptions.*            FROM PROPATH .
USING Consultingwerk.Framework.Base.*        FROM PROPATH .
USING Consultingwerk.Framework.Collections.* FROM PROPATH .
USING Consultingwerk.Framework.Enum.*        FROM PROPATH .
USING Consultingwerk.Framework.Exceptions.*  FROM PROPATH .
USING Consultingwerk.Util.*                  FROM PROPATH .
USING Progress.Lang.*                        FROM PROPATH .

CLASS Consultingwerk.Framework.Base.GenericDictionary
    IMPLEMENTS IEnumerable, ISupportsListChanged, ISupportsListHash, IArrayList
    ABSTRACT
    {&SERIALIZABLE}:

    DEFINE VARIABLE cKeys   AS CHARACTER            NO-UNDO EXTENT .
    DEFINE VARIABLE oValues AS Progress.Lang.Object NO-UNDO EXTENT .
    DEFINE VARIABLE iCount  AS INTEGER              NO-UNDO INITIAL 0 .

    /**
     * Purpose: Raised when the Dictionary is changed by adding or removing items or
     *          clearing the dictionary
     * Notes:
     * @param sender The sender of the event
     * @param e The ListChangedEventArgs object instance with the data of the ListChanged event
     */
    DEFINE PUBLIC EVENT ListChanged SIGNATURE VOID (sender AS Progress.Lang.Object, e AS ListChangedEventArgs).

    /**
     * Purpose: Returns the Dictionaries item count
     * Notes:
     */
    DEFINE PUBLIC PROPERTY Count AS INTEGER NO-UNDO
    GET:
        RETURN iCount .
    END GET.

    /**
     * Purpose: Returns the Keys of the Dictionary
     * Notes:
     */
    DEFINE PUBLIC PROPERTY Keys AS CharacterList NO-UNDO
    GET:
        DEFINE VARIABLE cTempKeys AS CHARACTER EXTENT NO-UNDO .
        DEFINE VARIABLE i         AS INTEGER          NO-UNDO .

        IF THIS-OBJECT:Count = 0 THEN
            RETURN NEW CharacterList (ArrayHelper:ToList(cKeys, CHR (1)),
                                      CHR (1)) .

        EXTENT (cTempKeys) = iCount .

        DO i = 1 TO iCount:
            cTempKeys[i] = cKeys[i] .
        END.

        RETURN NEW CharacterList (ArrayHelper:ToList(cTempKeys, CHR (1)),
                                  CHR (1)) .

    END GET.

    /**
     * Purpose: Returns a hash value representing the current list contents
     * Notes:
     */
    DEFINE PUBLIC PROPERTY ListHash AS CHARACTER NO-UNDO
    GET.
    PRIVATE SET.

    /**
     * Purpose: Constructor for the Dictionary class
     * Notes:
     */
    CONSTRUCTOR PROTECTED GenericDictionary ():
        SUPER ().

        ASSIGN THIS-OBJECT:ListHash = GUID .

    END CONSTRUCTOR.

    /**
     * Purpose: Removes all items from the Dictionary
     * Notes:
     */
    METHOD PUBLIC VOID Clear ():

        ASSIGN EXTENT (cKeys)   = ?
               EXTENT (oValues) = ?
               iCount           = 0 .

        THIS-OBJECT:OnListChanged (NEW ListChangedEventArgs (ListChangedTypeEnum:ListCleared)) .

    END METHOD.

    /**
     * Purpose: Determines if an object is a member of the Dictionary
     * Notes:
     * @param poItem The object to locate in the Dictionary
     * @return Logical value indicating if the object is contained in the Dictionary
     */
    METHOD PUBLIC LOGICAL ContainsItem (poItem AS Progress.Lang.Object):

        RETURN ArrayHelper:Find (poItem, oValues) > 0 .

    END METHOD.

    /**
     * Purpose: Determines if an key is a member of the Dictionary
     * Notes:
     * @param pcKey The key to locate in the Dictionary
     * @return Logical value indicating if the object is contained in the Dictionary
     */
    METHOD PUBLIC LOGICAL ContainsKey (pcKey AS CHARACTER):

        RETURN ArrayHelper:Find (pcKey, cKeys) > 0 .

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
     * Notes:   This method is only intended to be used by the ListEnumerator
     *          Any other use of this method is not supported
     * @param piIndex The index of the Item to be returned
     * @return The object at the specified list position
     */
    METHOD PUBLIC Progress.Lang.Object GetItemInternal__ (piIndex AS INTEGER):

        RETURN oValues [piIndex] .

        CATCH err AS Progress.Lang.Error:
            UNDO, THROW NEW InvalidListIndexException (err, "The specified index is not part of the List"{&TRAN}, 0) .
        END CATCH.

    END METHOD.

    /**
     * Purpose: Returns the Key of the specified Item
     * Notes:
     * @param poItem The Item to return the Key for
     * @return The Key of the given Item
     */
    METHOD PUBLIC CHARACTER GetKey (poItem AS Object):

        DEFINE VARIABLE iPos AS INTEGER NO-UNDO.

        iPos = ArrayHelper:Find (poItem, oValues) .

        IF iPos > 0 THEN
            RETURN cKeys[iPos] .
        ELSE
            UNDO, THROW NEW InvalidDictionaryItemException ("The specified item is not part of the Dictionary."{&TRAN}, 0) .

    END METHOD.

    /**
     * Purpose: Adds an Item to the Dictionary
     * Notes:
     * @param pcKey The key value
     * @param poItem The Item to add to the Dictionary
     * @return The item that was added to the dictionary
     */
    METHOD PROTECTED Progress.Lang.Object InternalAdd (pcKey AS CHARACTER,
                                                       poItem AS Progress.Lang.Object):

        DEFINE VARIABLE cTempList AS CHARACTER            NO-UNDO EXTENT .
        DEFINE VARIABLE oTempList AS Progress.Lang.Object NO-UNDO EXTENT .
        DEFINE VARIABLE i         AS INTEGER              NO-UNDO .

        IF EXTENT (oValues) = ? OR EXTENT (oValues) = iCount THEN DO:
            /* re-size array */
            ASSIGN oTempList = oValues
                   cTempList = cKeys .

            EXTENT (cKeys) = ? .
            EXTENT (cKeys) = iCount + 10 .

            EXTENT (oValues) = ? .
            EXTENT (oValues) = iCount + 10 .

            IF iCount > 0 THEN DO:
                DO i = 1 TO EXTENT (oTempList):
                    ASSIGN cKeys[i]   = cTempList[i]
                           oValues[i] = oTempList[i] .
                END.
            END.
        END.

        ASSIGN iCount           = iCount + 1
               cKeys [iCount]   = pcKey
               oValues [iCount] = poItem .

        THIS-OBJECT:OnListChanged (NEW ListChangedEventArgs (ListChangedTypeEnum:ListItemAdded)) .

        RETURN poItem .

    END METHOD.

    /**
     * Purpose: Returns the Item at the specified Index
     * Notes:
     * @param pcKey The Key of the Item to be returned
     * @return The object at the specified dictionary position
     */
    METHOD PROTECTED Progress.Lang.Object InternalGetItem (pcKey AS CHARACTER):

        DEFINE VARIABLE iPos AS INTEGER NO-UNDO.

        iPos = ArrayHelper:Find (pcKey, cKeys) .

        IF iPos > 0 THEN
            RETURN oValues [iPos] .
        ELSE
            UNDO, THROW NEW InvalidDictionaryKeyException ("The specified key is not part of the Dictionary."{&TRAN}, 0) .

    END METHOD.

    /**
     * Purpose: Returns the Item with the specified key
     * Notes:   This method does not fail when the key is not valid
     * @param pcKey The Key of the Item to be returned
     * @return The object at the specified dictionary position
     */
    METHOD PROTECTED Progress.Lang.Object InternalGetItemOrUnknown (pcKey AS CHARACTER):

        DEFINE VARIABLE iPos AS INTEGER NO-UNDO.

        iPos = ArrayHelper:Find (pcKey, cKeys) .

        IF iPos > 0 THEN
            RETURN oValues [iPos] .
        ELSE
            RETURN ? .

    END METHOD.

    /**
     * Purpose: Raises the ListChanged event
     * Notes:
     * @param e The ListChangedEventArgs object instance with the data of the ListChanged event
     */
    METHOD PROTECTED VOID OnListChanged (e AS ListChangedEventArgs):

        Consultingwerk.Assertion.EventArgsAssert:IsValid (e, "ListChanged":U) .

        THIS-OBJECT:ListHash = GUID .

        THIS-OBJECT:ListChanged:Publish (THIS-OBJECT, e) .

    END METHOD.

    /**
     * Purpose: Removes an entry from the list of keys and values
     * Notes:
     * @param piPos The position of the entry to remove
     */
    METHOD PRIVATE VOID RemoveEntry (piPos AS INTEGER):

        DEFINE VARIABLE i       AS INTEGER NO-UNDO .
        DEFINE VARIABLE iExtent AS INTEGER NO-UNDO .

        ASSIGN iExtent        = EXTENT (oValues) - 1
               oValues[piPos] = ?
               cKeys[piPos]   = ? .

        DO i = piPos TO iExtent:
            ASSIGN oValues [i] = oValues [i + 1]
                   cKeys [i]   = cKeys [i + 1].
        END.

        ASSIGN oValues [iExtent + 1] = ?
               cKeys [iExtent + 1]   = ?
               iCount                = iCount - 1 .

    END METHOD.

    /**
     * Purpose: Removes the first occurrence of a specific object from the Dictionary
     * Notes:
     * @param poDictionaryItem The member to remove from the Dictionary
     * @return Logical value indicating if the item has been removed
     */
    METHOD PUBLIC LOGICAL RemoveItem (poDictionaryItem AS Progress.Lang.Object):

        DEFINE VARIABLE iPos AS INTEGER NO-UNDO.

        ASSIGN iPos = ArrayHelper:Find (poDictionaryItem, oValues) .

        IF iPos > 0 THEN DO:
            THIS-OBJECT:RemoveEntry (iPos) .

            THIS-OBJECT:OnListChanged (NEW ListChangedEventArgs (ListChangedTypeEnum:ListItemRemoved)) .

            RETURN TRUE .
        END.
        ELSE
            RETURN FALSE .

    END METHOD .

    /**
     * Purpose: Removes the Dictionary item with the specified key
     * Notes:   Raises an InvalidDictionaryKeyException for non existing keys
     * @param pcKey The Key of the Item to remove from the Dictionary
     */
    METHOD PUBLIC VOID RemoveKey (pcKey AS CHARACTER):

        DEFINE VARIABLE iPos AS INTEGER NO-UNDO.

        ASSIGN iPos = ArrayHelper:Find (pcKey, cKeys) .

        IF iPos > 0 THEN DO:
            THIS-OBJECT:RemoveEntry (iPos) .

            THIS-OBJECT:OnListChanged (NEW ListChangedEventArgs (ListChangedTypeEnum:ListItemRemoved)) .
        END.
        ELSE
            UNDO, THROW NEW InvalidDictionaryKeyException ("The specified key is not part of the Dictionary."{&TRAN}, 0) .

    END METHOD .

    /**
     * Purpose: Removes the Dictionary items with the specified keys
     * Notes:   Does not raise an error for invalid keys
     * @param pcKeys The Keys of the Items to remove from the Dictionary
     */
    METHOD PUBLIC VOID RemoveKeys (pcKeys AS CHARACTER):

        DEFINE VARIABLE i        AS INTEGER   NO-UNDO .
        DEFINE VARIABLE lDeleted AS LOGICAL   NO-UNDO INITIAL FALSE .
        DEFINE VARIABLE cKey     AS CHARACTER NO-UNDO .
        DEFINE VARIABLE iPos     AS INTEGER   NO-UNDO .

        DO i = 1 TO NUM-ENTRIES (pcKeys):
            ASSIGN cKey = ENTRY (i, pcKeys)
                   iPos = ArrayHelper:Find (cKey, cKeys) .

            IF iPos > 0 THEN DO:
                THIS-OBJECT:RemoveEntry (iPos) .

                ASSIGN lDeleted = TRUE .
            END.
        END.

        IF lDeleted THEN
            THIS-OBJECT:OnListChanged (NEW ListChangedEventArgs (ListChangedTypeEnum:ListItemRemoved)) .

    END METHOD .

END CLASS.
