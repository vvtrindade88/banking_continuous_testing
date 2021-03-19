*** Settings ***
Library   RequestsLibrary
Library   Collections
Resource  ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
buscar holder individual

    ${response}        Get Request        accreditation            /marketplaces/${marketplace_external_key}/banking/accreditation/holders/${holder_external_key}/partner/${partner_external_key}

    Log                           ${response.json()}
    Log                           ${response.headers['X-REQUEST-ID']}
    Set Global Variable           ${response}
    Should Be Equal As Strings    ${response.status_code}    200
