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
    File        : UniqueIndexRequiredException
    Purpose     : Exception thrown by methods that rely on buffers with unique  
                  indexes
    Syntax      : 
    Description : 
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Feb 10 13:56:49 CET 2015
    Notes       : 
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.Exceptions.* from propath .
using Progress.Lang.*             from propath .

class Consultingwerk.Util.Exceptions.UniqueIndexRequiredException 
    inherits Exception 
    {&SERIALIZABLE}: 
        
    /**
     * Purpose: Returns the name of the buffer that caused this exception
     * Notes:
     */
    define public property BufferName as character no-undo 
    get.
    protected set. 

    /**
     * Purpose: Returns if the calling method did require a Primary unique index
     * Notes:
     */
    define public property PrimaryRequired as logical no-undo initial false 
    get.
    private set. 
    
    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param pcBufferName The name of the Buffer that caused this error
     */
    constructor public UniqueIndexRequiredException (pcErrorString as character,
                                                     pcBufferName as character):
        super (pcErrorString, 0).
        
        this-object:BufferName = pcBufferName . 
        
    end constructor.

    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     * @param pcBufferName The name of the Buffer that caused this error
     */
    constructor public UniqueIndexRequiredException (pcErrorString as character, 
                                                     piMessageNumber as integer,
                                                     pcBufferName as character):
        super (pcErrorString, piMessageNumber).
        
        this-object:BufferName = pcBufferName . 
        
    end constructor.

    /**
     * Purpose: Constructor of the Exception class
     * Notes:
     * @param pcErrorString The error message associated with this Exception object
     * @param piMessageNumber The error message number associated with this Exception object
     * @param pcBufferName The name of the Buffer that caused this error
     * @param plPrimaryRequired Logical value indicating if the method that caused the exception did require a primary unique index
     */
    constructor public UniqueIndexRequiredException (pcErrorString as character, 
                                                     piMessageNumber as integer,
                                                     pcBufferName as character,
                                                     plPrimaryRequired as logical):
        super (pcErrorString, piMessageNumber).
        
        assign this-object:BufferName      = pcBufferName 
               this-object:PrimaryRequired = plPrimaryRequired . 
        
    end constructor.

    /**
     * Purpose: Builds and returns a unique record identifier composed from field
     *          values of either the primary unique index or the first unqiue index
     *          of the table
     * Notes:
     * @param pcBufferName The name of the buffer that caused the error
     * @param plPrimaryRequired Logical value indicating if the method that caused the exception did require a primary unique index
     */
    constructor public UniqueIndexRequiredException (pcBufferName as character, 
                                                     plPrimaryRequired as logical):
        
        super (substitute ("The buffer &1 does not have a &2unique index"{&TRAN}, 
                           pcBufferName,
                           if plPrimaryRequired then "primary ":U else "":U), 0).
        
        assign this-object:BufferName      = pcBufferName
               this-object:PrimaryRequired = plPrimaryRequired . 

    end constructor . 
            
end class.
