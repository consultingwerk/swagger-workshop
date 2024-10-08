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
    File        : LogicalFieldNameValidator
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Apr 09 05:43:54 CEST 2023
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

using Consultingwerk.*                       from propath.
using Consultingwerk.Framework.Collections.* from propath.
using Progress.Lang.*                        from propath.

class Consultingwerk.LogicalFieldNameValidator
    implements IFieldWithoutOperatorCallback:

    define variable oList as CharacterList no-undo .

    /**
     * Purpose: Validates a logical field name
     * Notes:
     * @param pcFieldName The field name to validate
     * @return Logical value indicating if the field name is a logical field
     */
    method public logical ValidateLogicalField (pcFieldName as character):

        return oList:ContainsValue (pcFieldName) .

    end method .

    /**
     * Purpose: Constructor for the LogicalFieldNameValidator class
     * Notes:
     * @param pcFieldList The List of supported logical field names
     */
    constructor public LogicalFieldNameValidator (pcFieldList as character):

        oList = new CharacterList (pcFieldList).

    end constructor.

end class.
