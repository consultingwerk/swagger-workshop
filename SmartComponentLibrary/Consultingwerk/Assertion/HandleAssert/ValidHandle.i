&if 1=0 &then
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
    File        : ValidHandle.i
    Purpose     : Include File base Assertion for ValidHandle
            
    Syntax      : {Consultingwerk/Assertion/HandleAssert/ValidHandle.i hWidget """hWidget"":U"}
                  {Consultingwerk/Assertion/HandleAssert/ValidHandle.i hWidget}

    Description : Reduces runtime overhead of using the ValidHandle assertion 

    Author(s)   : 
    Created     : Thu Jun 25 21:33:03 CEST 2015
    Notes       : SCL-875
  ----------------------------------------------------------------------*/
&endif

    if not valid-handle ({1}) then
        undo, throw new Consultingwerk.Exceptions.InvalidHandleException ({2}) .