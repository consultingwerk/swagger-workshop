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
    File        : ParameterNullValueException
    Purpose     : An error object thrown to signal invalid parameter null values
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Jan 22 15:30:52 CET 2012
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

using Progress.Lang.*.
using Consultingwerk.Exceptions.InvalidParameterValueException.

{Consultingwerk/products.i}

class Consultingwerk.Exceptions.ParameterNullValueException
    inherits InvalidParameterValueException
    {&SERIALIZABLE}:

    /**
     * Purpose: Constructor of the ParameterNullValueException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcParameterName The name of the invalid parameter
     * @param pcClassName The name of the class that caused the InvalidParameterException
     */
    constructor public ParameterNullValueException (poInnerException as Progress.Lang.ProError,
                                                    pcParameterName as character,
                                                    pcClassName as character ):
        super (poInnerException,
               pcParameterName,
               ?,
               pcClassName).

    end constructor.

    /**
     * Purpose: Constructor of the ParameterNullValueException class
     * Notes:
     * @param pcParameterName The name of the invalid parameter
     * @param pcClassName The name of the class that caused the InvalidParameterException
     */
    constructor public ParameterNullValueException (pcParameterName as character,
                                                    pcClassName as character ):
        super (pcParameterName,
               ?,
               pcClassName).

    end constructor.

end class.
