&IF 1=0 &THEN
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
    File        : GenericDictionary.i
    Purpose     : Generic Dictionary template for type safe Add and GetItem
                  methods

    Syntax      : { Consultingwerk/Framework/Base/GenericDictionary.i ItemType }

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Jan 20 20:52:06 CET 2011
    Notes       :
  ----------------------------------------------------------------------*/
&ENDIF

    /**
     * Purpose: Adds an item to the generic Dictionary
     * Notes:
     * @param pcKey The key value
     * @param poItem And item of the Lists member type
     * @return The item that was added to the List
     */
    METHOD PUBLIC {1} Add (pcKey AS CHARACTER,
                           poItem AS {1}):

        SUPER:InternalAdd (pcKey, poItem).

        RETURN poItem .

    END METHOD.

    /**
     * Purpose: Adds an item to the generic Dictionary
     * Notes:
     * @param pcKey The key value
     * @param poItem And item of the Lists member type
     * @return The item that was added to the List
     */
    METHOD PUBLIC {1} AddWhenNotContained (pcKey AS CHARACTER,
                                           poItem AS {1}):

        IF NOT THIS-OBJECT:ContainsKey (pcKey) THEN DO:
            SUPER:InternalAdd (pcKey, poItem).

            RETURN poItem .
        END.
        ELSE
            RETURN THIS-OBJECT:GetItem (pcKey) .

    END METHOD.

    /**
     * Purpose: Retrieves an item from the generic Dictionary
     * Notes:   CAST's the element from the underlying Progress.Lang.Object
     * @param pcKey The key of the item to retrieve
     * @return The item of the Lists member type
     */
    METHOD PUBLIC {1} GetItem (pcKey AS CHARACTER):

        RETURN CAST (SUPER:InternalGetItem (pcKey), {1}) .

    END METHOD.

    /**
     * Purpose: Retrieves an item from the generic Dictionary
     * Notes:   CAST's the element from the underlying Progress.Lang.Object
     *          This method does not fail when the key is not valid
     * @param pcKey The key of the item to retrieve
     * @return The item of the Lists member type
     */
    METHOD PUBLIC {1} GetItemOrNull (pcKey AS CHARACTER):

        RETURN CAST (SUPER:InternalGetItemOrUnknown (pcKey), {1}) .

    END METHOD.
