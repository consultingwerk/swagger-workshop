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
    File        : get-message.i
    Purpose     : Returns a translated message

    Syntax      : {Consultingwerk/get-message.i SFR 123 cParam1 cParam2}

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Apr 05 22:27:45 CET 20
  ----------------------------------------------------------------------*/

(if valid-object ({Consultingwerk/get-service.i Consultingwerk.SmartFramework.IMessageProvider})
then
    {Consultingwerk/get-service.i Consultingwerk.SmartFramework.IMessageProvider}:GetMessageText ("{1}":U, {2}
    &if "{3}" <> "" &then
    , {3}
    &if "{4}" <> "" &then
    , {4}
    &if "{5}" <> "" &then
    , {5}
    &if "{6}" <> "" &then
    , {6}
    &if "{7}" <> "" &then
    , {7}
    &if "{8}" <> "" &then
    , {8}
    &if "{9}" <> "" &then
    , {9}
    &endif
    &endif
    &endif
    &endif
    &endif
    &endif
    &endif
    )
else
    substitute ("Error message &1:&2":U, "{1}":U, {2}))
