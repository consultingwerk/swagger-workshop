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
    File        : InternationalizationSettings
    Purpose     : Holder structur for Numeric- and DateFormat settings
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 26.04.2020 10:27:58
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.InternationalizationSettings
    inherits ParameterObject
    {&SERIALIZABLE}:

    {Consultingwerk/JsonSerializableProperty.i NumericFormat Consultingwerk.NumericFormat}
    {Consultingwerk/JsonSerializableProperty.i DateFormat Consultingwerk.DateFormat}

    /**
     * Purpose: Constructor for the InternationalizationSettings class
     * Notes:
     */
    constructor public InternationalizationSettings ():
        super ().
    end constructor.

    /**
     * Purpose: Constructor for the InternationalizationSettings class
     * Notes:
     * @param pNumericFormat The value for the NumericFormat property
     * @param pDateFormat The value for the DateFormat property
     */
    constructor public InternationalizationSettings (pNumericFormat as Consultingwerk.NumericFormat,
                                                     pDateFormat as Consultingwerk.DateFormat):
        this-object ().

        assign this-object:NumericFormat = pNumericFormat
               this-object:DateFormat    = pDateFormat
                .

    end constructor.

    /**
     * Purpose: Property Setter for the NumericFormat property
     * Notes:
     * @param pNumericFormat The value for the NumericFormat property
     * @return The reference to the object instance
     */
    method public InternationalizationSettings NumericFormat (pNumericFormat as Consultingwerk.NumericFormat):
        assign this-object:NumericFormat = pNumericFormat .
        return this-object.
    end method .

    /**
     * Purpose: Property Setter for the DateFormat property
     * Notes:
     * @param pDateFormat The value for the DateFormat property
     * @return The reference to the object instance
     */
    method public InternationalizationSettings DateFormat (pDateFormat as Consultingwerk.DateFormat):
        assign this-object:DateFormat = pDateFormat .
        return this-object.
    end method .

end class.
