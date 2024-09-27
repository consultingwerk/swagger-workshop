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
    File        : DataTypeHelper
    Purpose     :
    Syntax      : Static methods only, private constructor to disallow
                  instance creation
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Dec 01 16:49:22 CET 2010
    Notes       : This file is intended for GUI for .NET only
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

class Consultingwerk.Util.DataTypeHelper:

    /* Variable to control error-handling behavior in FormatDate(date,...). It
       allows FormatDateTime() and FormatDateTimeTz() to use the session's default
       DATE-FORMAT to be used in cases of error */
    define static variable lInternalFormatDateCall as logical no-undo.

    /**
     * Purpose: Disallow instance creation
     * Notes:
     */
    constructor protected DataTypeHelper ():
        super ().

    end constructor.

&if defined (DotNetAccessible) ne 0 &then
    /**
     * Purpose: Converts a .NET System.Byte[] into an ABL Character value
     * Notes:
     * @param poBytes The System.Bytes[] to convert
     * @return The resulting ABL Character value
     */
    method public static character ByteArrayToCharacter (poBytes as "System.Byte[]":U):

        define variable oStream       as System.IO.MemoryStream no-undo.
        define variable oStreamReader as System.IO.StreamReader no-undo.

        oStream = new System.IO.MemoryStream (poBytes).

        oStream:Position = 0.
        oStreamReader = new System.IO.StreamReader (oStream).

        return oStreamReader:ReadToEnd () .

        finally:
            oStreamReader:Close() .
            oStream:Close() .
        end finally.

    end method.

    /**
     * Purpose: Converts a .NET Byte[] to an ABL MEMPTR
     * Notes:
     * @param poBytes The System.Byte[] to convert to a MEMPTR
     * @return The new MEMPTR with the data from the Byte[]
     */
    method public static memptr ByteArrayToMemptr (poBytes as "System.Byte[]":U):

        define variable mptr        as memptr        no-undo .
        define variable oIntPointer as System.IntPtr no-undo .
        define variable iPtr64      as int64         no-undo .
        define variable iPtr32      as integer       no-undo .

        set-size (mptr) = poBytes:length .

        if SessionHelper:ProcessBitness() = 32 then do:
            {&_proparse_ prolint-nowarn(overflow)}
            iPtr32 = get-pointer-value (mptr) .

            oIntPointer = new System.IntPtr (iPtr32).
        end .
        else do:
            iPtr64 = get-pointer-value (mptr) .

            oIntPointer = new System.IntPtr (iPtr64).
        end.

        System.Runtime.InteropServices.Marshal:Copy (poBytes, 0, oIntPointer, poBytes:length).

        return mptr .

        finally:
            if valid-object (oIntPointer) then
                delete object oIntPointer.
        end finally.

    end method .

    /**
     * Purpose: Converts an ABL Character value into a .NET System.Byte[]
     * Notes:
     * @param pcValue The Character value to convert
     * @return The resulting System.Byte[]
     */
    method public static "System.Byte[]":U CharacterToByteArray (pcValue as character):

        return System.Text.Encoding:ASCII:GetBytes (pcValue) .

    end method.

    /**
     * Purpose: Converts an ABL Longchar value into a .NET System.Byte[]
     * Notes:
     * @param pcValue The Character value to convert
     * @return The resulting System.Byte[]
     */
    method public static "System.Byte[]":U CharacterToByteArray (pcValue as longchar):

        return System.Text.Encoding:ASCII:GetBytes (pcValue) .

    end method.
