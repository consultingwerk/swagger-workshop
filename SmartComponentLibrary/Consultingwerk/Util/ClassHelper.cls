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
    File        : ClassHelper
    Purpose     : Class contains generic supporting routines to work
                  with classes
    Syntax      : Static methods only, private constructor to disallow
                  instance creation
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Jul 12 20:31:09 CEST 2010
    Notes       : This file is intended for GUI for .NET only
                  The result temp-table description is in Consultingwerk/Util/TempTables/ttClassNames.i
                  Provides logging for .classpath file usage through the "ClassHelper"
                  custom log entry type
                  More extensive logging can be activated through the "ClassHelperExt"
                  logging type
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{ Consultingwerk/products.i }

using Consultingwerk.*                 from propath.
using Consultingwerk.Assertion.*       from propath.
using Consultingwerk.Exceptions.*      from propath.
using Consultingwerk.Util.*            from propath.
using Consultingwerk.Util.Exceptions.* from propath.
using Progress.Lang.*                  from propath.
using Progress.Reflect.*               from propath.

class Consultingwerk.Util.ClassHelper:

    {Consultingwerk/Util/TempTables/ttClassNames.i &ACCESS="private static"}
    {Consultingwerk/Util/TempTables/ttClassNames.i &ACCESS="private static" &PREFIX="return_"}
    {Consultingwerk/Util/TempTables/ttClassNames.i &ACCESS="private static" &PREFIX="return2_"}
    {Consultingwerk/Util/TempTables/ttClassPath.i &ACCESS="private static"}
    {Consultingwerk/Util/TempTables/ttFileNames.i &ACCESS="private static"}

&if defined (DotNetAccessible) ne 0 &then
    define static variable oProcess as System.Diagnostics.Process no-undo .
