    /**
     * Purpose: Constructor for the List class
     * Notes:
     */
    CONSTRUCTOR PUBLIC {1} ():
        SUPER ().

    END CONSTRUCTOR.

    /**
     * Purpose: Constructor for the List class
     * Notes:   Defaults to the comma (",") as the delimiter for Keys and Values
     * @param pcValues The initial list of Values
     */
    CONSTRUCTOR PUBLIC {1} (pcValues AS LONGCHAR):

        SUPER (pcValues).

    END CONSTRUCTOR.

    /**
     * Purpose: Constructor for the List class
     * Notes:
     * @param pcValues The initial list of Values
     * @param pcValueDelimiter The delimiter for the Values
     */
    CONSTRUCTOR PUBLIC {1} (pcValues AS LONGCHAR,
                                            pcValueDelimiter AS CHARACTER):

        SUPER (pcValues, pcValueDelimiter).

    END CONSTRUCTOR.

    /**
     * Purpose: Adds the specified value to the List.
     * Notes:
     * @param pValue The value for the key/value pair to add to the List
     */
    METHOD PUBLIC VOID Add (pValue AS {2}):

        THIS-OBJECT:InternalAdd (STRING (pValue)) .

    END METHOD.

    /**
     * Purpose: Adds the specified value to the List only when it is not
     *          yet contained - silently ignores keys that are already
     *          contained
     * Notes:
     * @param pValue The value for the key/value pair to add to the List
     */
    METHOD PUBLIC VOID AddWhenNotContained (pValue AS {2}):

        IF NOT THIS-OBJECT:ContainsValue (pValue) THEN
            THIS-OBJECT:InternalAdd (STRING (pValue)) .

    END METHOD.

    /**
     * Purpose: Determines whether the List contains the specified value.
     * Notes:
     * @param pValue The value to locate in the List
     * @return Logical value indicating if the List contains the value
     */
    METHOD PUBLIC LOGICAL ContainsValue (pValue AS {2}):

        RETURN THIS-OBJECT:InternalContainsValue (STRING (pValue)).

    END METHOD.

    /**
     * Purpose: Returns the Enumerator for the List
     * Notes:
     * @return The Enumerator instance
     */
    METHOD PUBLIC {1}Enumerator GetEnumerator ():

        RETURN NEW {1}Enumerator (THIS-OBJECT) .

    END METHOD.

    /**
     * Purpose: Returns the Value for the specified Key
     * Notes:
     * @param piIndex The index to remove from the List
     * @return The Value for the specified Index
     */
    METHOD PUBLIC {2} GetValue (piIndex AS INTEGER):

        RETURN {3} (THIS-OBJECT:InternalGetValue (piIndex)) .

    END METHOD.

    /**
     * Purpose: Returns the index of the given value in the list
     * Notes:   Returns 0 if the value is not in the list
     * @param pValue The value to locate in the list
     * @return The index of the given value in the list
     */
    METHOD PUBLIC INTEGER IndexOf (pValue AS {2}):

        RETURN THIS-OBJECT:InternalIndexOf (STRING (pValue)) .

    END METHOD.

    /**
     * Purpose: Inserts the specified value to the List at the specified position
     * Notes:
     * @param pValue The value for the key/value pair to add to the List
     * @param piPosition The position to add the new value to
     */
    METHOD PUBLIC VOID Insert (pValue AS {2}, piPosition AS INTEGER):

        THIS-OBJECT:InternalInsert (STRING (pValue), piPosition) .

    END METHOD.

    /**
     * Purpose: Assigns the Value for the specified Key
     * Notes:
     * @param piIndex The index to remove from the List
     * @param pValue The value to assign for the Key in the List
     */
    METHOD PUBLIC VOID SetValue (piIndex AS INTEGER,
                                 pValue AS {2}):

        THIS-OBJECT:InternalSetValue (piIndex, STRING (pValue)) .

    END METHOD.

    /**
     * Purpose: Returns an array with the elements of the list
     * Notes:
     * @return The array with the elements of the list
     */
    METHOD PUBLIC {2} EXTENT ToArray ():

        DEFINE VARIABLE oReturn AS {2} EXTENT NO-UNDO .
        DEFINE VARIABLE i       AS INTEGER    NO-UNDO .

        IF THIS-OBJECT:Count > 0 THEN DO:

            EXTENT (oReturn) = THIS-OBJECT:Count .

            DO i = 1 TO THIS-OBJECT:Count:
                oReturn[i] = THIS-OBJECT:GetValue (i) .
            END.
        END.

        RETURN oReturn .

    END METHOD.
