*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
buscar verification code
    [Arguments]  ${holder_external_key}  ${account_external_key}  ${entry_external_key}
    conectar pix-dict
    ${response}        Get Request        pix-dict            /admin/internal_operation/marketplaces/${marketplace_external_key}/banking/dict/holders/${holder_external_key}/accounts/${account_external_key}/entries/${entry_external_key}/code

    Log                           ${response.json()}
    Log                           ${response.headers['X-REQUEST-ID']}
    Log                           ${response.status_code}
    Set Global Variable           ${response}

    ${verification_code}       Set Variable If    ${response.status_code}==200    ${response.json()["code"]}
    Set Global Variable        ${verification_code}
