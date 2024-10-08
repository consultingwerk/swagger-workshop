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
    File        : WidgetType.i
    Purpose     : Include File base Assertion for WidgetType
            
    Syntax      : {Consultingwerk/Assertion/HandleAssert/WidgetType.i hWidget ""QUERY"":U}
                  {Consultingwerk/Assertion/HandleAssert/WidgetType.i hWidget WidgetTypeEnum:Query}
                  {Consultingwerk/Assertion/HandleAssert/WidgetType.i hWidget cType}

    Description : Reduces runtime overhead of using the WidgetType assertion 

    Author(s)   : 
    Created     : Thu Jun 25 10:10:51 CEST 2015
    Notes       : SCL-875
  ----------------------------------------------------------------------*/
&endif

    do:
        /* Mike Fechner, Consultingwerk Ltd. 23.06.2015
           As this is fairly frequently called, don't call into ValidHandle */
        if not valid-handle ({1}) then
            undo, throw new Consultingwerk.Exceptions.InvalidHandleException ({2}) .
        
        if {1}:type <> {2} then
            undo, throw new Consultingwerk.Exceptions.InvalidTypeException ({2}, {1}:type) .
    end.