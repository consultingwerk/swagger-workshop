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
    File        : SerializableProperty.i
    Purpose     : Defines a Serializable Property in a child class of
                  Consultingwerk.Serializable

    Syntax      : {Consultingwerk/SerializableProperty.i Name Data-Type "Other Definition"}
                  The third parameter (Other Definition) is optional

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Sep 17 14:18:14 CEST 2010
    Notes       : The XmlSerializable class does also support nested objects,
                  where the second parameter does not equal a built in ABL
                  primitive data type, the Consultingwerk.Serializable class
                  however does
  ----------------------------------------------------------------------*/
&endif
&if "{2}" = "CHARACTER" or
    "{2}" = "DATE" or
    "{2}" = "DATETIME" or
    "{2}" = "DATETIME-TZ" or
    "{2}" = "DECIMAL" or
    "{2}" = "INT64" or
    "{2}" = "INTEGER" or
    "{2}" = "LOGICAL" or
    "{2}" = "LONGCHAR" or
    "{2}" = "RAW" or
    "{2}" = "ROWID" &then
    define public property {1} as {2} no-undo {3}
    get:
        return this-object:Get{2}Property ("{1}":U) .
    end get.
    set(input arg as {2}):
        this-object:Set{2}Property ("{1}":U, arg) .
    end set.
&else
    define public property {1} as {2} no-undo {3}
    get:
        return cast (this-object:GetObjectProperty ("{1}":U),
                     {2}) .
    end get.
    set(input arg as {2}):
        this-object:SetObjectProperty ("{1}":U, arg) .
    end set.
&endif

&if "{&SerializableProperties}":U ne "":U &then
&global-define SerializableProperties {&SerializableProperties},{1},{2}
&else
&global-define SerializableProperties {1},{2}
&endif
