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
    File        : get-service.i
    Purpose     : Simplify the access of services form the default
                  service container

    Syntax      : {Consultingwerk/get-service.i <ABL Service Type Name (Class)>}
                  {Consultingwerk/get-service.i Consultingwerk.BusinessEntityDesigner.Services.IFieldNameGeneratorService}

                  Optinal second parameter: A reference (NEW statament) to the
                  default service implementation

    Description : Returns a reference to a service of a give type, typically
                  an Interface type. Allows singleton like classes (framework
                  components) that are not tied to an actual class name, but
                  to an interface

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Aug 02 14:12:07 CEST 2011
    Notes       : Sess Consultingwerk.Framework.ServiceContainer
  ----------------------------------------------------------------------*/

/* ***************************  Main Block  *************************** */

&if proversion begins "10" or proversion eq "11.0" or proversion eq "11.1" or proversion eq "11.2" or proversion eq "11.3" &then
    &if "{2}":U eq "":U &then
    cast (Consultingwerk.Framework.FrameworkSettings:ServiceContainer:GetService
                    (Progress.Lang.Class:GetClass ("{1}":U)),
                     {1})
    &else
    (if valid-object (Consultingwerk.Framework.FrameworkSettings:ServiceContainer:GetService
                                (Progress.Lang.Class:GetClass ("{1}":U))) then
            cast (Consultingwerk.Framework.FrameworkSettings:ServiceContainer:GetService
                        (Progress.Lang.Class:GetClass ("{1}":U)), {1})
        else
            cast (Consultingwerk.Framework.FrameworkSettings:ServiceContainer:AddNewService
                        (Progress.Lang.Class:GetClass ("{1}":U), {2}), {1})
    )
    &endif
&else
    &if "{2}":U eq "":U &then
    cast (Consultingwerk.Framework.FrameworkSettings:ServiceContainer:GetService
                    (get-class ({1})),
                     {1})
    &else
    (if valid-object (Consultingwerk.Framework.FrameworkSettings:ServiceContainer:GetService
                                (get-class ({1}))) then
            cast (Consultingwerk.Framework.FrameworkSettings:ServiceContainer:GetService
                        (get-class ({1})), {1})
        else
            cast (Consultingwerk.Framework.FrameworkSettings:ServiceContainer:AddNewService
                        (get-class ({1}), {2}), {1})
    )
    &endif
&endif
