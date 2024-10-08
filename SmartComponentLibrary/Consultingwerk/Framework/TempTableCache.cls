/**********************************************************************
 * Copyright (C) 2006-2022 by Consultingwerk Ltd. ("CW") -            *
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
    File        : TempTableCache
    Purpose     : General purpose cache for temp-tables
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Dec 17 08:00:48 CET 2022
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Assertion.* from propath .
using Progress.Lang.*            from propath .

class Consultingwerk.Framework.TempTableCache:

    define temp-table ttCache no-undo
        field CacheKey        as character
        field TempTableHandle as handle
        index CacheKey is primary unique CacheKey .

    /**
     * Purpose: Clears the temp-table cache
     * Notes:   Deletes all temp-table object handles
     */
    method public void ClearCache ():

        for each ttCache:
            if valid-handle (ttCache.TempTableHandle) then
                delete object ttCache.TempTableHandle.
        end.

        empty temp-table ttCache.

    end method .

    /**
     * Purpose: Retrieves a temp-table from the cache
     * Notes:   phTempTable is intended to be returned by-value (no by-reference usage)
     * @param pcCacheKey The key to store the temp-table under
     * @param phTempTable The temp-table handle (no by-reference usage)
     * @return Logical value indicating if the temp-table key was found in the cache
     */
    method public logical GetFromCache (pcCacheKey as character,
                                        output table-handle phTempTable):

        define buffer ttCache for ttCache .

        if not can-find (ttCache where ttCache.CacheKey = pcCacheKey) then
            return false .

        find ttCache where ttCache.CacheKey = pcCacheKey no-error .

        assign phTempTable = ttCache.TempTableHandle .

        return true .

    end method .

    /**
     * Purpose: Retrieves a temp-table from the cache
     * Notes:
     * @param pcCacheKey The key to store the temp-table under
     * @return The handle of the temp-table in the cache
     */
    method public handle GetFromCache (pcCacheKey as character):

        define buffer ttCache for ttCache .

        if not can-find (ttCache where ttCache.CacheKey = pcCacheKey) then
            return ? .

        find ttCache where ttCache.CacheKey = pcCacheKey no-error .

        return ttCache.TempTableHandle.

    end method .

    /**
     * Purpose: Stores a temp-table in the cache
     * Notes:   phTempTable is intended to be passed by-value (no by-reference usage)
     * @param pcCacheKey The key to store the temp-table under
     * @param phTempTable The temp-table handle (no by-reference usage)
     */
    method public void StoreInCache (pcCacheKey as character,
                                     table-handle phTempTable):

        define buffer ttCache for ttCache .

        HandleAssert:IsTempTable (phTempTable) .

        create ttCache.
        assign ttCache.CacheKey        = pcCacheKey
               ttCache.TempTableHandle = phTempTable .

    end method.

    /**
     * Purpose: Clears the temp-table cache
     * Notes:   Deletes all temp-table object handles
     */
    destructor public TempTableCache ():
        this-object:ClearCache().
    end destructor.

end class.
