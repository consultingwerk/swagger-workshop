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
    File        : foreachPrimitive.i
    Purpose     : Simplify the usage of Consultingwerk Enumerators in the ABL, similar 
                  to the foreach statement in C# 

    Syntax      : {foreachPrimitive.i <itemtype> <itemvariable> in <list>}
                  Consultingwerk/foreach.i System.Collections.DictionaryEntry oEntry in THIS-OBJECT:Model:Shapes
                  
                  The third parameter "in" should always be "in", to simulate the C# syntax.
            
                  The fifth parameter may be set as "nodefine" to avoid the creation 
                  of the variables
                  
    Description : 

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri May 06 13:32:39 CEST 2011
    Notes       : See http://msdn.microsoft.com/en-us/library/ttw7t8t6(v=vs.71).aspx
                  for a reference of the C# foreach statement
  ----------------------------------------------------------------------*/

&if "{5}" ne "nodefine" &then
    define variable {2}           as {1} no-undo . 
    define variable {2}Enumerator as Consultingwerk.Framework.Collections.{1}DictionaryEnumerator no-undo . 
&endif    
    
    assign {2}Enumerator = {4}:GetEnumerator() .
    
    {2}Enumerator:Reset() .
    
    do while {2}Enumerator:MoveNext() on error undo, throw:
        assign {2} = {2}Enumerator:Current .  
