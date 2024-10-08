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
    File        : InvalidParameterValueException
    Purpose     : An error object thrown to signal invalid parameter values
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

class Consultingwerk.Exceptions.InvalidParameterValueException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the name of the invalid parameter
     * Notes:
     */
    define public property ParameterName as character no-undo
    get.
    private set.

    /**
     * Purpose: Returns the value of the invalid parameter
     * Notes:
     */
    define public property ParameterValue as character no-undo
    get.
    private set.

    /**
        Purpose: Returns the class name that caused the InvalidParameterException
        Notes:
     */
    define public property ClassName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the InvalidParameterException class
     * Notes:
     */
    constructor public InvalidParameterValueException ():

        super ("The parameter value is invalid."{&TRAN}, 0).

    end constructor.

    /**
     * Purpose: Constructor of the InvalidParameterException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public InvalidParameterValueException (poInnerException as Error):

        super (poInnerException,
               "The parameter value is invalid."{&TRAN},
               0).

    end constructor.

    /**
     * Purpose: Constructor of the InvalidParameterException class
     * Notes:
     * @param pcParameterName The name of the invalid parameter
     * @param pcValue The invalid parameter value
     * @param pcClassName The name of the class that caused the InvalidParameterException
     */
    constructor public InvalidParameterValueException (pcParameterName as character,
                                                       pcValue         as character,
                                                       pcClassName     as character ):

        super (substitute("The parameter value '&2' for &1 in &3 is invalid."{&TRAN},
                          pcParameterName, pcValue, pcClassName), 0).

        assign ParameterName  = pcParameterName
               ParameterValue = pcValue
               ClassName      = pcClassName .

    end constructor.

    /**
     * Purpose: Constructor of the InvalidParameterException class
     * Notes:
     * @param pcParameterName The name of the invalid parameter
     * @param pcClassName The name of the class that caused the InvalidParameterException
     */
    constructor public InvalidParameterValueException (pcParameterName as character,
                                                       pcClassName     as character):

        super (substitute("The parameter value for &1 in &2 is invalid."{&TRAN},
                          pcParameterName, pcClassName), 0).

        assign ParameterName  = pcParameterName
               ClassName      = pcClassName .

    end constructor.

    /**
     * Purpose: Constructor of the InvalidParameterException class
     * Notes:
     * @param pcParameterName The name of the invalid parameter
     * @param pcClassName The name of the class that caused the InvalidParameterException
     * @param pcErrorMessage The error message to add to this exception (AddMessage)
     * @param piMessageNumber The error message number to add to this exception (AddMessage)
     */
    constructor public InvalidParameterValueException (pcParameterName as character,
                                                       pcClassName     as character,
                                                       pcErrorMessage  as character,
                                                       piMessageNumber as integer):

        super (substitute("The parameter value for &1 in &2 is invalid."{&TRAN},
                          pcParameterName, pcClassName), 0).

        assign ParameterName  = pcParameterName
               ClassName      = pcClassName .

        this-object:AddMessage (pcErrorMessage, piMessageNumber) .

    end constructor.

    /**
     * Purpose: Constructor of the InvalidParameterException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcParameterName The name of the invalid parameter
     * @param pcValue The invalid parameter value
     * @param pcClassName The name of the class that caused the InvalidParameterException
     */
    constructor public InvalidParameterValueException (poInnerException as Error,
                                                       pcParameterName  as character,
                                                       pcValue          as character,
                                                       pcClassName      as character ):

        super (poInnerException,
               substitute("The parameter value '&2' for &1 in &3 is invalid."{&TRAN},
                          pcParameterName, pcValue, pcClassName), 0).

        assign ParameterName  = pcParameterName
               ParameterValue = pcValue
               ClassName      = pcClassName .

    end constructor.

end class.
