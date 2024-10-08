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
    File        : ListAssert
    Purpose     : Assertion methods for delimited lists
    Syntax      :
    Description : Routines in this class typically raise an error condition
                  when the condition is not met.
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Jul 14 17:36:13 CEST 2013
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.Assertion.* from propath .
using Consultingwerk.Util.*      from propath .
using Progress.Lang.*            from propath .

class Consultingwerk.Assertion.ListAssert:

    /**
     * Purpose: Validates if an entry is in the given list of values
     * Notes:
     * @param pcEntry The entry to locate in the list
     * @param pcList The list to locate the entry in
     */
    method public static void EntryIsInList (pcEntry as character,
                                             pcList as character):

        if lookup (pcEntry, pcList) = 0 or lookup (pcEntry, pcList) = ? then
            undo, throw new AssertException (substitute ("The Entry ~"&1~" is not in the List of ~"&2~"."{&TRAN},
                                                         pcEntry, pcList),
                                             0) .

    end method .

    /**
     * Purpose: Validates if an entry is in the given list of values
     * Notes:
     * @param pcEntry The entry to locate in the list
     * @param pcList The list to locate the entry in
     * @param pcDelimiter The list delimiter to use
     */
    method public static void EntryIsInList (pcEntry as character,
                                             pcList as character,
                                             pcDelimiter as character):

        if lookup (pcEntry, pcList, pcDelimiter) = 0 or lookup (pcEntry, pcList, pcDelimiter) = ? then
            undo, throw new AssertException (substitute ("The Entry ~"&1~" is not in the List of ~"&2~"."{&TRAN},
                                                         pcEntry, pcList),
                                             0) .

    end method .

    /**
     * Purpose: Validates if an entry is in the given list of values
     * Notes:
     * @param pcEntry The entry to locate in the list
     * @param pcList The list to locate the entry in
     */
    method public static void EntryIsInList (pcEntry as character,
                                             pcList as longchar):

        if lookup (pcEntry, pcList) = 0 or lookup (pcEntry, pcList) = ? then
            undo, throw new AssertException (substitute ("The Entry ~"&1~" is not in the List of ~"&2~"."{&TRAN},
                                                         pcEntry,
                                                         DataTypeHelper:LongcharToCharacter(pcList)),
                                             0) .

    end method .

    /**
     * Purpose: Validates if an entry is in the given list of values
     * Notes:
     * @param pcEntry The entry to locate in the list
     * @param pcList The list to locate the entry in
     * @param pcDelimiter The list delimiter to use
     */
    method public static void EntryIsInList (pcEntry as character,
                                             pcList as longchar,
                                             pcDelimiter as character):

        if lookup (pcEntry, pcList, pcDelimiter) = 0 or lookup (pcEntry, pcList, pcDelimiter) = ? then
            undo, throw new AssertException (substitute ("The Entry ~"&1~" is not in the List of ~"&2~"."{&TRAN},
                                                         pcEntry,
                                                         DataTypeHelper:LongcharToCharacter(pcList)),
                                             0) .

    end method .

    /**
     * Purpose: Validates if a list has an even number of entries
     * Notes:
     * Throws: Consultingwerk.Assertion.AssertException
     * @param pcList The list to validate
     */
    method public static void EvenEntries (pcList as character):

        define variable iEntries as integer no-undo.

        assign iEntries = num-entries (pcList) .

        if iEntries modulo 2 <> 0 then
            undo, throw new AssertException (substitute ("List has &1 odd number of entries, but an even number is expected."{&TRAN},
                                                         pcList),
                                             0) .
    end method .

    /**
     * Purpose: Validates if a list has an even number of entries
     * Notes:
     * Throws: Consultingwerk.Assertion.AssertException
     * @param pcList The list to validate
     * @param pcDelimiter The list delimiter
     */
    method public static void EvenEntries (pcList as character,
                                           pcDelimiter as character):

        define variable iEntries as integer no-undo.

        assign iEntries = num-entries (pcList, pcDelimiter) .

        if iEntries modulo 2 <> 0 then
            undo, throw new AssertException (substitute ("List has &1 odd number of entries, but an even number is expected."{&TRAN},
                                                         pcList),
                                             0) .
    end method .

    /**
     * Purpose: Validates if a list has the expected number of entries
     * Notes:
     * Throws: Consultingwerk.Assertion.AssertException
     * @param pcList The list to validate
     * @param pcDelimiter The list delimiter
     * @param piEntries The expected number of entries
     */
    method public static void NumEntries (pcList as character,
                                          pcDelimiter as character,
                                          piEntries as integer):

        define variable iEntries as integer no-undo.

        assign iEntries = num-entries (pcList, pcDelimiter) .

        if iEntries <> piEntries then
            undo, throw new AssertException (substitute ("List has &1 entries, but expected are &2 entries."{&TRAN},
                                                         iEntries, piEntries),
                                             0) .
    end method .

    /**
     * Purpose: Validates if a list has the expected number of entries
     * Notes:
     * Throws: Consultingwerk.Assertion.AssertException
     * @param pcList The list to validate
     * @param pcDelimiter The list delimiter
     * @param piEntries The expected number of entries
     */
    method public static void NumEntries (pcList as longchar,
                                          pcDelimiter as character,
                                          piEntries as integer):

        define variable iEntries as integer no-undo.

        assign iEntries = num-entries (pcList, pcDelimiter) .

        if iEntries <> piEntries then
            undo, throw new AssertException (substitute ("List has &1 entries, but expected are &2 entries."{&TRAN},
                                                         iEntries, piEntries),
                                             0) .
    end method .

    /**
     * Purpose: Validates if a list has the expected number of entries
     * Notes:   Uses the comma as the default list delimiter
     * Throws: Consultingwerk.Assertion.AssertException
     * @param pcList The list to validate
     * @param piEntries The expected number of entries
     */
    method public static void NumEntries (pcList as character,
                                          piEntries as integer):

        define variable iEntries as integer no-undo.

        assign iEntries = num-entries (pcList) .

        if iEntries <> piEntries then
            undo, throw new AssertException (substitute ("List has &1 entries, but expected are &2 entries."{&TRAN},
                                                         iEntries, piEntries),
                                             0) .
    end method .

    /**
     * Purpose: Validates if a list has the expected number of entries
     * Notes:   Uses the comma as the default list delimiter
     * Throws: Consultingwerk.Assertion.AssertException
     * @param pcList The list to validate
     * @param piEntries The expected number of entries
     */
    method public static void NumEntries (pcList as longchar,
                                          piEntries as integer):

        define variable iEntries as integer no-undo.

        assign iEntries = num-entries (pcList) .

        if iEntries <> piEntries then
            undo, throw new AssertException (substitute ("List has &1 entries, but expected are &2 entries."{&TRAN},
                                                         iEntries, piEntries),
                                             0) .
    end method .

    /**
     * Purpose: Validates if a list has only unique entries
     * Notes:   Based on Consultingwerk.Util.ListHelper:VerifyUniqueEntries
     * Throws: Consultingwerk.Assertion.AssertException
     * @param pcList The list to validate
     */
    method public static void UniqueEntries (pcList as character):

        if ListHelper:VerifyUniqueEntries (pcList) = false then
            undo, throw new AssertException (substitute ("The list &1 does have non-unique entries."{&TRAN}, pcList),
                                             0) .
    end method .

    /**
     * Purpose: Validates if a list has only unique entries
     * Notes:   Based on Consultingwerk.Util.ListHelper:VerifyUniqueEntries
     * Throws: Consultingwerk.Assertion.AssertException
     * @param pcList The list to validate
     * @param pcDelimiter The list delimiter
     */
    method public static void UniqueEntries (pcList as character,
                                             pcDelimiter as character):

        if ListHelper:VerifyUniqueEntries (pcList, pcDelimiter) = false then
            undo, throw new AssertException (substitute ("The list &1 does have non-unique entries."{&TRAN}, pcList),
                                             0) .
    end method .

end class.
