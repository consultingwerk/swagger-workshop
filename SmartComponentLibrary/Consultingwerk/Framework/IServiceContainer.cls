/**********************************************************************
 * Copyright (C) 2006-2013 by Consultingwerk Ltd. ("CW") -            *
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
    File        : IServiceContainer
    Purpose     : Provides a container for services.
    Syntax      :
    Description : General purpose interface to manage services by type / class
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Thu Dec 23 13:01:38 CET 2010
    Notes       : see System.ComponentModel.Design.IServiceContainer
                  http://msdn.microsoft.com/en-us/library/system.componentmodel.design.iservicecontainer.aspx
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

INTERFACE Consultingwerk.Framework.IServiceContainer:

    /**
     * Purpose: Adds the specified service to the service container.
     * Notes:
     * @param poClass The reference to the class or interface of the service to add
     * @param poObject An instance of the service type to add. This object must implement or inherit from the type indicated by the serviceType parameter
     * @return The reference to the service that was added (poObject). This allows fluid style usage of this routine
     */
    METHOD PUBLIC Progress.Lang.Object AddService (poClass AS Progress.Lang.Class,
                                                   poObject AS Progress.Lang.Object).

    /**
     * Purpose: Disposes all services
     * Notes:   Calls dispose() on CCS IService implementations
     */
    METHOD PUBLIC VOID DisposeServices ().

    /**
     * Purpose: Adds the specified service to the service container.
     * Notes:   If the Service implements the CCS IService Interface, we'll call the
     *          initialize() method. This method is intended to be used by the
     *          get-service.i include file with CCS style services that reqiure to the
     *          initialize()'d
     * @param poClass The reference to the class or interface of the service to add
     * @param poObject An instance of the service type to add. This object must implement or inherit from the type indicated by the serviceType parameter
     * @return The reference to the service that was added (poObject). This allows fluid style usage of this routine
     */
    METHOD PUBLIC Progress.Lang.Object AddNewService (poClass AS Progress.Lang.Class,
                                                      poObject AS Progress.Lang.Object).

    /**
     * Purpose: Gets the service object of the specified type.
     * Notes:   Throws an ServiceNotRegisteredException when no service of that type
     *          registered
     * @param poClass The reference to the class or interface of the service to return
     * @return The reference to the instance of the service of ? when the service is not registered with the service container
     */
    METHOD PUBLIC Progress.Lang.Object GetMandatoryService (poClass AS Progress.Lang.Class).

    /**
     * Purpose: Gets the service object of the specified type.
     * Notes:   Returns ? when no service of that type is registered
     * @param poClass The reference to the class or interface of the service to return
     * @return The reference to the instance of the service of ? when the service is not registered with the service container
     */
    METHOD PUBLIC Progress.Lang.Object GetService (poClass AS Progress.Lang.Class).

    /**
     * Purpose: Returns if the given object instance is registered as a Service
     *          in the service container of the overloading service container
     * Notes:
     * @param poService The Service instance to check
     * @return Logical value indicating if the object instance is registered as a service
     */
    METHOD PUBLIC LOGICAL IsRegistered (poService AS Progress.Lang.Object) .

    /**
     * Purpose: Reloads the Service instance
     * Notes:   Does not actively delete the existing service instance, it will
     *          just be deregistered
     *          - creates a new instance of the currently loadad service using the default constructor
     *          - removes the existing service from the service container
     *          - adds the new service to the service container and calls initialize() when it's a CCS IService
     * @param poClass as Progress.Lang.Class
     * @return The reference to the new Service Instance
     */
    METHOD PUBLIC Progress.Lang.Object ReloadService (poClass AS Progress.Lang.Class) .

    /**
     * Purpose: Removes the specified service type from the service container.
     * Notes:
     * @param poClass The reference to the class or interface of the service to remove from the service container.
     */
    METHOD PUBLIC VOID RemoveService (poClass AS Progress.Lang.Class).

END INTERFACE.
