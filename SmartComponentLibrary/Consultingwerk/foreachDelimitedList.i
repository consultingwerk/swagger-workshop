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
    File        : foreachDelimitedList.i
    Purpose     : Simplify the usage of Arrays in iterating loops in the ABL,
                  similar to the foreach statement in C#. Works with Arrays
                  of primitive types and objects

    Syntax      : {foreachDelimitedList.i <itemtype> <itemvariable> in <list>}

                  The third parameter "in" should always be "in", to simulate the C# syntax.

                  The fifth parameter may defined the list delimiter, defaults to , (comma), e.g. '|' or CHR(1)

                  The sixth parameter may be set as "nodefine" to avoid the creation
                  of the variables

                  The seventh parameter may be set as the block label for the DO WHILE loop.

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri May 06 13:32:39 CEST 2011
    Notes       : See http://msdn.microsoft.com/en-us/library/ttw7t8t6(v=vs.71).aspx
                  for a reference of the C# foreach statement
  ----------------------------------------------------------------------*/

&if "{6}" ne "nodefine" &then
    define variable {2}           as {1}     no-undo .
    define variable {2}Enumerator as integer no-undo .
    define variable {2}max        as integer no-undo .
&endif

    assign {2}max = num-entries ({4} &if "{5}" ne "" &then , {5} &endif ) .

    &if "{7}" ne "" &then {7}: &endif
    do {2}Enumerator = 1 to {2}max on error undo, throw:
        assign {2} = &if "{1}" ne "character" &then {1} &endif ( entry ({2}Enumerator, {4} &if "{5}" ne "" &then , {5} &endif )) .
