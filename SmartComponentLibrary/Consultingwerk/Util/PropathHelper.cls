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
    File        : PropathHelper
    Purpose     : Supporting Methods for dealing with the PROPATH
    Syntax      : Static methods only, Protected constructor to disallow
                  instance creation
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Dec 15 22:49:25 CET 2010
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.*   from propath .
using Consultingwerk.Util.*         from propath .
using Consultingwerk.Util.Support.* from propath .
using Progress.Lang.*               from propath .

class Consultingwerk.Util.PropathHelper:

    {Consultingwerk/Util/TempTables/ttPropath.i static}

    define static variable cSlash as character no-undo.

    /**
     * Purpose: Static construtor for the PropathHelper class
     * Notes:
     */
    constructor static PropathHelper():

        if opsys begins "WIN":U then
            assign cSlash = "~\":U .
        else
            assign cSlash = "/":U .

    end constructor.

    /**
     * Purpose: Disallow instance creation
     * Notes:
     */
    constructor protected PropathHelper ():
        super ().

    end constructor.

    /**
     * Purpose: Returns the actual PROPATH entries based on the temp-table
     *          from a .propath file
     * Notes:
     * @param pcBasePath The base path (current directory)
     * @param ttPropath The OUTPUT temp-table with the propath entries
     * @return The PROPATH resulting from the temp-table
     */
    method public static character GetPropath (pcBasePath as character,
                                               table ttPropath):

        define variable cPropath as character no-undo.

        for each ttPropath:
            if ttPropath.propath_kind = "src":U or ttPropath.propath_kind = "folder":U then do:
                assign ttPropath.propath_path = replace (ttPropath.propath_path, "@~{ROOT~}":U, ".":U)
                       ttPropath.propath_path = replace (ttPropath.propath_path, "@~{WORK~}":U, ".":U) .

                /* "folder" kind entries start with back-slash, need to distinguish from UNC path */
                if substring (ttPropath.propath_path, 1, 1, "CHARACTER":U) =  "~\":U and
                   substring (ttPropath.propath_path, 2, 1, "CHARACTER":U) <> "~\":U then
                    assign ttPropath.propath_path = "..":U + ttPropath.propath_path .

                if not PropathHelper:IsAbsoluteDirectory (ttPropath.propath_path) then
                    ttPropath.propath_path = FileHelper:FindFile (pcBasePath + "/":U + ttPropath.propath_path, false) .

                if ttPropath.propath_path > "":U then
                    cPROPATH = cPROPATH + (if cPROPATH > "":U then ",":U else "":U) + ttPropath.propath_path .
            end.
            else if ttPropath.propath_kind = "lib":U then do:
                assign ttPropath.propath_path = replace (ttPropath.propath_path, "@~{ROOT~}":U, ".":U)
                       ttPropath.propath_path = replace (ttPropath.propath_path, "@~{WORK~}":U, ".":U) .

                if substring (ttPropath.propath_path, 1, 1, "CHARACTER":U) =  "~\":U and
                   substring (ttPropath.propath_path, 2, 1, "CHARACTER":U) <> "~\":U then
                    assign ttPropath.propath_path = "..":U + ttPropath.propath_path .

                if FileHelper:Exists (ttPropath.propath_path) then
                    assign cPROPATH = cPROPATH +
                                      (if cPROPATH > "":U then ",":U else "":U) +
                                      FileHelper:FindFile(ttPropath.propath_path) .
            end.
        end.

        return cPropath .

    end method.

    /**
     * Purpose: Returns the propath entry/folder the given file name is located under
     * Notes:   Supports relative and absolute file names for existing files and
     *          absolute file names for non existing files. File Names / folders will
     *          be returned with forward slash
     * @param pcFileName The file name to locate in a PROPATH folder
     * @return The absolute path representation of the PROPATH entry containing the given file path
     */
    method public static character GetPropathBaseFolder (pcFileName as character):

        define variable cFullFileName as character no-undo.
        define variable cEntry        as character no-undo.
        define variable i             as integer   no-undo.

        if FileHelper:IsRelativePath (pcFileName) then
            assign cFullFileName = FileHelper:FindFile (pcFileName, true) .
        else
            assign cFullFileName = pcFileName .

        assign cFullFileName = replace (cFullFileName, "~\":U, "/":U) .

        do i = 1 to num-entries (propath):
            cEntry = entry (i, propath) .

            file-information:file-name = cEntry .

            if file-information:file-type matches "*D*":U then do:
                cEntry = replace (file-information:full-pathname, "~\":U, "/":U) .

                if cFullFileName begins cEntry then
                    return cEntry .
            end.
        end.

        return ? .

    end method.

    /**
     * Purpose: Returns the relative file name based on a matching PROPATH entry
     * Notes:
     * @param pcFileName The file name to locate in a PROPATH folder
     * @return The relative file name
     */
    method public static character GetRelativeFileName (pcFileName as character):

        define variable cPropathEntry as character no-undo.

        if FileHelper:IsRelativePath (pcFileName) then
            return pcFileName .

        assign cPropathEntry = PropathHelper:GetPropathBaseFolder (pcFileName) .

        if cPropathEntry = ? then
            undo, throw new InvalidParameterValueException ("pcFileName":U,
                                                            pcFileName,
                                                            "Consultingwerk.Util.PropathHelper":U) .

        return substring (pcFileName,
                          length (cPropathEntry, "CHARACTER":U) + 2,
                          -1,
                          "CHARACTER":U) .

    end method.

    /**
     * Purpose: Tests if the current directory name is absolute of relative
     * Notes:   Absolute paths start with either a / (slash) or a double \\ (UNC)
     *          or a letter followed by a colon
     * @param pcDirectory The name of the directory to test
     * @return Logical value indicating if the directory is specified as an absolute path
     */
    method public static logical IsAbsoluteDirectory (pcDirectory as character):

        define variable cFirstLetter  as character no-undo.
        define variable cSecondLetter as character no-undo.

        if pcDirectory begins "/":U or pcDirectory begins "~\":U /* includes \\ for UNC */then
            return true .

        if length (pcDirectory, "CHARACTER":U) < 2 then
            return false .

        assign cFirstLetter  = upper (substring (pcDirectory, 1, 1, "CHARACTER":U))
               cSecondLetter = upper (substring (pcDirectory, 2, 1, "CHARACTER":U)).

        if asc (cFirstLetter) >= 65 and asc (cFirstLetter) <= 90 and
           cSecondLetter = ":":U then
            return true .

        return false .

    end method.

    /**
     * Purpose: Turns a relative propath into an absolute path
     * Notes:
     * @param pcBasePath The relative path to be used as a base for relative references
     * @param pcPropath The propath to make absolute
     * @return The propath with only absolute path references
     */
    method public static character MakeAbsolute (pcBasePath as character,
                                                 pcPropath as character):

        define variable cDelimiter as character no-undo.
        define variable i          as integer   no-undo.
        define variable cEntry     as character no-undo.

        file-information:file-name = pcBasePath .

        if file-information:full-pathname = ? then
            undo, throw new AppError ("Invalid base path for method MakeAbsolute."{&TRAN}, 0) .

        assign pcBasePath = file-information:full-pathname
               cDelimiter = ",":U .

        do i = 1 to num-entries (pcPropath, cDelimiter):
            assign cEntry = entry (i, pcPropath, cDelimiter) .

            if not IsAbsoluteDirectory (cEntry) then do:
                if cEntry = ".":U then
                    assign cEntry = pcBasePath .
                else do:
                    if cEntry begins "./":U or cEntry begins ".~\":U then
                        cEntry = substring (cEntry, 3, -1, "CHARACTER":U) .

                    assign cEntry = pcBasePath + cSlash + cEntry .

                    file-information:file-name = cEntry .

                    if file-information:full-pathname > "":U then
                        assign cEntry = file-information:full-pathname .
                end.

                entry (i, pcPropath, cDelimiter) = cEntry .
            end.
        end.

        return pcPropath .

    end method.

    /**
     * Purpose: Returns the propath delimiter for the current OS
     * Notes:   Accoording to the OpenEdge documentation, even UNIX sessions
     *          use the comma as the propath delimiter from within the AVM so this
     *          method is just left for backwards compatibility
     * @return The comma as the propath
     */
    method public static character PropathDelimiter():

        return ",":U .

    end method.

end class.
