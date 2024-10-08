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
    File        : ListMethod
    Purpose     : Generic List of Methods (OpenEdge 11.6 reflection)
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Jan 16 11:57:14 CET 2016
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Framework.Base.* from propath .
using Consultingwerk.*                from propath .
using Progress.Lang.*                 from propath .

{Consultingwerk/products.i}

class Consultingwerk.ListMethod
    inherits GenericList
    serializable:

&if defined (AblReflection) ne 0 &then

    {Consultingwerk/Framework/Base/GenericList.i Progress.Reflect.Method}

&endif

end class.
