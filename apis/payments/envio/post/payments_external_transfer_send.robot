*** Settings ***
Library   RequestsLibrary
Library   Collections
Library   FakerLibrary
Resource  ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
criar envio de ted
    [Arguments]  ${marketplace_external_key}  ${holder_external_key}  ${account_external_key}  ${amount}  ${account_check_digit}  ${account_number}  ${bank_code}  ${document}  ${name}  ${routing_check_digit}  ${routing_number}  ${description}  ${reference_id}

    conectar payments
    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ...                         "amount": ${amount},
    ...                         "recipient": {
    ...                                        "account_check_digit": "${account_check_digit}",
    ...                                        "account_number": "${account_number}",
    ...                                        "bank_code": "${bank_code}",
    ...                                        "document": "${document}",
    ...                                        "name": "${name}",
    ...                                        "routing_check_digit": "${routing_check_digit}",
    ...                                        "routing_number": "${routing_number}"
    ...                                    },
    ...                         "description": "${description}",
    ...                         "reference_id": "${reference_id}"
    ...                      }
    ${response}        Post Request        payments                 /marketplaces/${marketplace_external_key}/holders/${holder_external_key}/accounts/${account_external_key}/external-transfer-send
    ...                                                             data=${body}
    ...                                                             headers=${header}

    Log                           ${response.status_code}
    Log                           ${response.json()}
    Log                           ${response.headers['X-REQUEST-ID']}
    Set Global Variable           ${response}

    ${payment_external_key}       Set Variable If    ${response.status_code}==202    ${response.json()["external_transfer_id"]}
    Set Global Variable           ${payment_external_key}
