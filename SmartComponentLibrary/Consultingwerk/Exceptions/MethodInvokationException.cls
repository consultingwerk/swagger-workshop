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
    File        : MethodInvokationException
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Jan 16 13:54:47 CET 2016
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

{Consultingwerk/products.i}

class Consultingwerk.Exceptions.MethodInvokationException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the Method Name associated with this exception
     * Notes:
     */
    define public property MethodName as character no-undo
    get.
    protected set.

    /**
     * Purpose: Constructor of the MethodInvokationException class
     * Notes:
     */
    constructor public MethodInvokationException ():

        super ().

    end constructor.

    /**
     * Purpose: Constructor of the MethodInvokationException class
     * Notes:
     * @param pcErrorString The error message associated with this MethodInvokationException object
     * @param piMessageNumber The error message number associated with this MethodInvokationException object
     */
    constructor public MethodInvokationException (pcErrorString as character,
                                                  piMessageNumber as integer):

        super (pcErrorString, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the MethodInvokationException class
     * Notes:
     * @param pcErrorString The error message associated with this MethodInvokationException object
     */
    constructor public MethodInvokationException (pcErrorString as character):

        super (pcErrorString).

    end constructor.

    /**
     * Purpose: Constructor of the MethodInvokationException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public MethodInvokationException (poInnerException as Error):

        super (poInnerException).

    end constructor.

    /**
     * Purpose: Constructor of the MethodInvokationException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this MethodInvokationException object
     */
    constructor public MethodInvokationException (poInnerException as Error,
                                                  pcErrorString as character,
                                                  piMessageNumber as integer):

        super (poInnerException, pcErrorString, piMessageNumber).

    end constructor.

    /**
     * Purpose: Constructor of the MethodInvokationException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this MethodInvokationException object
     */
    constructor public MethodInvokationException (poInnerException as Error,
                                                  pcErrorString as character):

        super (poInnerException, pcErrorString).

    end constructor.

    /**
     * Purpose: Constructor of the MethodInvokationException class
     * Notes:
     * @param pcErrorString The error message associated with this MethodInvokationException object
     * @param piMessageNumber The error message number associated with this MethodInvokationException object
     * @param pcMethodName The method name associated with this exception
     */
    constructor public MethodInvokationException (pcErrorString as character,
                                                  piMessageNumber as integer,
                                                  pcMethodName as character):

        super (pcErrorString, piMessageNumber).

        this-object:MethodName = pcMethodName .

    end constructor.

    /**
     * Purpose: Constructor of the MethodInvokationException class
     * Notes:
     * @param pcErrorString The error message associated with this MethodInvokationException object
     * @param pcMethodName The method name associated with this exception
     */
    constructor public MethodInvokationException (pcErrorString as character,
                                                  pcMethodName as character):

        super (pcErrorString).

        this-object:MethodName = pcMethodName .

    end constructor.

    /**
     * Purpose: Constructor of the MethodInvokationException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this MethodInvokationException object
     * @param pcMethodName The method name associated with this exception
     */
    constructor public MethodInvokationException (poInnerException as Error,
                                                  pcErrorString as character,
                                                  piMessageNumber as integer,
                                                  pcMethodName as character):

        super (poInnerException, pcErrorString, piMessageNumber).

        this-object:MethodName = pcMethodName .

    end constructor.

    /**
     * Purpose: Constructor of the MethodInvokationException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this MethodInvokationException object
     * @param pcMethodName The method name associated with this exception
     */
    constructor public MethodInvokationException (poInnerException as Error,
                                                  pcErrorString as character,
                                                  pcMethodName as character):

        super (poInnerException, pcErrorString).

        this-object:MethodName = pcMethodName .

    end constructor.

end class.
