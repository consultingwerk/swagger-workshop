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
    File        : template-schema-type.i
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     : Tue Sep 05 22:26:07 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

using Consultingwerk.*                     from propath.
using Consultingwerk.Studio.SwaggerToAbl.* from propath.
using Consultingwerk.Util.*                from propath.
using Consultingwerk.Util.LoggingStream.*  from propath.
using Progress.Json.ObjectModel.*          from propath.

&global-define OUT put stream out unformatted

define input  parameter poClassName          as ClassName                           no-undo.
define input  parameter poSchema             as JsonObject                          no-undo.
define input  parameter poApiSpec            as JsonObject                          no-undo.
define input  parameter poGeneratorParameter as SwaggerSchemaTypeGeneratorParameter no-undo.
define input  parameter poLoggingStream      as ILoggingStream                      no-undo.
define output parameter pcOutputFile         as character                           no-undo.

define stream out .

/* ***************************  Main Block  *************************** */

{Consultingwerk\Studio\SwaggerToAbl\template-main.i}
