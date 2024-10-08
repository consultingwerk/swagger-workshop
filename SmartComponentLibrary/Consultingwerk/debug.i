&if 1=0 &then
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
    File        : debug.i
    Purpose     : Turns on or of compile time option for including 
                  debug only code

    Syntax      : Include file

    Description : 

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Feb 12 17:3509:47 CET 2011
    Notes       : 
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */
&endif   

&if 0=1 &then
&global-define DEBUG
&global-define DebugCustomTypeDescriptor
&global-define DebugPropertyAttributes System.ComponentModel.DefaultValueAttribute
&global-define DebugLogFile "../debug.log"
&endif