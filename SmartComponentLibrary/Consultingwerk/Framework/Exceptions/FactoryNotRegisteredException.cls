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
    File        : FactoryNotRegisteredException
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 24.03.2018 12:37:40
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW .

{Consultingwerk/products.i}

USING Consultingwerk.*                          FROM PROPATH .
USING Consultingwerk.Exceptions.*               FROM PROPATH .
USING Consultingwerk.Framework.Exceptions.*     FROM PROPATH .
USING Progress.Lang.*                           FROM PROPATH .

CLASS Consultingwerk.Framework.Exceptions.FactoryNotRegisteredException
    INHERITS Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Gets and sets the Factory Alias associated with this exception
     * Notes:
     */
    DEFINE PUBLIC PROPERTY FactoryAlias AS CHARACTER NO-UNDO
    GET.
    SET.

    /**
     * Purpose: Gets and sets the Factory Type associated with this exception
     * Notes:
     */
    DEFINE PUBLIC PROPERTY FactoryType AS CHARACTER NO-UNDO
    GET.
    SET.

    /**
     * Purpose: Constructor of the FactoryNotRegisteredException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     * @param pcFactoryType The factory type that is causing the issue
     * @param pcFactoryAlias The factory alias that is causing the issue
     */
    CONSTRUCTOR PUBLIC FactoryNotRegisteredException (pcErrorString AS CHARACTER,
                                                      piMessageNumber AS INTEGER,
                                                      pcFactoryType AS CHARACTER,
                                                      pcFactoryAlias AS CHARACTER):

        SUPER (pcErrorString, piMessageNumber).

        ASSIGN THIS-OBJECT:FactoryType  = pcFactoryType
               THIS-OBJECT:FactoryAlias = pcFactoryAlias .

    END CONSTRUCTOR.

END CLASS.
