/**********************************************************************
 * Copyright (C) 2006-2019 by Consultingwerk Ltd. ("CW") -            *
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
    File        : FactoryMissingConstructorException
    Purpose     : Exception raised when the Factory:CreateInstance method
                  does not find a matching construtor
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 31.03.2019 22:09:45
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW .

{Consultingwerk/products.i}

USING Consultingwerk.*                          FROM PROPATH .
USING Consultingwerk.Exceptions.*               FROM PROPATH .
USING Consultingwerk.Framework.Exceptions.*     FROM PROPATH .
USING Progress.Lang.*                           FROM PROPATH .

CLASS Consultingwerk.Framework.Exceptions.FactoryMissingConstructorException
    INHERITS Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Constructor of the FactoryMissingConstructorException class
     * Notes:
     */
    CONSTRUCTOR PUBLIC FactoryMissingConstructorException ():

        SUPER ().

    END CONSTRUCTOR.

    /**
     * Purpose: Constructor of the FactoryMissingConstructorException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    CONSTRUCTOR PUBLIC FactoryMissingConstructorException (pcErrorString AS CHARACTER,
                                                           piMessageNumber AS INTEGER):

        SUPER (pcErrorString, piMessageNumber).

    END CONSTRUCTOR.

    /**
     * Purpose: Constructor of the FactoryMissingConstructorException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     */
    CONSTRUCTOR PUBLIC FactoryMissingConstructorException (pcErrorString AS CHARACTER):

        SUPER (pcErrorString).

    END CONSTRUCTOR.

    /**
     * Purpose: Constructor of the FactoryMissingConstructorException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    CONSTRUCTOR PUBLIC FactoryMissingConstructorException (poInnerException AS Error):

        SUPER (poInnerException).

    END CONSTRUCTOR.

    /**
     * Purpose: Constructor of the FactoryMissingConstructorException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    CONSTRUCTOR PUBLIC FactoryMissingConstructorException (poInnerException AS Error,
                                                           pcErrorString AS CHARACTER,
                                                           piMessageNumber AS INTEGER):

        SUPER (poInnerException, pcErrorString, piMessageNumber).

    END CONSTRUCTOR.

    /**
     * Purpose: Constructor of the FactoryMissingConstructorException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     */
    CONSTRUCTOR PUBLIC FactoryMissingConstructorException (poInnerException AS Error,
                                                           pcErrorString AS CHARACTER):

        SUPER (poInnerException, pcErrorString).

    END CONSTRUCTOR.

END CLASS.
