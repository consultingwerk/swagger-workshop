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
    File        : LogicalExpressionParser
    Purpose     : Parses a logical expression
    Syntax      :
    Description : Returns true or false for the given expression
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Jun 21 10:20:33 CEST 2014
    Notes       : Parses the logical expression and splits it into individual
                  value expressions. Supports & for AND, | for OR and ! for
                  NOT. Supports parenthesis between individual terms:
                  (A|B)&(C|D) will turn into (A OR B) AND (C OR D)
                  Parenthesis will be threated as part of an individual
                  expression when a non " ", &, |, !, (, ) character has
                  started the individual expression. So
                  (A|B())&(C(test)|D) will turn into
                  (A OR B()) AND (C(test) OR D) where A, B(), C(test) AND D
                  will be passed as value expressions to the logical value
                  provider.
                  The Logical value provider is expected to return TRUE or
                  FALSE based on the given values
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.Assertion.*                  from propath .
using Consultingwerk.Framework.ExpressionParser.* from propath .
using Consultingwerk.Util.*                       from propath .
using Progress.Lang.*                             from propath .

class Consultingwerk.Framework.ExpressionParser.LogicalExpressionParser:

    define static temp-table ttEval no-undo
        field cDummy as character .

    /**
     * Purpose: Returns the reference to the value provider used by this instance
     * Notes:
     */
    define public property LogicalValueProvider as ILogicalValueProvider no-undo
    get.
    protected set.

    /**
     * Purpose: Static Constructor for the LogicalExpressionParser class
     * Notes:   Creates single temp-table record required by expression parser
     */
    constructor static LogicalExpressionParser ():

        create ttEval .

    end constructor.

    /**
     * Purpose: Constructor for the LogicalExpressionParser class
     * Notes:
     * @param poValueProvider The ILogicalValueProvider that provides the values for the expression parser
     */
    constructor public LogicalExpressionParser (poValueProvider as ILogicalValueProvider):

        {Consultingwerk/Assertion/ObjectAssert/IsValid.i poValueProvider """poValueProvider"":U"}

        assign this-object:LogicalValueProvider = poValueProvider .

    end constructor.

    /**
     * Purpose: Evaluates a logical expression
     * Notes:   Parses logical expressions, supports the following logical operators:
     *          & AND
     *          | OR
     *          ! NOT
     *          Supports for double/single quoted expressions
     *          Supports parenthesis
     * @param pcExpression The logical expression to evaluate
     * @return The expression result
     */
    method public logical Evaluate (pcExpression as character):

        define variable cTargetExpression as character no-undo .
        define variable iPos              as integer   no-undo initial 1.
        define variable iBracket          as integer   no-undo .
        define variable iLength           as integer   no-undo .
        define variable cChar             as character no-undo .

        define variable lInExpression     as logical   no-undo initial false .
        define variable cExpression       as character no-undo .

        assign iLength = length (pcExpression, "CHARACTER":U) .

        charLoop:
        repeat on error undo, throw:
            assign cChar = substring (pcExpression, iPos, 1, "CHARACTER":U) .

            /* When we are currently not in an expression, we expect:
                SPACE   - skip
                &, |, ! - replace with AND, OR, NOT
                ( ) */
            if not lInExpression then do:
                case cChar:
                    when " ":U then do:
                        assign cTargetExpression = cTargetExpression + " ":U .

                        if iPos > iLength then
                            leave charLoop .

                        next charLoop .
                    end.
                    when "&":U then do:
                        assign cTargetExpression = cTargetExpression + " AND ":U .

                        if iPos > iLength then
                            leave charLoop .

                        next charLoop .
                    end.
                    when "|":U then do:
                        assign cTargetExpression = cTargetExpression + " OR ":U .

                        if iPos > iLength then
                            leave charLoop .

                        next charLoop .
                    end.
                    when "!":U then do:
                        assign cTargetExpression = cTargetExpression + " NOT ":U .

                        if iPos > iLength then
                            leave charLoop .

                        next charLoop .
                    end.
                    when "(":U then do:
                        assign iBracket          = StringHelper:FindClosingBracket (pcExpression, iPos)
                               cTargetExpression = cTargetExpression + "(":U .

                        if iPos > iLength then
                            leave charLoop .

                        next charLoop .
                    end.
                    when ")":U then do:
                        assign cTargetExpression = cTargetExpression + ")":U .

                        if iPos > iLength then
                            leave charLoop .

                        next charLoop .
                    end.
                    otherwise
                        if lInExpression = false then
                            assign lInExpression = true
                                   cExpression   = "":U .
                end case.
            end.

               /* We're in an expression now. add characters until the next SPACE & | ! ) */
            if cChar = " ":U or cChar = "&":U or cChar = "|":U or cChar = "!":U or cChar = ")":U or
               (cExpression = "":U and cChar = "(":U) then do:

                assign cTargetExpression = cTargetExpression +
                                           string (this-object:LogicalValueProvider:GetLogicalValue (cExpression)) .

                /* parse breaking char in next iteration */
                assign iPos          = iPos - 1
                       cExpression   = "":U
                       lInExpression = false .

                if iPos > iLength then
                    leave charLoop .

                next charLoop .
            end.

            /* We're in an expression now and encountering an opening bracket */
            if cChar = "(":U then do:
                assign iBracket    = StringHelper:FindClosingBracket (pcExpression, iPos)
                       cExpression = cExpression + substring (pcExpression, iPos, iBracket - iPos + 1, "CHARACTER":U)
                       iPos        = iBracket .

                if iPos > iLength then
                    leave charLoop .

                next charLoop .
            end.

            assign cExpression = cExpression + cChar .

            if iPos > iLength then
                leave charLoop .

            finally:
                assign iPos = iPos + 1.

            end finally.
        end.

        if cExpression > "":U then
            assign cTargetExpression = cTargetExpression +
                                       string (this-object:LogicalValueProvider:GetLogicalValue (cExpression)) .

        {&_proparse_ prolint-nowarn(avoidnoerror)}
        buffer ttEval:find-first ("WHERE ":U + cTargetExpression) no-error .

        return buffer ttEval:available .

    end method .

end class.
