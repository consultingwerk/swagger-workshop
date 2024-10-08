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
    File        : get-businessservice.i
    Purpose     : Simplify the access of business services form the service
                  manager

    Syntax      : {Consultingwerk/get-businessservice.i <ABL Service Type Name (Class)>}
                  {Consultingwerk/get-businessservice.i Consultingwerk.BusinessEntityDesigner.Services.IFieldNameGeneratorService}

                  Optinal second parameter: The BusinessServiceOperatingModeEnum member

    Description : Returns a reference to a service of the give type. Expectation
                  is that the Business Service name equals the implementing
                  class name as otherwise the CAST would fail

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Sep 25 15:04:07 CEST 2023
    Notes       : Sess Consultingwerk.Framework.ServiceContainer
  ----------------------------------------------------------------------*/

/* ***************************  Main Block  *************************** */

    cast (Consultingwerk.OERA.ServiceManager:GetBusinessService(get-class ({1}):TypeName
    &if "{2}":U ne "":U &then
                   , {2}
    &endif
    ) , {1} )
