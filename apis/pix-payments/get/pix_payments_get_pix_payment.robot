*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
buscar pagamento pix
    [Arguments]  ${holder_external_key}   ${account_external_key}   ${entry_external_key}  ${payment_external_key}
    conectar pix-payments
    ${response}        Get Request        pix-dict            /marketplaces/${marketplace_external_key}/banking/pix/holders/${holder_external_key}/accounts/${account_external_key}/payments/${payment_external_key}

    Log                           ${response.json()}
    Log                           ${response.headers['X-REQUEST-ID']}
    Log                           ${response.status_code}
    Set Global Variable           ${response}
