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
    File        : FileLoggingStream
    Purpose     : Logging stream with output to a file
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Apr 27 23:35:40 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Util.*               from propath .
using Consultingwerk.Util.LoggingStream.* from propath .
using Progress.Lang.*                     from propath .

class Consultingwerk.Util.LoggingStream.FileLoggingStream
    inherits LoggingStream:

    define variable cFileName as character no-undo.

    define stream logging .

    /**
     * Purpose: Constructor for the FileLoggingStream class
     * Notes:
     * @param pcFileName The name of the logging file
     */
    constructor public FileLoggingStream (pcFileName as character):

        super() .

        assign cFileName = pcFileName .

        this-object:OpenFile () .

    end constructor.

    /**
     * Purpose: Clears the logfile.
     * Notes:
     */
    method override public void ClearLogFile ():

        output stream logging close .

        this-object:OpenFile () .

    end method.

    /**
     * Purpose: Opens the file for output
     * Notes:
     */
    method protected void OpenFile():

        output stream logging to value (cFileName) unbuffered .

    end method.

    /**
     * Purpose: Writes a message to the logfile
     * Notes:   The second character parameter allows to specify that this message
     *          should only appear in the client logfile when a certain custom
     *          log entry type (CustomLogEntries) is activated.
     * @param pcMessage The message text
     * @param pcMessageSubSys The custom log entry type for the message
     */
    method override public void WriteMessage (pcMessage as character,
                                              pcMessageSubSys as character):

        assign pcMessage = StringHelper:Indent (pcMessage, 13)
               substring (pcMessage, 1, -1, "CHARACTER":U) = substitute ("[&1]":U, trim (string (pcMessageSubSys, "x(10)":U))) .

        if pcMessageSubSys <> "":U and pcMessageSubSys <> "APPL":U and pcMessageSubSys <> "USER":U then do:
            if this-object:IsCustomLogEntryTypeActive(pcMessageSubSys) or pcMessageSubSys = "LogManager":U then
                put stream logging unformatted pcMessage skip .
        end.
        else
            put stream logging unformatted pcMessage skip .

    end method.

    /**
     * Purpose: Writes a character message to the logfile and the default
     *          logging sub system
     * Notes:
     * @param pcMessage A character message to write to the log file
     */
    method override public void WriteMessage (pcMessage as character):

        assign pcMessage = StringHelper:Indent (pcMessage, 13) .

        put stream logging unformatted pcMessage skip .

    end method.

    /**
     * Purpose: Destructor for the FileLoggingStream class
     * Notes:
     */
    destructor public FileLoggingStream ():

        output stream logging close .

    end destructor .

end class.
