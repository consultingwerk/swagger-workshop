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
    File        : WidgetTypeEnum
    Purpose     : Widget TYPE Constants (CHARACTER)
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Aug 28 16:05:31 CEST 2011
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Progress.Lang.*.

class Consultingwerk.WidgetTypeEnum:

    define public static property AsyncRequest       as character no-undo initial "ASYNC-REQUEST":U        get .
    define public static property Browse             as character no-undo initial "BROWSE":U               get .
    define public static property BrowseColumn       as character no-undo initial "BROWSE-COLUMN":U        get .
    define public static property Buffer             as character no-undo initial "BUFFER":U               get .
    define public static property BufferField        as character no-undo initial "BUFFER-FIELD":U         get .
    define public static property Button             as character no-undo initial "BUTTON":U               get .
    define public static property ComboBox           as character no-undo initial "COMBO-BOX":U            get .
    define public static property ControlFrame       as character no-undo initial "CONTROL-FRAME":U        get .
    define public static property DataRelation       as character no-undo initial "DATA-RELATION":U        get .
    define public static property Dataset            as character no-undo initial "DATASET":U              get .
    define public static property DataSource         as character no-undo initial "DATA-SOURCE":U          get .
    define public static property DialogBox          as character no-undo initial "DIALOG-BOX":U           get .
    define public static property Editor             as character no-undo initial "EDITOR":U               get .
    define public static property FillIn             as character no-undo initial "FILL-IN":U              get .
    define public static property FieldGroup         as character no-undo initial "FIELD-GROUP":U          get .
    define public static property Frame              as character no-undo initial "FRAME":U                get .
    define public static property Image              as character no-undo initial "IMAGE":U                get .
    define public static property Literal            as character no-undo initial "LITERAL":U              get .
    define public static property Menu               as character no-undo initial "MENU":U                 get .
    define public static property MenuItem           as character no-undo initial "MENU-ITEM":U            get .
    define public static property RadioSet           as character no-undo initial "RADIO-SET":U            get .
    define public static property Procedure          as character no-undo initial "PROCEDURE":U            get .
    define public static property Query              as character no-undo initial "QUERY":U                get .
    define public static property Rectangle          as character no-undo initial "RECTANGLE":U            get .
    define public static property SaxAttributes      as character no-undo initial "SAX-ATTRIBUTES":U       get .
    define public static property SaxReader          as character no-undo initial "SAX-READER":U           get .
    define public static property Server             as character no-undo initial "SERVER":U               get .
    define public static property ServerSocket       as character no-undo initial "SERVER-SOCKET":U        get .
    define public static property SelectionList      as character no-undo initial "SELECTION-LIST":U       get .
    define public static property Slider             as character no-undo initial "SLIDER":U               get .
    define public static property SoapFault          as character no-undo initial "SOAP-FAULT":U           get .
    define public static property SoapFaultDetail    as character no-undo initial "SOAP-FAULT-DETAIL":U    get .
    define public static property SoapHeader         as character no-undo initial "SOAP-HEADER":U          get .
    define public static property SoapHeaderEntryRef as character no-undo initial "SOAP-HEADER-ENTRYREF":U get .
    define public static property Socket             as character no-undo initial "SOCKET":U               get .
    define public static property Stream             as character no-undo initial "STREAM":U               get .
    define public static property SubMenu            as character no-undo initial "SUB-MENU":U             get .
    define public static property TempTable          as character no-undo initial "TEMP-TABLE":U           get .
    define public static property Text               as character no-undo initial "TEXT":U                 get .
    define public static property ToggleBox          as character no-undo initial "TOGGLE-BOX":U           get .
    define public static property Window             as character no-undo initial "WINDOW":U               get .
    define public static property XDocument          as character no-undo initial "X-DOCUMENT":U           get .
    define public static property XNodeRef           as character no-undo initial "X-NODEREF":U            get .

    /**
     * Purpose: Disallow instance creation
     * Notes:
     */
    constructor private WidgetTypeEnum ():
        super ().

    end constructor.

end class.