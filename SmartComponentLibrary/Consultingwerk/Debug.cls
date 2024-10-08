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
    File        : Debug
    Purpose     : Writes messages to the debug log file
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Feb 12 17:18:42 CET 2013
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.Debug:

    define stream logoutput.

    /**
     * Purpose: Constructor for the Debug class
     * Notes:   Disallow instance creation
     */
    constructor private Debug ():
        super ().

    end constructor.

    /**
     * Purpose: Writes a message to the debug log file
     * Notes:   Requires the DEBUG Compile time option
     * @param pcMessageGroup The message group to prefix the message with
     * @param pcMessage The message to write to the debug log file
     */
    method public static void Log (pcMessageGroup as character,
                                   pcMessage as character):

        &if defined (DEBUG) eq 0 &then
        return .
        &else
        Debug:Log (substitute ("[&1] &2":U,
                   pcMessageGroup,
                   pcMessage)) .
        &endif
    end method .

    /**
     * Purpose: Writes a message to the debug log file
     * Notes:   Requires the DEBUG Compile time option
     * @param pcMessage The message to write to the debug log file
     */
    method public static void Log (pcMessage as character):

        &if defined (DEBUG) eq 0 &then
        return .
        &else
        output stream logoutput to value ({&DebugLogFile}) unbuffered append .

        put stream logoutput unformatted substitute ("[&1] &2":U,
                                                     string (now),
                                                     pcMessage) skip .

        finally:
            output stream logoutput close  .
        end finally.
        &endif

    end method .

    /**
     * Purpose: Writes empty lines to the debug log file
     * Notes:
     * @param piLines The number of lines to Skip
     */
    method public static void Skip (piLines as integer):

        &if defined (DEBUG) eq 0 &then
        return .
        &else
        define variable i as integer no-undo.

        if piLines > 0 then .
        else piLines = 1 .

        output stream logoutput to value ({&DebugLogFile}) unbuffered append .

        do i = 1 to piLines:

            put stream logoutput unformatted " ":U skip (1) .

        end.

        finally:
            output stream logoutput close  .
        end finally.
        &endif

    end method .

end class.
