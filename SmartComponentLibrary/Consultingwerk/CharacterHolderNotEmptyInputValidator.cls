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
    File        : CharacterHolderNotEmptyInputValidator
    Purpose     : Validates the the Value of the CharacterHolder is not empty
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Jan 19 23:59:30 CET 2020
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.CharacterHolderNotEmptyInputValidator
    implements IValueObjectValidator:

    /**
     * Purpose: Validates the properties of the given value object
     * Notes:
     * @param poValueObject The value object to validate
     * @return Logical value indicating if the object's properties are valid
     */
    method public logical IsValid (poValueObject as Progress.Lang.Object):

        return CharacterType:IsNotNullOrEmpty (cast (poValueObject, CharacterHolder):Value) .

    end method.

end class.