&endif

    /**
     * Purpose: Returns a DateTime-Tz value based on a date and a time string
     * Notes:   Supports Time Strings in the Form of hh:mm:ss or hh:mm
     * @param pdDay The day value
     * @param pcTime The time value either as hh:mm:ss or hh:mm
     * @return The resulting DateTime-Tz value
     */
    method public static datetime-tz DateTimeFromDateAndTimeString (pdDay as date,
                                                                    pcTime as character):

        if num-entries (pcTime, ":":U) = 2 then
            assign pcTime = pcTime + ":00":U .

        ListAssert:NumEntries(pcTime, ":":U, 3) .

        return datetime (pdDay, integer (entry (1, pcTime, ":":U)) * Consultingwerk.Const:MSECS_PER_HOUR +
                                integer (entry (2, pcTime, ":":U)) * Consultingwerk.Const:MSECS_PER_MINUTE +
                                integer (entry (3, pcTime, ":":U)) * Consultingwerk.Const:MSECS_PER_SECOND) .

    end method.

    /**
     * Purpose: Returns the ABL Default Format for the given data type
     * Notes:   Creates a single field temp-table and returns the format of the field
     * @param pcDataType The ABL DataType
     * @return The default format for the data type
     */
    method public static character DefaultFormat (pcDataType as character):

        define variable hTable as handle no-undo.

        create temp-table hTable.
        hTable:add-new-field ("test":U, pcDataType) .
        hTable:temp-table-prepare ("ttTest":U) .

        return hTable:default-buffer-handle:buffer-field (1):format .

        finally:
            GarbageCollectorHelper:DeleteObject (hTable) .
        end finally.

    end method.

    /**
     * Purpose: Returns the XML default data-type for the given ABL data type
     * Notes:   Creates a single field temp-table and returns the XML-DATA-TYPE of the field
     * @param pcDataType The ABL DataType
     * @return The default XML data type for the data type
     */
    method public static character DefaultXmlSchemaType (pcDataType as character):

        define variable hTable as handle no-undo.

        create temp-table hTable.
        hTable:add-new-field ("test":U, pcDataType) .
        hTable:temp-table-prepare ("ttTest":U) .

        return hTable:default-buffer-handle:buffer-field (1):xml-data-type .

        finally:
            GarbageCollectorHelper:DeleteObject (hTable) .
        end finally.

    end method.

    /**
     * Purpose: Returns a DATETIME-TZ for the given Unit Time stamp (Epoch)
     * Notes:
     * @param piEpochValue The UNIT Time Value
     * @return DATETIME-TZ
     */
    method public static datetime-tz EpochToDateTimeTz (piEpochValue as int64):

        return add-interval (Consultingwerk.Const:EPOCH,
                             piEpochValue,
                             "SECONDS":U).

    end method.

&if defined (DotNetAccessible) ne 0 &then
&if defined (Infragistics) ne 0 &then
    /**
     * Purpose: Converts a Infragistics DefaultableBoolean to a Progress LOGICAL
     * Notes:   Maps DefaultableBoolean:Default to ?
     * @param poValue The DefaultableBoolean value to convert to LOGICAL
     * @return The equivalent LOGICAL value
     */
    method public static logical FromDefaultableBoolean (poValue as Infragistics.Win.DefaultableBoolean):

        if Progress.Util.EnumHelper:AreEqual (poValue,
                                              Infragistics.Win.DefaultableBoolean:true) then
            return true .
        if Progress.Util.EnumHelper:AreEqual (poValue,
                                              Infragistics.Win.DefaultableBoolean:false) then
            return false .
        if Progress.Util.EnumHelper:AreEqual (poValue,
                                              Infragistics.Win.DefaultableBoolean:default) then
            return ? .

    end method.
