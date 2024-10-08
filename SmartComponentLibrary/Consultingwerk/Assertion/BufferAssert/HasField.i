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
    File        : HasField.i
    Purpose     : Include File base Assertion for HasField

    Syntax      : {Consultingwerk/Assertion/BufferAssert/HasField.i hBuffer ""FieldName""}
                  {Consultingwerk/Assertion/BufferAssert/HasField.i hBuffer "ENTRY (i, cFields)"}
                  {Consultingwerk/Assertion/BufferAssert/HasField.i "BUFFER Customer:HANDLE" ""CustNum""}

    Description : Reduces runtime overhead of using the HasField assertion

    Author(s)   :
    Created     : Thu Jun 25 21:33:03 CEST 2015
    Notes       : SCL-875
  ----------------------------------------------------------------------*/
&endif

    do:
        {Consultingwerk/Assertion/HandleAssert/WidgetType.i "{1}" Consultingwerk.WidgetTypeEnum:Buffer}

        if not Consultingwerk.Util.BufferHelper:HasField ({1},
                                                          {2}) then

            undo, throw new Consultingwerk.Assertion.AssertException (substitute ("The buffer &1 has no field named &2."{&TRAN},
                                                                                  {1}:name,
                                                                                  {2}),
                                                                      0) .
    end.