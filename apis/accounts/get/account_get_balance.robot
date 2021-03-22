*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
buscar account balance
    [Arguments]  ${marketplace_external_key}  ${account_external_key}
    conectar accounts
    ${response}        Get Request        accounts            /marketplaces/${marketplace_external_key}/accounts/${account_external_key}

    Log                           ${response.json()}
    Set Global Variable           ${response}

    ${account_balance}       Set Variable If    ${response.status_code}==200    ${response.json()["balance"]}
    Set Global Variable      ${account_balance}
