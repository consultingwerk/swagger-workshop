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
    File        : eBlockInfo.i
    Purpose     :

    Syntax      :

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : 26.06.2011 21:29:58
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE {&ACCESS} TEMP-TABLE eBlockInfo NO-UNDO {&REFERENCE-ONLY} BEFORE-TABLE eBlockInfoBefore
    FIELD Sequence AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL "0":U LABEL "Sequence"{&TRAN}
    FIELD FileName AS CHARACTER FORMAT "X(20)":U LABEL "File Name"{&TRAN}
    FIELD LineNum AS INTEGER FORMAT ">>>,>>9":U INITIAL "0":U LABEL "Line Number"{&TRAN}
    FIELD BlockType AS CHARACTER FORMAT "X(12)":U LABEL "Block Type"{&TRAN}
    FIELD TransactionBlock AS LOGICAL FORMAT "yes/no":U INITIAL "no":U LABEL "Transaction"{&TRAN}
    FIELD BlockLabel AS CHARACTER FORMAT "X(40)":U LABEL "Block Label"{&TRAN}

    INDEX Sequence AS UNIQUE PRIMARY Sequence ASCENDING

    .
