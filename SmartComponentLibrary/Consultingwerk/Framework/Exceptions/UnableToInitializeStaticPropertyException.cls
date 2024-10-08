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
    File        : UnableToInitializeStaticPropertyException
    Purpose     : Exception thrown when the AppServerStartupManager cannot
                  assign a static property during initialization
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 16.11.2019 09:47:39
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW .

{Consultingwerk/products.i}

USING Consultingwerk.*                          FROM PROPATH .
USING Consultingwerk.Exceptions.*               FROM PROPATH .
USING Consultingwerk.Framework.Exceptions.*     FROM PROPATH .
USING Progress.Lang.*                           FROM PROPATH .

CLASS Consultingwerk.Framework.Exceptions.UnableToInitializeStaticPropertyException
    INHERITS Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the name of the class
     * Notes:
     */
    DEFINE PUBLIC PROPERTY ClassName AS CHARACTER NO-UNDO
    GET.
    PRIVATE SET.

    /**
     * Purpose: Returns the name of the property
     * Notes:
     */
    DEFINE PUBLIC PROPERTY PropertyName AS CHARACTER NO-UNDO
    GET.
    PRIVATE SET.

    /**
     * Purpose: Constructor of the UnableToInitializeStaticPropertyException class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     * @param pcClassName The name of the class that raised the issue
     * @param pcPropertyName The name of the property that raised the issue
     */
    CONSTRUCTOR PUBLIC UnableToInitializeStaticPropertyException (poInnerException AS Error,
                                                                  pcErrorString AS CHARACTER,
                                                                  piMessageNumber AS INTEGER,
                                                                  pcClassName AS CHARACTER,
                                                                  pcPropertyName AS CHARACTER):

        SUPER (poInnerException, pcErrorString, piMessageNumber).

        ASSIGN THIS-OBJECT:ClassName    = pcClassName
               THIS-OBJECT:PropertyName = pcPropertyName .

        IF VALID-OBJECT (poInnerException) THEN
            THIS-OBJECT:AddMessagesFrom (poInnerException) .

    END CONSTRUCTOR.

END CLASS.
