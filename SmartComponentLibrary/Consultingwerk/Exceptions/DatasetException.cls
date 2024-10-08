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
    File        : DatasetException
    Purpose     : Exception raised by the DatasetHelper:ThrowDatasetErrors
                  method with the ERROR-STRING's of the ProDataset records
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Oct 21 17:23:51 CEST 2014
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw .

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Exceptions.DatasetException
    inherits Exception
    {&SERIALIZABLE}:

    /**
     * Purpose: Constructor of the DatasetException class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     */
    constructor public DatasetException (pcErrorString as character,
                                         piMessageNumber as integer):

        super (input pcErrorString, input piMessageNumber).

    end constructor.

    /**
     * Purpose: Returns the buffer name associated with the given message
     *          number
     * Notes:
     * @param piMessageNum The number of the message to return the buffer name from
     * @return The buffer name or ? when no field is associated with the message
     */
    method public character GetBufferName (piMessageNum as integer):

        define variable cMessage as character no-undo .
        define variable cBuffer  as character no-undo .

        assign cMessage = this-object:GetMessage (piMessageNum) .

        if num-entries (cMessage, chr (4)) > 2 then
            assign cBuffer = entry (3, cMessage, chr (4)) .

        if cBuffer > "":U then
            return cBuffer .
        else
            return ? .

    end method.

    /**
     * Purpose: Returns the field name associated with the given message
     *          number
     * Notes:
     * @param piMessageNum The number of the message to return the field name from
     * @return The field name or ? when no field is associated with the message
     */
    method public character GetFieldName (piMessageNum as integer):

        define variable cMessage as character no-undo .
        define variable cField   as character no-undo .

        assign cMessage = this-object:GetMessage (piMessageNum) .

        if num-entries (cMessage, chr (4)) > 1 then
            assign cField = entry (2, cMessage, chr (4)) .

        if cField > "":U then
            return cField .
        else
            return ? .

    end method.

    /**
     * Purpose: Returns the message text associated with the given message
     *          number
     * Notes:   The message text excludes the field and buffer name
     * @param piMessageNum The number of the message to return the message text from
     * @return The message text associated with the message
     */
    method public character GetMessageText (piMessageNum as integer):

        define variable cMessage     as character no-undo .
        define variable cMessageText as character no-undo .

        assign cMessage     = this-object:GetMessage (piMessageNum)
               cMessageText = entry (1, cMessage, chr (4)) .

        if cMessageText > "":U then
            return cMessageText .
        else
            return ? .

    end method.

end class.
