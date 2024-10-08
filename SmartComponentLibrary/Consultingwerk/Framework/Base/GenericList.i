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
    File        : GenericList.i
    Purpose     : Generic List template for type safe Add and GetItem
                  methods

    Syntax      : { Consultingwerk/Framework/Base/GenericList.i ItemType }

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Jan 20 20:52:06 CET 2011
    Notes       :
  ----------------------------------------------------------------------*/
&ENDIF
&IF DEFINED (NativeLists) NE 0 &THEN
{Consultingwerk/Framework/Base/GenericNativeList.i {1}}
&ENDIF

    /**
     * Purpose: Adds an item to the generic List
     * Notes:
     * @param poItem And item of the Lists member type
     * @return The new Item added to the List
     */
    METHOD PUBLIC {1} Add (poItem AS {1}):
        &IF DEFINED (NativeLists) EQ 0 &THEN
        SUPER:InternalAdd (poItem).
        &ELSE
        THIS-OBJECT:ListHash = GUID  .
        THIS-OBJECT:NativeList:Add(poItem).
        &ENDIF
        RETURN poItem .
    END METHOD.

    /**
     * Purpose: Adds an array of items to the generic List
     * Notes:
     * @param poItem An array of items of the Lists member type
     */
    METHOD PUBLIC VOID Add (poItem AS {1} EXTENT):
        &IF DEFINED (NativeLists) EQ 0 &THEN
        SUPER:InternalAdd (poItem).
        &ELSE
        DEFINE VARIABLE loop AS INTEGER NO-UNDO.
        DEFINE VARIABLE cnt AS INTEGER NO-UNDO.

        cnt = EXTENT(poItem).
        DO loop = 1 TO cnt:
            THIS-OBJECT:NativeList:Add(poItem[loop]).
        END.
        &ENDIF
    END METHOD.

    /**
     * Purpose: Adds an item to the generic List only when it is not
     *          yet contained - silently ignores keys that are already
     *          contained
     * Notes:
     * @param poItem And item of the Lists member type
     * @return The new Item added to the List
     */
    METHOD PUBLIC {1} AddWhenNotContained (poItem AS {1}):
        &IF DEFINED (NativeLists) EQ 0 &THEN
        IF NOT THIS-OBJECT:Contains (poItem) THEN
            SUPER:InternalAdd (poItem).
        &ELSE
        IF NOT THIS-OBJECT:NativeList:Contains(poItem) THEN
            THIS-OBJECT:NativeList:Add(poItem).
        &ENDIF

        RETURN poItem .

    END METHOD.

    /**
     * Purpose: Retrieves an item from the generic List
     * Notes:
     * @param piIndex The 1 based index of the item to retrieve
     * @return The item of the Lists member type
     */
    METHOD PUBLIC {1} GetItem (INPUT piIndex AS INTEGER ):

        &IF DEFINED (NativeLists) EQ 0 &THEN
        RETURN CAST (SUPER:InternalGetItem (piIndex), {1}) .
        &ELSE
        RETURN THIS-OBJECT:NativeList:Get(piIndex).

        CATCH err AS Progress.Lang.Error:
            UNDO, THROW NEW Consultingwerk.Framework.Exceptions.InvalidListIndexException(err, "The specified index is not part of the List"{&TRAN}, 0) .
        END CATCH.
        &ENDIF
    END METHOD.

    /**
     * Purpose: Returns if the List is empty
     * Notes:
     * @return Logical value indicating if the list if empty
     */
    METHOD PUBLIC LOGICAL IsEmpty ():
        &IF DEFINED (NativeLists) EQ 0 &THEN
        RETURN THIS-OBJECT:Count = 0 OR THIS-OBJECT:Count = ? .
        &ELSE
        RETURN THIS-OBJECT:NativeList:IsEmpty.
        &ENDIF
    END METHOD.

    /**
     * Purpose: Returns an Array with the elements of the List
     * Notes:
     * @return The array of elements of the Lists member type
     */
    METHOD PUBLIC {1} EXTENT ToArray ():

        DEFINE VARIABLE oArray AS {1}     NO-UNDO EXTENT .
        DEFINE VARIABLE iCount AS INTEGER NO-UNDO .
        DEFINE VARIABLE i      AS INTEGER NO-UNDO .

        &IF DEFINED (NativeLists) EQ 0 &THEN
        ASSIGN iCount = THIS-OBJECT:Count .
        &ELSE
        iCount = THIS-OBJECT:NativeList:Count.
        &ENDIF
        IF iCount = 0 THEN
            RETURN oArray .

        EXTENT (oArray) = iCount .

        DO i = 1 TO iCount:
            &IF DEFINED (NativeLists) EQ 0 &THEN
            oArray[i] = CAST (THIS-OBJECT:InternalGetItem (i), {1}).
            &ELSE
            oArray[i] = THIS-OBJECT:NativeList:Get(i).
            &ENDIF
        END.

        RETURN oArray .

    END METHOD .
