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
    File        : translate.i
    Purpose     : Provides String Translation based on an original string

    Syntax      : Static String:       {Consultingwerk/translate.i &scope="''" &string="'Question':U"}
                  Variable:            {Consultingwerk/translate.i &scope=cScope &string=cString}
                  No scope:            {Consultingwerk/translate.i &string="'Question':U"}

                  By key:              {Consultingwerk/translate.i &scope="''" &key="'xyz':U"}
                  By key with Default: {Consultingwerk/translate.i &scope="''" &key="'xyz':U" &defaulttext="'Default Text':U"}


    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Jan 11 00:33:45 CET 2013
  ----------------------------------------------------------------------*/

&if defined (string) ne 0 &then
(if not valid-object ({Consultingwerk/get-service.i Consultingwerk.SmartFramework.ITranslationProvider}) then
    {&string}
else
    {Consultingwerk/get-service.i Consultingwerk.SmartFramework.ITranslationProvider}:GetTranslationByString (
    &if defined (scope) ne 0 &then {&scope} &else "":U &endif ,
    {&string} ))
&else
(if not valid-object ({Consultingwerk/get-service.i Consultingwerk.SmartFramework.ITranslationProvider}) then
    &if defined (defaulttext) ne 0 &then {&defaulttext} &else ? &endif
else
    {Consultingwerk/get-service.i Consultingwerk.SmartFramework.ITranslationProvider}:GetTranslationByKey (
    &if defined (scope) ne 0 &then {&scope} &else "":U &endif ,
    {&key} &if defined (defaulttext) ne 0 &then , {&defaulttext} &endif ))
&endif