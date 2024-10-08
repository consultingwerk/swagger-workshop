/**********************************************************************
 * Copyright (C) 2006-2013 by Consultingwerk Ltd. ("CW") -            *
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
    File        : Dictionary
    Purpose     : A Dictionary class for Progress.Lang.Object instances
                  with a CHARACTER value as the Key
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Dec 27 15:01:32 CET 2009
    Notes       :
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.

{ Consultingwerk/products.i }

USING Consultingwerk.Exceptions.*           FROM PROPATH .
USING Consultingwerk.Framework.Base.*       FROM PROPATH .
USING Consultingwerk.Framework.Enum.*       FROM PROPATH .
USING Consultingwerk.Framework.Exceptions.* FROM PROPATH .
USING Progress.Lang.*                       FROM PROPATH .

CLASS Consultingwerk.Framework.Base.Dictionary
    INHERITS GenericDictionary:

    {Consultingwerk/Framework/Base/GenericDictionary.i Progress.Lang.Object}

END CLASS.
