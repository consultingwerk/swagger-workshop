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
    File        : UnmatchedQuoteException
    Purpose     : Exception thrown from the StringHelper:FindClosingQuote()
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

class Consultingwerk.Exceptions.UnmatchedQuoteException
    inherits Exception
    {&SERIALIZABLE}:

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
     * @param piStartingPosition The starting position, which is the position of the opening quote
     */
    constructor public UnmatchedQuoteException (pcSourceString as longchar,
                                                piStartingPosition as integer):

        define variable lcPattern as longchar no-undo
            initial "The Character value ~"&1~" does not contain a matching quote for position &2"{&TRAN} .

        super (string (substitute (lcPattern,
                                   pcSourceString,
                                   piStartingPosition)), 0).

        assign this-object:SourceString     = pcSourceString
               this-object:StartingPosition = piStartingPosition .

    end constructor.

end class.
