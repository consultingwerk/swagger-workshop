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
    File        : foreachGeneric.i
    Purpose     : Simplify the usage of Progress.Collections.Iterators in the ABL, similar
                  to the foreach statement in C#

    Syntax      : {foreachGeneric.i <itemtype> <itemvariable> in <list>}
                  Consultingwerk/foreachGeneric.i System.Collections.DictionaryEntry oEntry in THIS-OBJECT:Model:Shapes

                  The third parameter "in" should always be "in", to simulate the C# syntax.

                  The fifth parameter may be set as "nodefine" to avoid the creation
                  of the variables

                  The sixth parameter may be set as the block label for the DO WHILE loop.

    Description :

    Author(s)   : Peter Judge / Consultingwerk Ltd.
    Created     : Thu Aug 04 15:31:26 EDT 2022
    Notes       : See http://msdn.microsoft.com/en-us/library/ttw7t8t6(v=vs.71).aspx
                  for a reference of the C# foreach statement
  ----------------------------------------------------------------------*/
&endif
&if defined (NativeLists) gt 0 &then
&if "{5}" ne "nodefine" &then
    define variable {2}           as {1} no-undo .
    define variable {2}Enumerator as Progress.Collections.IIterator<{1}> no-undo .
&endif

    assign {2}Enumerator = {4}:GetGenericEnumerator().

    {2}Enumerator:Reset() .

    &if "{6}" ne "" &then {6}: &endif
    do while {2}Enumerator:MoveNext() on error undo, throw:
        assign {2} = {2}Enumerator:Current.
&else
{Consultingwerk/foreachABL.i {1} {2} in {4} {5} {6}}
&endif
