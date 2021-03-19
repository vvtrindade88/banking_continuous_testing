*** Settings ***
Library   RequestsLibrary
Library   Collections
Resource  ../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
solicitar aprovação do holder

    ${header}  Create Dictionary  Content-Type=application/json
    ${response}        Post Request        accreditation            /marketplaces/${marketplace_external_key}/banking/accreditation/holders/${holder_external_key}/approval
    ...                                                             headers=${header}

    Log                           ${response.json()}
    Log                           ${response.headers['X-REQUEST-ID']}
    Set Global Variable           ${response}
