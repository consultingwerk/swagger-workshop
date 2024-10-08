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
    File        : LongcharInputStream
    Purpose     : Input Stream Implementation over a LONGCHAR variable
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Jul 02 16:09:07 CEST 2017
    Notes       : Used for the OpenEdge native JSON serialization (OpenEdge 11.6+).
                  Does not implement Read() methods not required for that
                  purpose.
                  This implementation relies on the OpenEdge.Core.ByteBucket
                  Due to issues with the OpenEdge 11.6 implementation of that
                  class, we're using the OpenEdge 11.7 based implementation
                  also on OpenEdge 11.6.3 in the package OpenEdge.Core117
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.* from propath .
using Progress.IO.*    from propath .
using Progress.Lang.*  from propath .

&if not proversion begins "11.3" and not proversion begins "11.4" and not proversion begins "11.5" &then
&scoped-define ProgressIOInputStream ProgressIOInputStream
&endif

&if proversion eq "11.6" &then
&scoped-define ByteBucket OpenEdge.Core117.ByteBucket
&else
&scoped-define ByteBucket OpenEdge.Core.ByteBucket
&endif

class Consultingwerk.LongcharInputStream
    &if defined (ProgressIOInputStream) ne 0 &then
    inherits InputStream
    &endif
    :

    define variable iPos as int64 no-undo.

&if defined (ProgressIOInputStream) ne 0 &then
    define variable oByteBucket as {&ByteBucket} no-undo .

    /**
     * Purpose: Constructor for the LongcharInputStream class
     * Notes:
     * @param pcLongchar The longchar variable to read
     */
    constructor public LongcharInputStream (pcLongchar as longchar):

        assign oByteBucket = new {&ByteBucket} () .

        oByteBucket:PutString (pcLongchar) .

    end constructor.

    /**
     * Purpose: This method reads data from a input stream and
     *          stores the information in the specified MEMPTR. It returns
     *          the total number of bytes read
     * Notes:
     * @param pmTarget The target MEMPTR to read into
     * @param piOffset The target offset to read into
     * @param piLength The requested length in bytes
     * @return The number of bytes returned
     */
    method override public int64 Read (pmTarget as memptr,
                                       piOffset as int64,
                                       piLength as int64):

        define variable oMemPtr as OpenEdge.Core.Memptr no-undo .

        oMemPtr = oByteBucket:GetBytes(piOffset + iPos, piLength) .

        put-bytes (pmTarget, 1) = oMemPtr:Value.

        assign iPos = iPos + piLength .

        return get-size (pmTarget) .

    end method.

    /**
     * Purpose: Not implemented
     * Notes:
     * @param pcDelimiter CHARACTER
     * @param plcTarget LONGCHAR
     * @return INT64
     */
    method override public int64 Read (pcDelimiter as character,
                                       output plcTarget as longchar):

        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED":U).

    end method.

    /**
     * Purpose: Not implemented
     * Notes:
     * @param pcDelimiter CHARACTER
     * @param pcTarget CHARACTER
     * @return INT64
     */
    method override public int64 Read (pcDelimiter as character,
                                       output pcTarget as character):

        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED":U).

    end method.

&endif
end class.
