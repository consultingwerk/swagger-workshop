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
    File        : InvalidEntryInClassPathException
    Purpose     : Exception raised for an invalid entry in the .classpath
                  file
    Syntax      :
    Description :
    Author(s)   :
    Created     : 05.09.2018 20:08:09
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*                          from propath .
using Consultingwerk.Exceptions.*               from propath .
using Consultingwerk.Util.Exceptions.*          from propath .
using Progress.Lang.*                           from propath .

class Consultingwerk.Util.Exceptions.InvalidEntryInClassPathException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Returns the invalid .classpath entry
     * Notes:
     */
    define public property ClassPathEntry as character no-undo
    get.
    private set.

    /**
     * Purpose: Returns the name of the .classpath file
     * Notes:
     */
    define public property ClassPathFile as character no-undo
    get.
    private set.

    /**
     * Purpose: Constructor of the InvalidEntryInClassPathException class
     * Notes:
     * @param pcEntry The invalid .classpath entry
     * @param pcClassPathFile The name of the .classpath file
     */
    constructor public InvalidEntryInClassPathException (pcEntry as character,
                                                         pcClassPathFile as character):

        super (substitute ("Invalid Entry ~"&1~" in .classpath file ~"&2~"":U,
                           pcEntry,
                           pcClassPathFile), 0).

        assign this-object:ClassPathEntry = pcEntry
               this-object:ClassPathFile  = pcClassPathFile .

    end constructor.

end class.
