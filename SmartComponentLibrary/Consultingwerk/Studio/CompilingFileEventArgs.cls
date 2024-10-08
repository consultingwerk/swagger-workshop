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
    File        : CompilingFileEventArgs
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Aug 27 09:05:32 CEST 2021
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Consultingwerk.* FROM PROPATH.
USING Progress.Lang.*  FROM PROPATH .

{Consultingwerk/products.i}

CLASS Consultingwerk.Studio.CompilingFileEventArgs
    INHERITS CancelableEventArgs:

    /**
     * Purpose: Returns the file name
     * Notes:
     */
    DEFINE PUBLIC PROPERTY FileName AS CHARACTER NO-UNDO
    GET.
    PRIVATE SET.

    /**
     * Purpose: Constructor for the CompilingFileEventArgs event
     * Notes:
     * @param pcFileName The name of the file that is compiled
     */
    CONSTRUCTOR {&PACKAGE-PROTECTED} CompilingFileEventArgs (pcFileName AS CHARACTER):

        ASSIGN THIS-OBJECT:FileName = pcFileName .

    END CONSTRUCTOR.

END CLASS.
