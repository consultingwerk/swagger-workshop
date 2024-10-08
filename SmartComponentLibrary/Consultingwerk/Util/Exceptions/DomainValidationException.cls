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
    File        : DomainValidationException
    Purpose     : Exception thrown by NetworkHelper:VerifyMXRecord
                  when the Domain lookup did not return a valid MX
    Syntax      :
    Description :
    Author(s)   : Marko Rüterbories / Consultingwerk Ltd.
    Created     : Tue Nov 29 10:13:09 CET 2016
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Exceptions.* from propath.
using Progress.Lang.*             from propath.

{Consultingwerk/products.i}

class Consultingwerk.Util.Exceptions.DomainValidationException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the name of the Domain that caused the issue
     * Notes:
     */
    define public property DomainName as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor for the DomainValidationException class
     * Notes:   The pcDomainName will be substituted for &1 the pcErrorMessage
     * @param pcErrorMessage The error message for the exception
     * @param pcDomainName The name of the Domain that caused the exception
     */
    constructor public DomainValidationException (pcErrorMessage as character,
                                                  pcDomainName as character):

        super (substitute (pcErrorMessage, pcDomainName), 0).

        assign this-object:DomainName = pcDomainName.

    end constructor.

end class.