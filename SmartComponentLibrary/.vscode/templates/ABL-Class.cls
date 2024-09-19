##@@##     ${input#Class file name (incl. extension)#}
/**********************************************************************
 * Copyright (c) ${dateTimeFormat#template=${year}#}-${dateTimeFormat#template=${year}#} by Consultingwerk Ltd. ("CW") -            *
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
    File        : ${relativeFile|find=(\.cls$)|replace=|flags=g|find=/|replace=.|flags=g|find=([a-zA-Z0-9#$%_]+)(\.)|replace=|flags=g|}
    Purpose     : ${input#Class purpose#}
    Syntax      :
    Description :
    Author(s)   : ${author} / Consultingwerk Ltd.
    Created     : ${dateTimeFormat#options={"year":"numeric","month":"2-digit","day":"2-digit"}#template=${year}-${month}-${day}#}
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

using Consultingwerk.*               from propath.
using Consultingwerk.Assertion.*     from propath.
using Consultingwerk.Util.*          from propath.
using ${relativeFile|find=(cls$)|replace=|flags=g|find=\/|replace=.|flags=g|find=(\.[a-zA-Z0-9#$%_]*\.)$|replace=.*|flags=g|} from propath.

class ${relativeFile#find=(\.cls$)#replace=#flags=g#find=/#replace=.#flags=g#}:

    /**
     * Purpose: Default constructor for ${relativeFile|find=(\.cls$)|replace=|flags=g|find=/|replace=.|flags=g|find=([a-zA-Z0-9#$%_]+)(\.)|replace=|flags=g|}
     * Notes:
     */
    constructor public ${relativeFile|find=(\.cls$)|replace=|flags=g|find=/|replace=.|flags=g|find=([a-zA-Z0-9#$%_]+)(\.)|replace=|flags=g|} ():
        ${cursor}
    end constructor.

end class.
