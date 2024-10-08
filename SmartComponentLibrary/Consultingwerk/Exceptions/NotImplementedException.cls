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
    File        : NotImplementedException
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwer Ltd.
    Created     : Sun Feb 17 09:48:56 CET 2008
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.NotImplementedException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the class name that caused this NotImplementedException
     * Notes:
     */
    define public property ClassName as character no-undo
    get.
    private set.

    /**
     * Purpose: Returns the method name that caused this NotImplementedException
     * Notes:
     */
    define public property MethodName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor for the NotImplementedException class
     * Notes:
     */
    constructor public NotImplementedException ():
        super ("This method is not implemented yet."{&TRAN}, 0).

    end constructor.

    /**
     * Purpose: Constructor for the NotImplementedException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public NotImplementedException (poInnerException as Error):

        super (poInnerException,
               "This method is not implemented yet."{&TRAN},
               0).

    end constructor.

    /**
     * Purpose: Constructor for the NotImplementedException class
     * Notes:
     * @param pcMethodName The name of the method that is not implemented
     * @param pcClassName The name of the class that caused this NotImplementedException
     */
    constructor public NotImplementedException (pcMethodName as character,
                                                pcClassName  as character):

        super (substitute("The method &1 of class &2 is not implemente yet."{&TRAN},
                          pcMethodName, pcClassName), 0).

        assign this-object:ClassName  = pcClassName
               this-object:MethodName = pcMethodName .

    end constructor.

    /**
     * Purpose: Constructor for the NotImplementedException class
     * Notes:   Expects the method and class name as a single CHARACTER parameter, SPACE delimited as returned by PROGRAM-NAME(1)
     * @param pcMethodClassName The single parameter combining Method and Class name as returned by PROGRAM-NAME(1)
     */
    constructor public NotImplementedException (pcMethodClassName as character):

        this-object (entry (1, pcMethodClassName, " ":U),
                     (if num-entries (pcMethodClassName, " ":U) > 1 then entry (2, pcMethodClassName, " ":U) else "":U)).

    end constructor.

    /**
     * Purpose: Constructor for the NotImplementedException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcMethodName The name of the method that is not implemented
     * @param pcClassName The name of the class that caused this NotImplementedException
     */
    constructor public NotImplementedException (poInnerException as Error,
                                                pcMethodName as character,
                                                pcClassName  as character):

        super (poInnerException,
               substitute("The method &1 of class &2 is not implemente yet."{&TRAN},
                          pcMethodName, pcClassName),
               0).

        assign this-object:ClassName  = pcClassName
               this-object:MethodName = pcMethodName .

    end constructor.

end class.
