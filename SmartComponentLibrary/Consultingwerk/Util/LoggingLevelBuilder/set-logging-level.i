/*------------------------------------------------------------------------
    File        : set-logging-level.i
    Purpose     : method template for strong typed logging levle builder

    Syntax      :

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Nov 26 12:33:08 CET 2019
    Notes       :
  ----------------------------------------------------------------------*/

    /**
     * Purpose: Sets the logging level
     * Notes:
     * @param poLoggingLevel The LoggingLevelEnum with the new logging level
     * @return The reference to the LoggingLevelBuilder itself for fluent style
     */
    method public LoggingLevelBuilder {2} (poLoggingLevel as LoggingLevelEnum):

        LogManager:SetLoggingLevel ("{1}":U, integer(poLoggingLevel:GetValue())) .

        return this-object .

    end method .
