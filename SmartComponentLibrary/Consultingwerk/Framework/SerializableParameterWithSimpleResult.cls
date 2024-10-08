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
    File        : SerializableParameterWithSimpleResult
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 15.10.2018 21:01:59
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

{Consultingwerk/products.i}

USING Consultingwerk.*                          FROM PROPATH .
USING Consultingwerk.Framework.*                FROM PROPATH .
USING Progress.Lang.*                           FROM PROPATH .

CLASS Consultingwerk.Framework.SerializableParameterWithSimpleResult
    INHERITS JsonSerializable
    {&SERIALIZABLE}:

    {Consultingwerk/JsonSerializableProperty.i CharacterResult CHARACTER}
    {Consultingwerk/JsonSerializableProperty.i Parameter Consultingwerk.JsonSerializable}

    /**
     * Purpose: Constructor for the SerializableParameterWithSimpleResult class
     * Notes:
     */
    CONSTRUCTOR PUBLIC SerializableParameterWithSimpleResult ():
        SUPER ().
    END CONSTRUCTOR.

    /**
     * Purpose: Constructor for the SerializableParameterWithSimpleResult class
     * Notes:
     * @param poParameter The value for the Parameter property
     */
    CONSTRUCTOR PUBLIC SerializableParameterWithSimpleResult (poParameter AS JsonSerializable):
        THIS-OBJECT ().

        ASSIGN THIS-OBJECT:Parameter = poParameter
                .

    END CONSTRUCTOR.

END CLASS.
