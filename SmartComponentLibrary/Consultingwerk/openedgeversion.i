&if 1=0 &then
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
    File        : openedgeversion.i
    Purpose     : Defines preprocessor variables with OpenEdge releases

    Syntax      :

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri Sep 09 19:35:50 CEST 2022
    Notes       :
  ----------------------------------------------------------------------*/
&endif

&if proversion begins "11.7" &then
&global-define OpenEdge_11_7
&endif

&if proversion begins "12.0" &then
&global-define OpenEdge_11_7
&global-define OpenEdge_12_0
&endif

&if proversion begins "12.1" &then
&global-define OpenEdge_11_7
&global-define OpenEdge_12_0
&global-define OpenEdge_12_1
&endif

&if proversion begins "12.2" &then
&global-define OpenEdge_11_7
&global-define OpenEdge_12_0
&global-define OpenEdge_12_1
&global-define OpenEdge_12_2
&endif

&if proversion begins "12.3" &then
&global-define OpenEdge_11_7
&global-define OpenEdge_12_0
&global-define OpenEdge_12_1
&global-define OpenEdge_12_2
&global-define OpenEdge_12_3
&endif

&if proversion begins "12.4" &then
&global-define OpenEdge_11_7
&global-define OpenEdge_12_0
&global-define OpenEdge_12_1
&global-define OpenEdge_12_2
&global-define OpenEdge_12_3
&global-define OpenEdge_12_4
&endif

&if proversion begins "12.5" &then
&global-define OpenEdge_11_7
&global-define OpenEdge_12_0
&global-define OpenEdge_12_1
&global-define OpenEdge_12_2
&global-define OpenEdge_12_3
&global-define OpenEdge_12_4
&global-define OpenEdge_12_5
&endif

&if proversion begins "12.6" &then
&global-define OpenEdge_11_7
&global-define OpenEdge_12_0
&global-define OpenEdge_12_1
&global-define OpenEdge_12_2
&global-define OpenEdge_12_3
&global-define OpenEdge_12_4
&global-define OpenEdge_12_5
&global-define OpenEdge_12_6
&endif

&if proversion begins "12.7" &then
&global-define OpenEdge_11_7
&global-define OpenEdge_12_0
&global-define OpenEdge_12_1
&global-define OpenEdge_12_2
&global-define OpenEdge_12_3
&global-define OpenEdge_12_4
&global-define OpenEdge_12_5
&global-define OpenEdge_12_6
&global-define OpenEdge_12_7
&endif

&if proversion begins "12.8" &then
&global-define OpenEdge_11_7
&global-define OpenEdge_12_0
&global-define OpenEdge_12_1
&global-define OpenEdge_12_2
&global-define OpenEdge_12_3
&global-define OpenEdge_12_4
&global-define OpenEdge_12_5
&global-define OpenEdge_12_6
&global-define OpenEdge_12_7
&global-define OpenEdge_12_8
&endif
