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
    File        : Environment
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Jan 09 23:02:13 CET 2013
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.*      from propath .
using Consultingwerk.Util.* from propath .
using Progress.Lang.*       from propath .

{Consultingwerk/products.i}

class Consultingwerk.Environment:

    define static variable iPid as integer no-undo initial ? .

    /**
     * Purpose: Retrieves the process identifier of the calling process.
     * Notes:   https://msdn.microsoft.com/de-de/library/windows/desktop/ms683180(v=vs.85).aspx
     * @return The return value is the process identifier of the calling process.
     */
    procedure GetCurrentProcessId external "kernel32.dll":U:
        define return parameter ppid as long no-undo.
    end procedure.

    /**
     * Purpose: Returns the NewLine character on the current platform
     * Notes:
     */
    define public static property NewLine as character no-undo
    get.
    private set.

    /**
     * Purpose: Returns the Process Id of the current session
     * Notes:
     */
    define public static property Pid as integer no-undo
    get:
        define variable cPid    as character  no-undo.
        define variable hBuffer as handle     no-undo.

        if iPid <> ? then
            return iPid .

        if num-dbs > 0 then do on error undo, throw:
            create buffer hBuffer for table substitute ("&1._MyConnection":U, ldbname (1)) .
            hBuffer:find-first ().

            assign iPid = hBuffer:buffer-field ("_MyConn-Pid":U):buffer-value .

            return iPid .

            finally:
                GarbageCollectorHelper:DeleteObject(hBuffer) .
            end finally.
        end.

        case opsys:
            when "WIN32":U then do:
                run GetCurrentProcessId (output iPid) .
            end.
            when "UNIX":U then do:
                input through "echo $PPID":U .
                import cPid.
                input close.

                assign iPid = DataTypeHelper:ToInteger(trim (cPid)) .
            end.
        end case .

        return iPid .

    end get .

    /**
     * Purpose: Returns the time when the session was started
     * Notes:
     */
    define public static property TimeStarted as datetime-tz no-undo
    get.
    private set .

    /**
     * Purpose: Constructor for the Environment class
     * Notes:
     */
    constructor static Environment ():

        define variable cNewLine as character no-undo.

&if defined (DotNetAccessible) ne 0 &then
        /* Mike Fechner, Consultingwerk Ltd. 21.05.2014
           10.2B Windows compiled code running on the AppServer will raise this
           error here when accessing System.Environmet:NewLine
           Error attempting to push run time parameters onto the stack. (984) */
        if session:remote or session:client-type = Consultingwerk.ClientType:MULTI-SESSION-AGENT then
            assign Consultingwerk.Environment:NewLine = "~n":U .
        else do:
            run Consultingwerk/get-newline.p (output cNewLine) .

            assign Consultingwerk.Environment:NewLine = cNewLine .
        end.
&else
        assign Consultingwerk.Environment:NewLine = "~n":U .
&endif

        Consultingwerk.Environment:Initialize () .

    end constructor.

    /**
     * Purpose: Initializes the class
     * Notes:   Called form the static constructor
     */
    method protected static void Initialize ():

        Consultingwerk.Environment:TimeStarted = now .

    end method.

end class.
