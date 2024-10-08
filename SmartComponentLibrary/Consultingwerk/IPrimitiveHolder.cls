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
    File        : IPrimitiveHolder
    Purpose     : Interface for primitive data-type holder classes
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk
    Created     : Sun Nov 15 09:58:28 CET 2015
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

interface Consultingwerk.IPrimitiveHolder:

    /**
     * Purpose: Performs by-value comparison with another holder class
     * Notes:   The provided object for comparison needs to be of the same type
     * @param poObject The object to compare with the current instance
     * @return Logical value indicating if this object and the passed in object instance have the same value
     */
    method override public logical Equals (poObject as Progress.Lang.Object) .

    /**
     * Purpose: Returns the Expression to be used in a Query String
     * Notes:   Quoted value
     * @return The CHARACTER Expression
     */
    method public character GetExpression () .

    /**
     * Purpose: Returns the Value of the Holder instance
     * Notes:   Unquoted value
     * @return The value as a CHARACTER
     */
    method public character GetValue () .

    /**
     * Purpose: Returns a Character representation of the value
     * Notes:
     * @return The Character representation of the value
     */
    method override public character ToString () .

end interface .