&endif

    /**
     * Purpose: Gets and sets the name of the .classpath file for location
                R-Code of ABL classes
     * Notes:
     */
    define public static property ClassPathFile as character no-undo initial ".classpath":U
    get.
    set.

    /**
     * Purpose: Ability to force GetClassNames to include classes from the
     *          Consultingwerk.SmartComponents package
     * Notes:
     */
    define public static property ForceIncludeSmartComponents as logical initial false no-undo
    get.
    set.

    /**
     * Purpose: Gets and sets the name of the Logfile that should be created during
     *          the Consultingwerk.Util.ClassHelper:GetClassNamesInClassPath calls
     * Notes:
     */
    define public static property LogfileName as character no-undo
    get.
    set.

    /**
     * Purpose: Allows to start the GetClassNames () in a separate runtime
     * Notes:   Typically set from the _idestartup.p procedure in a project root
     */
    define public static property UseExternalRuntimeForGetClassNames as logical initial false no-undo
    get.
    set.

    /**
     * Purpose: Controls that ClassHelper:GetClassNamesFromExternalRuntime does only
     *          search for the rcode of getclassnames.p to evaluate the absolute filename
     *          passed as the -p argument of the AVN
     * Notes:   Required for customers that separate r-code and source code during
     *          development but still make source code and r-code available to the
     *          AVM runtime when testing for whatever reasons. See SCL-837
     */
    define public static property UseRcodeOnlyForExternalRuntime as logical initial false no-undo
    get.
    set.

    /**
     * Purpose: Constructor for the ClassHelper class
     * Notes:   Protected default constructor
     */
    constructor protected ClassHelper():
        super ().

    end constructor.

    /**
     * Purpose: Returns the full class name based on package and class name
     * Notes:   Package may be empty
     * @param pcPackageName The name of the package
     * @param pcClassName The name of the class
     * @return The full class name
     */
    method public static character ClassName (pcPackageName as character,
                                              pcClassName as character):

        Assert:NotNullOrEmpty(pcClassName, "pcClassName":U) .

        if pcPackageName > "":U then
            return substitute ("&1.&2":U, pcPackageName, pcClassName) .

        return pcClassName.

    end method.

    /**
     * Purpose: Converts a class name into the source code file name (.cls)
     * Notes:
     * @param pcClassName The ClassName to convert into a source code file name
     * @return The file name of the class source code
     */
    method public static character ClassNameToFile (pcClassName as character):

        {Consultingwerk/Assertion/Assert/NotNullOrEmpty.i pcClassName}

        return replace (pcClassName, ".":U, "/":U) + ".cls":U .

    end method.

    /**
     * Purpose: Returns the Progress.Lang.Class reference for a type referenced
     *          by either the .cls or .r file name
     * Notes:
     * @param pcFileName The file name
     * @return The Progress.Lang.Class reference of the matching type
     */
    method public static Progress.Lang.Class FileNameToClass (pcFileName as character):
        /* Behavior prior to the change for SCL-4076 is to not throw any errors */
        return ClassHelper:FileNameToClass(pcFileName, false).
    end method.

    /**
     * Purpose: Returns the Progress.Lang.Class reference for a type referenced
     *          by either the .cls or .r file name
     * Notes:
     * @param pcFileName The file name
     * @param plThrowExceptionIfNotType If TRUE, an exception is thrown if the filename does not represent an OOABL type
     * @return The Progress.Lang.Class reference of the matching type
     */
    method public static Progress.Lang.Class FileNameToClass (pcFileName as character,
                                                              plThrowExceptionIfNotType as logical):

        define variable cShortFileName as character           no-undo .
        define variable oClass         as Progress.Lang.Class no-undo .
        define variable cExtension     as character           no-undo .
        define variable cClassName     as character           no-undo .

        file-information:file-name = pcFileName .

        if file-information:full-pathname = ? then do:
            if plThrowExceptionIfNotType then
                undo, throw new FileNotFoundException(pcFileName).

            return ? .
        end.

        assign cShortFileName = FileHelper:RelativeFileName (file-information:full-pathname).

        /* File Name should be .cls or .r */
        assign cExtension = entry (num-entries (cShortFileName, ".":U), cShortFileName, ".":U) .

        if cExtension = "R":U then do:
            rcode-information:file-name = pcFileName .

            if not rcode-information:is-class then do:
                if plThrowExceptionIfNotType then
                    undo, throw new RcodeNotTypeException(pcFileName).

                return ? .
            end.
        end.
        else if not cExtension = "CLS":U then do:
            if plThrowExceptionIfNotType then
                undo, throw new UnsupportedFileExtensionException(substitute("File &1 must have a .CLS extension"{&TRAN}, quoter(cShortFileName)),
                                                                  "cls":U).

            return ? .
        end.

        assign cClassName = substring (cShortFileName, 1, r-index (cShortFileName, ".":U) - 1, "CHARACTER":U)
               cClassName = replace (cClassName, "/":U, ".":U)
               cClassName = replace (cClassName, "~\":U, ".":U)
               oClass     = ClassHelper:ClassNameToClass(cClassName, plThrowExceptionIfNotType).

        return oClass .

    end method .

    /**
     * Purpose: Returns the Progress.Lang.Class reference for a type referenced
     *          by either the type name (ie "Consultingwerk.CharacterType" )
     * Notes:
     * @param pcTypeName The file name
     * @param plThrowExceptionIfNotType If TRUE, an exception is thrown if the name does not represent an OOABL type
     * @return The Progress.Lang.Class reference of the matching type
     */
    method public static Progress.Lang.Class ClassNameToClass (pcTypeName  as character,
                                                               plThrowExceptionIfNotType as logical):

        define variable oClass as Progress.Lang.Class no-undo .

        do on error undo, throw:
            assign oClass = Progress.Lang.Class:GetClass (pcTypeName).

            catch err as Progress.Lang.Error:
                if plThrowExceptionIfNotType then
                    undo, throw new InvalidValueException(err, pcTypeName).

                LogManager:WriteIgnoredError (err).

                return ?.
            end catch.
        end.

        return oClass.
    end method.

    /**
     * Purpose: Returns the Class Name for a type referenced by either the .cls or
     *          .r file name
     * Notes:   Does not verify if it's a valid class name
     * @param pcFileName The file name
     * @return The resulting class name
     */
    method public static character FileNameToClassName (pcFileName as character):

        define variable cShortFileName as character           no-undo .
        define variable cExtension     as character           no-undo .
        define variable cClassName     as character           no-undo .

        file-information:file-name = pcFileName .

        if file-information:full-pathname = ? then
            return ? .

        assign cShortFileName = FileHelper:RelativeFileName (file-information:full-pathname) .

        /* File Name should be .cls or .r */
        assign cExtension = entry (num-entries (cShortFileName, ".":U), cShortFileName, ".":U) .

        if cExtension = "R":U then do:
            rcode-information:file-name = pcFileName .

            if not rcode-information:is-class then
                return ? .
        end.
        else if not cExtension = "CLS":U then
            return ? .

        assign cClassName = substring (cShortFileName, 1, r-index (cShortFileName, ".":U) - 1, "CHARACTER":U)
               cClassName = replace (cClassName, "/":U, ".":U)
               cClassName = replace (cClassName, "~\":U, ".":U).

        return cClassName .

    end method .

    /**
     * Purpose: Verifies if the given class type has a static property of the
     *          given type
     * Notes:
     * @param poClassType The class to look for the property in
     * @param poPropertyType The type of property to look for
     * @return Logical value indicating if the class has a static property of the given type
     */
    method public static logical HasStaticPropertyOfType (poClassType as Progress.Lang.Class,
                                                          poPropertyType as Progress.Lang.Class):

        define variable oProperties as Progress.Reflect.Property no-undo extent .
        define variable oProperty   as Progress.Reflect.Property no-undo .
        define variable i           as integer                   no-undo .

        assign oProperties = poClassType:GetProperties(Progress.Reflect.Flags:Static or Progress.Reflect.Flags:Public) .

        do i = 1 to extent (oProperties):
            assign oProperty = oProperties[i] .

            if oProperty:DataType = Progress.Reflect.DataType:Object and
               Progress.Lang.Class:GetClass (oProperty:DataTypeName):IsA (poPropertyType) then

                return true .
        end.

        return false.
    end method.

    /**
     * Purpose: Returns true when the given class name is a valid abstract class
     * Notes:   Returns false when the class is not abstract or the class name is invalid
     * @param pcClassName The name of the class to test
     * @return Logical value indicating if the class name represents a valid abstract class
     */
    method public static logical IsAbstract (pcClassName as character):

        define variable oClass as Progress.Lang.Class no-undo .

        oClass = ClassHelper:ClassNameToClass(pcClassName, false).

        if not valid-object (oClass) then
            return false .

        return oClass:IsAbstract() .

    end method.

    /**
     * Purpose: Returns if an instance of the given class is in the call stack
     * Notes:   Checks by investigating the PROGRAM-NAME() function
     * @param poType The type to locate in the call stack
     * @param pcMethodName The name of the method
     * @return Logical value indicating if an instance of the given class is in the call stack
     */
    method public static logical IsInCallStack (poType as Progress.Lang.Class,
                                                pcMethodName as character):

        define variable cProgramName as character no-undo .
        define variable i            as integer   no-undo initial 1 .

        assign cProgramName = program-name (1) .

        do while cProgramName > "":U:
            if num-entries (cProgramName, " ":U) > 1 and
               entry (1, cProgramName, " ":U) = pcMethodName and
               entry (2, cProgramName, " ":U) = poType:TypeName then
                return true .

            assign i            = i + 1
                   cProgramName = program-name (i) .
        end.

        return false .

    end method.

    /**
     * Purpose: Returns if an instance of the given class is in the call stack
     * Notes:   Checks by investigating the PROGRAM-NAME() function
     * @param poType The type to locate in the call stack
     * @return Logical value indicating if an instance of the given class is in the call stack
     */
    method public static logical IsInCallStack (poType as Progress.Lang.Class):

        define variable cProgramName as character no-undo .
        define variable i            as integer   no-undo initial 1 .

        assign cProgramName = program-name (1) .

        do while cProgramName > "":U:
            if num-entries (cProgramName, " ":U) > 1 and
               entry (2, cProgramName, " ":U) = poType:TypeName then
                return true .

            assign i            = i + 1
                   cProgramName = program-name (i) .
        end.

        return false .

    end method.

    /**
     * Purpose: Returns the current number of instances of the given class
     * Notes:   Iterates the SESSION:FIRST object chain
     * @param poClass The class to count instances from
     * @return The number of instances of the class
     */
    method public static integer NumInstances (poClass as Progress.Lang.Class):

        define variable i as integer              no-undo .
        define variable o as Progress.Lang.Object no-undo .

        assign o = session:first-object .

        do while valid-object (o):
            if o:GetClass():IsA (poClass) then
                assign i = i + 1 .

            assign o = o:Next-Sibling .
        end.

        return i .

    end method.

    /**
     * Purpose: Returns the ShortClassName for the given Class object
     * Notes:   The short name is the class name without the package
     * @param poClass The class to return the short name for
     * @return The short name of the class
     */
    method public static character ShortClassName (poClass as Progress.Lang.Class):

        define variable cFullName as character no-undo.

        {Consultingwerk/Assertion/ObjectAssert/IsValid.i poClass """Class"":U"}

        assign cFullName = poClass:TypeName .

        return entry (num-entries (cFullName, ".":U), cFullName, ".":U) .

    end method .

    /**
     * Purpose: Returns the class name with a shortened package name
     * Notes:   The package name will the build based on upper case letters
     *          of the package name only. The SmartBusinessEntityAdapter will
     *          be returned as C.SC.I.SmartBusinessEntityAdapter
     * @param poClass The class reference to return the shortened class/package name for
     * @return The shortened class/package name
     */
    method public static character ShortPackageName (poClass as Progress.Lang.Class):

        return ClassHelper:ShortPackageName (poClass:TypeName) .

    end method.

    /**
     * Purpose: Returns the class name with a shortened package name
     * Notes:   The package name will the build based on upper case letters
     *          of the package name only. The SmartBusinessEntityAdapter will
     *          be returned as C.SC.I.SmartBusinessEntityAdapter
     * @param pcClassName The class reference to return the shortened class/package name for
     * @return The shortened class/package name
     */
    method public static character ShortPackageName (pcClassName as character):

        define variable i        as integer   no-undo .
        define variable iEntries as integer   no-undo .
        define variable cEntry   as character no-undo .

        assign iEntries = num-entries (pcClassName, ".":U) - 1 .

        do i = 1 to iEntries:
            assign cEntry = entry (i, pcClassName, ".":U)
                   cEntry = StringHelper:CapitalLetters (cEntry).

            if cEntry = "":U or cEntry = ? then
                assign cEntry = substring (entry (i, pcClassName, ".":U), 1, 3, "CHARACTER":U) .

            assign entry (i, pcClassName, ".":U) = cEntry .
        end.

        return pcClassName .

    end method.

    /**
     * Purpose: Splits a full class name into package and class name
     * Notes:   Performs no validation of type, just splits based on last period
     * @param pcFullClassName The full class name to split
     * @return The Consultingwerk.ClassName that represents the parts of the class name
     */
    method public static ClassName SplitClassName (pcFullClassName as character):

        define variable oClassName as Consultingwerk.ClassName no-undo .
        define variable iIndex     as integer                  no-undo .

        assign oClassName             = new ClassName ()
               oClassName:FullName    = pcFullClassName
               oClassName:ClassName   = entry (num-entries (pcFullClassName, ".":U), pcFullClassName, ".":U)
               .

        assign iIndex = r-index (pcFullClassName, ".":U) .

        if iIndex > 1 then
            assign oClassName:PackageName = substring (pcFullClassName, 1, iIndex - 1, "CHARACTER":U) .

        return oClassName.

    end method .

    /**
     * Purpose: Validates a class name for invalid characters
     * Notes:
     * @param pcClassName The class name to validate
     * @return Logical value indicating if the class name is valid
     */
    method public static logical ValidateClassName (pcClassName as character):

        define variable i    as integer no-undo.
        define variable iAsc as integer no-undo.

        characterLoop:
        do i = 1 to length (pcClassName, "CHARACTER":U):

            assign iAsc = asc (substring (pcClassName, i, 1, "CHARACTER":U)) .

            if (iAsc >= 65 and iAsc <= 90)  /* A..Z */      or
               (iAsc >= 97 and iAsc <= 122) /* a..z */      or
               (iAsc >= 48 and iAsc <= 57)                  or
               iAsc = 45 or iAsc = 95       /* -, _ */ then
               next characterLoop .

            return false .
        end.

        return true .

    end method.

    /**
     * Purpose: Validates a package name for invalid characters
     * Notes:
     * @param pcClassName The class name to validate
     * @return Logical value indicating if the class name is valid
     */
    method public static logical ValidatePackageName (pcClassName as character):

        define variable i    as integer no-undo.
        define variable iAsc as integer no-undo.

        characterLoop:
        do i = 1 to length (pcClassName, "CHARACTER":U):

            assign iAsc = asc (substring (pcClassName, i, 1, "CHARACTER":U)) .

            if (iAsc >= 65 and iAsc <= 90)  /* A..Z */      or
               (iAsc >= 97 and iAsc <= 122) /* a..z */      or
               (iAsc >= 48 and iAsc <= 57)                  or
               iAsc = 45 or iAsc = 95 or iAsc = 46  /* - _ . */ then
               next characterLoop .

            return false .
        end.

        return true .

    end method.

    /**
     * Purpose: Writes the current PROPATH in a tabular fashion to the log file
     * Notes:   ABL stores the PROPATH as a comma-separated list of directories.
     *          (ABL strips the operating-specific separation characters (a colon
     *          ( : ) on UNIX; a semicolon ( ; ) in Windows) and replaces them with
     *          commas.
     */
    method public static void WriteClassPath():

        define variable iSize    as integer   no-undo .
        define variable cEntries as character no-undo .

        if log-manager:logfile-name <> ? or session:remote or session:client-type = "WEBSPEED":U then do:
            file-information:file-name = ClassHelper:ClassPathFile .

            log-manager:write-message ("########################################################################~n":U +
                                       substitute ("### .classpath file: &1 (&2)~n":U, ClassHelper:ClassPathFile, file-information:full-pathname) +
                                       "### .classpath Entries:":U) .

            if file-information:full-pathname > "":U then do:
                LogManager:WriteMessage (substitute ("Using .classpath file: &1":U, file-information:full-pathname), "ClassHelper":U) .


                {&_proparse_ prolint-nowarn(avoidnoerror)}
                temp-table ttClassPath:read-xml ("FILE":U, file-information:full-pathname, "EMPTY":U, ?, ?) no-error .

                for each ttClassPath:
                    assign cEntries = cEntries +
                                      substitute ("&1,&2,":U,
                                                  ttClassPath.Directory,
                                                  ttClassPath.ProcedureLibrary) .
                end.

                assign iSize    = ListHelper:LongestEntry (cEntries, ",":U) + 1 .

                for each ttClassPath where ttClassPath.Directory > "":U or ttClassPath.ProcedureLibrary > "":U:
                    if ttClassPath.Directory > "":U then do:
                        file-information:file-name = ttClassPath.Directory .

                        log-manager:write-message (substitute ("### &1 &2":U,
                                                               string (ttClassPath.Directory,
                                                                       substitute ("X(&1)":U, iSize)),
                                                               file-information:full-pathname)) .
                    end.
                    else do:
                        file-information:file-name = ttClassPath.ProcedureLibrary .

                        log-manager:write-message (substitute ("### &1 &2":U,
                                                               string (ttClassPath.ProcedureLibrary,
                                                                       substitute ("X(&1)":U, iSize)),
                                                               file-information:full-pathname)) .
                    end.
                end.
            end.

            log-manager:write-message ("########################################################################~n":U) .
        end .

    end method .

    /**
     * Purpose: Writes a message to the logfile
     * Notes:   Does nothing, when the ClassHelper:LogfileName is not set
     * @param pcMessage The message to be written to the logfile
     */
    method public static void WriteLogMessage (pcMessage as character):

        if ClassHelper:LogfileName > "" then do:
            output to value (ClassHelper:LogfileName) append .

            put unformatted substitute ("&1 - &2":U,
                                        string (now, "99/99/9999 HH:MM:SS.SSS":U),
                                        pcMessage) skip .

            output close .
        end.
    end method .

end class.
