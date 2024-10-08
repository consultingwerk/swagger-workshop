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
    File        : IFactory
    Purpose     : Generic Interface for Factory services
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat Mar 24 09:01:07 CET 2018
    Notes       :
  ----------------------------------------------------------------------*/

USING Ccs.Common.*               FROM PROPATH .
USING Consultingwerk.Framework.* FROM PROPATH .
USING Progress.Lang.*            FROM PROPATH .

INTERFACE Consultingwerk.Framework.IFactory
    INHERITS IService:

    /**
     * Purpose: Creates an object instance
     * Notes:   Factory method for object instances referenced by the provided
     *          type (typically an interface)
     * @param poType The type to create an instance of
     * @return The created object instance
     */
    METHOD PUBLIC Progress.Lang.Object CreateInstance (poType AS Progress.Lang.Class).

    /**
     * Purpose: Creates an object instance
     * Notes:   Factory method for object instances referenced by the provided
     *          type (typically an interface)
     * @param poType The type to create an instance of
     * @param pcAlias The alias of the object
     * @return The created object instance
     */
    METHOD PUBLIC Progress.Lang.Object CreateInstance (poType AS Progress.Lang.Class,
                                                       pcAlias AS CHARACTER).

    /**
     * Purpose: Creates an object instance
     * Notes:   Factory method for object instances referenced by the provided
     *          type (typically an interface)
     * @param poType The type to create an instance of
     * @param poParameters An array of parameters to pass to the object's constructor, Holder types will be passed as their Value to the constructor
     * @return The created object instance
     */
    METHOD PUBLIC Progress.Lang.Object CreateInstance (poType AS Progress.Lang.Class,
                                                       poParameters AS Progress.Lang.Object EXTENT).

    /**
     * Purpose: Creates an object instance
     * Notes:   Factory method for object instances referenced by the provided
     *          type (typically an interface)
     * @param poType The type to create an instance of
     * @param pcAlias The alias of the object
     * @param poParameters An array of parameters to pass to the object's constructor, Holder types will be passed as their Value to the constructor
     * @return The created object instance
     */
    METHOD PUBLIC Progress.Lang.Object CreateInstance (poType AS Progress.Lang.Class,
                                                       pcAlias AS CHARACTER,
                                                       poParameters AS Progress.Lang.Object EXTENT).

END INTERFACE.
