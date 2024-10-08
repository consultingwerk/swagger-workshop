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
    File        : CompareStrengthEnum
    Purpose     : Enum with possible values for the strength parameter of 
                  the ABL Compare function. Use ToString() to pass as the 
                  required character parameter 
                 
    Syntax      : 
    Description : 
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Mon Apr 11 21:13:31 CEST 2011
    Notes       : Used for the AfterInitializeBusinessEntityAdapterEventArgs
                  class
  ----------------------------------------------------------------------*/

@lowercase.

block-level on error undo, throw.

{Consultingwerk/products.i}

&if defined (NativeEnums) ne 0 &then
&scoped-define CLASS enum
&else
&scoped-define CLASS class
&endif

using Consultingwerk.*                      from propath .
using Progress.Lang.*                       from propath .

{&CLASS} Consultingwerk.CompareStrengthEnum 
    &if "{&CLASS}" eq "class" &then
    inherits enum
    &endif   
        : 

&if "{&CLASS}" eq "enum" &then
    define enum
&endif    

    /**
     * Purpose: The AVM compares the two strings using the numeric values in the
     *          current code page.
     * Notes:
     */
    {Consultingwerk/EnumMember.i Raw 1 CompareStrengthEnum}  
    
    /**
     * Purpose: The AVM performs a case-sensitive comparison of the two strings
     *          using the numeric values in either the collation table specified in
     *          collation, or the collation table of the client. If you specify this
     *          strength with an ICU collation, the AVM applies the ICU TERTIARY strength.
     * Notes:
     */
    {Consultingwerk/EnumMember.i Case-Sensitive 2 CompareStrengthEnum}  

    /**
     * Purpose: The AVM performs a case-insensitive comparison of the two strings
     *          using the numeric values in either the collation table specified in
     *          collation, or the collation table of the client. If you specify this
     *          strength with an ICU collation, the AVM applies the ICU SECONDARY strength.
     * Notes:
     */
    {Consultingwerk/EnumMember.i Case-Insensitive 3 CompareStrengthEnum}  

    /**
     * Purpose: The AVM converts any lowercase letters in the two strings to uppercase
     *          letters, based on the settings of the Internal Code Page (-cpinternal)
     *          and Case Table (-cpcase) startup parameters, and then performs a raw
     *          comparison of the resulting strings. When neither string contains a
     *          wildcard character, this option behaves the same as the MATCHES operator.
     * Notes:
     */
    {Consultingwerk/EnumMember.i Caps 4 CompareStrengthEnum}  

    /**
     * Purpose: The AVM compares the base characters in the two strings.
     * Notes:
     */
    {Consultingwerk/EnumMember.i Primary 5 CompareStrengthEnum}  
    
    /**
     * Purpose: The AVM compares the base characters and any diacritical marks in
     *          the two strings.
     * Notes:
     */
    {Consultingwerk/EnumMember.i Secondary 6 CompareStrengthEnum}  

    /**
     * Purpose: The AVM performs a case-sensitive comparison of the base characters
     *          and diacritical marks in the two strings.
     * Notes:
     */
    {Consultingwerk/EnumMember.i Tertiary 7 CompareStrengthEnum}  

    /**
     * Purpose: The AVM performs a case-sensitive comparison of the base characters
     *          and any diacritical marks in the two strings, and distinguishes words
     *          with and without punctuation. ICU uses this strength to distinguish
     *          between Hiragana and Katakana when applied with the ICU-JA (Japanese)
     *          collation. Otherwise, it is the same as TERTIARY.
     * Notes:
     */
    {Consultingwerk/EnumMember.i Quarternary 8 CompareStrengthEnum}  

&if "{&CLASS}" eq "enum" &then
    .
&endif    

&if "{&CLASS}" eq "class" &then

    /**
     * Purpose: Constructor for the CompareStrengthEnum class
     * Notes:
     * @param piValue The integer enum value
     * @param pcLabel The character enum label
     */
    constructor private CompareStrengthEnum (piValue AS integer, pcLabel AS character):
        super ().
        
        assign this-object:Value = piValue 
               this-object:Label = pcLabel . 
        
    end constructor.

    {Consultingwerk/EnumFromString.i Consultingwerk.CompareStrengthEnum}    

&endif

end {&CLASS} .
