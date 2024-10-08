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
    File        : SessionHelper
    Purpose     :
    Syntax      : Static methods only, Protected constructor to disallow
                  instance creation
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Aug 08 21:32:44 CEST 2010
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{ Consultingwerk/products.i }

using Consultingwerk.*      from propath.
using Consultingwerk.Util.* from propath.
using Progress.Lang.*       from propath.

class Consultingwerk.Util.SessionHelper:
    /* External procedure definitions here are used in the InputIsRedirected method */
    &if "{&PROCESS-ARCHITECTURE}":U eq "64":U &then
        &scoped-define LONGINT int64
    &else
        &scoped-define LONGINT long
    &endif

    /* Windows API calls */
    procedure GetFileType external "kernel32.dll":U:
        define input  parameter piFileHandle as {&LONGINT}.
        define return parameter piResult     as {&LONGINT}.
    end procedure.

    procedure GetStdHandle external "kernel32.dll":U:
        define input  parameter piFileHandle as {&LONGINT}.
        define return parameter piResult     as {&LONGINT}.
    end procedure.

    /* Linux API calls.
       The .SO name is correct on Linux on OE 11.x and 12.x */
    procedure isatty external "libc.so.6":U:
        define input  parameter piFileHandle as {&LONGINT}.
        define return parameter piResult     as {&LONGINT}.
    end procedure.

    define private static variable cPatchLevel        as character initial ? no-undo .
    define private static variable cFullVersionString as character initial ? no-undo .

&if defined (DotNetAccessible) ne 0 &then
    /**
     * Purpose: Returns the Assemblies Directory
     * Notes:   Usually the -assemblies parameter
     */
    define public static property AssembliesDirectory as character no-undo
    get:
        return Progress.ClrBridge.AssemblyStore:Instance:AssembliesPath .

        catch err as Progress.Lang.Error:
            LogManager:WriteIgnoredError (err) .

            return ? .
        end catch.
    end .

    /**
     * Purpose: Returns the Assemblies Directory as a full path name
     * Notes:   Usually the -assemblies parameter, resolved using System.IO.DirectoryInfo
     */
    define public static property AssembliesFullPath as character no-undo
    get:
        define variable cAssemblies as character               no-undo .
        define variable oDirectory  as System.IO.DirectoryInfo no-undo .

        assign cAssemblies = SessionHelper:AssembliesDirectory.

        if cAssemblies = "":U then
            assign cAssemblies = ".":U .

        oDirectory = new System.IO.DirectoryInfo (cAssemblies) .

        if oDirectory:Exists then
            return oDirectory:FullName .
        else
            return ? .

        catch err as Progress.Lang.Error:
            LogManager:WriteIgnoredError (err) .

            return ? .
        end catch.
    end .
&endif

    /**
     * Purpose: Protected default constructor.
     * Notes:   There's no need to create instances of the helper classes
     */
    constructor protected SessionHelper ():
        super ().

    end constructor.

    /**
     * Purpose: Returns if the current session allows compilation of ABL source code
     * Notes:   Compiles a non existing .p file (random file name) and tests the
     *          error message.
                 ** Compiler is not available in this version of PROGRESS. (494)
     * @return Logical value indicating if the current session allows compilation
     */
    method public static logical AllowsCompile ():

        compile value (substitute ("&1.p":U, guid)) .

        return true .

        catch e as Progress.Lang.Error :
            if e:GetMessageNum (1) = 494 then
                return false .
            else
                return true .
        end catch.

    end method.

    /**
     * Purpose: Returns the current working directory
     * Notes:
     * @return The current working directory
     */
    method public static character CurrentDirectory ():

        &if defined (DotNetAccessible) ne 0 &then
        return System.Environment:CurrentDirectory .
        &else
        file-information:file-name = ".":U .

        return file-information:full-pathname .
        &endif

    end method.

    /**
     * Purpose: Returns the name of the current method of the caller
     * Notes:   Returns the first entry by space of PROGRAM-NAME(2)
     * @return The name of the current method of the caller
     */
    method public static character CurrentMethodName ():

        return entry (1, program-name (2), " ":U).

    end method .

