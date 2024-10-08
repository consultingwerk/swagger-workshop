/**********************************************************************
 * Copyright (C) 2006-2013 by Consultingwerk Ltd. ("CW") -            *
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
    File        : user-env.i
    Purpose     : Definition of the user_env variable required by the
                  data dictionary tools

    Syntax      :

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Jul 08 00:13:51 CEST 2013
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

/* Mike Fechner, Consultingwerk Ltd. 20.02.2013
   user_env changed extent in 11.0 */
&IF PROVERSION BEGINS "10":U &THEN
&scoped-define user_env_extent 35
&ELSEIF PROVERSION BEGINS "11.0":U &THEN
&scoped-define user_env_extent 41
&ELSEIF PROVERSION BEGINS "11.1":U &THEN
&scoped-define user_env_extent 41
&ELSEIF PROVERSION BEGINS "11.2":U &THEN
&scoped-define user_env_extent 41
&ELSEIF PROVERSION BEGINS "11.3":U OR PROVERSION BEGINS "11.4":U OR PROVERSION BEGINS "11.5":U OR PROVERSION BEGINS "11.6":U &THEN
&scoped-define user_env_extent 42
&ELSE
&scoped-define user_env_extent 43
&ENDIF

DEFINE {1} SHARED VARIABLE user_env    AS CHARACTER NO-UNDO EXTENT {&user_env_extent} .

/* For Online schema support */
DEFINE {1} SHARED STREAM pre-str.
DEFINE {1} SHARED STREAM trig-str.
DEFINE {1} SHARED STREAM post-str.
DEFINE {1} SHARED STREAM offln-str.
