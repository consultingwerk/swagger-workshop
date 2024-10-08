/**********************************************************************
 * Copyright (C) 2006-2018 by Consultingwerk Ltd. ("CW") -            *
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
    File        : IArrayList
    Purpose     : Interface required to be implemented by an Array based
                  list
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Jan 06 06:26:50 CET 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Consultingwerk.Framework.Base.* FROM PROPATH.
USING Progress.Lang.*                 FROM PROPATH .

INTERFACE Consultingwerk.Framework.Base.IArrayList
    INHERITS IEnumerable:

    /**
     * Purpose: Returns the Lists item count
     * Notes:
     */
    DEFINE PUBLIC PROPERTY Count AS INTEGER NO-UNDO
    GET.

    /**
     * Purpose: Returns a hash value representing the current list contents
     * Notes:
     */
    DEFINE PUBLIC PROPERTY ListHash AS CHARACTER NO-UNDO
    GET.

    /**
     * Purpose: Returns the Item at the specified Index
     * Notes:   This method is only intended to be used by the ListEnumerator
     *          Any other use of this method is not supported
     * @param piIndex The index of the Item to be returned
     * @return The object at the specified list position
     */
    METHOD PUBLIC Progress.Lang.Object GetItemInternal__ (piIndex AS INTEGER) .

END INTERFACE.
