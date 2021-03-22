*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
reenviar verification code
    [Arguments]  ${holder_external_key}  ${account_external_key}  ${entry_external_key}
    conectar pix-dict

    ${header}  Create Dictionary  Content-Type=application/json
    ${response}        Post Request        pix-dict            /marketplaces/${marketplace_external_key}/banking/dict/holders/${holder_external_key}/accounts/${account_external_key}/entries/${entry_external_key}/ownership/resend
    ...                                                        headers=${header}

    Log                         ${response.json()}
    Log                         ${response.headers['X-REQUEST-ID']}
    Log                         ${response.status_code}
    Set Global Variable         ${response}
