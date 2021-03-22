*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
confirmar pagamento pix
    conectar pix-payments
    [Arguments]  ${holder_external_key}  ${account_external_key}  ${payment_external_key}

    ${header}  Create Dictionary  Content-Type=application/json
    ${response}        Post Request        pix-payments        /marketplaces/${marketplace_external_key}/banking/pix/holders/${holder_external_key}/accounts/${account_external_key}/payments/${payment_external_key}/confirm
    ...                                                        headers=${header}

    Log                         ${response.json()}
    Log                         ${response.headers['X-REQUEST-ID']}
    Log                         ${response.status_code}
    Set Global Variable         ${response}
