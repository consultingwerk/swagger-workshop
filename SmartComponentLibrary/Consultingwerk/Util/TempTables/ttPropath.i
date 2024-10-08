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
    File        : ttPropath.i
    Purpose     : Temp-Table for the entries of the .propath file 

    Syntax      :

    Description : 

    Author(s)   : 
    Created     : Tue Sep 05 20:33:41 CEST 2017
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

define {1} temp-table ttPropath no-undo 
    field propath_seq      as integer 
    field propath_env      as character 
    field propath_kind     as character
    field propath_output   as character
    field propath_path     as character 
    field propath_platform as character  
    
    index propath_seq is unique primary propath_seq .  