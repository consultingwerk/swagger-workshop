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
    File        : ISupportsAvailable
    Purpose     : Interface to resolve dependency from BufferAssert to
                  TableModel class
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Sep 12 20:07:56 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Progress.Lang.*.

interface Consultingwerk.Assertion.Support.ISupportsAvailable:

    /**
     * Purpose: Returns if currently a record is available in the TableModel
     * Notes:
     */
    define public property available as logical no-undo
    get.

    /**
     * Purpose: Returns the name of the Buffer used by the Model
     * Notes:
     */
    define public property BufferName as character no-undo
    get.

end interface.
