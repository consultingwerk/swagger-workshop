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

interface Consultingwerk.IValueObjectValidatorWithDisplayProperties:

    /**
     * Purpose: Returns the list of properties that should be displayed after
                the call to IsValid()
     * Notes:
     */
    define public property DisplayProperties as character extent no-undo
    get .

end interface.
