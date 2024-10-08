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
    File        : FileAssert
    Purpose     : Provides routines for validating file system files
    Syntax      :
    Description : Routines in this class typically raise an error condition
                  when the condition is not met.
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Jan 01 19:50:05 CET 2013
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Assertion.* from propath .
using Progress.Lang.*            from propath .

class Consultingwerk.Assertion.FileAssert:

    /**
     * Purpose: Constructor for the FileAssert class
     * Notes:   Disallow instance creation
     */
    constructor private FileAssert ():
        super ().

    end constructor.

    /**
     * Purpose: Verifies that the file exists
     * Notes:
     * Throws:  Consultingwerk.Assertion.AssertException
     * @param pcFileName The file name to verify
     */
    method public static void Exists (pcFileName as character):

        file-information:file-name = pcFileName .
        if file-information:full-pathname = ? then
            undo, throw new AssertException (substitute ("Invalid file name: &1":U,
                                                         pcFileName),
                                             0) .
    end method .

    /**
     * Purpose: Verifies that the file does not exist
     * Notes:
     * Throws:  Consultingwerk.Assertion.AssertException
     * @param pcFileName The file name to verify
     */
    method public static void DoesNotExist (pcFileName as character):

        file-information:file-name = pcFileName .
        if file-information:full-pathname <> ? then
            undo, throw new AssertException (substitute ("File already exists: &1":U,
                                                         pcFileName),
                                             0) .
    end method .

end class.
