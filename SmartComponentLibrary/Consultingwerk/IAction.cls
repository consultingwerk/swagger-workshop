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
    File        : IAction
    Purpose     : Interface for classes with an Execute() method
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Mar 12 13:41:19 CET 2023
    Notes       : Used by the Consultingwerk.Windows.Sequencer
  ----------------------------------------------------------------------*/

@lowercase.

using Progress.Lang.*.

interface Consultingwerk.IAction:

    /**
     * Purpose: Performs the action
     * Notes:
     */
    method public void Execute ().

end interface.
