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
    File        : NotSupportedException
    Purpose     : General purpose error class for methods that are not
                  supported
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwer Ltd.
    Created     : Mon Apr 25 00:04:42 CET 2011
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.NotSupportedException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the class name that caused this NotSupportedException
     * Notes:
     */
    define public property ClassName as character no-undo
    get.
    private set.

    /**
     * Purpose: Returns the method name that caused this NotSupportedException
     * Notes:
     */
    define public property MethodName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the NotSupportedException class
     * Notes:
     */
    constructor public NotSupportedException ():
        super ("This method is not supported."{&TRAN}, 0).

    end constructor.

    /**
     * Purpose: Constructor of the NotSupportedException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public NotSupportedException (poInnerException as Error):

        super (poInnerException,
               "This method is not supported."{&TRAN},
               0).

    end constructor.

    /**
     * Purpose: Constructor of the NotSupportedException class
     * Notes:
     * @param pcMethodName The name of the method that is not implemented
     */
    constructor public NotSupportedException (pcMethodName as character):

        super (substitute("The method &1 is not supported."{&TRAN},
                          pcMethodName), 0).

        assign this-object:MethodName = pcMethodName .

    end constructor.

    /**
     * Purpose: Constructor of the NotSupportedException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcMethodName The name of the method that is not implemented
     */
    constructor public NotSupportedException (poInnerException as Error,
                                              pcMethodName as character):

        super (poInnerException,
               substitute("The method &1 is not supported."{&TRAN},
                          pcMethodName),
               0).

        assign this-object:MethodName = pcMethodName .

    end constructor.

    /**
     * Purpose: Constructor of the NotSupportedException class
     * Notes:
     * @param pcMethodName The name of the method that is not implemented
     * @param pcClassName The name of the class that caused this NotSupportedException
     */
    constructor public NotSupportedException (pcMethodName as character,
                                              pcClassName  as character):

        this-object (pcMethodName, pcClassName, ?) .

    end constructor.

    /**
     * Purpose: Constructor of the NotSupportedException class
     * Notes:
     * @param pcMethodName The name of the method that is not implemented
     * @param pcClassName The name of the class that caused this NotSupportedException
     * @param pcErrorMessage An Additional Custom Error Message
     */
    constructor public NotSupportedException (pcMethodName   as character,
                                              pcClassName    as character,
                                              pcErrorMessage as character):

        super (substitute("The method &1 of class &2 is not supported."{&TRAN},
                          pcMethodName, pcClassName), 0).

        if pcErrorMessage > "":U then
            this-object:AddMessage (pcErrorMessage, 0) .

        assign this-object:ClassName  = pcClassName
               this-object:MethodName = pcMethodName .

    end constructor.

    /**
     * Purpose: Constructor of the NotSupportedException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcMethodName The name of the method that is not implemented
     * @param pcClassName The name of the class that caused this NotSupportedException
     */
    constructor public NotSupportedException (poInnerException as Error,
                                              pcMethodName as character,
                                              pcClassName  as character):

        this-object (poInnerException, pcMethodName, pcClassName, ?) .

    end constructor.

    /**
     * Purpose: Constructor of the NotSupportedException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcMethodName The name of the method that is not implemented
     * @param pcClassName The name of the class that caused this NotSupportedException
     * @param pcErrorMessage An Additional Custom Error Message
     */
    constructor public NotSupportedException (poInnerException as Error,
                                              pcMethodName     as character,
                                              pcClassName      as character,
                                              pcErrorMessage   as character):

        super (poInnerException,
               substitute("The method &1 of class &2 is not supported."{&TRAN},
                          pcMethodName, pcClassName),
               0).

        if pcErrorMessage > "":U then
            this-object:AddMessage (pcErrorMessage, 0) .

        assign this-object:ClassName  = pcClassName
               this-object:MethodName = pcMethodName .

    end constructor.

end class.
