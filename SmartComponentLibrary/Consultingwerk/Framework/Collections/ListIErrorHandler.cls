/**********************************************************************
 * Copyright (C) 2006-2022 by Consultingwerk Ltd. ("CW") -            *
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
    File        : ListIErrorHandler
    Purpose     : List of IErrorHandler implementations
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Mar 31 20:39:40 CEST 2011
    Notes       :
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.

{Consultingwerk/products.i}

USING Consultingwerk.Framework.*      FROM PROPATH .
USING Consultingwerk.Framework.Base.* FROM PROPATH .
USING Progress.Lang.*                 FROM PROPATH .

CLASS Consultingwerk.Framework.Collections.ListIErrorHandler
    INHERITS GenericList
    SERIALIZABLE:

    { Consultingwerk/Framework/Base/GenericList.i IErrorHandler }

END CLASS.
