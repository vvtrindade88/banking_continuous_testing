*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
buscar account por holder
    conectar accounts
    ${response}        Get Request        accounts            /marketplaces/${marketplace_external_key}/holders/${holder_external_key}/accounts

    Log                           ${response.json()}
    Set Global Variable           ${response}

    ${account_external_key}       Set Variable If    ${response.status_code}==200    ${response.json()["items"][0]["id"]}
    Set Global Variable           ${account_external_key}

    ${account_number}             Set Variable If    ${response.status_code}==200    ${response.json()["items"][0]["number"]}
    Set Global Variable           ${account_number}

    ${account_routing_number}     Set Variable If    ${response.status_code}==200    ${response.json()["items"][0]["routing_number"]}
    Set Global Variable           ${account_routing_number}
