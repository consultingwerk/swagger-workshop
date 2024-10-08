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
    File        : ISerializable
    Purpose     : Interface describing methods of Objects that can be
                  used to Serialize and Deserialize Object to potentially
                  carry them across an AppServer boundary or store them
                  in a persistent storage
                  Serialization is done to a LONGCHAR to allow various
                  implementations
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Sep 15 18:07:54 CEST 2010
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

interface Consultingwerk.ISerializable:

    /**
     * Purpose: Returns an LONGCHAR (potentially XML) representation of the
     *          object instance
     * Notes:
     * @return The LONGCHAR representation of the ISerializable objects data
     */
    method public longchar Serialize ().

    /**
     * Purpose: Initializes the object instance based on the passed in LONGCHAR
     *          (potentially XML) representation of the object instance
     * Notes:
     * @param pcSerializedReprasentation The stored LONGCHAR representation of the objects data
     */
    method public void Deserialize (pcSerializedReprasentation as longchar).

end interface.
