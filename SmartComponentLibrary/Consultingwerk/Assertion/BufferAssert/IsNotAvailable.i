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
    File        : IsNotAvailable.i
    Purpose     : Include File base Assertion for IsNotAvailable

    Syntax      : {Consultingwerk/Assertion/BufferAssert/IsNotAvailable.i hBuffer}
                  {Consultingwerk/Assertion/BufferAssert/IsNotAvailable.i "BUFFER Customer:HANDLE"}

    Description : Reduces runtime overhead of using the IsNotAvailable assertion

    Author(s)   : Mark Bartscherer / Consultingwerk Ltd.
    Created     : Tue Nov 29 12:30:19 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/
&endif

    do:
        /* Mike Fechner, Consultingwerk Ltd. 23.06.2015
           As this is fairly frequently called, don't call into ValidHandle */
        if not valid-handle ({1}) then
            undo, throw new Consultingwerk.Exceptions.InvalidHandleException ("BUFFER":U) .

        if {1}:type <> "BUFFER":U then
            undo, throw new Consultingwerk.Exceptions.InvalidTypeException ("BUFFER":U, {1}:type) .

        if {1}:available then
            undo, throw new Consultingwerk.Assertion.AssertException (substitute ("Unexpected record is available in buffer &1."{&TRAN},
                                                                                  {1}:name),
                                                                      0) .
    end.