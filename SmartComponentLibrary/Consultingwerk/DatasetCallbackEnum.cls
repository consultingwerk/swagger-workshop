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
    File        : DatasetCallback
    Purpose     : Enum for ProDataset Callback Names
    Syntax      : 
    Description : Reduce risk of typos in ProDataset SET-CALLBACK method 
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon May 09 08:31:24 CEST 2011
    Notes       : Enum names are without - for consistency with coding stlye
                  However the values will return the proper form ABL constant
                  including the dash ("-") 
                  
                  This Enum type is purposely implemented using CHARACTER 
                  static properties and not our Enum base class / EnumMember.i
                  include file - because the SET-CALLBACK method does implicitely
                  use the ToString() method and thus would cause compilation 
                  issues.
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.* from propath .
using Progress.Lang.*  from propath .

class Consultingwerk.DatasetCallbackEnum: 

    /**
     * Purpose: This event occurs at the very end of a FILL, and can be used to
     *          adjust the contents of the ProDataSet object or Buffer object, reject
     *          the FILL operation, or disconnect from a server or database. For a
     *          child table, the event occurs once for each parent record that is
     *          created.
     * Notes:
     */
    define public static property AfterFill as character no-undo initial "AFTER-FILL":U
    get. 

    /**
     * Purpose: This event occurs at the very beginning of a FILL, before anything
     *          is read or created.
     * Notes:   For a ProDataSet object, this event allows the developer to make a
     *          server or database connection, or do other preparatory work.
     *          Alternatively, it allows the developer to intercept and fully
     *          replace the default behavior.
     */
    define public static property BeforeFill as character no-undo initial "BEFORE-FILL":U
    get. 

    /**
     * Purpose: Disallow instance creation
     * Notes:
     */
    constructor private DatasetCallbackEnum ():
        super ().
        
    end constructor.

    /**
     * Purpose: Verifies if the specified callback name is valid
     * Notes:
     * @param pcValue The value to verify
     * @return Logical value indicating if the value is valid
     */
    method public static logical IsValid (pcValue as character):
        
        if index ("AFTER-FILL,BEFORE-FILL":U, pcValue) > 0 then 
            return true . 
            
        return false .     

    end method.

end class.