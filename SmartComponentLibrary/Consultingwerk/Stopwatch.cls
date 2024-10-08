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
    File        : Stopwatch
    Purpose     : Elternative to ETIME
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Dec 14 12:19:11 CET 2016
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.Stopwatch:

    define variable dtStart as datetime-tz no-undo initial now .
    define variable dtStop  as datetime-tz no-undo initial ? .

    /**
     * Purpose: Returns the elapsed time
     * Notes:
     */
    define public property Elapsed as int64 no-undo
    get:

        if dtStop <> ? then
            return interval (dtStop, dtStart, "milliseconds":U) .
        else
            return interval (now, dtStart, "milliseconds":U) .

    end get.

    /**
     * Purpose: Starts the Stopwatch
     * Notes:
     */
    method public void Start():

        assign dtStart = now
               dtStop  = ? .

    end method.

    /**
     * Purpose: Stops the Stopwatch
     * Notes:
     * @return The number of elapsed milliseconds
     */
    method public int64 Stop ():

        assign dtStop = now .

        return interval (dtStop, dtStart, "milliseconds":U) .

    end method.

    /**
     * Purpose: Returns a string representation of the object
     * Notes:
     * @return A string representation of the runtime
     */
    method public override character ToString ():

        return substitute ("&1 msec":U, this-object:Elapsed) .

    end method.

end class.
