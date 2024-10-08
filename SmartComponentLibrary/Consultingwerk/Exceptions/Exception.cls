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
    File        : Exception
    Purpose     : Common base error class, implementing inner exception
                  handling / access, returning the Error instance
                  that caused the current exception.
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Feb 20 20:19:00 CET 2008
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.*            from propath .
using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.Exception
    inherits AppError
    implements Consultingwerk.Exceptions.ISupportsInnerException,
               Consultingwerk.Exceptions.ISupportsOriginalStackTrace
    serializable:

    /**
     * Purpose: Returns the Error instance that caused the current exception.
     * Notes:
     */
    define public property InnerException as Error no-undo
    get.
    protected set.

    /**
     * Purpose: Returns the original stack trace of the exception
     * Notes:   Only SET-able when the property is empty or unknown
     */
    define public property OriginalStackTrace as character no-undo initial ?
    get.
    set (arg as character):

        if this-object:OriginalStackTrace = ? or
           this-object:OriginalStackTrace = "":U then

            assign this-object:OriginalStackTrace = arg .

    end set .

    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     */
    constructor public Exception ():

        super ().

    end constructor.

    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public Exception (pcErrorString as character,
                                  piMessageNumber as integer):

        super (pcErrorString, piMessageNumber).

        if pcErrorString > "":U and this-object:NumMessages = 0 then
            this-object:AddMessage (pcErrorString, piMessageNumber) .

    end constructor.

    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public Exception (pcErrorString as character):

        super (pcErrorString).

    end constructor.

    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param poInnerException The reference to the original error
     */
    constructor public Exception (poInnerException as Error):

        super ().

        this-object:InnerException = poInnerException .
        this-object:OriginalStackTrace = poInnerException:CallStack .

    end constructor.

    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public Exception (poInnerException as Error,
                                  pcErrorString as character,
                                  piMessageNumber as integer):

        this-object (pcErrorString, piMessageNumber).

        this-object:InnerException = poInnerException .
        this-object:OriginalStackTrace = poInnerException:CallStack .

    end constructor.

    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param poInnerException The reference to the original error
     * @param pcErrorString The error message associated with this Exception object
     */
    constructor public Exception (poInnerException as Error,
                                  pcErrorString as character):

        super (pcErrorString).

        this-object:InnerException = poInnerException .
        this-object:OriginalStackTrace = poInnerException:CallStack .

    end constructor.

    /**
     * Purpose: Adds error messages from another error to this Exception instance
     * Notes:
     * @param poError The error instance to add errors from
     * @return The reference to the error (to be used in a throw statement)
     */
    method public Exception AddMessagesFrom (poError as Error):

        define variable i as integer no-undo.

        do i = 1 to poError:NumMessages:
            this-object:AddMessage (poError:GetMessage (i), poError:GetMessageNum (i)) .
        end.

        return this-object.

    end method .

    /**
     * Purpose: Adds the messages and the original stack trace of the provided
     * Notes:
     * @param poError The original error
     * @return The reference to the error (to be used in a throw statement)
     */
    method public Exception AssignFromError (poError as Progress.Lang.Error):

        this-object:AddMessagesFrom (poError) .
        this-object:OriginalStackTrace = poError:CallStack .

        return this-object .

    end method.

    /**
     * Purpose: Creates an Exception using the given error message and number and
     *          Existing Error
     * Notes:   The messages from the existing error will be added to the new error
     *          are well, useful for adding messages to ABL runtime errors
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     * @param poError The reference to the original error
     * @return The reference to the new Exception
     */
    method public static Exception FromErrorMessageAndError (pcErrorString as character,
                                                             piMessageNumber as integer,
                                                             poError as Error):

        define variable oException as Exception no-undo .
        define variable i          as integer   no-undo .

        assign oException = new Exception (poError, pcErrorString, piMessageNumber) .

        do i = 1 to poError:NumMessages:
            oException:AddMessage (poError:GetMessage (i), poError:GetMessageNum (i)) .
        end.

        if type-of (poError, AppError) then
            oException:ReturnValue = cast (poError, AppError):ReturnValue .

        return oException .

    end method .

end class.
