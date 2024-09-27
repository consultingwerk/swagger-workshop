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
    File        : FileHelper
    Purpose     : File System Helper methods
    Syntax      : Static methods only, Protected constructor to disallow
                  instance creation
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Jun 26 11:07:56 CEST 2011
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*                 from propath.
using Consultingwerk.Assertion.*       from propath.
using Consultingwerk.Exceptions.*      from propath.
using Consultingwerk.SmartFramework.*  from propath.
using Consultingwerk.Util.*            from propath.
using Consultingwerk.Util.Exceptions.* from propath.
using Consultingwerk.Util.Support.*    from propath.
&if defined (DotNetAccessible) ne 0 &then
using Consultingwerk.Windows.Util.*    from propath.
&endif
using Progress.Lang.*                  from propath.

class Consultingwerk.Util.FileHelper:

    {Consultingwerk/Util/TempTables/ttFileNames.i &ACCESS=static}

    define stream imp .

    define static variable cPropath             as character no-undo initial ? .
    define static variable cOrigPropath         as character no-undo initial ? .
    define static variable iPropathEntriesCount as integer   no-undo initial ? .

    /**
     * Purpose: Disallow instance creation
     * Notes:
     */
    constructor protected FileHelper ():
        super ().

    end constructor.

    /**
     * Purpose: Returns if the given string value can be found in the provided file
     *          name
     * Notes:
     * @param pcSearchString The string value to search
     * @param pcFileName The file name
     * @return Logical value indicating if the string can be found
     */
    method public static logical CanFindTextInBinaryFile (pcSearchString as character,
                                                          pcFileName as character):

        define variable mpData  as memptr    no-undo .

        copy-lob from file pcFileName
                 to mpData .

        /* empty files */
        if get-size(mpData) eq 0 then
            return false.

        &if proversion begins "11" or proversion begins "12.0" or proversion begins "12.1" &then
        define variable i       as int64     no-undo .
        define variable iLength as int64     no-undo .
        define variable cString as character no-undo .

        iLength = get-size (mpData) .

        i = 1 .

        do while i < iLength:
            cString = trim (get-string (mpData, i , 1010)) .

            if index (cString, pcSearchString)  > 0 then
                return true .

            i = i + length (cString, "CHARACTER":U) + 1 .
        end.

        return false .
        &else
        return (index(mpData, pcSearchString) > 0).
        &endif

        catch err as Progress.Lang.Error :
            undo, throw new FileNotFoundException(err, pcFileName).
        end catch.

        finally:
            set-size (mpData) = 0 .
        end finally.

    end method.

    /**
     * Purpose: Combines the provided path into a single path
     * Notes:   Does not validate the resulting path entry
     * @param pcPath1 The first path entry to combine
     * @param pcPath2 The second path entry to combine
     * @param pcPath3 The third path entry to combine
     * @param pcPath4 The fourth path entry to combine
     * @param pcPath5 The fifth path entry to combine
     * @param pcPath6 The sixth path entry to combine
     * @param pcPath7 The seventh path entry to combine
     * @param pcPath8 The eight path entry to combine
     * @param pcPath9 The ninth path entry to combine
     * @param pcPath10 The tenth path entry to combine
     * @return The combined path
     */
    method public static character CombinePath (pcPath1 as character,
                                                pcPath2 as character,
                                                pcPath3 as character,
                                                pcPath4 as character,
                                                pcPath5 as character,
                                                pcPath6 as character,
                                                pcPath7 as character,
                                                pcPath8 as character,
                                                pcPath9 as character,
                                                pcPath10 as character):

        define variable cPath as character no-undo.

        assign cPath = right-trim (right-trim (pcPath1, "/":U), "~\":U) .

        if pcPath2 > "":U then
            assign cPath = cPath + (if cPath > "":U then "/":U else "":U) + trim (trim(pcPath2, "/":U), "~\":U) .

        if pcPath3 > "":U then
            assign cPath = cPath + (if cPath > "":U then "/":U else "":U) + trim (trim(pcPath3, "/":U), "~\":U) .

        if pcPath4 > "":U then
            assign cPath = cPath + (if cPath > "":U then "/":U else "":U) + trim (trim(pcPath4, "/":U), "~\":U) .

        if pcPath5 > "":U then
            assign cPath = cPath + (if cPath > "":U then "/":U else "":U) + trim (trim(pcPath5, "/":U), "~\":U) .

        if pcPath6 > "":U then
            assign cPath = cPath + (if cPath > "":U then "/":U else "":U) + trim (trim(pcPath6, "/":U), "~\":U) .

        if pcPath7 > "":U then
            assign cPath = cPath + (if cPath > "":U then "/":U else "":U) + trim (trim(pcPath7, "/":U), "~\":U) .

        if pcPath8 > "":U then
            assign cPath = cPath + (if cPath > "":U then "/":U else "":U) + trim (trim(pcPath8, "/":U), "~\":U) .

        if pcPath9 > "":U then
            assign cPath = cPath + (if cPath > "":U then "/":U else "":U) + trim (trim(pcPath9, "/":U), "~\":U) .

        if pcPath10 > "":U then
            assign cPath = cPath + (if cPath > "":U then "/":U else "":U) + trim (trim(pcPath10, "/":U), "~\":U) .

        return cPath .

    end method.

    /**
     * Purpose: Combines the provided path into a single path
     * Notes:   Does not validate the resulting path entry
     * @param pcPath1 The first path entry to combine
     * @param pcPath2 The second path entry to combine
     * @param pcPath3 The third path entry to combine
     * @param pcPath4 The fourth path entry to combine
     * @param pcPath5 The fifth path entry to combine
     * @param pcPath6 The sixth path entry to combine
     * @param pcPath7 The seventh path entry to combine
     * @param pcPath8 The eight path entry to combine
     * @param pcPath9 The ninth path entry to combine
     * @return The combined path
     */
    method public static character CombinePath (pcPath1 as character,
                                                pcPath2 as character,
                                                pcPath3 as character,
                                                pcPath4 as character,
                                                pcPath5 as character,
                                                pcPath6 as character,
                                                pcPath7 as character,
                                                pcPath8 as character,
                                                pcPath9 as character):

        return FileHelper:CombinePath (pcPath1, pcPath2, pcPath3, pcPath4, pcPath5, pcPath6, pcPath7, pcPath8, pcPath9, ?) .

    end method .

    /**
     * Purpose: Combines the provided path into a single path
     * Notes:   Does not validate the resulting path entry
     * @param pcPath1 The first path entry to combine
     * @param pcPath2 The second path entry to combine
     * @param pcPath3 The third path entry to combine
     * @param pcPath4 The fourth path entry to combine
     * @param pcPath5 The fifth path entry to combine
     * @param pcPath6 The sixth path entry to combine
     * @param pcPath7 The seventh path entry to combine
     * @param pcPath8 The eight path entry to combine
     * @return The combined path
     */
    method public static character CombinePath (pcPath1 as character,
                                                pcPath2 as character,
                                                pcPath3 as character,
                                                pcPath4 as character,
                                                pcPath5 as character,
                                                pcPath6 as character,
                                                pcPath7 as character,
                                                pcPath8 as character):

        return FileHelper:CombinePath (pcPath1, pcPath2, pcPath3, pcPath4, pcPath5, pcPath6, pcPath7, pcPath8, ?, ?) .

    end method .

    /**
     * Purpose: Combines the provided path into a single path
     * Notes:   Does not validate the resulting path entry
     * @param pcPath1 The first path entry to combine
     * @param pcPath2 The second path entry to combine
     * @param pcPath3 The third path entry to combine
     * @param pcPath4 The fourth path entry to combine
     * @param pcPath5 The fifth path entry to combine
     * @param pcPath6 The sixth path entry to combine
     * @param pcPath7 The seventh path entry to combine
     * @return The combined path
     */
    method public static character CombinePath (pcPath1 as character,
                                                pcPath2 as character,
                                                pcPath3 as character,
                                                pcPath4 as character,
                                                pcPath5 as character,
                                                pcPath6 as character,
                                                pcPath7 as character):

        return FileHelper:CombinePath (pcPath1, pcPath2, pcPath3, pcPath4, pcPath5, pcPath6, pcPath7, ?, ?, ?) .

    end method .

    /**
     * Purpose: Combines the provided path into a single path
     * Notes:   Does not validate the resulting path entry
     * @param pcPath1 The first path entry to combine
     * @param pcPath2 The second path entry to combine
     * @param pcPath3 The third path entry to combine
     * @param pcPath4 The fourth path entry to combine
     * @param pcPath5 The fifth path entry to combine
     * @param pcPath6 The sixth path entry to combine
     * @return The combined path
     */
    method public static character CombinePath (pcPath1 as character,
                                                pcPath2 as character,
                                                pcPath3 as character,
                                                pcPath4 as character,
                                                pcPath5 as character,
                                                pcPath6 as character):

        return FileHelper:CombinePath (pcPath1, pcPath2, pcPath3, pcPath4, pcPath5, pcPath6, ?, ?, ?, ?) .

    end method .

    /**
     * Purpose: Combines the provided path into a single path
     * Notes:   Does not validate the resulting path entry
     * @param pcPath1 The first path entry to combine
     * @param pcPath2 The second path entry to combine
     * @param pcPath3 The third path entry to combine
     * @param pcPath4 The fourth path entry to combine
     * @param pcPath5 The fifth path entry to combine
     * @return The combined path
     */
    method public static character CombinePath (pcPath1 as character,
                                                pcPath2 as character,
                                                pcPath3 as character,
                                                pcPath4 as character,
                                                pcPath5 as character):

        return FileHelper:CombinePath (pcPath1, pcPath2, pcPath3, pcPath4, pcPath5, ?, ?, ?, ?, ?) .

    end method .

    /**
     * Purpose: Combines the provided path into a single path
     * Notes:   Does not validate the resulting path entry
     * @param pcPath1 The first path entry to combine
     * @param pcPath2 The second path entry to combine
     * @param pcPath3 The third path entry to combine
     * @param pcPath4 The fourth path entry to combine
     * @return The combined path
     */
    method public static character CombinePath (pcPath1 as character,
                                                pcPath2 as character,
                                                pcPath3 as character,
                                                pcPath4 as character):

        return FileHelper:CombinePath (pcPath1, pcPath2, pcPath3, pcPath4, ?, ?, ?, ?, ?, ?) .

    end method .

    /**
     * Purpose: Combines the provided path into a single path
     * Notes:   Does not validate the resulting path entry
     * @param pcPath1 The first path entry to combine
     * @param pcPath2 The second path entry to combine
     * @param pcPath3 The third path entry to combine
     * @return The combined path
     */
    method public static character CombinePath (pcPath1 as character,
                                                pcPath2 as character,
                                                pcPath3 as character):

        return FileHelper:CombinePath (pcPath1, pcPath2, pcPath3, ?, ?, ?, ?, ?, ?, ?) .

    end method .

    /**
     * Purpose: Combines the provided path into a single path
     * Notes:   Does not validate the resulting path entry
     * @param pcPath1 The first path entry to combine
     * @param pcPath2 The second path entry to combine
     * @return The combined path
     */
    method public static character CombinePath (pcPath1 as character,
                                                pcPath2 as character):

        return FileHelper:CombinePath (pcPath1, pcPath2, ?, ?, ?, ?, ?, ?, ?, ?) .

    end method .

    /**
     * Purpose: Copies files from one path to a target directory
     * Notes:
     * @param pcSourcePath The source file path
     * @param pcFileMask A comma-delimited list of file patterns to copy (e.g. *.xml,*.resx)
     * @param pcTargetPath The directory to copy into
     */
    method public static void CopyFiles (pcSourcePath as character,
                                         pcFileMask as character,
                                         pcTargetPath as character):

        FileHelper:CopyFiles(pcSourcePath, pcFileMask, ?, pcTargetPath) .

    end method .

    /**
     * Purpose: Copies files from one path to a target directory
     * Notes:
     * @param pcSourcePath The source file path
     * @param pcFileMask A comma-delimited list of file patterns to copy (e.g. *.xml,*.resx)
     * @param pcExcludeFiles A comma-delimited list of relative file names to exclude from copy
     * @param pcTargetPath The directory to copy into
     */
    method public static void CopyFiles (pcSourcePath as character,
                                         pcFileMask as character,
                                         pcExcludeFiles as character,
                                         pcTargetPath as character):

        define variable cMask         as character no-undo.
        define variable cFile         as character no-undo.
        define variable cFileName     as character no-undo.
        define variable cRelative     as character no-undo.
        define variable cRelativeFile as character no-undo.
        define variable cTarget       as character no-undo.
        define variable i             as integer   no-undo.
        define variable j             as integer   no-undo.

        file-information:file-name = pcSourcePath .
        if file-information:full-pathname > "":U then
            assign pcSourcePath = file-information:full-pathname .
        else
            undo, throw new InvalidParameterValueException ("pcSourcePath":U,
                                                            pcSourcePath,
                                                            "Consultingwerk.Util.FileHelper":U) .

        file-information:file-name = pcTargetPath .
        if file-information:full-pathname > "":U then
            assign pcTargetPath = file-information:full-pathname .
        else
            undo, throw new InvalidParameterValueException ("pcTargetPath":U,
                                                            pcTargetPath,
                                                            "Consultingwerk.Util.FileHelper":U) .

        maskLoop:
        do i = 1 to num-entries (pcFileMask) on error undo, throw:
            assign cMask = entry (i, pcFileMask) .

            if CharacterType:IsNullOrEmpty(cMask) then
                next maskLoop .

            empty temp-table ttFileNames .

            /* Get a list of files to copy */
            Consultingwerk.Util.FileHelper:GetFileList (pcSourcePath,
                                                        cMask,
                                                        output table ttFileNames by-reference) .

            fileNamesLoop:
            for each ttFileNames on error undo, throw:

                assign cFile     = replace (ttFileNames.FileName, "~\":U, "/":U)
                       cRelative = substring (substring (cFile, 1, r-index (cFile, "/":U) - 1, "CHARACTER":U),
                                              length (pcSourcePath, "CHARACTER":U) +  2,
                                              -1,
                                              "CHARACTER":U)
                       cFileName = substring (cFile, r-index (cFile, "/":U) + 1, -1, "CHARACTER":U).

                if pcExcludeFiles > "":U then do:
                    assign cRelativeFile = trim (substitute ("&1/&2":U,
                                                             cRelative,
                                                             cFileName),
                                                 "/":U) .

                    do j = 1 to num-entries (pcExcludeFiles):
                        if cRelativeFile matches (entry (j, pcExcludeFiles)) then
                            next fileNamesLoop .
                    end.
                end.

                if cRelative > "":U then
                    cTarget = pcTargetPath + "/":U + cRelative .
                else
                    cTarget = pcTargetPath .

                assign cTarget = replace (cTarget, "~\":U, "/":U).

                file-information:file-name = cTarget .
                if file-information:full-pathname = ? then
                    Consultingwerk.Util.FileHelper:CreateDirectory (cTarget) .

                &if defined (DotNetAccessible) ne 0 &then
                System.IO.File:Copy (cFile, replace (cTarget, "/":U, "~\":U) + "~\":U + cFileName, true) .
                System.IO.File:SetAttributes (replace (cTarget, "/":U, "~\":U) + "~\":U + cFileName,
                                              System.IO.FileAttributes:Normal) .

                &else
                os-copy value (cFile) value (cTarget) .
                if os-error > 0 then
                    undo, throw new OsErrorException (os-error) .
                &endif
            end.
        end.

    end method.

    /**
     * Purpose: Copies r-code without DB-references from one path to a target directory
     * Notes:
     * @param pcSourcePath The source file path
     * @param pcTargetPath The directory to copy into
     */
    method public static void CopyNonDbRcode (pcSourcePath as character,
                                              pcTargetPath as character):

        FileHelper:CopyNonDbRcode (pcSourcePath, ?, pcTargetPath) .

    end method .

    /**
     * Purpose: Copies r-code without DB-references from one path to a target directory
     * Notes:
     * @param pcSourcePath The source file path
     * @param pcExcludeFiles A comma-delimited list of relative file names to exclude from copy
     * @param pcTargetPath The directory to copy into
     */
    method public static void CopyNonDbRcode (pcSourcePath as character,
                                              pcExcludeFiles as character,
                                              pcTargetPath as character):

        define variable cFile         as character no-undo.
        define variable cFileName     as character no-undo.
        define variable cRelative     as character no-undo.
        define variable cRelativeFile as character no-undo.
        define variable cTarget       as character no-undo.
        define variable j             as integer   no-undo.

        file-information:file-name = pcSourcePath .
        if file-information:full-pathname > "":U then
            assign pcSourcePath = file-information:full-pathname .
        else
            undo, throw new InvalidParameterValueException ("pcSourcePath":U,
                                                            pcSourcePath,
                                                            "Consultingwerk.Util.FileHelper":U) .

        file-information:file-name = pcTargetPath .
        if file-information:full-pathname > "":U then
            assign pcTargetPath = file-information:full-pathname .
        else
            undo, throw new InvalidParameterValueException ("pcTargetPath":U,
                                                            pcTargetPath,
                                                            "Consultingwerk.Util.FileHelper":U) .

        empty temp-table ttFileNames .

        /* Get a list of files to copy */
        Consultingwerk.Util.FileHelper:GetFileList (pcSourcePath,
                                                    "*.r":U,
                                                    output table ttFileNames by-reference) .

        fileNamesLoop:
        for each ttFileNames on error undo, throw:

            rcode-information:file-name = ttFileNames.FileName .

            if rcode-information:db-references > "":U then
                next fileNamesLoop .

            assign cFile     = replace (ttFileNames.FileName, "~\":U, "/":U)
                   cRelative = substring (substring (cFile, 1, r-index (cFile, "/":U) - 1, "CHARACTER":U),
                                          length (pcSourcePath, "CHARACTER":U) +  2,
                                          -1,
                                          "CHARACTER":U)
                   cFileName = substring (cFile, r-index (cFile, "/":U) + 1, -1, "CHARACTER":U).

            if pcExcludeFiles > "":U then do:
                assign cRelativeFile = substitute ("&1/&2":U,
                                                   cRelative,
                                                   cFileName) .

                do j = 1 to num-entries (pcExcludeFiles):
                    if cRelativeFile matches (entry (j, pcExcludeFiles)) then
                        next fileNamesLoop .
                end.
            end.

            if cRelative > "":U then
                cTarget = pcTargetPath + "/":U + cRelative .
            else
                cTarget = pcTargetPath .

            assign cTarget = replace (cTarget, "~\":U, "/":U).

            file-information:file-name = cTarget .
            if file-information:full-pathname = ? then
                Consultingwerk.Util.FileHelper:CreateDirectory (cTarget) .

            &if defined (DotNetAccessible) ne 0 &then
            System.IO.File:Copy (cFile, replace (cTarget, "/":U, "~\":U) + "~\":U + cFileName, true) .
            System.IO.File:SetAttributes (replace (cTarget, "/":U, "~\":U) + "~\":U + cFileName,
                                          System.IO.FileAttributes:Normal) .

            &else
            os-copy value (cFile) value (cTarget) .
            if os-error > 0 then
                undo, throw new OsErrorException (os-error) .
            &endif
        end.

    end method.

    /**
     * Purpose: Creates all directories and subdirectories in the specified path.
     * Notes:
     * @param pcPath The path to create
     * @return 0 when success otherwise 999 on windows (Exception) or the OS-ERROR on UNIX
     */
    method public static integer CreateDirectory (pcPath as character):

        @SuppressUnusedWarnings.
        {&_proparse_ prolint-nowarn(varusage)}
        define variable iPos as integer no-undo initial 2.

        &if defined (DotNetAccessible) ne 0 &then
        System.IO.Directory:CreateDirectory (replace (pcPath, "/":U, "~\":U)) .

        return 0 .

        catch err as System.Exception:
            LogManager:WriteIgnoredError (err) .

            return 999 .
        end catch.
        &else
        assign pcPath = replace (pcPath, "~\":U, "/":U) .

        iPos = index (pcPath, "/":U, iPos) .

        do while iPos > 0:
            os-create-dir value (substring (pcPath, 1, iPos - 1, "CHARACTER":U)) .

            iPos = index (pcPath, "/":U, iPos + 1) .
        end.

        os-create-dir value (pcPath) .

        return os-error .
        &endif

    end method.

    /**
     * Purpose: Creates the required directories to create the given file
     * Notes:
     * @param pcFileName The name of the file to create the directories for
     * @return 0 when success otherwise 999 on windows (Exception) or the OS-ERROR on UNIX
     */
    method public static integer CreateDirectoryForFile (pcFileName as character):

        define variable cDirectory as character no-undo.

        assign cDirectory = FileHelper:DirectoryName (pcFileName) .

        return FileHelper:CreateDirectory (cDirectory).

    end method .

    /**
     * Purpose: Returns the directory portion of a file name, absolutely or relatively
     * Notes:
     * @param pcFileName The base file name
     * @return The directory portion of the file name
     */
    method public static character DirectoryName (pcFileName as character):

        define variable iIndex as integer no-undo.

        if opsys = "WIN32":U then
            assign pcFileName = replace (pcFileName, "~\":U, "/":U) .

        iIndex = r-index (pcFileName, "/":U) .

        if iIndex > 1 then
            return substring (pcFileName, 1, iIndex - 1, "character":U) .
        else
            return ".":u.

    end method .

    /**
     * Purpose: Returns the directory portion of a file name, absolutely or relatively
     * Notes:   Ensures to return Windows path delimiter on Windows
     * @param pcFileName The base file name
     * @return The directory portion of the file name
     */
    method public static character DirectoryName2 (pcFileName as character):

        define variable iIndex as integer no-undo.

        if opsys = "WIN32":U then
            assign pcFileName = replace (pcFileName, "~\":U, "/":U) .

        iIndex = r-index (pcFileName, "/":U) .

        if iIndex > 1 then
            return FileHelper:SanitizePath(substring (pcFileName, 1, iIndex - 1, "character":U)) .
        else
            return ".":u .

    end method .

&if defined (DotNetAccessible) ne 0 &then
    /**
     * Purpose: Ensures that the given OS file is cased in exactly the same way as
     *          passed in
     * Notes:
     * @param pcFileName The file name to verify
     */
    method public static void EnsureFileNameCase (pcFileName as character):

        define variable oFileSystemInfoArray as "System.IO.FileSystemInfo[]" no-undo .

        define variable cFileNameOnDisk      as character no-undo case-sensitive .
        define variable cFileName            as character no-undo case-sensitive .

        FileAssert:Exists (pcFileName) .

        assign cFileName            = FileHelper:ShortFileName (pcFileName)

               oFileSystemInfoArray = (new System.IO.DirectoryInfo (FileHelper:DirectoryName (pcFileName)))
                                               :GetFileSystemInfos (FileHelper:ShortFileName (pcFileName))

               cFileNameOnDisk      = cast (oFileSystemInfoArray:GetValue(0), System.IO.FileSystemInfo):Name.

        if cFileName <> cFileNameOnDisk then do:
            assign file-information:file-name = pcFileName
                   cFileName           = FileHelper:DirectoryName (file-information:full-pathname) +
                                         "~\":U +
                                         FileHelper:ShortFileName (pcFileName)
                   cFileName           = replace (cFileName, "/":U, "~\":U).

            Microsoft.VisualBasic.FileSystem:Rename (file-information:full-pathname, cFileName) .
        end.

    end method .
&endif

    /**
     * Purpose: Ensures that the folder referenced by the file name exists
     * Notes:
     * @param pcFileName The file name to verify the folder for
     * @return The absolute file name of the folder
     */
    method public static character EnsureFolderExists (pcFileName as character):

        define variable cPath as character no-undo.
        define variable iPos  as integer   no-undo.

        assign cPath = FileHelper:DirectoryName (pcFileName) .

        /* file name relative to working directory */
        if cPath = pcFileName then
            return ".":U .

        if FileHelper:Exists (cPath) then
            return FileHelper:FindFile (cPath) .

        assign cPath = replace (cPath, "~\":U, "/":U)
               iPos  = index (cPath, "/":U).

        do while iPos > 0:
            os-create-dir value (substring (cPath, 1, iPos - 1, "CHARACTER":U)) .

            iPos = index (cPath, "/":U, iPos + 1) .
        end.

        os-create-dir value (cPath) .

        if os-error > 0 then
            undo, throw new OsErrorException (os-error) .

        return FileHelper:FindFile (cPath) .

    end method.

    /**
     * Purpose: Returns True when the file can be found in the PROPATH
     * Notes:
     * @param pcFileName The file name to search
     * @return Logical value indicating if the file can be found
     */
    method public static logical Exists (pcFileName as character):

        file-information:file-name = pcFileName .

        if file-information:full-pathname <> ? then
            return true .
        else
            return false .

    end method.

    /**
     * Purpose: Returns the absolute file name for the given file
     * Notes:
     * @param pcFileName The file name to search
     * @return The absolute path to the file or ? when the file is not found
     */
    method public static character FindFile (pcFileName as character):

        file-information:file-name = pcFileName .

        return file-information:full-pathname .

    end method.

    /**
     * Purpose: Returns the absolute file name for the given file
     * Notes:
     * @param pcFileName The file name to search
     * @param plThrowOnInvalidFileName Logical value indicating if the method should throw an error for an invalid file
     * @return The absolute path to the file or ? when the file is not found
     */
    method public static character FindFile (pcFileName as character,
                                             plThrowOnInvalidFileName as logical):

        file-information:file-name = pcFileName .

        if plThrowOnInvalidFileName and file-information:full-pathname = ? then
            undo, throw new FileNotFoundException (pcFileName) .

        return file-information:full-pathname .

    end method.

    /**
     * Purpose: Returns the file name extension of an operating system file excluding
     *          the dot (.). If the file does not have an extension, returns Null ("")
     * Notes:   Wrapper/facade to adecomm/_osfext.p, but excludes the leading dot
     * @param pcFileName The name of the file to return the extension for
     * @return The file extension
     */
    method public static character FileExtension (pcFileName as character):

        define variable cExtension as character no-undo.

        run adecomm/_osfext.p (pcFileName, output cExtension) .

        if cExtension begins ".":U then
            return substring (cExtension, 2, -1, "character":U) .

        return cExtension.

    end method.

    /**
     * Purpose: Returns the List of files on disk for the specified criteria
     * Notes:
     * @param pcDirectory The directory to search files in (including subdirectories)
     * @param pcFileMask A comma-delimited list of file name patterns to return (e.g. *.cls,*.w,*.p)
     * @param ttFileNames OUTPUT TABLE containing the matching file names (Consultingwerk/Util/TempTables/ttFileNames.i)
     */
    method public static void GetFileList (pcDirectory as character,
                                           pcFileMask as character,
                                           output table ttFileNames):

        define variable cMask      as character no-undo .
        define variable i          as integer   no-undo .
        {&_proparse_ prolint-nowarn(varusage)}
        define variable cDirectory as character no-undo .

        empty temp-table ttFileNames .

&if defined (DotNetAccessible) ne 0 &then
        define variable oFiles as "System.String[]" no-undo .
&endif
        maskLoop:
        do i = 1 to num-entries (pcFileMask):
            assign cMask = entry (i, pcFileMask) .

            if CharacterType:IsNullOrEmpty(cMask) then
                next maskLoop .

&if defined (DotNetAccessible) ne 0 &then
            oFiles = System.IO.Directory:GetFiles (pcDirectory,
                                                   cMask,
                                                   System.IO.SearchOption:AllDirectories) .

            {Consultingwerk/foreach.i System.Object oFile in oFiles}
                if not can-find (ttFileNames where ttFileNames.FileName = unbox (oFile)) then do:
                    create ttFileNames.
                    assign ttFileNames.FileName = unbox (oFile) .
                end.
            end.
&else
            /* SCL-3130 - special characters ~ and . in file mask require masking */
            assign cMask = replace (cMask, "~~":U, "~~~~":U)
                   cMask = replace (cMask, ".":U, "~~.":U) .

            run Consultingwerk/Util/Support/getfilenames.p
                    (pcDirectory,
                     cMask,
                     input-output table ttFileNames by-reference) .
&endif
        end.

&if defined (DotNetAccessible) eq 0 &then
        /* SCL-3365 : When on Linux, FileHelper:GetFileList needs to return
           relatively to the working directory, when the pcDirectory was an
           relative path */
        if FileHelper:IsRelativePath (pcDirectory) then do:
            cDirectory = FileHelper:FindFile (pcDirectory) .

            for each ttFileNames where ttFileNames.FileName begins cDirectory:
                assign ttFileNames.FileName = substitute ("&1&2":U,
                                                          pcDirectory,
                                                          substring (ttFileNames.FileName,
                                                                     length (cDirectory, "CHARACTER":U) + 1,
                                                                     -1,
                                                                     "CHARACTER":U)) .
            end .
        end .
&endif

    end method.

    /**
     * Purpose: Returns the List of files on disk for the specified criteria
     * Notes:
     * @param pcDirectory The directory to search files in (including subdirectories)
     * @param pcFileMask A comma-delimited list of file name patterns to return (e.g. *.cls,*.w,*.p)
     * @param pdtModDate The last recent file mod date, only files more recent will be returned
     * @param ttFileNames OUTPUT TABLE containing the matching file names (Consultingwerk/Util/TempTables/ttFileNames.i)
     */
    method public static void GetFileList (pcDirectory as character,
                                           pcFileMask as character,
                                           pdtModDate as datetime,
                                           output table ttFileNames):

        FileHelper:GetFileList (pcDirectory, pcFileMask, output table ttFileNames by-reference) .

        fileNamesLoop:
        for each ttFileNames on error undo, throw:

            file-information:file-name = ttFileNames.FileName .

            if file-information:full-pathname = ? or

               pdtModDate > datetime (file-information:file-mod-date,
                                      file-information:file-mod-time * 1000) then do:

                delete ttFileNames.
                next fileNamesLoop .
            end.
        end.

    end method .

    /**
     * Purpose: Returns the List of files on disk in the specified folder and the specified criteria
     * Notes:
     * @param pcDirectory The directory to search files in (excluding subdirectories)
     * @param pcFileMask A comma-delimited list of file name patterns to return (e.g. *.cls,*.w,*.p)
     * @param ttFileNames OUTPUT TABLE containing the matching file names (Consultingwerk/Util/TempTables/ttFileNames.i)
     */
    method public static void GetFileListInDirectory (pcDirectory as character,
                                                      pcFileMask as character,
                                                      output table ttFileNames):

        define variable cMask      as character no-undo .
        define variable i          as integer   no-undo .
        define variable cDirectory as character no-undo .

        define variable cFileShort as character no-undo .
        define variable cFileLong  as character no-undo .
        define variable cType      as character no-undo .

        empty temp-table ttFileNames .

        maskLoop:
        do i = 1 to num-entries (pcFileMask):
            assign cMask = entry (i, pcFileMask) .

            if CharacterType:IsNullOrEmpty(cMask) then
                next maskLoop .

            /* SCL-3130 - special characters ~ and . in file mask require masking */
            assign cMask = replace (cMask, "~~":U, "~~~~":U)
                   cMask = replace (cMask, ".":U, "~~.":U) .

            input from os-dir (pcDirectory) .

            repeat on error undo, throw:
                import cFileShort cFileLong cType .

                if cType matches "*F*":U and
                   cFileShort matches pcFileMask then do:

                    if not can-find (ttFileNames where ttFileNames.FileName = cFileLong) then do:
                        create ttFileNames .
                        assign ttFileNames.FileName = cFileLong .
                    end.
                end.
            end.
        end.

        /* SCL-3365 : When on Linux, FileHelper:GetFileList needs to return
           relatively to the working directory, when the pcDirectory was an
           relative path */
        if FileHelper:IsRelativePath (pcDirectory) then do:
            cDirectory = FileHelper:FindFile (pcDirectory) .

            for each ttFileNames where ttFileNames.FileName begins cDirectory:
                assign ttFileNames.FileName = substitute ("&1&2":U,
                                                          pcDirectory,
                                                          substring (ttFileNames.FileName,
                                                                     length (cDirectory, "CHARACTER":U) + 1,
                                                                     -1,
                                                                     "CHARACTER":U)) .
            end .
        end .

    end method.

    /**
     * Purpose: Returns the List of files on disk for the specified criteria
     * Notes:   The routine is an alternative to GetFileList and does not require
     *          access to the .NET Framework (suitable for 10.2B AppServer and
     *          UNIX)
     * @param pcDirectory The directory to search files in (including subdirectories)
     * @param pcFileMask A comma-delimited list of file name patterns to return (e.g. *.cls,*.w,*.p)
     * @param ttFileNames OUTPUT TABLE containing the matching file names (Consultingwerk/Util/TempTables/ttFileNames.i)
     */
    method public static void GetFileListNoDotNet (pcDirectory as character,
                                                   pcFileMask as character,
                                                   output table ttFileNames):

        define variable cMask as character no-undo.
        define variable i     as integer   no-undo.

        empty temp-table ttFileNames .

        maskLoop:
        do i = 1 to num-entries (pcFileMask):
            assign cMask = entry (i, pcFileMask) .

            if CharacterType:IsNullOrEmpty(cMask) then
                next maskLoop .

            run Consultingwerk/Util/Support/getfilenames.p
                    (pcDirectory,
                     cMask,
                     input-output table ttFileNames by-reference) .
        end.

    end method.

    /**
     * Purpose: Reads the file and returns a LONGCHAR with the given
     *          line delimiter
     * Notes:
     * @param pcFileName The name of the file to import
     * @param plCrLf Use CR/LF (TRUE) or LF as the line delimiter
     * @return The LONGCHAR with the text file contents
     */
    method public static longchar GetFileText (pcFileName as character,
                                               plCrLf as logical):

        define variable lcText as longchar  no-undo .
        define variable cLine  as character no-undo .

        input stream imp from value (pcFileName) .

        repeat:
            import stream imp unformatted cLine .
            assign lcText = lcText + cLine + (if plCrLf then chr(13) + chr(10) else chr(10)) .
        end.

        return lcText .

        finally:
            input stream imp close .
        end finally.

    end method.

    /**
     * Purpose: Returns a temporary filename either using a .NET API or based on
     *          a GUID and the AVM SESSION:TEMP-DIRECTORY
     * Notes:   The .NET GUI will create an empty temp-file to "block" the file
     * @return The name for a temporary file
     */
    method public static character GetTempFileName ():

&if defined (DotNetAccessible) ne 0 &then
        return System.IO.Path:GetTempFileName () .

        catch ex as System.IO.IOException:
            if session:batch then do:
                message substitute ("System.IO.IOException: &1":U, ex:Message) .
                message substitute ("Temp-Path:             &1":U, System.IO.Path:GetTempPath ()) .
            end .

            undo, throw ex .
        end catch.

&else
        return session:temp-directory + guid + ".tmp":U .
&endif

    end method.

    /**
     * Purpose: Returns a human readable file size including the Unit
     * Notes:   E.g 10 Bytes, 20 kB, 1.2 MB, ...
     * @param piFileSize The file size to convert into a human readable file size
     * @return The string with the file size including the unit
     */
    method public static character HumanReadableFileSize (piFileSize as int64):

        define variable cUnits   as character no-undo initial "Bytes,kB,MB,GB,TB":U.
        define variable iSize    as int64     no-undo extent 5.
        define variable iLargest as integer   no-undo .
        define variable i        as integer   no-undo .
        define variable iRest    as int64     no-undo .
        define variable deResult as decimal   no-undo .

        if piFileSize = 0 or piFileSize = ? then
            return substitute ("0 &1":U, entry (1, cUnits)) .

        assign iRest = piFileSize .

        loopBlk:
        do i = 1 to 4:
            assign iSize [i] = iRest modulo 1024
                   iRest     = (iRest - iSize [i]) / 1024 .

            if iSize[i] > 0 then
                iLargest = i .

            if iRest = 0 then
                leave loopBlk .
        end.

        if iRest > 0 then
            assign iSize [5] = iRest
                   iLargest  = 5.

        if iLargest <= 1 then
            return substitute ("&1 &2":U, iSize[1], entry (iLargest, cUnits)) .

        deResult = iSize[iLargest] + round (iSize[iLargest - 1] / 1024, 1) .

        return substitute ("&1 &2":U, deResult, entry (iLargest, cUnits)) .

    end method.

    /**
     * Purpose: Returns if the given pathname is a file name reference from within a
     *          procedure library (.PL file)
     * Notes:   Returns true for file names like
     *          C:\Progress\OpenEdge122_64\gui\netlib\OpenEdge.Net.pl<<OpenEdge\Web\WebHandler.r>>
     *
     * @param pcPath The path reference to be checked
     * @return Logical value indicating if the file name reference from within a procedure library
     */
    method public static logical IsInProcedureLibrary (pcPath as character):

        define variable iPos as integer no-undo.

        assign iPos = index (pcPath, "<<":U) .

        if iPos = 0 then
            return false .

        if index (pcPath, ">>":U, iPos) > 0 then
            return true .
        else
            return false .

    end method.

    /**
     * Purpose: Returns if the given file is a relative file name
     * Notes:   Absolute file names begins with / or \ or the second character is a :
     * @param pcPath The path name to test
     * @return Logical value indicating if the given path is a relative path
     */
    method public static logical IsRelativePath (pcPath as character):

        if substring (pcPath, 1, 1, "CHARACTER":U) = "/":U or
           substring (pcPath, 1, 1, "CHARACTER":U) = "~\":U or
           substring (pcPath, 2, 1, "CHARACTER":U) = ":":U then

            return false .
        else
            return true .

    end method.

    /**
     * Purpose: Moves files from one path to a target directory
     * Notes:
     * @param pcSourcePath The source file path
     * @param pcFileMask A comma-delimited list of file patterns to copy (e.g. *.xml,*.resx)
     * @param pcTargetPath The directory to copy into
     */
    method public static void MoveFiles (pcSourcePath as character,
                                         pcFileMask as character,
                                         pcTargetPath as character):

        FileHelper:MoveFiles(pcSourcePath, pcFileMask, ?, pcTargetPath) .

    end method .

    /**
     * Purpose: Moves files from one path to a target directory
     * Notes:
     * @param pcSourcePath The source file path
     * @param pcFileMask A comma-delimited list of file patterns to copy (e.g. *.xml,*.resx)
     * @param pcExcludeFiles A comma-delimited list of relative file names to exclude from copy
     * @param pcTargetPath The directory to copy into
     */
    method public static void MoveFiles (pcSourcePath as character,
                                         pcFileMask as character,
                                         pcExcludeFiles as character,
                                         pcTargetPath as character):

        define variable i as integer no-undo.

        FileHelper:CopyFiles (pcSourcePath, pcFileMask, pcExcludeFiles, pcTargetPath) .

        fileNamesLoop:
        for each ttFileNames:
            if pcExcludeFiles > "":U then do:
                do i = 1 to num-entries (pcExcludeFiles):
                    if ttFileNames.FileName matches (entry (i, pcExcludeFiles)) then
                        next fileNamesLoop .
                end.
            end.

            os-delete value (ttFileNames.FileName).

            if os-error > 0 then
                undo, throw new OsErrorException (os-error) .
        end.

        FileHelper:DeleteEmptyDirectories (pcSourcePath) .

    end method .

    /**
     * Purpose: A Method for Deleting Empty Directories.
     * Notes:
     * @param pcDirectory : character is the absolute path of the directory. Example:(c:\temp\)
     */
    method public static void DeleteEmptyDirectories (pcDirectory as character):

        run Consultingwerk/Util/Support/delete-empty-directories.p (pcDirectory) .

    end method.

    /**
     * Purpose: Returns the file size of the given file
     * Notes:
     * @param pcFileName The (relative file name)
     * @return The file size
     */
    method public static int64 FileSize (pcFileName as character):

        file-information:file-name = pcFileName .

        if file-information:full-pathname = ? then
            undo, throw new AssertException (substitute ("Invalid file name: &1":U,
                                                         pcFileName),
                                             0) .

        return file-information:file-size .

    end method.

    /**
     * Purpose: Returns a normalized path name
     * Notes:   Replaces back slash with forward slash
     * @param pcSourcePathname The source path name
     * @return The path name with forward slashes only
     */
    method public static character NormalizePathname (pcSourcePathname as character):

        return replace (pcSourcePathname, "~\":U, "/":U).

    end method .

    /**
     * Purpose: Returns the error message of an OS-ERROR value
     * Notes:
     * @param piOSError The OS-ERROR Error code
     * @return The OS-ERROR Text
     */
    method public static character OS-ERROR-TEXT (piOSError as integer):

        case piOSError:

            when 0 then return "No error"{&TRAN} .
            when 1 then return "Not owner"{&TRAN} .
            when 2 then return "No such file or directory"{&TRAN} .
            when 3 then return "Interrupted system call"{&TRAN} .
            when 4 then return "I/O error"{&TRAN} .
            when 5 then return "Bad file number"{&TRAN} .
            when 6 then return "No more processes"{&TRAN} .
            when 7 then return "Not enough core memory"{&TRAN} .
            when 8 then return "Permission denied"{&TRAN} .
            when 9 then return "Bad address"{&TRAN} .
            when 10 then return "File exists"{&TRAN} .
            when 11 then return "No such device"{&TRAN} .
            when 12 then return "Not a directory"{&TRAN} .
            when 13 then return "Is a directory"{&TRAN} .
            when 14 then return "File table overflow"{&TRAN} .
            when 15 then return "Too many open files"{&TRAN} .
            when 16 then return "File too large"{&TRAN} .
            when 17 then return "No space left on device"{&TRAN} .
            when 18 then return "Directory not empty"{&TRAN} .
            when 999 then return "Unmapped error (ABL default)"{&TRAN} .

            otherwise return substitute ("Unknown OS-ERROR (&1)"{&TRAN}, piOSError) .

        end case .

    end method.

    /**
     * Purpose: Returns the parent directory based on the given directory
     * Notes:   Returns ? when called for the root folder
     * @param pcDirectoryName The name of the directory who's parent directory should be returned
     * @return The parent directory
     */
    method public static character ParentDirectory (pcDirectoryName as character):

        if opsys = "UNIX":U then
            return ParentDirectoryUnix(pcDirectoryName) .
        else
            return ParentDirectoryWindows(pcDirectoryName) .

    end method.

    /**
     * Purpose: Returns the parent directory based on the given directory
     * Notes:   Returns ? when called for the root folder
     * @param pcDirectoryName The name of the directory who's parent directory should be returned
     * @return The parent directory
     */
    method protected static character ParentDirectoryUnix (pcDirectoryName as character):

        define variable cDirectory as character no-undo.

        assign cDirectory = FileHelper:FindFile(pcDirectoryName, true) .

        /* Root folder */
        if cDirectory = "/":U then
            return ? .

        {&_proparse_ prolint-nowarn(overflow)}
        assign cDirectory = ListHelper:RemoveEntry (cDirectory,
                                                    num-entries (cDirectory, "/":U),
                                                    "/":U) .

        return FileHelper:FindFile(cDirectory, true) .

    end method.

    /**
     * Purpose: Returns the parent directory based on the given directory
     * Notes:   Returns ? when called for the root folder
     * @param pcDirectoryName The name of the directory who's parent directory should be returned
     * @return The parent directory
     */
    method protected static character ParentDirectoryWindows (pcDirectoryName as character):

        define variable cDirectory as character no-undo.

        assign cDirectory = FileHelper:FindFile(pcDirectoryName, true) .

        /* Root of a Windows drive */
        if cDirectory matches ".:~\":U then
            return ? .

        {&_proparse_ prolint-nowarn(overflow)}
        assign cDirectory = ListHelper:RemoveEntry (cDirectory,
                                                    num-entries (cDirectory, "~\":U),
                                                    "~\":U) .

        return FileHelper:FindFile(cDirectory, true) .

    end method.

    /**
     * Purpose: Return relative path if file is in propath
     * Notes:   Based on adecomm/_relfile.p
     * @param pcFileName The (absolute) name of a file
     * @return The relative file name based on the current propath
     */
    method public static character RelativeFileName (pcFileName as character):

        define variable cReturn         as character no-undo.
        define variable cCurrentPropath as character no-undo.
        define variable cLongestProPath as character no-undo.
        define variable cDir            as character no-undo.
        define variable i               as integer   no-undo.

        assign cCurrentPropath = propath .

        if cCurrentPropath <> cOrigPropath or cPropath = ? then do:
            file-information:file-name = ".":U .

            assign cOrigPropath = cCurrentPropath
                   cPropath             = replace (PropathHelper:MakeAbsolute (file-information:full-pathname,
                                                                       cOrigPropath),
                                                   "~\":U, "~/":U)

                   iPropathEntriesCount = num-entries (cPropath).

            do i = iPropathEntriesCount to 1 by -1:
                file-information:file-name = entry (i, cPropath) .

                if file-information:full-pathname = ? then do:
                    {&_proparse_ prolint-nowarn(overflow)}
                    cPropath = ListHelper:RemoveEntry(cPropath, i) .
                end.
            end.

            assign iPropathEntriesCount = num-entries (cPropath) .
        end.

        file-information:file-name = pcFileName .

        if file-information:full-pathname = ? then
            return ? .

        pcFileName = replace (file-information:full-pathname, "~\":U, "~/":U) .

        do i = 1 to iPropathEntriesCount:
            cDir = right-trim (entry (i, cPropath), "/":U)  .

            if pcFileName begins cDir then
                assign cLongestProPath = if num-entries (cDir, "/":U) > num-entries(cLongestProPath, "/":U)
                                            then cDir
                                            else cLongestProPath.
        end.

        if cLongestProPath <> "":U then
            cReturn = substring (pcFilename,
                                 length(cLongestProPath, "CHARACTER":U) + 2,
                                 -1,
                                 "CHARACTER":U).

        /* Procedure Library syntax should not be returned */
        if cReturn matches "*~~.pl<<*>>":U then
            cReturn = right-trim (substring (cReturn, r-index (cReturn, ".pl<<":U) + 5, -1, "CHARACTER":U), ">":U) .

        return cReturn .

    end method .

    /**
     * Purpose: Returns the actual file name from a file in a Procedure Library
     * Notes:   Returns OpenEdge\Web\WebHandler.r from
     *          C:\Progress\OpenEdge122_64\gui\netlib\OpenEdge.Net.pl<<OpenEdge\Web\WebHandler.r>>
     * @param pcPath The Path in the Procedure Library
     * @return The actual file name
     */
    method public static character RemoveProcedureLibraryPath (pcPath as character):

        define variable iPos1 as integer no-undo.
        define variable iPos2 as integer no-undo.

        assign iPos1 = index (pcPath, "<<":U) .

        if iPos1 = 0 then
            return pcPath .

        iPos2 = index (pcPath, ">>":U, iPos1) .

        if iPos2 = 0 then
            return pcPath .

        return substring (pcPath,
                          iPos1 + 2,
                          iPos2 - iPos1 - 2,
                          "CHARACTER":U).

    end method.

    /**
     * Purpose: Replaces the extension of a file
     * Notes:   When the source file name does not have an extension, the extension
     *          will be added
     * @param pcSourceFileName The original file name optionally including a path
     * @param pcExtension The extension to use in the returned file name
     * @return The target file name with the replaces extension
     */
    method public static character ReplaceFileExtension (pcSourceFileName as character,
                                                         pcExtension as character):

        define variable cTarget   as character no-undo.
        define variable cFileName as character no-undo.
        define variable iPathPos  as integer   no-undo.
        define variable iDotPos   as integer   no-undo.

        assign cTarget = FileHelper:NormalizePathname (pcSourceFileName) .

        iPathPos = r-index (cTarget, "/":U) .

        if iPathPos > 0 then
            assign cFileName = substring (cTarget, iPathPos + 1, -1, "CHARACTER":U) .
        else
            assign cFileName = cTarget .

        iDotPos = r-index (cFileName, ".":U) .

        if iDotPos > 0 then
            assign cFileName = substring (cFileName, 1, iDotPos, "CHARACTER":U) + pcExtension .
        else
            assign cFileName = cFileName + ".":U + pcExtension .

        if iPathPos > 0 then
            return substring (cTarget, 1, iPathPos, "CHARACTER":U) + cFileName .
        else
            return cFileName .

    end method .

    /**
     * Purpose: Replaces invalid characters in a file name
     * Notes:
     * @param pcFileName The file name
     * @return The file name with invalid characters replaced
     */
    method public static character ReplaceInvalidCharactersInFileName (pcFileName as character):

        define variable i      as integer no-undo.
        define variable iCount as integer no-undo.

        assign iCount = num-entries (Consultingwerk.Const:ILLEGAL_CHARACTERS_IN_FILENAMES) .

        do i = 1 to iCount:
            assign pcFileName = replace (pcFileName,
                                         entry (i, Consultingwerk.Const:ILLEGAL_CHARACTERS_IN_FILENAMES),
                                         "_":U) .
        end.

        return pcFileName.

    end method.

    /**
     * Purpose: Returns the path name with slash/backslash depending on the OS
     * Notes:
     * @param pcPath The path
     * @return The path with Unix slashes or Windows backslashes
     */
    method public static character SanitizePath (pcPath as character):

        if opsys = "UNIX":U then
            return FileHelper:SanitizePathUnix(pcPath) .
        else
            return FileHelper:SanitizePathWindows(pcPath).

    end method.

    /**
     * Purpose: Returns the path name with Unix slashes
     * Notes:
     * @param pcPath The path
     * @return The path with Unix slashes
     */
    method public static character SanitizePathUnix (pcPath as character):

        return replace (pcPath, "~\":U, "/":U) .

    end method.

    /**
     * Purpose: Returns the path name with Windows backslashes
     * Notes:
     * @param pcPath The path
     * @return The path with Windows backslashes
     */
    method public static character SanitizePathWindows (pcPath as character):

        return replace (pcPath, "/":U, "~\":U) .

    end method.

    /**
     * Purpose: Returns just the file name portion of a relative or absolute file
     *          name
     * Notes:
     * @param pcPath The base path
     * @return The file name portion of the path
     */
    method public static character ShortFileName (pcPath as character):

        define variable iIndex as integer no-undo.

        if opsys = "WIN32":U then
            assign pcPath = replace (pcPath, "~\":U, "/":U) .

        iIndex = r-index (pcPath, "/":U) .

        if iIndex > 0 then
            return substring (pcPath, iIndex + 1, -1, "CHARACTER":U) .

        return pcPath .

    end method .

    /**
     * Purpose: Returns just the file name portion of a relative or absolute file
     *          name without the file extension
     * Notes:
     * @param pcPath The base path
     * @return The file name portion of the path without the file extension
     */
    method public static character ShortFileNameWithoutExtension (pcPath as character):

        define variable cFileName as character no-undo .
        define variable iPos      as integer   no-undo .

        assign cFileName = FileHelper:ShortFileName (pcPath)

               iPos      = r-index (cFileName, ".":U).

        if iPos > 1 then
            return substring (cFileName, 1, iPos - 1, "CHARACTER":U) .
        else if iPos = 0 then
            return cFileName .
        else
            return "":U .

    end method .

&if defined (DotNetAccessible) ne 0 &then
    /**
     * Purpose: Performs substitution of place holders (@{...}) based on the .NET Special Folders
     *          enumeration values
     * Notes:   See https://learn.microsoft.com/en-us/dotnet/api/system.environment.specialfolder
     * @param pcPath The path including a reference to a special folder, please @{LocalApplicationData}
     * @return The actual folder name
     */
    method public static character SubstituteSpecialFolderPath (pcPath as character):

        define variable iPos as integer no-undo.

        if pcPath = ? or pcPath = "":U then
            return "":U .

        assign iPos = index (pcPath, "@":U) .

        if iPos = 0 then
            return pcPath .

        return StringHelper:SubstituteVariable (pcPath, iPos, new SpecialFolderVariableProvider()) .

    end method.
&endif

end class.
