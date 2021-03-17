*** Settings ***
Library   RequestsLibrary
Library   Collections
Resource  ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
buscar holder phone

    ${response}        Get Request        accreditation            /marketplaces/${marketplace_external_key}/banking/accreditation/holders/${holder_external_key}/phones/${phone_external_key}

    Log                           ${response.json()}
    Set Global Variable           ${response}
    Should Be Equal As Strings    ${response.status_code}    200
