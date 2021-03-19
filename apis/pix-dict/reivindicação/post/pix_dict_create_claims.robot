*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
criar reivindicação de posse
    [Arguments]  ${holder_external_key}  ${account_external_key}  ${entry_external_key}
    conectar pix-dict
    ${response}        Post Request        pix-dict            /marketplaces/${marketplace_external_key}/banking/dict/holders/${holder_external_key}/accounts/${account_external_key}/entries/${entry_external_key}/claims

    Log                           ${response.json()}
    Log                           ${response.headers['X-REQUEST-ID']}
    Log                           ${response.status_code}
    Set Global Variable           ${response}

    ${claim_external_key}       Set Variable If    ${response.status_code}==201    ${response.json()["id"]}
    Set Global Variable         ${claim_external_key}
