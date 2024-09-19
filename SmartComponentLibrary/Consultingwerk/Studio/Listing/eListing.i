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
    File        : eListing.i
    Purpose     :

    Syntax      :

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 26.06.2011 21:29:58
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE {&ACCESS} TEMP-TABLE eListing NO-UNDO {&REFERENCE-ONLY} BEFORE-TABLE eListingBefore
    FIELD Sequence AS INTEGER FORMAT ">,>>>>>,>>9":U LABEL "Sequence"{&TRAN}
    FIELD IncludeLevel AS INTEGER FORMAT ">>>,>>9":U INITIAL "0":U LABEL "Include"{&TRAN}
    FIELD LineNumber AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL "0":U LABEL "Line Number"{&TRAN}
    FIELD BlockLevel AS INTEGER FORMAT ">>>,>>9":U INITIAL "0":U LABEL "Block Level"{&TRAN}
    FIELD SourceCode AS CHARACTER FORMAT "X(60)":U LABEL "Source Code"{&TRAN}

    INDEX Sequence AS UNIQUE PRIMARY Sequence ASCENDING

    .
