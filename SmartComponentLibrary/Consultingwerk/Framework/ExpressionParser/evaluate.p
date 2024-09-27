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
    File        : evaluate.p
    Purpose     : Procedure to evaluate ABL expressions using DYNAMIC-FUNCTION
                  call with the expression passed as an input parameter
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Apr 21 12:28:23 CEST 2024
    Notes       : How to evaluate a math formula stored in a character variable?
                  https://community.progress.com/s/article/P39990
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

define variable cResult   as char        no-undo.
define variable daResult  as date        no-undo.
define variable dtResult  as datetime    no-undo.
define variable dtzResult as datetime-tz no-undo.
define variable deResult  as decimal     no-undo.
define variable iResult   as integer     no-undo.
define variable lResult   as logical     no-undo.

define temp-table tt no-undo /*dummy TEMP-TABLE*/
    field f1 as integer.

/* dummy QUERY required:
    -- to call the DYNAMIC-FUNCTION
    -- with the expression passed as an INPUT parameter to evaluate*/
define query q for tt. /* dummy QUERY */

function GetCharacter returns logical (pcValue as char):
     cResult = pcValue.
     return true.
end function.  /* GetChar*/

function GetDate returns logical (pdValue as date):
    daResult = pdValue.
    return true.
end function.  /* GetDate*/

function GetDateTime returns logical (pdtValue as datetime):
    dtResult = pdtValue.
    return true.
end function.  /* GetDateTime*/

function GetDateTimeTz returns logical (pdtzValue as datetime-tz):
    dtzResult = pdtzValue.
    return true.
end function.  /* GetDateTimeTz*/

function GetDecimal returns logical (pdeValue as decimal):
    deResult = pdeValue.
    return true.
end function.  /* GetDecimal*/

function GetInteger returns logical (piValue as integer):
    iResult = piValue.
    return true.
end function.  /* GetDecimal*/

function GetLogical returns logical (plValue as logical):
    lResult = plValue.
    return true.
end function. /* GetLogical */

procedure EvaluateCharacterExpression:
    define input  parameter pcExpression as character no-undo .
    define output parameter pcResult     as character no-undo .

    query q:query-prepare(substitute("for each tt where dynamic-function ('GetCharacter', &1) = true":u,
                                     pcExpression)).
    query q:query-open().
    query q:query-close.

    assign pcResult = cResult.

end procedure.

procedure EvaluateDateExpression:
    define input  parameter pcExpression as character no-undo .
    define output parameter pdResult     as date      no-undo .

    query q:query-prepare(substitute("for each tt where dynamic-function ('GetDate', &1) = true":u,
                                     pcExpression)).
    query q:query-open().
    query q:query-close.

    assign pdResult = daResult.

end procedure.

procedure EvaluateDateTimeExpression:
    define input  parameter pcExpression as character no-undo .
    define output parameter pdtResult    as datetime  no-undo .

    query q:query-prepare(substitute("for each tt where dynamic-function ('GetDateTime', &1) = true":u,
                                     pcExpression)).
    query q:query-open().
    query q:query-close.

    assign pdtResult = dtResult.

end procedure.

procedure EvaluateDateTimeTzExpression:
    define input  parameter pcExpression as character no-undo .
    define output parameter pdtzResult   as datetime-tz no-undo .

    query q:query-prepare(substitute("for each tt where dynamic-function ('GetDateTimeTz', &1) = true":u,
                                     pcExpression)).
    query q:query-open().
    query q:query-close.

    assign pdtzResult = dtzResult.

end procedure.

procedure EvaluateDecimalExpression:
    define input  parameter pcExpression as character no-undo .
    define output parameter pdeResult    as decimal   no-undo .

    query q:query-prepare(substitute("for each tt where dynamic-function ('GetDecimal', &1) = true":u,
                                     pcExpression)).
    query q:query-open().
    query q:query-close.

    assign pdeResult = deResult.

end procedure.

procedure EvaluateIntegerExpression:
    define input  parameter pcExpression as character no-undo .
    define output parameter piResult     as integer   no-undo .

    query q:query-prepare(substitute("for each tt where dynamic-function ('GetInteger', &1) = true":u,
                                     pcExpression)).
    query q:query-open().
    query q:query-close.

    assign piResult = iResult.

end procedure.

procedure EvaluateLogicalExpression:
    define input  parameter pcExpression as character no-undo .
    define output parameter plResult     as logical   no-undo .

    query q:query-prepare(substitute("for each tt where dynamic-function ('GetLogical', &1) = true":u,
                                     pcExpression)).
    query q:query-open().
    query q:query-close.

    assign plResult = lResult.

end procedure.
