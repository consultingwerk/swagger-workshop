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
    File        : JsonSerializableProperty11.i
    Purpose     : Defines a Serializable Property in a child class of
                  Consultingwerk.JsonSerializable

    Syntax      : {Consultingwerk/JsonSerializableProperty11.i Name Data-Type "Other Definition"}

                  Dynamic extent Array-Support, currently only for array's of objects, not primitives:
                  {Consultingwerk/JsonSerializableProperty.i Name "Data-Type EXTENT" "Other Definition"}

                  The third parameter (Other Definition) is optional

    Description : This version of the file does not provide backwards compatibility
                  with the XML based serialization (OpenEdge 10.2B). If you do
                  require the backwards compatibility, please use the
                  JsonSerializableProperty.i include file

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Jun 29 19:32:14 CEST 2012
    Notes       : You are not supposed to use the SerializableProperties
                  for other purposes than using it in the JsonSerializable
                  base class - as we may be changing the format of this
                  property without warning.
  ----------------------------------------------------------------------*/
&endif

    define public property {1} as {2} no-undo {3}
    get.
    set.

&if "{&SerializableProperties}":U ne "":U &then
&global-define SerializableProperties {&SerializableProperties},{1},{2}
&else
&global-define SerializableProperties {1},{2}
&endif
