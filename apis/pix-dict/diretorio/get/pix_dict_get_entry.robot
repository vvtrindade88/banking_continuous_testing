*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
buscar chave pix
    [Arguments]  ${holder_external_key}   ${account_external_key}   ${entry_external_key}
    conectar pix-dict
    ${response}        Get Request        pix-dict            /marketplaces/${marketplace_external_key}/banking/dict/holders/${holder_external_key}/accounts/${account_external_key}/entries/${entry_external_key}

    Log                           ${response.json()}
    Log                           ${response.status_code}
    Set Global Variable           ${response}
