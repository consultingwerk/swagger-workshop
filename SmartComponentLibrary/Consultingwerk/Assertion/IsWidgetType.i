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
    File        : IsWidgetType.i
    Purpose     : Tests if the provided widget handle is of the given type

    Syntax      :

    Description : Specific variant of WidgetAssert:WidgetType

    Author(s)   :
    Created     : Fri Aug 19 16:37:02 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Main Block  *************************** */

    /**
     * Purpose: Validates the type of the given widget
     * Notes:
     * Throws:  Consultingwerk.Exceptions.InvalidTypeException or InvalidHandleException
     * @param phHandle The (WIDGET-)HANDLE to validate
     */
    method public static void Is{1} (phHandle as handle):

        {Consultingwerk/Assertion/HandleAssert/WidgetType.i phHandle Consultingwerk.WidgetTypeEnum:{1}}

    end method.
