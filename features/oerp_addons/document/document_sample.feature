###############################################################################
#
#    OERPScenario, OpenERP Functional Tests
#    Copyright 2009 Camptocamp SA
#
##############################################################################

# Features Generic tags (none for all)
##############################################################################

# Branch      # Module       # Processes     # System
@document @sample_document

Feature: Ensure that document configuration is correct
    Scenario: Configure the media storage
    
    Given I have a media storage called "root filestore" of type "filestore" owned by "Administrator"
    # Note: The default path is always ROOT_PATH + filestore + DB_NAME, so this already
    # compliant with qa, test, prod,...
    And all directories are linked to the "root filestore"
