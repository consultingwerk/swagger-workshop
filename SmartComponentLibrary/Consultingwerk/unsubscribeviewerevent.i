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
    File        : unsubscribeviewerevent.i
    Purpose     : Unsubscribes a viewer controls events from event handlers
                  in the Viewer Logic Object
                  This include only supports unsubscribing from events based
                  on the data-bound field name. This include file is typically
                  not suited to unsubscribe from events of Buttons


    Syntax      : unsubscribeviewerevent.i
                    BindingPropertyName
                    EventName
                    EventHandlerMethodName

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Sep 26 10:07:38 CEST 2013
    Notes       : The BindingPropertyName can be retrieved from the
                  Consultingwerk.Util.BindingSourceHelper:BindingColumnName
                  method
  ----------------------------------------------------------------------*/

        {Consultingwerk/foreach.i System.Windows.Forms.Control oControl{1}{2} in "this-object:GetBoundControls(""{1}"":U)" }
            oControl{1}{2}:{2}:Unsubscribe ({3}) .
        end.
