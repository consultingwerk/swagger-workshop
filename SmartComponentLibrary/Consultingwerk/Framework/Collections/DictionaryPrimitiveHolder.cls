/**********************************************************************
 * Copyright (C) 2006-2019 by Consultingwerk Ltd. ("CW") -            *
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
    File        : DictionaryPrimitiveHolder
    Purpose     : Generic Dictionary for IPrimitiveHolder and IPrimitiveArrayHolder
                  instances
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 19.11.2019 16:44:06
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Ccs.Common.Support.*                      FROM PROPATH .
USING Consultingwerk.Framework.Base.*           FROM PROPATH .
USING Consultingwerk.Framework.Collections.*    FROM PROPATH .
USING Progress.Lang.*                           FROM PROPATH .

{Consultingwerk/products.i}

CLASS Consultingwerk.Framework.Collections.DictionaryPrimitiveHolder
    INHERITS GenericDictionary:

    /**
     * Purpose: Adds an item to the generic Dictionary
     * Notes:
     * @param pcKey The key value
     * @param poItem And item of the Lists member type
     * @return The item that was added to the List
     */
    METHOD PUBLIC IPrimitiveHolder Add (pcKey AS CHARACTER,
                                        poItem AS IPrimitiveHolder):

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
    METHOD PUBLIC IPrimitiveArrayHolder Add (pcKey AS CHARACTER,
                                             poItem AS IPrimitiveArrayHolder):

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
    METHOD PUBLIC IPrimitiveHolder AddWhenNotContained (pcKey AS CHARACTER,
                                                        poItem AS IPrimitiveHolder):

        IF NOT THIS-OBJECT:ContainsKey (pcKey) THEN DO:
            SUPER:InternalAdd (pcKey, poItem).

            RETURN poItem .
        END.
        ELSE
            RETURN CAST (THIS-OBJECT:GetItem (pcKey), IPrimitiveHolder) .

    END METHOD.

    /**
     * Purpose: Adds an item to the generic Dictionary
     * Notes:
     * @param pcKey The key value
     * @param poItem And item of the Lists member type
     * @return The item that was added to the List
     */
    METHOD PUBLIC IPrimitiveArrayHolder AddWhenNotContained (pcKey AS CHARACTER,
                                                             poItem AS IPrimitiveArrayHolder):

        IF NOT THIS-OBJECT:ContainsKey (pcKey) THEN DO:
            SUPER:InternalAdd (pcKey, poItem).

            RETURN poItem .
        END.
        ELSE
            RETURN CAST (THIS-OBJECT:GetItem (pcKey), IPrimitiveArrayHolder) .

    END METHOD.

    /**
     * Purpose: Retrieves an item from the generic Dictionary
     * Notes:   CAST's the element from the underlying Progress.Lang.Object
     * @param pcKey The key of the item to retrieve
     * @return The item of the Lists member type
     */
    METHOD PUBLIC Progress.Lang.Object GetItem (pcKey AS CHARACTER):

        RETURN SUPER:InternalGetItem (pcKey) .

    END METHOD.

END CLASS.
