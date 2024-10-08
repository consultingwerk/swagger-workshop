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
    File        : CannotDeleteServiceException
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Sep 09 05:16:30 CEST 2022
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Exceptions.* from propath.
using Progress.Lang.*             from propath.

{Consultingwerk/products.i}

class Consultingwerk.Util.Exceptions.CannotDeleteServiceException
    inherits Exception
    serializable:

    /**
     * Purpose: Constructor for the CannotDeleteServiceException class
     * Notes:
     * @param poService as Progress.Lang.Object
     */
    constructor public CannotDeleteServiceException (poService as Progress.Lang.Object):

        this-object:AddMessage (substitute ("Cannnot delete service instance &1"{&TRAN}, poService:ToString()),
                                0) .

    end constructor.

end class.
