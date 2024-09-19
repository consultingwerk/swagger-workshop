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
    File        : SwaggerSchemaTypeGeneratorParameter
    Purpose     :
    Syntax      :
    Description :
    Author(s)   :
    Created     : 07.05.2024 12:57:00
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*                       from propath.
using Consultingwerk.Framework.Collections.* from propath.
using Consultingwerk.Studio.SwaggerToAbl.*   from propath.
using Progress.Lang.*                        from propath.

class Consultingwerk.Studio.SwaggerToAbl.SwaggerSchemaTypeGeneratorParameter
    inherits ParameterObject
    implements IValueObjectValidatorWithMessages, ISwaggerBasePackageParameter
    serializable:

    {Consultingwerk/JsonSerializableProperty.i BasePackage character}
    {Consultingwerk/JsonSerializableProperty.i LogFileName character}
    {Consultingwerk/JsonSerializableProperty.i NestedPackages logical "initial true"}
    {Consultingwerk/JsonSerializableProperty.i Operations character "extent"}

    /**
     * Purpose: Validates the properties of the given value object
     * Notes:
     * @param poValueObject The value object to validate
     * @return CharacterDictionary of validation messages, when the dictionary is unknown or empty, validation was successful
     */
    method public CharacterDictionary IsValid (poValueObject as Progress.Lang.Object):

        define variable oErrors      as CharacterDictionary       no-undo.
        define variable oValueObject as SwaggerSchemaTypeGeneratorParameter no-undo.

        assign oErrors      = new CharacterDictionary()
               oValueObject = cast(poValueObject, SwaggerSchemaTypeGeneratorParameter).

        if CharacterType:IsNullOrEmpty(oValueObject:BasePackage) then
            oErrors:Add("BasePackage":u, "Base package name must be specified":u).

        return oErrors.

    end method .

end class.
