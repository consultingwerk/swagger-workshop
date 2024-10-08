/**********************************************************************
 * Copyright (C) 2006-2023 by Consultingwerk Ltd. ("CW") -            *
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
    File        : IValueObjectValidatorWithMessages
    Purpose     : Interface for objects that can validate the properties
                  of a value object and return a list of error messages
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Jul 21 13:35:10 CEST 2018
    Notes       : IValueObjectValidator only returns TRUE/FALSE for validation
                  The ComplexInputPrompt method of the InputPromptHelper
                  expects validation instances that implement only one of
                  those two interfaces - not both
  ----------------------------------------------------------------------*/

@lowercase.

using Consultingwerk.*                       from propath .
using Consultingwerk.Framework.Collections.* from propath .
using Progress.Lang.*                        from propath .

interface Consultingwerk.IValueObjectValidatorWithMessages:

    /**
     * Purpose: Validates the properties of the given value object
     * Notes:
     * @param poValueObject The value object to validate
     * @return CharacterDictionary of validation messages, when the dictionary is unknown or empty, validation was successful
     */
    method public CharacterDictionary IsValid (poValueObject as Progress.Lang.Object).

end interface.
