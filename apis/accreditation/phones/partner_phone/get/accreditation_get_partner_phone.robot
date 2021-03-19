*** Settings ***
Library   RequestsLibrary
Library   Collections
Resource  ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
buscar partner phone

    ${response}        Get Request        accreditation            /marketplaces/${marketplace_external_key}/banking/accreditation/holders/${holder_external_key}/partners/${partner_external_key}/phones/${phone_external_key}

    Log                           ${response.json()}
    Log                           ${response.headers['X-REQUEST-ID']}
    Set Global Variable           ${response}
    Should Be Equal As Strings    ${response.status_code}    200