&endif
&endif

    /**
     * Purpose: Returns a date value from an MDY based date string
     * Notes:
     * @param pcString The MDY based date string
     * @return The date value
     */
    method public static date FromMdyDateString (pcString as character):

        define variable oFormat       as DateFormat    no-undo .
        define variable oNumberFormat as NumericFormat no-undo .

        oFormat = SessionHelper:GetDateFormat() .
        oNumberFormat = SessionHelper:GetNumericFormat() .

        SessionHelper:SetDefaultDateFormat () .
        SessionHelper:SetDefaultNumericFormat() .

        return DataTypeHelper:ToDate (pcString) .

        finally:
            SessionHelper:SetDateFormat (oFormat) .
            SessionHelper:SetNumericFormat(oNumberFormat) .
        end finally.

    end method.

    /**
     * Purpose: Returns a date value from an MDY based datetime string
     * Notes:
     * @param pcString The MDY based date string
     * @return The date value
     */
    method public static datetime FromMdyDateTimeString (pcString as character):

        define variable oFormat       as DateFormat    no-undo .
        define variable oNumberFormat as NumericFormat no-undo .

        oFormat = SessionHelper:GetDateFormat() .
        oNumberFormat = SessionHelper:GetNumericFormat() .

        SessionHelper:SetDefaultDateFormat () .
        SessionHelper:SetDefaultNumericFormat() .

        return DataTypeHelper:ToDateTime (pcString) .

        finally:
            SessionHelper:SetDateFormat (oFormat) .
            SessionHelper:SetNumericFormat(oNumberFormat) .
        end finally.

    end method.

    /**
     * Purpose: Returns a date value from an MDY based datetime string
     * Notes:
     * @param pcString The MDY based date string
     * @return The date value
     */
    method public static datetime-tz FromMdyDateTimeTzString (pcString as character):

        define variable oFormat       as DateFormat    no-undo .
        define variable oNumberFormat as NumericFormat no-undo .

        oFormat = SessionHelper:GetDateFormat() .
        oNumberFormat = SessionHelper:GetNumericFormat() .

        SessionHelper:SetDefaultDateFormat () .
        SessionHelper:SetDefaultNumericFormat() .

        return DataTypeHelper:ToDateTimeTz (pcString) .

        finally:
            SessionHelper:SetDateFormat (oFormat) .
            SessionHelper:SetNumericFormat(oNumberFormat) .
        end finally.

    end method.

    /**
     * Purpose: Returns a human readable version of an interval
     * Notes:   e.g. 2 days 4 hours 10 minutes 6.134 seconds
     * @param pdtDateTime1 The first datetime-tz value
     * @param pdtDateTime2 The second datetime-tz value
     * @return The interval as a human readable version
     */
    method public static character HumanReadableInterval (pdtDateTime1 as datetime-tz,
                                                          pdtDateTime2 as datetime-tz):

        define variable dtTemp  as datetime-tz no-undo .
        define variable i       as int64       no-undo .
        define variable j       as int64       no-undo .
        define variable deSecs  as decimal     no-undo .
        define variable cString as character   no-undo .

        if pdtDateTime1 < pdtDateTime2 then
            assign dtTemp       = pdtDateTime1
                   pdtDateTime1 = pdtDateTime2
                   pdtDateTime2 = dtTemp .

        assign i = interval (pdtDateTime1, pdtDateTime2, "days":U) .

        if i = 1 then
             assign cString = cString + substitute (" &1 day":U, i) .
        else if i > 1 then
             assign cString = cString + substitute (" &1 days":U, i) .

        assign i = interval (pdtDateTime1, pdtDateTime2, "hours":U) modulo 24 .

        if i = 1 then
             assign cString = cString + substitute (" &1 hour":U, i) .
        else if i > 1 then
             assign cString = cString + substitute (" &1 hours":U, i) .

        assign j = interval (pdtDateTime1, pdtDateTime2, "minutes":U) modulo 60 .

        if i > 0 or j > 0 then do:
            if j = 1 then
                assign cString = cString + substitute (" &1 minute":U, j) .
            else
                assign cString = cString + substitute (" &1 minutes":U, j) .
        end.

        assign i      = interval (pdtDateTime1, pdtDateTime2, "milliseconds":U) modulo 60000
               deSecs = i / 1000 .

        if deSecs > 0 or cString = "" then do:
            if deSecs = 1 then
                assign cString = cString + substitute (" &1 second":U, deSecs) .
            else
                assign cString = cString + substitute (" &1 seconds":U, deSecs) .
        end.

        return trim (cString) .

    end method.

    /**
     * Purpose: Returns true when the passed in data type name is an ABL primitive type
     * Notes:
     * @param pcDataType An Character value that should be tested for a valid ABL data type
     * @return True when the passed in data type name is an ABL primitive type
     */
    method public static logical IsAblDataType (pcDataType as character):

        if lookup (pcDataType, Consultingwerk.Const:ABL_DATA_TYPES) > 0 then
            return true .
        else
            return false .

    end method .

    /**
     * Purpose: Returns TRUE when the passed in character string is a single
     *          digit
     * Notes:
     * @param pcChar The character string
     * @return Logical value indicating if the string is a single digit character
     */
    method public static logical IsDigit (pcChar as character):

        if length (pcChar, "CHARACTER":U) = 1 then
            return (index ("0123456789":U, pcChar) > 0) .
        else
            return false.

    end method.

    /**
     * Purpose: Verifies if the initial value expression is valid for the given datatype
     * Notes:   Supports strings such as TODAY or NOW for DATE and DATETIME
     * @param pcDataType The data type
     * @param pcInitial The initial value expression to validate
     * @return
     */
    method public static logical IsValidInitial (pcDataType as character,
                                                 pcInitial as character):

        define variable hTempTable as handle no-undo .

        create temp-table hTempTable .
        hTempTable:add-new-field("test":U, pcDataType, ?, ?, pcInitial) .

        return true.

        catch uncaught as Progress.Lang.Error :
            return false .
        end catch.

        finally:
            GarbageCollectorHelper:DeleteObject(hTempTable) .
        end finally.

    end method.

    /**
     * Purpose: Returns the CHARACTER representation of a LONGCHAR
     * Notes:   Returns the first 31991 characters
     * @param plLongchar The input longchar value
     * @return The CHARACTER value
     */
    method public static character LongcharToCharacter (plLongchar as longchar):

        define variable lcTest    as longchar no-undo .
        define variable iLength   as integer  no-undo .
        define variable iTruncate as integer  no-undo .

        if plLongchar = ? then
            return ? .

        fix-codepage (lcTest) = session:cpinternal .

        assign lcTest  = plLongchar
               iLength = length (lcTest, "RAW":U) .

        if iLength <= 31991 then
            {&_proparse_ prolint-nowarn(overflow)}
            return string (lcTest) .
        else do:
            assign lcTest  = substring (lcTest, 1, 31991, "CHARACTER":U)
                   iLength = length (lcTest, "RAW":U) .

            /* Need <= 31991 in Bytes - but SUBSTRING for LONGCHAR only supports whole CHARACTERS
               and thus might exceed 31991 Bytes */
            do while iLength > 31991:
                assign iTruncate = iLength - 31991
                       lcTest    = substring (lcTest, 1, 31991 - iTruncate, "CHARACTER":U)
                       iLength   = length (lcTest, "RAW":U) .
            end.

            {&_proparse_ prolint-nowarn(overflow)}
            return string (lcTest) .
        end.

    end method.

    /**
     * Purpose: Converts a Progress.Reflect.DataType Enum member to the corresponding
     *          ABL DataType in a Character representation
     * Notes:
     * @param poType The Progress.Reflect.DataType to convert into an ABL DataType
     * @return The ABL DataType as a CHARACTER Value
     */
    method public static character ToAblDataType (poType as Progress.Reflect.DataType):

        if not valid-object(poType) then
            return ?.

        case poType:
            when Progress.Reflect.DataType:DateTimeTZ then
                return "DATETIME-TZ":U.

            when Progress.Reflect.DataType:Object     then
                return get-class(Progress.Lang.Object):TypeName.

            when Progress.Reflect.DataType:AnyType    then
                return ?.

            otherwise
                return caps(string(poType)).
        end case.
    end method.