&if defined (DotNetAccessible) ne 0 &then
    /**
     * Purpose: Returns the name of the current Progress Executable
     * Notes:   Uses System.Environment:CommandLine
     * @return The path to the current executable
     */
    method public static character ExecutablePath ():

        define variable cCommandLine as character no-undo.

        assign cCommandLine = System.Environment:CommandLine .

        if cCommandLine begins "~"":U then
            return entry (2, cCommandLine, "~"":U) .
        else
            return entry (1, cCommandLine, " ":U) .

    end method.
&endif

    /**
     * Purpose: Returns the current session date format
     * Notes:
     * @return The Consultingwerk.DateFormat with the current session Settings
     */
    method public static DateFormat GetDateFormat ():

        define variable oDateFormat as DateFormat no-undo .

        assign oDateFormat = new Consultingwerk.DateFormat ()
               oDateFormat:DateFormat = session:date-format
               oDateFormat:YearOffset = session:year-offset .

        return oDateFormat .

    end method .

    /**
     * Purpose: Returns the current InternationalizationSettings
     * Notes:
     * @return The InternationalizationSettings instance describing the Date- and NumericFormat
     */
    method public static InternationalizationSettings GetInternationalizationSettings():

        return new InternationalizationSettings (SessionHelper:GetNumericFormat(),
                                                 SessionHelper:GetDateFormat()) .

    end method.

    /**
     * Purpose: Returns the current session numeric format
     * Notes:
     * @return The Consultingwerk.NumericFormat with the current session Settings
     */
    method public static NumericFormat GetNumericFormat ():

        define variable oNumericFormat as NumericFormat no-undo .

        assign oNumericFormat = new Consultingwerk.NumericFormat ()
               oNumericFormat:NumSeparator = session:numeric-separator
               oNumericFormat:DecimalPoint = session:numeric-decimal-point .

        return oNumericFormat .

    end method .

    /**
     * Purpose: Indicates whether the session is receiving redirected input (eg from < )
     * Notes:   If the current SESSION:CLIENT-TYPE is not webclient or a 4GL runtime, then
     *          the result is always FALSE.
     * @return If TRUE, then STDIN is redirected to a WebClient or 4GLClient AVM process; FALSE otherwise.
     */
    method static public logical InputIsRedirected():

&if "{&PROCESS-ARCHITECTURE}":U eq "64":U &then
        define variable iFileHandle         as int64   no-undo.
        define variable iFileType           as int64   no-undo.
        define variable iRedirectedFileType as int64   no-undo.
&else
        define variable iFileHandle         as integer no-undo.
        define variable iFileType           as integer no-undo.
        define variable iRedirectedFileType as integer no-undo.
&endif

        if  session:client-type ne Consultingwerk.ClientType:FourGLCLIENT and
            session:client-type ne Consultingwerk.ClientType:WEBCLIENT    then
            return false.

        if opsys eq "UNIX":U then do:
            /* https://linux.die.net/man/3/isatty */
            iRedirectedFileType = 0.

            /* STDIN = 0 */
            run isatty (input 0, output iFileType).
        end.
        else do:
            /* https://learn.microsoft.com/en-us/windows/win32/api/fileapi/nf-fileapi-getfiletype */
            iRedirectedFileType = 1.

            /* Windows stdin = -10    */
            run GetStdHandle (-10, output iFileHandle).
            run GetFileType (iFileHandle, output iFileType).
        end.

        return iFileType eq iRedirectedFileType.

    end method.

    /**
     * Purpose: Returns the "bitness" of the current process (32 / 64 bit)
     * Notes:
     * @return 32 or 64 depending on the current Process process
     */
    method public static integer ProcessBitness ():

        &if defined (DotNetAccessible) ne 0 &then

        &if proversion begins "10" &then
        return 32 . /* no 64 bit Progress on Windows on OE10 */
        &else
        if System.Environment:Is64BitProcess then
            return 64.
        else
            return 32.
        &endif

        &else
        return 64. /* no 32 bit Progress on Linux anymore */
        &endif

    end method .

    /**
     * Purpose: Sets the Sessions date format
     * Notes:
     * @param poDateFormat The DateFormat object with the settings for the current session
     */
    method public static void SetDateFormat (poDateFormat as DateFormat):

        assign session:date-format = poDateFormat:DateFormat
               session:year-offset = poDateFormat:YearOffset .

    end method .

    /**
     * Purpose: Sets the ABL default date format (mdy-1950)
     * Notes:
     */
    method public static void SetDefaultDateFormat ():

        session:date-format = "mdy":U .
        session:year-offset = 1950 .

    end method .

    /**
     * Purpose: Resets the InternationalizationSettings to the American Defaults
     * Notes:
     */
    method public static void SetDefaultInternationalizationSettings():

        SessionHelper:SetDefaultNumericFormat() .
        SessionHelper:SetDefaultDateFormat() .

    end method.

    /**
     * Purpose: Sets the ABL default numeric format (AMERICAN)
     * Notes:
     */
    method public static void SetDefaultNumericFormat ():

        session:numeric-format = "AMERICAN":U .

    end method .

    /**
     * Purpose: Sets the InternationalizationSettings
     * Notes:
     * @param poSettings The InternationalizationSettings instance describing the Date- and NumericFormat
     */
    method public static void SetInternationalizationSettings (poSettings as InternationalizationSettings):

        SessionHelper:SetNumericFormat (poSettings:NumericFormat) .
        SessionHelper:SetDateFormat (poSettings:DateFormat) .

    end method.

    /**
     * Purpose: Sets the Sessions numeric format
     * Notes:
     * @param poNumericFormat The NumericFormat object with the settings for the current session
     */
    method public static void SetNumericFormat (poNumericFormat as NumericFormat):

        session:set-numeric-format (poNumericFormat:NumSeparator,
                                    poNumericFormat:DecimalPoint) .

    end method .

&if defined (DotNetAccessible) ne 0 &then
    /**
     * Purpose: Returns the startup parameters of the current Progress session
     * Notes:   Uses System.Environment:CommandLine
     * @return The list of session startup parameters
     */
    method public static character StartupParameters ():

        define variable cCommandLine as character no-undo.

        assign cCommandLine = System.Environment:CommandLine .

        if cCommandLine begins "~"":U then
            return substring (cCommandLine, index (cCommandLine, "~"":U, 2) + 1, -1, "CHARACTER":U) .
        else
            return substring (cCommandLine, index (cCommandLine, " ":U) + 1, -1, "CHARACTER":U) .

    end method.
&endif

end class.
