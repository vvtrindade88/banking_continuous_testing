*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
buscar envio de ted
    [Arguments]  ${marketplace_external_key}  ${holder_external_key}  ${account_external_key}  ${payment_external_key}
    conectar accounts
    ${response}        Get Request        payments            /marketplaces/${marketplace_external_key}/holders/${holder_external_key}/accounts/${account_external_key}/external-transfer-send/${payment_external_key}

    Log                           ${response.json()}
    Set Global Variable           ${response}
