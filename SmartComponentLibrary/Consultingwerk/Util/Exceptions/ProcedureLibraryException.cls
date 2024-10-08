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
    File        : ProcedureLibraryException
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 26.12.2017 10:03:28
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*                          from propath .
using Consultingwerk.Exceptions.*               from propath .
using Consultingwerk.Util.Exceptions.*          from propath .
using Progress.Lang.*                           from propath .

class Consultingwerk.Util.Exceptions.ProcedureLibraryException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the name of the Procedure Library that caused the issue
     * Notes:
     */
    define public property ProcedureLibrary as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the ProcedureLibraryException class
     * Notes:
     */
    constructor public ProcedureLibraryException ():

        super ().

    end constructor.

    /**
     * Purpose: Constructor of the ProcedureLibraryException class
     * Notes:
     * @param pcProcedureLibrary The name of the Procedure Library that caused the issue
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public ProcedureLibraryException (pcProcedureLibrary as character,
                                                  pcErrorString as character,
                                                  piMessageNumber as integer):

        super (pcErrorString, piMessageNumber).

        this-object:ProcedureLibrary = pcProcedureLibrary .

    end constructor.

    /**
     * Purpose: Constructor of the ProcedureLibraryException class
     * Notes:
     * @param pcProcedureLibrary The name of the Procedure Library that caused the issue
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public ProcedureLibraryException (pcProcedureLibrary as character,
                                                  pcErrorString as character):

        super (pcErrorString).

        this-object:ProcedureLibrary = pcProcedureLibrary .

    end constructor.

    /**
     * Purpose: Constructor of the ProcedureLibraryException class
     * Notes:
     * @param pcProcedureLibrary The name of the Procedure Library that caused the issue
     */
    constructor public ProcedureLibraryException (pcProcedureLibrary as character):

        super ().

        this-object:ProcedureLibrary = pcProcedureLibrary .

    end constructor.

end class.
