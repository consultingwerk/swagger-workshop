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
    File        : InvalidValueException
    Purpose     : An error object thrown to signal invalid (parameter) values
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Apr 25 23:20:48 CEST 2011
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.InvalidValueException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the Description for the Value that caused this InvalidValueException
     * Notes:
     */
    define public property Description as character no-undo
    get.
    protected set.

    /**
     * Purpose: Returns the Value that caused this InvalidValueException
     * Notes:
     */
    define public property Value as character no-undo
    get.
    protected set.

    /**
     * Purpose: Constructor for the InvalidValueException class
     * Notes:
     * @param pcValue The invalid value
     */
    constructor public InvalidValueException (pcValue as character):

        super (substitute ("Invalid value ~"&1~".":U, pcValue), 0).

        this-object:Value = pcValue .

    end constructor.

    /**
     * Purpose: Constructor for the InvalidValueException class
     * Notes:
     * @param pcValue The invalid value
     * @param pcDescription The description of the invalid value
     */
    constructor public InvalidValueException (pcValue as character,
                                              pcDescription as character):

        super (substitute ("Invalid value ~"&1~" for &2.":U, pcValue, pcDescription), 0).

        this-object:Value = pcValue .
        this-object:Description = pcDescription .

    end constructor.

    /**
     * Purpose: Constructor for the InvalidValueException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcValue The invalid value
     */
    constructor public InvalidValueException (poInnerException as Error,
                                              pcValue as character):

        super (poInnerException,
               substitute ("Invalid value ~"&1~".":U, pcValue),
               0).

        this-object:Value = pcValue .

    end constructor.

    /**
     * Purpose: Constructor for the InvalidValueException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcValue The invalid value
     * @param pcDescription The description of the invalid value
     */
    constructor public InvalidValueException (poInnerException as Error,
                                              pcValue as character,
                                              pcDescription as character):

        super (poInnerException,
               substitute ("Invalid value ~"&1~" for &2.":U, pcValue, pcDescription),
               0).

        this-object:Value = pcValue .
        this-object:Description = pcDescription .

    end constructor.

end class.
