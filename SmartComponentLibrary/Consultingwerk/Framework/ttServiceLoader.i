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
    File        : ttServiceLoader.i
    Purpose     : Temp-Table for the ServiceLoader class

    Syntax      :

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Nov 07 23:29:46 CET 2011
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE {&ACCESS} TEMP-TABLE ttServiceLoader{&SUFFIX} NO-UNDO {&REFERENCE-ONLY}
    FIELD Order AS INTEGER
    FIELD ServiceTypeName   AS CHARACTER
    FIELD ServiceClassName  AS CHARACTER
    FIELD Disabled          AS LOGICAL INITIAL FALSE
    FIELD RequiredDatabases AS CHARACTER
    FIELD LazyLoading       AS LOGICAL INITIAL FALSE
    INDEX Order IS PRIMARY Order
    INDEX ServiceTypeName ServiceTypeName
    INDEX LazyLoading LazyLoading .
