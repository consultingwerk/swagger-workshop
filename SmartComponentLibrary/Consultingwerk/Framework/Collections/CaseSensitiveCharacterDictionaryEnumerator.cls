/**********************************************************************
 * Copyright (C) 2006-2017 by Consultingwerk Ltd. ("CW") -            *
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
    File        : CharacterDictionaryCaseSensitiveEnumerator
    Purpose     : Enumerator for the ABL Primitive Dictionary Classes
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Jan 25 23:32:21 CET 2012
    Notes       : Does not implement IEnumerator as the Current property
                  cannot be of any common type
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.

USING Consultingwerk.Framework.Base.*        FROM PROPATH .
USING Consultingwerk.Framework.Collections.* FROM PROPATH .
USING Progress.Lang.*                        FROM PROPATH .

CLASS Consultingwerk.Framework.Collections.CaseSensitiveCharacterDictionaryEnumerator:

    {Consultingwerk/Framework/Base/CaseSensitiveAblPrimitiveDictionaryEnumerator.i CaseSensitiveCharacter CHARACTER}

END CLASS.
