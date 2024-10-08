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
    File        : NotSupportedOnThisPlatform
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Sep 23 09:55:20 CEST 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.NotSupportedOnThisPlatform
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the class name that caused this NotSupportedOnThisPlatform
     * Notes:
     */
    define public property ClassName as character no-undo
    get.
    private set.

    /**
     * Purpose: Returns the method name that caused this NotSupportedOnThisPlatform
     * Notes:
     */
    define public property MethodName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the NotSupportedOnThisPlatformException class
     * Notes:
     */
    constructor public NotSupportedOnThisPlatform ():

        super ("This method is not supported on this platform."{&TRAN}, 0).

    end constructor.

    /**
     * Purpose: Constructor of the NotSupportedOnThisPlatformException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public NotSupportedOnThisPlatform (poInnerException as Progress.Lang.Error):

        super (poInnerException,
               "This method is not supported on this platform."{&TRAN},
               0).

    end constructor.

    /**
     * Purpose: Constructor of the NotSupportedOnThisPlatformException class
     * Notes:
     * @param pcMethodName The name of the method that is not implemented
     */
    constructor public NotSupportedOnThisPlatform (pcMethodName as character):

        super (substitute("The method &1 is not supported on this platform."{&TRAN},
                          pcMethodName), 0).

        assign this-object:MethodName = pcMethodName .

    end constructor.

    /**
     * Purpose: Constructor of the NotSupportedOnThisPlatformException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcMethodName The name of the method that is not implemented
     */
    constructor public NotSupportedOnThisPlatform (poInnerException as Progress.Lang.Error,
                                                   pcMethodName as character):

        super (poInnerException,
               substitute("The method &1 is not supported on this platform."{&TRAN},
                          pcMethodName),
               0).

        assign this-object:MethodName = pcMethodName .

    end constructor.

    /**
     * Purpose: Constructor of the NotSupportedOnThisPlatformException class
     * Notes:
     * @param pcMethodName The name of the method that is not implemented
     * @param pcClassName The name of the class that caused this NotSupportedOnThisPlatformException
     */
    constructor public NotSupportedOnThisPlatform (pcMethodName as character,
                                                   pcClassName as character):

        super (substitute("The method &1 of class &2 is not supported on this platform."{&TRAN},
                          pcMethodName, pcClassName), 0).

        assign this-object:ClassName  = pcClassName
               this-object:MethodName = pcMethodName .

    end constructor.

    /**
     * Purpose: Constructor of the NotSupportedOnThisPlatformException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcMethodName The name of the method that is not implemented
     * @param pcClassName The name of the class that caused this NotSupportedOnThisPlatformException
     */
    constructor public NotSupportedOnThisPlatform (poInnerException as Progress.Lang.Error,
                                                   pcMethodName as character,
                                                   pcClassName as character):

        super (poInnerException,
               substitute("The method &1 of class &2 is not supported on this platform."{&TRAN},
                          pcMethodName, pcClassName),
               0).

        assign this-object:ClassName  = pcClassName
               this-object:MethodName = pcMethodName .

    end constructor.

end class.
