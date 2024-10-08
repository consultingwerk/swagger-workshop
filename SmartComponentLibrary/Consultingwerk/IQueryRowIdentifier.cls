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
    File        : IQueryRowIdentifier
    Purpose     : Provides abstraction methods for query row id representation
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Dec 03 15:27:56 CET 2013
    Notes       : Used in the Consultingwerk.OERA.DataAccess class to allow
                  customers extensions to the RowId context string used by the
                  Data Access
  ----------------------------------------------------------------------*/

@lowercase.

using Consultingwerk.* from propath .
using Progress.Lang.* from propath.

interface Consultingwerk.IQueryRowIdentifier:

    /**
     * Purpose: Assigns the internal storage with the restart row identifiers of
     *          the given data source object handle
     * Notes:
     * @param phDataSource The handle of the DATA-SOURCE
     */
    method public void GetDataSourceNextRowids (phDataSource as handle) .

    /**
     * Purpose: Populates the ROWID[]with the rowids of the current Query result row
     * Notes:
     * @param phQueryHandle The handle of the query
     */
    method public void GetQueryCurrentRowids (phQueryHandle as handle) .

    /**
     * Purpose: Returns if the QueryRowIdentifier contains a valid row identifier
     * Notes:   Verifies that a ROWID for the topmost buffer is available
     * @return Logical value indicating if the QueryRowIdentifier contains a valid row identifier
     */
    method public logical IsBaseRowidSpecified () .

    /**
     * Purpose: Parses a character representation of the rowident
     * Notes:
     * @param pcRowidIdent The character representation of the rowident
     */
    method public void ParseString (pcRowidIdent as character) .

    /**
     * Purpose: Compares the array of the current query ROWIDs with the array of
     *          Restart ROWIDs
     * Notes:
     * @param phQueryHandle The Query handle
     * @return Logical value indicating if the two arrays are equal
     */
    method public logical QueryCurrentRowidsEquals (phQueryHandle as handle) .

    /**
     * Purpose: Moves a query objects result list pointer to the row corresponding
     *          to the specified ROWID or ROWIDs. To reposition to a particular row
     *          when the query is a join, supply the ROWIDs of the buffers that
     *          correspond to the desired row.
     * Notes:
     * @param phQueryHandle The handle of the query
     * @return Logical value indicating if the method was successful
     */
    method public logical RepositionQuery (phQueryHandle as handle) .

    /**
     * Purpose: Sets the RESTART-ROWID for the data source buffer(s)
     * Notes:
     * @param phBufferHandle The buffer handle
     */
    method public void SetBufferRestartRowids (phBufferHandle as handle) .

    /**
     * Purpose: Returns the ROWID[] representation of this instance
     * Notes:   Used for backwards compatibility only
     * @return The ROWID[] representation of this instance
     */
    method public rowid extent ToArray () .

    /**
     * Purpose: Returns the CHARACTER representation (serialization) of this instance
     * Notes:   The result of this method can be parsed by the method ParseString()
     * @return The CHARACTER representation of this instance
     */
    method override public character ToString () .

end interface.
