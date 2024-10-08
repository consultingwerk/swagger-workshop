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
    File        : ListNameValuePair
    Purpose     : List of NameValuePair implementations
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Mar 31 20:39:40 CEST 2011
    Notes       : Simplified dictionary implementation
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*                       from propath .
using Consultingwerk.Framework.Base.*        from propath .
using Consultingwerk.Framework.Collections.* from propath.
using Progress.Lang.*                        from propath .

class Consultingwerk.ListNameValuePair
    inherits GenericList
    serializable:

    { Consultingwerk/Framework/Base/GenericList.i NameValuePair }

    /**
     * Purpose: Returns if the ListNameValuePair contains a pair this the given Name
     * Notes:
     * @param pcName The Name value to search
     * @return True, when the ListNameValuePair contains a pair this the given Name
     */
    method public logical ContainsName (pcName as character):

        {Consultingwerk/foreachGeneric.i NameValuePair oPair in this-object}

             if oPair:Name = pcName then
                return true .
        end.

        return false .

    end method .

    /**
     * Purpose: Returns a ListNameValuePair from a single delimited list
     * Notes:   name1,name2,name3
     * @param poList The CharacterList to convert
     * @return The new ListNameValuePair
     */
    method public static ListNameValuePair FromCharacterList (poList as CharacterList):

        define variable oList as ListNameValuePair no-undo .

        oList = new ListNameValuePair() .

        {Consultingwerk/foreachPrimitiveList.i Character cDatabase in poList}
            oList:Add (cDatabase, cDatabase) .
        end.

        return oList .

    end method .

    /**
     * Purpose: Returns a ListNameValuePair from a single delimited list
     * Notes:   name1,name2,name3
     * @param pcList The simple delimited list
     * @return The new ListNameValuePair
     */
    method public static ListNameValuePair FromSingleDelimitedList (pcList as character):

        define variable i        as integer           no-undo .
        define variable iEntries as integer           no-undo .
        define variable oList    as ListNameValuePair no-undo .

        assign iEntries = num-entries (pcList)
               oList    = new ListNameValuePair().

        do i = 1 to iEntries:

            oList:Add (entry (i, pcList), entry (i, pcList)) .

        end.

        return oList .

    end method .

    /**
     * Purpose: Returns a ListNameValuePair from a single delimited list
     * Notes:   name1,name2,name3
     * @param pcList The simple delimited list
     * @param pcDelimiter The list delimiter
     * @return The new ListNameValuePair
     */
    method public static ListNameValuePair FromSingleDelimitedList (pcList as character,
                                                                    pcDelimiter as character):

        define variable i        as integer           no-undo .
        define variable iEntries as integer           no-undo .
        define variable oList    as ListNameValuePair no-undo .

        assign iEntries = num-entries (pcList, pcDelimiter)
               oList    = new ListNameValuePair().

        do i = 1 to iEntries:

            oList:Add (entry (i, pcList, pcDelimiter), entry (i, pcList, pcDelimiter)) .

        end.

        return oList .

    end method .

    /**
     * Purpose: Finds a NameValuePair by it's Name
     * Notes:   Performs a FIND-FIRST, does not verify if there is a second pair
     *          with the same name
     * @param pcName The Name value to search
     * @return The matching NameValuePair or ? when no Pair has been found
     */
    method public NameValuePair FindByName (pcName as character):

        {Consultingwerk/foreachGeneric.i NameValuePair oPair in THIS-OBJECT}

             if oPair:Name = pcName then
                return oPair .
        end.

        return ? .

    end method .

    /**
     * Purpose: Adds a NameValuePair to the List
     * Notes:
     * @param pcName The Name value
     * @param pcValue The value
     * @return The new NameValuePair added to the List
     */
    method public NameValuePair Add (pcName as character, pcValue as character):

        define variable oItem as NameValuePair no-undo .

        oItem = new NameValuePair (pcName, pcValue) .

        this-object:Add (oItem).

        return oItem .

    end method.

    /**
     * Purpose: Returns the value for the given Name
     * Notes:   When the Name is used in the List more than once, the first occurence
     *          is returned
     * @param pcName The Name value to search
     * @return The Value of the Pair with the given Name or ? when no pair was found
     */
    method public character GetValueByName (pcName as character):

        define variable oPair as NameValuePair no-undo.

        assign oPair = this-object:FindByName (pcName) .

        if valid-object (oPair) then
            return oPair:Value .
        else
            return ? .

    end method .

    /**
     * Purpose: Returns the value for the given Name
     * Notes:   Depricated, use GetValueName instead
     * @param pcName The Name value to search
     * @return The Value of the Pair with the given Name or ? when no pair was found
     */
    method public character GetValueByPair (pcName as character):
        return this-object:GetValueByName (pcName) .
    end method .

end class.
