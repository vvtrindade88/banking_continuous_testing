*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
confirmar propriedade da chave pix
    [Arguments]  ${verification_code}
    conectar pix-dict

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ...                         "code": "${verification_code}"
    ...                      }
    ${response}        Post Request        pix-dict            /marketplaces/${marketplace_external_key}/banking/dict/holders/${holder_external_key}/accounts/${account_external_key}/entries/${entry_external_key}/ownership
    ...                                                        data=${body}
    ...                                                        headers=${header}

    Log                         ${response.json()}
    Log                         ${response.status_code}
    Set Global Variable         ${response}
