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
    File        : GarbageCollectorHelper
    Purpose     :
    Syntax      : Static methods only, private constructor to disallow
                  instance creation
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Jan 13 23:36:38 CET 2010
    Notes       : This file is intended for GUI for .NET only
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{ Consultingwerk/products.i }

using Consultingwerk.Framework.*       from propath.
using Consultingwerk.Util.*            from propath.
using Consultingwerk.Util.Exceptions.* from propath.
&if defined (DotNetAccessible) ne 0 &then
using Infragistics.Win.UltraWinGrid.* from assembly.
using Infragistics.Win.UltraWinTree.* from assembly .
using Progress.Lang.*                 from assembly .
&endif

class Consultingwerk.Util.GarbageCollectorHelper:

    /**
     * Purpose: Protected default constructor.
     * Notes:   There's no need to create instances of the helper classes
     */
    constructor protected GarbageCollectorHelper ():
        super ().

    end constructor.

&if defined (DotNetAccessible) ne 0 and defined (Infragistics) ne 0 &then
    /**
     * Purpose: Clears references to the UltraGrid cells EditorComponent
     * Notes:   See SCL-2305 for details. Those references seem to be circular references
     *          and cause the grid not to be GC'ed when a Form is closed. Invoked from
     *          the BaseForm:OnFormClosed method
     * @param poUltraGrid The reference to the UltraTree object
     */
    method public static void ClearUltraGridColumnEditors (poUltraGrid as UltraGrid):

        /* SCL-2534 */
        do on error undo, throw:
            if not valid-object (poUltraGrid) or not valid-object (poUltraGrid:DisplayLayout) or not valid-object (poUltraGrid:DisplayLayout:Bands) then
                return .

            catch uncaught as System.ApplicationException:
                /* Might happen while Form is being disposed */
                return .
            end catch.
        end.

        {Consultingwerk/foreach.i UltraGridBand oBand in poUltraGrid:DisplayLayout:Bands}
            {Consultingwerk/foreach.i UltraGridColumn oColumn in oBand:Columns}

                if valid-object (oColumn:EditorComponent) then
                    oColumn:EditorComponent = ? .
            end.
        end.

    end method.

    /**
     * Purpose: Deletes all nodes objects in the UltraTree's Nodes Collection
     * Notes:
     * @param poUltraTree The reference to the UltraTree object
     */
    method public static void ClearUltraTreeNodes (poUltraTree as UltraTree):

        GarbageCollectorHelper:ClearUltraTreeNodes (poUltraTree:Nodes) .

    end method.

    /**
     * Purpose: Deletes nodes objects in a TreeNodes Collections
     * Notes:
     * @param poNodesCollection The reference to the TreeNodesCollection
     */
    method public static void ClearUltraTreeNodes (poNodesCollection as TreeNodesCollection):

        define variable i as integer no-undo.

        if not valid-object (poNodesCollection) then
            return .

        do i = poNodesCollection:Count - 1 to 0 by -1:

            if valid-object (poNodesCollection[i]:Nodes) then
                GarbageCollectorHelper:ClearUltraTreeNodes(poNodesCollection[i]:Nodes) .

            delete object poNodesCollection[i] .
        end.

        poNodesCollection:clear () .

    end method.
