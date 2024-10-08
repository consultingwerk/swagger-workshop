/**********************************************************************
 * Copyright (C) 2006-2021 by Consultingwerk Ltd. ("CW") -            *
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
    File        : IStopConditionHandler
    Purpose     : Defines a methods required for handling messages,
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Mar 05 07:20:43 CEST 2021
    Notes       : See Consultingwerk.Util.ErrorHelper,
                  Consultingwerk.FrameworkSettings.ListIErrorHandler
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

{Consultingwerk/products.i}

INTERFACE Consultingwerk.Framework.IStopConditionHandler:

&IF "{&CATCH-STOP}" NE "" &THEN
    /**
     * Purpose: Handles an Stop Condition object
     * Notes:   Logical return value indicates if the error has been completely
     *          Handled, that is when this method returns TRUE, the ErrorHelper
     *          will not display the stop condition anymore, return false when the
     *          ErrorHelper should still display the error message dialog.
     * @param poStopCondition The reference to the Error to handle
     * @return Logical value indicating if the error has been completely handled
     */
    METHOD PUBLIC LOGICAL HandleStopCondition (poStopCondition AS Progress.Lang.Stop).
&ENDIF

END INTERFACE.
