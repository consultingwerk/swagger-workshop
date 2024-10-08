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
    File        : ParameterObject
    Purpose     : Base class for parameter objects
    Syntax      :
    Description : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Apr 14 06:02:28 CEST 2019
    Notes       : Relies on ABL Reflection, so at least OpenEdge 11.6
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*            from propath .
using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .
&if defined (AblReflection) ne 0 &then
using Progress.Reflect.*          from propath .
&endif

class Consultingwerk.ParameterObject
    abstract
    serializable
    inherits JsonSerializable:

    /**
     * Purpose: Compares this object to the passed in object by value
     * Notes:
     * @param poObject The reference to the object to compare to
     * @return Logical value indicating if the two objects are identical by value
     */
    method public override logical Equals (poObject as Progress.Lang.Object):

&if defined (AblReflection) ne 0 &then
        define variable oProperties as Progress.Reflect.Property extent no-undo .
        define variable i           as integer                          no-undo .

        if not valid-object (poObject) then
            return false .

        if poObject = this-object then
            return true .

        if not poObject:GetClass():IsA (this-object:GetClass()) then
            return false .

        oProperties = this-object:GetClass ():GetProperties (Progress.Reflect.Flags:Public or Progress.Reflect.Flags:Instance).

        propertyLoop:
        do i = 1 to extent (oProperties):

            if not oProperties[i]:CanRead then
                next propertyLoop .

            if oProperties[i]:DeclaringClass = get-class (Progress.Lang.Object) then
                next propertyLoop .

            if oProperties[i]:Get (this-object) <> oProperties[i]:GET (poObject) then
                return false .
        end.

        return true.
&else
        undo, throw new NotImplementedException ("Equals":U, "Consultingwerk.ParameterObject":U) .
&endif

    end method.

    /**
     * Purpose: Returns an 64bit RAW Hash Value representing the object instance
     * Notes:   Based on the ABL SHA-512 implementation
     * @return The RAW Hash Value representing the object instance
     */
    method public raw GetHashCode ():

&if defined (AblReflection) ne 0 &then
        define variable lcDataToHash as longchar no-undo.

        define variable oProperties as Progress.Reflect.Property extent no-undo .
        define variable i           as integer                          no-undo .

        fix-codepage (lcDataToHash) = "UTF-8":U .

        lcDataToHash = this-object:GetClass():TypeName .

        oProperties = this-object:GetClass ():GetProperties (Progress.Reflect.Flags:Public or Progress.Reflect.Flags:Instance).

        propertyLoop:
        do i = 1 to extent (oProperties):

            if not oProperties[i]:CanRead then
                next propertyLoop .

            if oProperties[i]:DeclaringClass = get-class (Progress.Lang.Object) then
                next propertyLoop .

            assign lcDataToHash = lcDataToHash + substitute  ("&1&2&1&3 ":U,
                                                             chr(1),
                                                             oProperties[i]:Name,
                                                             oProperties[i]:Get (this-object)) .
        end.

        return message-digest ('sha-512':U, lcDataToHash) .
&else
        undo, throw new NotImplementedException ("Equals":U, "Consultingwerk.ParameterObject":U) .
&endif

    end method.

    /**
     * Purpose: Returns a string representation of the object
     * Notes:
     * @return The string representation of the object
     */
    method public override character ToString ():

&if defined (AblReflection) ne 0 &then
        define variable oProperties as Progress.Reflect.Property extent no-undo .
        define variable i           as integer                          no-undo .
        define variable cReturn     as character                        no-undo .

        oProperties = this-object:GetClass ():GetProperties (Progress.Reflect.Flags:Public or Progress.Reflect.Flags:Instance).

        propertyLoop:
        do i = 1 to extent (oProperties):

            if not oProperties[i]:CanRead then
                next propertyLoop .

            if oProperties[i]:DeclaringClass = get-class (Progress.Lang.Object) then
                next propertyLoop .

            assign cReturn = cReturn + (if cReturn > "":U then "~n":U else "":U) +
                                       substitute ("&1: &2 ":U,
                                                   oProperties[i]:Name,
                                                   oProperties[i]:Get (this-object)) .
        end.

        return trim (cReturn).
&else
        undo, throw new NotImplementedException ("Equals":U, "Consultingwerk.ParameterObject":U) .
&endif
    end method.

end class.
