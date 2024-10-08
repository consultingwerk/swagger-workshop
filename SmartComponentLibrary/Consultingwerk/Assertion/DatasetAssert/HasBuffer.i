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
    File        : HasBuffer.i
    Purpose     : Include File base Assertion for HasBuffer

    Syntax      : {Consultingwerk/Assertion/DatasetAssert/HasBuffer.i hDataset ""eCustomer""}
                  {Consultingwerk/Assertion/DatasetAssert/HasBuffer.i hDataset "ENTRY (i, cBuffers)"}
                  {Consultingwerk/Assertion/DatasetAssert/HasBuffer.i "DATASET dsCustomer:HANDLE" ""eCustomer""}

    Description : Reduces runtime overhead of using the HasBuffer assertion

    Author(s)   :
    Created     : Thu Jun 25 21:33:03 CEST 2015
    Notes       : SCL-875
  ----------------------------------------------------------------------*/
&endif

    do:
        {Consultingwerk/Assertion/HandleAssert/WidgetType.i "{1}" Consultingwerk.WidgetTypeEnum:Dataset}

        if not valid-handle ({1}:get-buffer-handle ({2})) then

            undo, throw new Consultingwerk.Assertion.AssertException (substitute ("The dataset has &1 has no buffer &2."{&TRAN},
                                                                                  {1}:name,
                                                                                  {2}),
                                                                      0) .
    end.
