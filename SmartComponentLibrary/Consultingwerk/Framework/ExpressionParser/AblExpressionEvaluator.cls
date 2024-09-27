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
    File        : AblExpressionEvaluator
    Purpose     : Class wrapper to evaluate.p
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Apr 21 12:28:23 CEST 2024
    Notes       : How to evaluate a math formula stored in a character variable?
                  https://community.progress.com/s/article/P39990
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

class Consultingwerk.Framework.ExpressionParser.AblExpressionEvaluator:

    define variable hProcedure as handle no-undo.

    /**
     * Purpose: Constructor of the AblExpressionEvaluator class
     * Notes:   Creates a new instance of the class
     */
    constructor public AblExpressionEvaluator():

        run Consultingwerk/Framework/ExpressionParser/evaluate.p persistent set hProcedure .

    end constructor.

    /**
     * Purpose: Evaluates an ABL expression with a character result
     * Notes:
     * @param pcExpression The ABL expression to evaluate
     * @return The expression result
     */
    method public character EvaluateCharacterExpression (pcExpression as character):

        define variable cResult as character no-undo.

        run EvaluateCharacterExpression in hProcedure (pcExpression, output cResult).

        return cResult.

    end method.

    /**
     * Purpose: Evaluates an ABL expression with a date result
     * Notes:
     * @param pcExpression The ABL expression to evaluate
     * @return The expression result
     */
    method public date EvaluateDateExpression (pcExpression as character):

        define variable dResult as date no-undo.

        run EvaluateCharacterExpression in hProcedure (pcExpression, output dResult).

        return dResult.

    end method.

    /**
     * Purpose: Evaluates an ABL expression with a datetime result
     * Notes:
     * @param pcExpression The ABL expression to evaluate
     * @return The expression result
     */
    method public datetime EvaluateDateTimeExpression (pcExpression as character):

        define variable dtResult as datetime no-undo.

        run EvaluateCharacterExpression in hProcedure (pcExpression, output dtResult).

        return dtResult.

    end method.

    /**
     * Purpose: Evaluates an ABL expression with a datetime-tz result
     * Notes:
     * @param pcExpression The ABL expression to evaluate
     * @return The expression result
     */
    method public datetime-tz EvaluateDateTimeTzExpression (pcExpression as character):

        define variable dtzResult as datetime-tz no-undo.

        run EvaluateCharacterExpression in hProcedure (pcExpression, output dtzResult).

        return dtzResult.

    end method.

    /**
     * Purpose: Evaluates an ABL expression with a decimal result
     * Notes:
     * @param pcExpression The ABL expression to evaluate
     * @return The expression result
     */
    method public decimal EvaluateDecimalExpression (pcExpression as character):

        define variable deResult as decimal no-undo.

        run EvaluateDecimalExpression in hProcedure (pcExpression, output deResult).

        return deResult.

    end method.

    /**
     * Purpose: Evaluates an ABL expression with an integer result
     * Notes:
     * @param pcExpression The ABL expression to evaluate
     * @return The expression result
     */
    method public integer EvaluateIntegerExpression (pcExpression as character):

        define variable iResult as integer no-undo.

        run EvaluateIntegerExpression in hProcedure (pcExpression, output iResult).

        return iResult.

    end method.

    /**
     * Purpose: Evaluates an ABL expression with a logical result
     * Notes:
     * @param pcExpression The ABL expression to evaluate
     * @return The expression result
     */
    method public logical EvaluateLogicalExpression (pcExpression as character):

        define variable lResult as logical no-undo.

        run EvaluateLogicalExpression in hProcedure (pcExpression, output lResult).

        return lResult.

    end method.

    /**
     * Purpose: Destructor for the AblExpressionEvaluator class
     * Notes:
     */
    destructor public AblExpressionEvaluator ():

        if valid-handle (hProcedure) then
            delete object hProcedure.

    end destructor.

end class.
