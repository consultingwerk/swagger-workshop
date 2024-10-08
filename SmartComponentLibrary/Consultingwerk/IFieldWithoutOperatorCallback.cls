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
    File        : IFieldWithoutOperatorCallback
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Apr 09 05:40:00 CEST 2023
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

using Progress.Lang.*.

interface Consultingwerk.IFieldWithoutOperatorCallback:

    /**
     * Purpose: Validates a logical field name
     * Notes:
     * @param pcFieldName The field name to validate
     * @return Logical value indicating if the field name is a logical field
     */
    method public logical ValidateLogicalField (pcFieldName as character).

end interface.
