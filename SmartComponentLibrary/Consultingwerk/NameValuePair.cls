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
    File        : NameValuePair
    Purpose     : A general purpose NameValuePair
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Sep 10 19:06:29 CEST 2011
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.*  from propath .
using Progress.Lang.*   from propath .

{Consultingwerk/products.i}

class Consultingwerk.NameValuePair
    inherits JsonSerializable
    {&SERIALIZABLE}:

    /**
     * Purpose: Gets and sets the Name of the NameValuePair
     * Notes:
     */
    {Consultingwerk/JsonSerializableProperty.i Name character}

    /**
     * Purpose: Gets and sets the Value of the NameValuePair
     * Notes:
     */
    {Consultingwerk/JsonSerializableProperty.i Value character}

    /**
     * Purpose: Constructor for the NameValuePair class
     * Notes:
     */
    constructor public NameValuePair ():
        super ().
    end constructor.

    /**
     * Purpose: Constructor for the NameValuePair class
     * Notes:
     * @param pcName The name value
     * @param pcValue The value
     */
    constructor public NameValuePair (pcName as character,
                                      pcValue as character):

        assign this-object:Name  = pcName
               this-object:Value = pcValue .

    end constructor.

    /**
     * Purpose: Returns a CHARACTER representation of the object instance
     * Notes:
     * @return The CHARACTER representation of the object instance
     */
    method public override character ToString ():

        return substitute ("Name: &1~nValue: &2":U,
                           this-object:Name,
                           this-object:Value).

    end method.

end class.
