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
    File        : IsAvailable.i
    Purpose     : Include File base Assertion for IsAvailable

    Syntax      : {Consultingwerk/Assertion/BufferAssert/IsAvailable.i hBuffer}
                  {Consultingwerk/Assertion/BufferAssert/IsAvailable.i "BUFFER Customer:HANDLE"}

    Description : Reduces runtime overhead of using the IsAvailable assertion

    Author(s)   :
    Created     : Thu Jun 25 21:33:03 CEST 2015
    Notes       : SCL-875
  ----------------------------------------------------------------------*/
&endif

    do:
        /* Mike Fechner, Consultingwerk Ltd. 23.06.2015
           As this is fairly frequently called, don't call into ValidHandle */
        if not valid-handle ({1}) then
            undo, throw new Consultingwerk.Exceptions.InvalidHandleException ("BUFFER":U) .

        if {1}:type <> "BUFFER":U then
            undo, throw new Consultingwerk.Exceptions.InvalidTypeException ("BUFFER":U, {1}:type) .

        if not {1}:available then
            undo, throw new Consultingwerk.Assertion.BufferAssert.RecordNotAvailableAssertException (substitute ("No record is available in buffer &1."{&TRAN},
                                                                                                                 {1}:name),
                                                                                                     0,
                                                                                                     {1}:name) .
    end.