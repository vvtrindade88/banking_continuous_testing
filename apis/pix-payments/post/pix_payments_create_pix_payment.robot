*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
criar pagamento pix com dados completos
    conectar pix-payments
    [Arguments]  ${amount}  ${creditor_account_number}  ${creditor_routing_number}   ${creditor_account_type}  ${creditor_name}  ${creditor_national_registration}   ${creditor_psp}   ${pix_description}

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ...                       "amount": ${amount},
    ...                       "creditor": {
    ...                                     "account": {
    ...                                                 "number": "${creditor_account_number}",
    ...                                                 "routing_number": "${creditor_routing_number}",
    ...                                                 "type": "${creditor_account_type}"
    ...                                                 },
    ...                                     "name": "${creditor_name}",
    ...                                     "national_registration": "${creditor_national_registration}",
    ...                                     "psp": "${creditor_psp}"
    ...                                   },
    ...                       "description": "${pix_description}"
    ...                     }
    ${response}        Post Request        pix-payments        /marketplaces/${marketplace_external_key}/banking/pix/holders/${holder_external_key}/accounts/${account_external_key}/payments
    ...                                                        data=${body}
    ...                                                        headers=${header}

    Log                         ${response.json()}
    Log                         ${response.headers['X-REQUEST-ID']}
    Log                         ${response.status_code}
    Set Global Variable         ${response}

    ${payment_external_key}       Set Variable If    ${response.status_code}==201    ${response.json()["id"]}
    Set Global Variable           ${payment_external_key}

    ${end_to_end_id}          Set Variable If    ${response.status_code}==201    ${response.json()["end_to_end_id"]}
    Set Global Variable       ${end_to_end_id}

    ${message_id}             Set Variable If    ${response.status_code}==201    ${response.json()["message_id"]}
    Set Global Variable       ${message_id}


criar pagamento pix com chave pix
    conectar pix-payments
    [Arguments]  ${amount}  ${pix_type}  ${pix_value}   ${creditor_account_type}
    ...          ${creditor_name}  ${creditor_national_registration}   ${creditor_psp}   ${pix_description}  ${pix_transaction_id}

    Set Global Variable    ${type}
    Set Global Variable    ${value}

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ...                        "amount": ${amount},
    ...                        "creditor": {
    ...                                      "key": {
    ...                                              "type": "${pix_type}",
    ...                                              "value": "${pix_value}"
    ...                                             }
    ...                                    },
    ...                        "description": "${pix_description}"
    ...                        "transaction_id": "${pix_transaction_id}"
    ...                      }
    ${response}        Post Request        pix-payments        /marketplaces/${marketplace_external_key}/banking/pix/holders/${holder_external_key}/accounts/${account_external_key}/payments
    ...                                                        data=${body}
    ...                                                        headers=${header}

    Log                         ${response.json()}
    Log                         ${response.status_code}
    Set Global Variable         ${response}

    ${payment_external_key}       Set Variable If    ${response.status_code}==201    ${response.json()["id"]}
    Set Global Variable           ${payment_external_key}

    ${end_to_end_id}          Set Variable If    ${response.status_code}==201    ${response.json()["end_to_end_id"]}
    Set Global Variable       ${end_to_end_id}

    ${message_id}             Set Variable If    ${response.status_code}==201    ${response.json()["message_id"]}
    Set Global Variable       ${message_id}