&endif

    /**
     * Purpose: Deletes a MEMPTR
     * Notes:   Deallocates (frees) any memory associated with memptr Variable
     *          Just doing a SET-SIZE (pmMptr) = 0 . as the MEMPTR does not need
     *          any check if memory is already allocated or not (unlike DELETE OBJECT).
     *          This method is just form completeness to allow a consistent coding
     * @param pmMptr The MEMPTR to deallocate
     */
    {&_proparse_ prolint-nowarn(varusage)}
    method public static void DeleteObject (pmMptr as memptr):
        set-size (pmMptr) = 0 .
    end method.

    /**
     * Purpose: Deletes an Widget handle, if valid
     * Notes:
     * @param phWidget The handle of the widget to delete
     */
    method public static void DeleteObject (phWidget as handle):

        if valid-handle (phWidget) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget no-error .

    end method.

    /**
     * Purpose: Deletes an Array of Widget handles, if valid
     * Notes:
     * @param phWidgets The array of widget handles to delete
     */
    method public static void DeleteObject (phWidgets as handle extent):

        define variable i as integer no-undo.

        do i = 1 to extent (phWidgets):
            if valid-handle (phWidgets[i]) then
                {&_proparse_ prolint-nowarn(avoidnoerror)}
                delete object phWidgets[i] no-error .
        end.

    end method.

    /**
     * Purpose: Deletes an Widget handle, if valid
     * Notes:
     * @param phWidget1 The handle of the widget to delete
     * @param phWidget2 The handle of the widget to delete
     */
    method public static void DeleteObject (phWidget1 as handle,
                                            phWidget2 as handle):

        if valid-handle (phWidget1) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget1 no-error .

        if valid-handle (phWidget2) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget2 no-error .

    end method.

    /**
     * Purpose: Deletes an Widget handle, if valid
     * Notes:
     * @param phWidget1 The handle of the widget to delete
     * @param phWidget2 The handle of the widget to delete
     * @param phWidget3 The handle of the widget to delete
     */
    method public static void DeleteObject (phWidget1 as handle,
                                            phWidget2 as handle,
                                            phWidget3 as handle):

        if valid-handle (phWidget1) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget1 no-error .

        if valid-handle (phWidget2) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget2 no-error .

        if valid-handle (phWidget3) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget3 no-error .

    end method.

    /**
     * Purpose: Deletes an Widget handle, if valid
     * Notes:
     * @param phWidget1 The handle of the widget to delete
     * @param phWidget2 The handle of the widget to delete
     * @param phWidget3 The handle of the widget to delete
     * @param phWidget4 The handle of the widget to delete
     */
    method public static void DeleteObject (phWidget1 as handle,
                                            phWidget2 as handle,
                                            phWidget3 as handle,
                                            phWidget4 as handle):

        if valid-handle (phWidget1) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget1 no-error .

        if valid-handle (phWidget2) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget2 no-error .

        if valid-handle (phWidget3) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget3 no-error .

        if valid-handle (phWidget4) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget4 no-error .

    end method.

    /**
     * Purpose: Deletes an Widget handle, if valid
     * Notes:
     * @param phWidget1 The handle of the widget to delete
     * @param phWidget2 The handle of the widget to delete
     * @param phWidget3 The handle of the widget to delete
     * @param phWidget4 The handle of the widget to delete
     * @param phWidget5 The handle of the widget to delete
     */
    method public static void DeleteObject (phWidget1 as handle,
                                            phWidget2 as handle,
                                            phWidget3 as handle,
                                            phWidget4 as handle,
                                            phWidget5 as handle):

        if valid-handle (phWidget1) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget1 no-error .

        if valid-handle (phWidget2) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget2 no-error .

        if valid-handle (phWidget3) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget3 no-error .

        if valid-handle (phWidget4) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget4 no-error .

        if valid-handle (phWidget5) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object phWidget5 no-error .

    end method.

    /**
     * Purpose: Deletes an Service instance, if valid and not registered
     *          with the Service Container
     * Notes:
     * @param poService The reference to the object to delete
     */
    method public static void DeleteObject (poService as Ccs.Common.IService):

        if not valid-object (poService) then
            return .

        if FrameworkSettings:ServiceContainer:IsRegistered(poService) then
            undo, throw new CannotDeleteServiceException (poService) .

        {&_proparse_ prolint-nowarn(avoidnoerror)}
        delete object poService no-error .

    end method.

    /**
     * Purpose: Deletes Service  instances from an Array, if valid and not registered
     *          with the Service Container
     * Notes:   We have noticed a potential regression in OE11.4 CQC documented in
     *          SCL-392. It appears that passing an initialized Object[] to this method
     *          raises the runtime error: Uninitialized array used as source of assignment.
     *          (14906). We will investigate the issue in probably have to log a ticket
     *          with PSC when the issue is still present in 11.4 FCS. At this time
     *          we do not recommend to use this method.
     * @param poService The ABL array of objects to delete
     */
    method public static void DeleteObject (poService as Ccs.Common.IService extent):

        define variable i as integer no-undo.

        do i = 1 to extent (poService):
            GarbageCollectorHelper:DeleteObject (poService [i]) .
        end .

    end method.

    /**
     * Purpose: Deletes an Object instance, if valid
     * Notes:
     * @param poObject The reference to the object to delete
     */
    method public static void DeleteObject (poObject as Progress.Lang.Object):

        if valid-object (poObject) then
            {&_proparse_ prolint-nowarn(avoidnoerror)}
            delete object poObject no-error .

    end method.

    /**
     * Purpose: Deletes Object instances from an Array
     * Notes:   We have noticed a potential regression in OE11.4 CQC documented in
     *          SCL-392. It appears that passing an initialized Object[] to this method
     *          raises the runtime error: Uninitialized array used as source of assignment.
     *          (14906). We will investigate the issue in probably have to log a ticket
     *          with PSC when the issue is still present in 11.4 FCS. At this time
     *          we do not recommend to use this method.
     * @param poObjects The ABL array of objects to delete
     */
    method public static void DeleteObject (poObjects as Progress.Lang.Object extent):

        define variable i as integer no-undo.

        do i = 1 to extent (poObjects):
            GarbageCollectorHelper:DeleteObject (poObjects [i]) .
        end .

    end method.

end class.
