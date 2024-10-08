/**********************************************************************
 * Copyright (C) 2006-2018 by Consultingwerk Ltd. ("CW") -            *
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
    File        : IFactoryRegistry
    Purpose     : Interface for Services supporting the IFactory with registering
                  factory types
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Mar 24 10:38:59 CET 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.

INTERFACE Consultingwerk.Framework.IFactoryRegistry:

    /**
     * Purpose: Returns if the given factory is registered
     * Notes:
     * @param poType The type of evaluate
     * @return Logical value indicating if the factory for the given type is registered
     */
    METHOD PUBLIC LOGICAL HasFactory (poType AS Progress.Lang.Class).

    /**
     * Purpose: Returns if the given factory is registered
     * Notes:
     * @param poType The type of evaluate
     * @param pcAlias The type alias
     * @return Logical value indicating if the factory for the given type is registered
     */
    METHOD PUBLIC LOGICAL HasFactory (poType AS Progress.Lang.Class,
                                      pcAlias AS CHARACTER).

    /**
     * Purpose: Registers object factories from the given file
     * Notes:
     * @param pcFileName The file naem to load factories from
     */
    METHOD PUBLIC VOID LoadFromFile (pcFileName AS CHARACTER).

    /**
     * Purpose: Registers an object factory type
     * Notes:
     * @param poType The type to register
     * @param poImplementation The implementation of the type
     */
    METHOD PUBLIC VOID RegisterFactory (poType AS Progress.Lang.Class,
                                        poImplementation AS Progress.Lang.Class).

    /**
     * Purpose: Registers an object factory type
     * Notes:
     * @param poType The type to register
     * @param pcAlias The type alias
     * @param poImplementation The implementation of the type
     */
    METHOD PUBLIC VOID RegisterFactory (poType AS Progress.Lang.Class,
                                        pcAlias AS CHARACTER,
                                        poImplementation AS Progress.Lang.Class).

    /**
     * Purpose: Registers an object factory type
     * Notes:
     * @param poType The type to register
     */
    METHOD PUBLIC VOID UnregisterFactory (poType AS Progress.Lang.Class).

    /**
     * Purpose: Registers an object factory type
     * Notes:
     * @param poType The type to register
     * @param pcAlias The type alias
     */
    METHOD PUBLIC VOID UnregisterFactory (poType AS Progress.Lang.Class,
                                          pcAlias AS CHARACTER).

END INTERFACE.
