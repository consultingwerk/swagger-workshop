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
    File        : IsValid.i
    Purpose     : Include File base Assertion for IsValid
            
    Syntax      : {Consultingwerk/Assertion/ObjectAssert/IsValid.i oObject """Description"":U"}
                  {Consultingwerk/Assertion/ObjectAssert/IsValid.i oObject}

    Description : Reduces runtime overhead of using the IsValid assertion 

    Author(s)   : 
    Created     : Thu Jun 25 21:33:03 CEST 2015
    Notes       : SCL-875
  ----------------------------------------------------------------------*/
&endif

    if not valid-object ({1}) then
        undo, throw new Consultingwerk.Exceptions.InvalidReferenceException ({2}) .