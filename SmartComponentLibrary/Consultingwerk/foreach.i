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
    File        : foreach.i
    Purpose     : Simplify the usage of Enumerators in the ABL, similar
                  to the foreach statement in C#

    Syntax      : {foreach <itemtype> <itemvariable> in <list>}
                  Consultingwerk/foreach.i System.Collections.DictionaryEntry oEntry in THIS-OBJECT:Model:Shapes

                  The third parameter "in" should always be "in", to simulate the C# syntax.

                  The fifth parameter may be set as "nodefine" to avoid the creation
                  of the variables

                  The sixth parameter may be set as the block label for the DO WHILE loop.

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri May 06 13:32:39 CEST 2011
    Notes       : See http://msdn.microsoft.com/en-us/library/ttw7t8t6(v=vs.71).aspx
                  for a reference of the C# foreach statement
  ----------------------------------------------------------------------*/

&if "{5}" ne "nodefine" &then
    define variable {2}           as {1} no-undo .
    define variable {2}Enumerator as System.Collections.IEnumerator no-undo .
&endif

    assign {2}Enumerator = cast({4}, System.Collections.IEnumerable):GetEnumerator() .

    {2}Enumerator:Reset() .

    &if "{6}" ne "" &then {6}: &endif
    do while {2}Enumerator:MoveNext() on error undo, throw:
        assign {2} = cast({2}Enumerator:Current, {1}) .
