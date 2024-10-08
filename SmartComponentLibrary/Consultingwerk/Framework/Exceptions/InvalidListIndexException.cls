/**********************************************************************
 * Copyright (C) 2006-2018 by Consultingwerk Ltd. ("CW") -            *
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
    File        : InvalidListIndexException
    Purpose     : Raised when an invalid index is provided to a method of the
                  List implementations
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 28.07.2018 23:28:35
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW .

{Consultingwerk/products.i}

USING Consultingwerk.*                          FROM PROPATH .
USING Consultingwerk.Exceptions.*               FROM PROPATH .
USING Consultingwerk.Framework.Exceptions.*     FROM PROPATH .
USING Progress.Lang.*                           FROM PROPATH .

CLASS Consultingwerk.Framework.Exceptions.InvalidListIndexException
    INHERITS Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Constructor of the InvalidListIndexException class
     * Notes:
     */
    CONSTRUCTOR PUBLIC InvalidListIndexException ():

        SUPER ().

    END CONSTRUCTOR.

    /**
     * Purpose: Constructor of the InvalidListIndexException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    CONSTRUCTOR PUBLIC InvalidListIndexException (pcErrorString AS CHARACTER,
                                                  piMessageNumber AS INTEGER):

        SUPER (pcErrorString, piMessageNumber).

    END CONSTRUCTOR.

    /**
     * Purpose: Constructor of the InvalidListIndexException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     */
    CONSTRUCTOR PUBLIC InvalidListIndexException (pcErrorString AS CHARACTER):

        SUPER (pcErrorString).

    END CONSTRUCTOR.

    /**
     * Purpose: Constructor of the InvalidListIndexException class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    CONSTRUCTOR PUBLIC InvalidListIndexException (poInnerException AS Error):

        SUPER (poInnerException).

    END CONSTRUCTOR.

    /**
     * Purpose: Constructor of the InvalidListIndexException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    CONSTRUCTOR PUBLIC InvalidListIndexException (poInnerException AS Error,
                                                  pcErrorString AS CHARACTER,
                                                  piMessageNumber AS INTEGER):

        SUPER (poInnerException, pcErrorString, piMessageNumber).

    END CONSTRUCTOR.

    /**
     * Purpose: Constructor of the InvalidListIndexException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     */
    CONSTRUCTOR PUBLIC InvalidListIndexException (poInnerException AS Error,
                                                  pcErrorString AS CHARACTER):

        SUPER (poInnerException, pcErrorString).

    END CONSTRUCTOR.

END CLASS.