&IF DEFINED (DotNetAccessible) NE 0 &THEN
    /**
     * Purpose: Converts a Progress.Data.DataType Enum member to the corresponding
     *          ABL DataType in a Character representation
     * Notes:
     * @param poType The Progress.Data.DataType to convert into an ABL DataType
     * @return The ABL DataType as a CHARACTER Value
     */
    method public static character ToAblDataType (poType as Progress.Data.DataType):

        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:BLOB) then
            return "BLOB":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:CHARACTER) then
            return "CHARACTER":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:CLOB) then
            return "CLOB":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:COM_HANDLE) then
            return "COM-HANDLE":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:DATE) then
            return "DATE":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:DATETIME) then
            return "DATETIME":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:DATETIME_TZ) then
            return "DATETIME-TZ":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:DECIMAL) then
            return "DECIMAL":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:HANDLE) then
            return "HANDLE":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:INT64) then
            return "INT64":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:INTEGER) then
            return "INTEGER":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:LOGICAL) then
            return "LOGICAL":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:PROGRESS_LANG_OBJECT) then
            return "Progress.Lang.Object":U .
        {&_proparse_ prolint-nowarn(recidkeyword)}
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:RECID) then
            return "RECID":U .
        if Progress.Util.EnumHelper:AreEqual (poType, Progress.Data.DataType:ROWID) then
            return "ROWID":U .
        return ? .

    end method.

    /**
     * Purpose: Converts a System.Type to the corresponding ABL DataType in a Character
     *          representation
     * Notes:   Assumes CHARACTER for System.String, not LONGCHAR or BLOB
     *          Returns BLOB for System.Byte[]
     * @param poType The System.Type to convert into an ABL DataType
     * @return The ABL DataType as a CHARACTER Value
     */
    method public static character ToAblDataType (poType as System.Type):

        {Consultingwerk/Assertion/ObjectAssert/IsValid.i poType """poType"":U"}

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.String":U, true)) then
            return "CHARACTER":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.Boolean":U, true)) then
            return "LOGICAL":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.Byte":U, true)) then
            return "INTEGER":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.SByte":U, true)) then
            return "INTEGER":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.DateTime":U, true)) then
            return "DATETIME":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.Decimal":U, true)) then
            return "DECIMAL":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.Int16":U, true)) then
            return "INTEGER":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.UInt16":U, true)) then
            return "INTEGER":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.Int32":U, true)) then
            return "INTEGER":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.UInt32":U, true)) then
            return "INTEGER":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.Int64":U, true)) then
            return "INT64":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.UInt64":U, true)) then
            return "INT64":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.Double":U, true)) then
            return "DECIMAL":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.Single":U, true)) then
            return "DECIMAL":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.Char":U, true)) then
            return "CHARACTER":U .

        if poType:IsAssignableFrom (Progress.Util.TypeHelper:GetType ("System.Byte[]":U, true)) then
            return "BLOB":U .

        undo, throw new SystemTypeNotMappableToAblTypeException (substitute ("System.Type &1 not mappable to ABL primitive type."{&TRAN},
                                                                             poType:FullName),
                                                                 poType:FullName) .

    end method .
&endif

    /**
     * Purpose: Returns an DATE value from a CHARACTER value
     * Notes:   Does return ? on invalid value
     * @param pcString The string value
     * @return The date time value
     */
    method public static date ToDate (pcString as character):

        define variable dtValue as date no-undo.

        assign dtValue = date (pcString) .

        return dtValue .

        catch err as Progress.Lang.Error :
            LogManager:WriteIgnoredError (err) .

            return ?.
        end catch.

    end method .

    /**
     * Purpose: Produces a string version of a date, formatted per the
     *          input date format.
     * Notes:  If an error is raised, the date is returned formatted per the
     *         session's DATE-FORMAT
     *
     * @param pdaDate The date to format
     * @param poDateFormat The date format
     * @return A string version of the date, per the date format
     */
    method static public character FormatDate(pdaDate as date,
                                              poDateFormat as DateFormat):

        define variable cDateValue as character no-undo.
        define variable cEntry     as character no-undo extent 3.
        define variable iDayPos    as integer   no-undo.
        define variable iMonthPos  as integer   no-undo.
        define variable iYearPos   as integer   no-undo.

        if pdaDate = ? then
            return ?.

        ObjectAssert:IsValid(poDateFormat, "poDateFormat":U).

        assign iDayPos           = index(poDateFormat:DateFormat, "d":U)
               iMonthPos         = index(poDateFormat:DateFormat, "m":U)
               iYearPos          = index(poDateFormat:DateFormat, "y":U)

               cEntry[iDayPos]   = string(day(pdaDate),   "99":U)
               cEntry[iMonthPos] = string(month(pdaDate), "99":U)
               cEntry[iYearPos]  = string(year(pdaDate),  "9999":U)

               cDateValue        = substitute("&1/&2/&3":U,
                                              cEntry[1],
                                              cEntry[2],
                                              cEntry[3]).

        return cDateValue.

        catch err as Progress.Lang.Error:
            /* FormatDateTime() and FormatDateTimeTz() will catch (and ignore)
               this error, but the will also use the STRING() to format their
               input DATETIME/-TZ values */
            if lInternalFormatDateCall = true then
                undo, throw err.
            else do:
                LogManager:WriteIgnoredError (err).
                return string (pdaDate).
            end.
        end catch.

    end method.

    /**
     * Purpose: Produces a string version of a datetime, with the date formatted
     *          per the input date format.
     * Notes:  If an error is raised, the date is returned formatted per the
     *         session's DATE-FORMAT
     * @param pdtDateTime The datetime to format
     * @param poDateFormat The date format
     * @return A string version of the datetime, per the date format
     */
    method static public character FormatDateTime(pdtDateTime as datetime,
                                                  poDateFormat as DateFormat):

        define variable daValue        as date      no-undo.
        define variable cDateValue     as character no-undo.
        define variable cDateTimeValue as character no-undo.

        if pdtDateTime = ? then
            return ?.

        ObjectAssert:IsValid(poDateFormat, "poDateFormat":U).

        assign lInternalFormatDateCall         = true
               daValue                         = date(pdtDateTime)
               cDateValue                      = DataTypeHelper:FormatDate(daValue, poDateFormat)
               cDateTimeValue                  = string(pdtDateTime)
               entry(1, cDateTimeValue, " ":U) = cDateValue.

        return cDateTimeValue.

        catch err as Progress.Lang.Error :
            LogManager:WriteIgnoredError (err) .

            return string(pdtDateTime).
        end catch.

        finally:
            assign lInternalFormatDateCall = false.
        end finally.

    end method.

    /**
     * Purpose: Produces a string version of a datetime-tz, with the date formatted
     *          per the input date format.
     * Notes:  If an error is raised, the date is formatted per the
     *         session's DATE-FORMAT
     * @param pdtzDateTimeTz The datetime-tz to format
     * @param poDateFormat The date format
     * @return A string version of the datetime-tz, per the date format
     */
    method static public character FormatDateTimeTz(pdtzDateTimeTz as datetime-tz,
                                                    poDateFormat as DateFormat):

        define variable daValue          as date      no-undo.
        define variable cDateValue       as character no-undo.
        define variable cDateTimeTzValue as character no-undo.

        if pdtzDateTimeTz = ? then
            return ?.

        ObjectAssert:IsValid(poDateFormat, "poDateFormat":U).

        assign lInternalFormatDateCall           = true
               daValue                           = date(pdtzDateTimeTz)
               cDateValue                        = DataTypeHelper:FormatDate(daValue, poDateFormat)
               cDateTimeTzValue                  = string(pdtzDateTimeTz)
               entry(1, cDateTimeTzValue, " ":U) = cDateValue.

        return cDateTimeTzValue.

        catch err as Progress.Lang.Error :
            LogManager:WriteIgnoredError (err) .

            return string(pdtzDateTimeTz).
        end catch.

        finally:
            assign lInternalFormatDateCall = false.
        end finally.

    end method.

    /**
     * Purpose: Returns an DATETIME value from a CHARACTER value
     * Notes:   Does return ? on invalid value
     * @param pcString The string value
     * @return The date time value
     */
    method public static datetime ToDateTime (pcString as character):

        define variable dtValue as datetime no-undo.

        assign dtValue = datetime (pcString) .

        return dtValue .

        catch err as Progress.Lang.Error :
            LogManager:WriteIgnoredError (err) .

            return ?.
        end catch.

    end method .

    /**
     * Purpose: Returns an DATETIME value from a CHARACTER value
     * Notes:   Does return ? on invalid value
     * @param pcString The string value
     * @return The date time tz value
     */
    method public static datetime-tz ToDateTimeTz (pcString as character):

        define variable dtValue as datetime no-undo.

        assign dtValue = datetime-tz (pcString) .

        return dtValue .

        catch err as Progress.Lang.Error :
            LogManager:WriteIgnoredError (err) .

            return ?.
        end catch.

    end method .

    /**
     * Purpose: Returns an DECIMAL value from a CHARACTER value
     * Notes:   Does return ? on invalid value
     * @param pcString The string value
     * @return The integer value
     */
    method public static decimal ToDecimal (pcString as character):

        define variable deValue as decimal no-undo.

        assign deValue = decimal (pcString) .

        return deValue .

        catch err as Progress.Lang.Error :
            LogManager:WriteIgnoredError (err) .

            return ?.
        end catch.

    end method .

&if defined (DotNetAccessible) ne 0 &then
&if defined (Infragistics) ne 0 &then
    /**
     * Purpose: Converts a Progress LOGICAL into an Infragistics DefaultableBoolean
     * Notes:   Maps ? to DefaultableBoolean:Default
     * @param plValue The LOGICAL value to convert to DefaultableBoolean
     * @return The equivalent Infragistics.Win.DefaultableBoolean enum value
     */
    method public static Infragistics.Win.DefaultableBoolean ToDefaultableBoolean (plValue as logical):

        case plValue:
            when true then
                return Infragistics.Win.DefaultableBoolean:True .
            when false then
                return Infragistics.Win.DefaultableBoolean:False .
        end case .

        return Infragistics.Win.DefaultableBoolean:default .

    end method.
&endif

    /**
     * Purpose: Returns the Progress.Data.DataType Enum member matching a Progress
     *          DATA-TYPE
     * Notes:
     * @param pcDataType The ABL DataType to convert from
     * @return The Progress.Data.DataType Value
     */
    method public static Progress.Data.DataType ToEnum (pcDataType as character):

        case pcDataType :
            when "BLOB":U then                 return Progress.Data.DataType:BLOB .
            when "CHARACTER":U then            return Progress.Data.DataType:CHARACTER .
            when "CLOB":U then                 return Progress.Data.DataType:CLOB .
            when "COM-HANDLE":U then           return Progress.Data.DataType:COM_HANDLE .
            when "DATE":U then                 return Progress.Data.DataType:DATE .
            when "DATETIME":U then             return Progress.Data.DataType:DATETIME .
            when "DATETIME-TZ":U then          return Progress.Data.DataType:DATETIME_TZ .
            when "DECIMAL":U then              return Progress.Data.DataType:DECIMAL .
            when "HANDLE":U then               return Progress.Data.DataType:HANDLE .
            when "INT64":U then                return Progress.Data.DataType:INT64 .
            when "INTEGER":U then              return Progress.Data.DataType:INTEGER .
            when "LOGICAL":U then              return Progress.Data.DataType:LOGICAL .
            when "Progress.Lang.Object":U then return Progress.Data.DataType:PROGRESS_LANG_OBJECT .
            when "RECID":U then do:
                                               {&_proparse_ prolint-nowarn(recidkeyword)}
                                               return Progress.Data.DataType:RECID .
            end.
            when "ROWID":U then                return Progress.Data.DataType:ROWID .

            otherwise return Progress.Data.DataType:UNKNOWN .
        end case.

    end method.
&endif

    /**
     * Purpose: Returns a HANDLE value from a CHARACTER value
     * Notes:   Does return ? on invalid value
     * @param pcString The string value
     * @return The handle value
     */
    method public static handle ToHandle (pcString as character):

        define variable hValue as handle no-undo.

        assign hValue = widget-handle (pcString) .

        return hValue .

        catch err as Progress.Lang.Error :
            LogManager:WriteIgnoredError (err) .

            return ?.
        end catch.

    end method.

    /**
     * Purpose: Returns an INT64 value from a CHARACTER value
     * Notes:   Does return ? on invalid value
     * @param pcString The string value
     * @return The int64 value
     */
    method public static int64 ToInt64 (pcString as character):

        define variable iValue as int64 no-undo.

        assign iValue = int64 (pcString) .

        return iValue .

        catch err as Progress.Lang.Error :
            LogManager:WriteIgnoredError (err) .

            return ?.
        end catch.

    end method .

    /**
     * Purpose: Returns an INTEGER value from a CHARACTER value
     * Notes:   Does return ? on invalid value
     * @param pcString The string value
     * @return The integer value
     */
    method public static integer ToInteger (pcString as character):

        define variable iValue as integer no-undo.

        assign iValue = integer (pcString) .

        return iValue .

        catch err as Progress.Lang.Error :
            LogManager:WriteIgnoredError (err) .

            return ?.
        end catch.

    end method .

    /**
     * Purpose: Converts common string representations to a logical value (true/false/?)
     * Notes:   Supported input values for TRUE:  TRUE, YES, 1, JA, WAHR, +, Oui, vrai
     *          Supported input values for FALSE: FALSE, NO, 0, NEIN, FALSCH, -, nee, non, fault
     * @param pcValue The CHARACTER expression to parse
     * @return The equivalent LOGICAL value
     */
    method public static logical ToLogical (pcValue as character):

        define variable cYes as character no-undo initial "true,yes,1,ja,wahr,+,oui,vrai":U.
        define variable cNo  as character no-undo initial "false,no,0,nein,falsch,-,nee,non,fault":U.

        if lookup (pcValue, cYes) > 0 then
            return true .

        if lookup (pcValue, cNo) > 0 then
            return false .

        return ? .

    end method.

    /**
     * Purpose: Converts the given DATE value to an MDY based string
     * Notes:
     * @param pdaDate The date value
     * @return The MDY string value
     */
    method public static character ToMdyDateString (pdaDate as date):

        define variable oFormat       as DateFormat    no-undo .
        define variable oNumberFormat as NumericFormat no-undo .

        oFormat = SessionHelper:GetDateFormat() .
        oNumberFormat = SessionHelper:GetNumericFormat() .

        SessionHelper:SetDefaultDateFormat () .
        SessionHelper:SetDefaultNumericFormat() .

        return string (pdaDate, "99/99/9999":U) .

        finally:
            SessionHelper:SetDateFormat (oFormat) .
            SessionHelper:SetNumericFormat (oNumberFormat) .
        end finally.

    end method.

    /**
     * Purpose: Converts the given DATETIME value to an MDY based string
     * Notes:
     * @param pdtDateTime The date value
     * @return The MDY string value
     */
    method public static character ToMdyDateString (pdtDateTime as datetime):

        define variable oFormat       as DateFormat    no-undo .
        define variable oNumberFormat as NumericFormat no-undo .

        oFormat = SessionHelper:GetDateFormat() .
        oNumberFormat = SessionHelper:GetNumericFormat() .

        SessionHelper:SetDefaultDateFormat () .
        SessionHelper:SetDefaultNumericFormat() .

        return string (pdtDateTime, "99/99/9999 HH:MM:SS.SSS":U) .

        finally:
            SessionHelper:SetDateFormat (oFormat) .
            SessionHelper:SetNumericFormat (oNumberFormat) .
        end finally.

    end method.

    /**
     * Purpose: Converts the given DATETIME value to an MDY based string
     * Notes:
     * @param pdtDateTime The date value
     * @return The MDY string value
     */
    method public static character ToMdyDateString (pdtDateTime as datetime-tz):

        define variable oFormat       as DateFormat    no-undo .
        define variable oNumberFormat as NumericFormat no-undo .

        oFormat = SessionHelper:GetDateFormat() .
        oNumberFormat = SessionHelper:GetNumericFormat() .

        SessionHelper:SetDefaultDateFormat () .
        SessionHelper:SetDefaultNumericFormat() .

        return string (pdtDateTime, "99/99/9999 HH:MM:SS.SSS+HH:MM":U) .

        finally:
            SessionHelper:SetDateFormat (oFormat) .
            SessionHelper:SetNumericFormat (oNumberFormat) .
        end finally.

    end method.

&if defined (DotNetAccessible) ne 0 &then
    /**
     * Purpose: Convert an primitive value (in an ABL Character) into a .NET
     *          System.Object
     * Notes:   Supports CHARACTER, DATE, DECIMAL, INTEGER, INT64, LOGICAL
     * @param pcValue The ABL Value to convert
     * @param pcDataType The ABL Primitive Data Type
     * @return The .NET System.Object
     */
    method public static System.Object ToSystemObject (pcValue as character,
                                                       pcDataType as character):

        case pcDataType:
            when "CHARACTER":U then
                return box (pcValue) .
            when "DATE":U then
                return box (date (pcValue)) .
            when "DECIMAL":U then
                return box (decimal (pcValue)) .
            when "INTEGER":U then
                return box (integer (pcValue)) .
            when "INT64":U then
                return box (int64 (pcValue)) .
            when "LOGICAL":U then
                return box (DataTypeHelper:ToLogical(pcValue)) .
            otherwise
                undo, throw new Consultingwerk.Exceptions.InvalidValueException (pcDataType, "pcDataType":U) .

        end case .

    end method .

    /**
     * Purpose: Returns the System.Type matching a Progress DATA-TYPE
     * Notes:
     * @param pcDataType The ABL DataType to convert from
     * @return The System.Type reference
     */
    method public static System.Type ToSystemType (pcDataType as character):

        case pcDataType :
            when "BLOB":U then                 return Progress.Util.TypeHelper:GetType("System.Byte[]":U) .
            when "CHARACTER":U then            return Progress.Util.TypeHelper:GetType("System.String":U) .
            when "CLOB":U then                 return Progress.Util.TypeHelper:GetType("System.String":U) .
            when "DATE":U then                 return Progress.Util.TypeHelper:GetType("System.DateTime":U) .
            when "DATETIME":U then             return Progress.Util.TypeHelper:GetType("System.DateTime":U) .
            when "DATETIME-TZ":U then          return Progress.Util.TypeHelper:GetType("System.DateTime":U) .
            when "DECIMAL":U then              return Progress.Util.TypeHelper:GetType("System.Decimal":U) .
            when "INT64":U then                return Progress.Util.TypeHelper:GetType("System.Int64":U) .
            when "INTEGER":U then              return Progress.Util.TypeHelper:GetType("System.Int32":U) .
            when "LOGICAL":U then              return Progress.Util.TypeHelper:GetType("System.Boolean":U) .

            otherwise
                undo, throw new InvalidParameterValueException ("pcDataType":U,
                                                                pcDataType,
                                                                "Consultingwerk.Util.DataTypeHelper":U).
        end case.
    end method.
&endif

    /**
     * Purpose: Returns the unabbreviated ABL Data Type Name
     * Notes:   Returns ? when the data type name is not an unabbreviated ABL data
     *          type name
     * @param pcDataType The potentially abbreviated data type name
     * @return The unabbreviated data type name or ? when the data type is not a valid abbreviation of an ABL data type name
     */
    method public static character UnabbreviateDataTypeName (pcDataType as character):

        define variable cTypeName as character no-undo extent 17
            initial ["BLOB":U, "CHARACTER":U, "CLOB":U, "COM-HANDLE":U, "DATE":U,
                     "DATETIME":U, "DATETIME-TZ":U, "DECIMAL":U, "HANDLE":U, "INT64":U,
                     "INTEGER":U, "LOGICAL":U, "LONGCHAR":U, "RECID":U, "ROWID":U,
                     "RAW":U, "WIDGET-HANDLE":U] .

        define variable iMinAbbr as integer no-undo extent 17
            initial  [4, 4, 4, 10, 4,
                      8, 11, 3, 6, 5,
                      3, 7, 8, 5, 5,
                      3, 4].

        define variable i as integer no-undo.
        define variable j as integer no-undo.

        do i = 1 to extent (cTypeName):

            if pcDataType begins substring (cTypeName[i], 1, iMinAbbr[i], "CHARACTER":U) then do:

                do j = iMinAbbr[i] to length (pcDataType, "CHARACTER":U):

                    if pcDataType = substring (cTypeName[i], 1, j, "CHARACTER":U) then
                        return cTypeName[i] .
                end.
            end.
        end.

        return ? .

    end method.

end class.
