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
    File        : CodepageHelper
    Purpose     : Provides helper methods for code page operations or
                  validation
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Mar 17 07:55:52 CET 2014
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*           from propath.
using Consultingwerk.Assertion.* from propath.
using Consultingwerk.Util.*      from propath.
using Progress.Lang.*            from propath.

class Consultingwerk.Util.CodepageHelper:

    /**
     * Purpose: Converts a string from its codepage into another codepage-encoded string
     * Notes:   Uncovertible characters are ignored/thrown away in the target string and
     *          so this method should be used with care.
     *
     * @param plcValue The input string, that may or not contain uncovertible characters
     * @param pcTargetCodepage The codepage for the converted string
     * @return The converted string, in the target codepage.
     */
    method static public longchar ConvertToCodepage (plcValue as longchar,
                                                     pcTargetCodepage as character):
        define variable lcData            as longchar  no-undo .
        define variable lcTargetCharacter as longchar  no-undo.
        define variable iLoop             as integer   no-undo.
        define variable iCnt              as integer   no-undo.

        Assert:NotNullOrEmpty (pcTargetCodepage, "Target codepage"{&TRAN}).

        /* Throw errors from an invalid target codepage value; this should just be thrown,
           and not caught in the CONVERT-BLOCK. E.g. Code page attribute table for ISO88xyz
           was not found in convmap.cp. (912) */
        fix-codepage(lcData)            = pcTargetCodepage.
        fix-codepage(lcTargetCharacter) = pcTargetCodepage.

        do on error undo, throw:
            /* Attempt to assign plcValue to LONGCHAR fixed to target code page */
            lcData = plcValue.

            catch syserr as Progress.Lang.SysError:
                /* ** Unable to update  Field. (142) */
                if syserr:GetMessageNum (1) = 142 then do:
                    iCnt = length(plcValue, "CHARACTER":U).

                    do iLoop = 1 to iCnt on error undo, throw:
                        /* This assignment will eventually fail (since the assignment above failed) */
                        lcTargetCharacter = substring(plcValue, iLoop, 1, "CHARACTER":U).
                        lcData = lcData + lcTargetCharacter.

                        catch syserr2 as Progress.Lang.SysError:
                            /* Ignore error 142 */
                            if syserr:GetMessageNum (1) <> 142 then
                                undo, throw syserr2.
                        end.
                    end.
                end.    /* SysErr 142 */
                else
                    undo, throw syserr.
            end catch.
        end.

        return lcData.

    end method.

end class.
