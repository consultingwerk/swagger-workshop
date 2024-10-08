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
    File        : create-instance.i
    Purpose     : Scaffolding include file for the IFactory:CreateInstance
                  method

    Syntax      : The include file can be used with positional parameters
                  {1} The requested target type (mandatory)
                  {2} ... {16} for up to 15 parameter object references

                  or with named arguments

                  &type The requested target type (mandatory)
                  &alias The optional alias
                  &param1 ... &param10 for up to 15 parameter object references

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun Mar 31 18:56:38 CEST 2019
    Notes       :
  ----------------------------------------------------------------------*/

&if "{&type}" = "" &then

cast ({Consultingwerk/get-mandatory-service.i Consultingwerk.Framework.IFactory}:CreateInstance (
&if proversion begins "10" or proversion eq "11.0" or proversion eq "11.1" or proversion eq "11.2" or proversion eq "11.3" &then
    Progress.Lang.Class:GetClass ("{1}":U)
&else
    get-class ({1})
&endif

&if "{2}":U ne "":U &then
    ,
    Consultingwerk.Util.ArrayHelper:Array ({2}
                                           &if "{3}":U ne "":U &then , {3} &endif
                                           &if "{4}":U ne "":U &then , {4} &endif
                                           &if "{5}":U ne "":U &then , {5} &endif
                                           &if "{6}":U ne "":U &then , {6} &endif
                                           &if "{7}":U ne "":U &then , {7} &endif
                                           &if "{8}":U ne "":U &then , {8} &endif
                                           &if "{9}":U ne "":U &then , {9} &endif
                                           &if "{10}":U ne "":U &then , {10} &endif
                                           &if "{11}":U ne "":U &then , {11} &endif
                                           &if "{12}":U ne "":U &then , {12} &endif
                                           &if "{13}":U ne "":U &then , {13} &endif
                                           &if "{14}":U ne "":U &then , {14} &endif
                                           &if "{15}":U ne "":U &then , {15} &endif
                                           &if "{16}":U ne "":U &then , {16} &endif
                                           )
&endif
    ),
    {1})

&else

cast ({Consultingwerk/get-mandatory-service.i Consultingwerk.Framework.IFactory}:CreateInstance (
&if proversion begins "10" or proversion eq "11.0" or proversion eq "11.1" or proversion eq "11.2" or proversion eq "11.3" &then
    Progress.Lang.Class:GetClass ("{&type}":U)
&else
    get-class ({1})
&endif

&if defined (param1) ne 0 &then
    ,
    Consultingwerk.Util.ArrayHelper:Array ({&param1}
                                           &if "{&param2}":U ne "":U &then , {&param2} &endif
                                           &if "{&param3}":U ne "":U &then , {&param3} &endif
                                           &if "{&param4}":U ne "":U &then , {&param4} &endif
                                           &if "{&param5}":U ne "":U &then , {&param5} &endif
                                           &if "{&param6}":U ne "":U &then , {&param6} &endif
                                           &if "{&param7}":U ne "":U &then , {&param7} &endif
                                           &if "{&param8}":U ne "":U &then , {&param8} &endif
                                           &if "{&param9}":U ne "":U &then , {&param9} &endif
                                           &if "{&param10}":U ne "":U &then , {&param10} &endif
                                           &if "{&param11}":U ne "":U &then , {&param11} &endif
                                           &if "{&param12}":U ne "":U &then , {&param12} &endif
                                           &if "{&param13}":U ne "":U &then , {&param13} &endif
                                           &if "{&param14}":U ne "":U &then , {&param14} &endif
                                           &if "{&param15}":U ne "":U &then , {&param15} &endif
                                           )
&endif
    ),
    {1})

&endif

