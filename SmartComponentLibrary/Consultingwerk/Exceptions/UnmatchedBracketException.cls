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
    File        : UnmatchedBracketException
    Purpose     : Exception thrown from the StringHelper:FindClosingBracket()
                  method
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Nov 29 12:40:14 CET 2013
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.UnmatchedBracketException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the Bracket associated with the Exception
     * Notes:
     */
    define public property Bracket as character no-undo
    get.
    private set.

    /**
     * Purpose: Returns the Source String associated with the Exception
     * Notes:
     */
    define public property SourceString as longchar no-undo
    get.
    private set.

    /**
     * Purpose: Returns the Starting Position associated with the Exception
     * Notes:
     */
    define public property StartingPosition as integer no-undo
    get.
    private set.

    /**
     * Purpose: Constructor for the UnmatchedQuoteException class
     * Notes:
     * @param pcSourceString The source string that should contain a closing quote
     * @param pcBracket The character representing the current bracket type
     * @param piStartingPosition The starting position, which is the position of the opening quote
     */
    constructor public UnmatchedBracketException (pcSourceString as longchar,
                                                  pcBracket as character,
                                                  piStartingPosition as integer):

        define variable lcPattern as longchar no-undo
            initial "The Character value ~"&1~" does not contain a closing bracket for &2 at position &3"{&TRAN} .

        super (string (substitute (lcPattern,
                                   pcSourceString,
                                   pcBracket,
                                   piStartingPosition)), 0).

        assign this-object:SourceString     = pcSourceString
               this-object:Bracket          = pcBracket
               this-object:StartingPosition = piStartingPosition .

    end constructor.

end class.
