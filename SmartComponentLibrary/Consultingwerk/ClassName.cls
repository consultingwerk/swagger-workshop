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
    File        : ClassName
    Purpose     : Structure that describes parts of a class name (package and class)
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Sep 03 07:51:12 CEST 2015
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.ClassName
    inherits JsonSerializable
    implements IValueObjectValidator
    serializable:

    {Consultingwerk/JsonSerializableProperty.i FullName character}
    {Consultingwerk/JsonSerializableProperty.i ClassName character}
    {Consultingwerk/JsonSerializableProperty.i PackageName character}
    {Consultingwerk/JsonSerializableProperty.i IsExtent logical "initial false"}
    {Consultingwerk/JsonSerializableProperty.i Extent integer "initial ?"}

    /**
     * Purpose: Returns the fully qualified type name
     * Notes:   Includes EXTENT is applicable
     * @return The fully qualified type name
     */
    method public character FullyQualifiedTypeName ():

        define variable cTypeName as character no-undo.

        assign cTypeName = substitute ("&1.&2":u,
                                       this-object:PackageName,
                                       this-object:ClassName).

        if this-object:IsExtent then do:
            if this-object:Extent <> ? then
                assign cTypeName = substitute ("&1 EXTENT &2":u,
                                               cTypeName,
                                               this-object:Extent).
            else
                assign cTypeName = substitute ("&1 EXTENT":u,
                                               cTypeName).
        end.

        return cTypeName.

    end method.

    /**
     * Purpose: Validates the properties of the given value object
     * Notes:
     * @param poValueObject The value object to validate
     * @return Logical value indicating if the object's properties are valid
     */
    method public logical IsValid (poValueObject as Progress.Lang.Object):

        define variable oObject as ClassName no-undo .

        oObject = cast (poValueObject, ClassName) .

        return oObject:FullName > "":U or oObject:PackageName > "":U and oObject:ClassName > "":U .

    end method .

    /**
     * Purpose: Returns a string representation
     * Notes:
     * @return A String representation of the class name
     */
    method public override character ToString ():

        return "Class Name: "{&TRAN}  + this-object:ClassName + "~n":U +
               "Package Name:"{&TRAN} + this-object:PackageName + "~n":U +
               "Full Name:"{&TRAN}    + this-object:FullName .

    end method.

end class.
