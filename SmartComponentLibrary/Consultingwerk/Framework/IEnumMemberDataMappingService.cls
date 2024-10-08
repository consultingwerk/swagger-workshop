/**********************************************************************
 * Copyright (C) 2006-2023 by Consultingwerk Ltd. ("CW") -            *
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
    File        : IEnumMemberDataMappingService
    Purpose     : Interface for services supporting mapping of enum members
                  to data values
    Syntax      :
    Description : Typically used to map character field values containing
                  special characters to enum members
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sat May 02 14:22:45 CEST 2020
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

interface Consultingwerk.Framework.IEnumMemberDataMappingService:

    /**
     * Purpose: Returns the mapped data value for an enum member
     * Notes:
     * @param poClass  The reference to the Enum class
     * @param pcDataValue The mapped data value
     * @return The mapped enum member name
     */
    method public character GetEnumMemberName (poClass as Progress.Lang.Class,
                                               pcDataValue as character) .

    /**
     * Purpose: Returns the mapped data value for an enum member
     * Notes:
     * @param poClass  The reference to the Enum class
     * @param pcEnumMember The name of the enum member
     * @return The mapped data value
     */
    method public character GetMappedDataValue (poClass as Progress.Lang.Class,
                                                pcEnumMember as character) .

end interface.
