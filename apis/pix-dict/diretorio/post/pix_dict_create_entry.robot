*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
criar chave pix
    conectar pix-dict
    [Arguments]  ${type}  ${value}

    Set Global Variable    ${type}
    Set Global Variable    ${value}

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ...                         "type": "${type}",
    ...                         "value": "${value}"
    ...                      }
    ${response}        Post Request        pix-dict            /marketplaces/${marketplace_external_key}/banking/dict/holders/${holder_external_key}/accounts/${account_external_key}/entries
    ...                                                        data=${body}
    ...                                                        headers=${header}

    Log                         ${response.json()}
    Log                         ${response.status_code}
    Set Global Variable         ${response}

    ${entry_external_key}       Set Variable If    ${response.status_code}==201    ${response.json()["id"]}
    ...                                            ${response.status_code}==202    ${response.json()["id"]}
    Set Global Variable         ${entry_external_key}

    ${entry_key_value}          Set Variable If    ${response.status_code}==201    ${response.json()["key"]["value"]}
    ...                                            ${response.status_code}==202    ${response.json()["key"]["value"]}
    Set Global Variable         ${entry_key_value}
