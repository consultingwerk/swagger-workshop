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
    File        : IValueObjectValidator
    Purpose     : Interface for objects that can validate the properties
                  of a value object
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Jul 21 13:35:10 CEST 2018
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

interface Consultingwerk.IValueObjectValidator:

    /**
     * Purpose: Validates the properties of the given value object
     * Notes:
     * @param poValueObject The value object to validate
     * @return Logical value indicating if the object's properties are valid
     */
    method public logical IsValid (poValueObject as Progress.Lang.Object).

end interface.
