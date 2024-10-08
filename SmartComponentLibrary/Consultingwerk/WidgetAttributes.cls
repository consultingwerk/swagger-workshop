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
    File        : WidgetAttributes
    Purpose     : Can verify widget attribute names
    Syntax      :
    Description : Useful as the LIST-QUERY-ATTRS ABL function does return
                  attribute names and methods. This class provides a way
                  to verify if an attribute name is valid.
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Jul 13 20:13:17 CEST 2015
    Notes       : Relies in widgetattributes.xml created by
                  Consultingwerk.Studio.OpenEdgeDocs.ParseIndexXmlForAttributes
                  Used by WidgetHelper:ShowWidgetProperties and LogManager:WriteWidgetProperties
                  to avoid calling into GET-ATTR-CALL-TYPE type calls for widget
                  methods (as the LIST-QUERY-ATTRS does not allow to distinguish)
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.Framework.Collections.* from propath .
using Consultingwerk.*                       from propath .
using Consultingwerk.Util.*                  from propath .
using Progress.Lang.*                        from propath .

class Consultingwerk.WidgetAttributes:

    define static temp-table ttWidgetAttributes no-undo
        field AttributeName as character
        index AttributeName is unique primary AttributeName .

    /**
     * Purpose: Constructor for the WidgetAttributes class
     * Notes:   Disallow instance creation
     */
    constructor private WidgetAttributes ():
        super ().

    end constructor.

    /**
     * Purpose: Constructor for the WidgetAttributes class
     * Notes:
     */
    constructor static WidgetAttributes ():

        if FileHelper:Exists ("Consultingwerk/widgetattributes.xml":U) then
            temp-table ttWidgetAttributes:read-xml ("file":U, FileHelper:FindFile ("Consultingwerk/widgetattributes.xml":U), ?, ?, ?) .

    end constructor.

    /**
     * Purpose: Verifies that an Attribute name is valid
     * Notes:
     * @param pcAttributeName The name of the attribute to verify
     * @return Logical value indicating that the attribute name is valid
     */
    method public static logical IsValid (pcAttributeName as character):

        return can-find (ttWidgetAttributes where ttWidgetAttributes.AttributeName = pcAttributeName) .

    end method .

    /**
     * Purpose: Returns a List of all widget attributes
     * Notes:
     * @return The CharacterList of all widget attributes
     */
    method public static CharacterList ToList ():

        define variable oList as CharacterList no-undo.

        oList = new CharacterList () .

        for each ttWidgetAttributes on error undo, throw:
            oList:Add (ttWidgetAttributes.AttributeName) .
        end.

        return oList .

    end method .

end class.
