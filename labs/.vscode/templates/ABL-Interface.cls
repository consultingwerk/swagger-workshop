##@@##     ${input#Classname#}
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
    File        : ${relativeFile#find=(\.cls$)#replace=#flags=g#find=/#replace=.#flags=g#}
    Purpose     : ${input#description#}
    Syntax      :
    Description :
    Author(s)   : ${author} / Consultingwerk Ltd.
    Created     : ${dateTimeFormat#options={"year":"numeric","month":"2-digit","day":"2-digit"}#template=${year}-${month}-${day}#}
    Notes       :
  ----------------------------------------------------------------------*/

@lowercase.

{Consultingwerk/products.i}

using ${relativeFile|find=(cls$)|replace=|flags=g|find=\/|replace=.|flags=g|find=(\.[a-zA-Z0-9#$%_]*\.)$|replace=.*|flags=g|} from propath.

interface ${relativeFile#find=(\.cls$)#replace=#flags=g#find=/#replace=.#flags=g#}:

    ${cursor}

end interface.
