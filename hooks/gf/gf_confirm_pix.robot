*** Settings ***
Library          DateTime
Library          FakerLibrary
Resource         ../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
gf - confirmar envio do pix
    [Arguments]  ${end_to_end_id}

    ${random_number}  Random Number  digits=23  fix_len=True
    ${message_id}  Set Variable   M19468242${random_number}
    Log  ${message_id}

    conectar settlement
    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate  {
    ...                     "data": {
    ...                        "data": {
    ...                           "clearing_system_party_identification": "60701190",
    ...                           "message_definition_identifier": "pacs.002.spi.1.4",
    ...                           "message_identification": "${message_id}",
    ...                           "document": {
    ...                                "financial_institution_to_financial_institution_payment_status_report": {
    ...                                      "transaction_information_and_status": [
    ...                                                 {
    ...                                                    "original_instruction_identification": "${end_to_end_id}",
    ...                                                    "original_end_to_end_identification": "${end_to_end_id}",
    ...                                                    "transaction_status": "ACSP"
    ...                                                   }
    ...                                                ]
    ...                                           }
    ...                                     }
    ...                               }
    ...                         }
    ...                    }
    ${response}        Post Request        settlement          /confirm
    ...                                                        data=${body}
    ...                                                        headers=${header}

    # Run Keyword If    '${response.status_code}' == 200    Log  ${response.json()}
    # Run Keyword If    '${response.status_code}' == 200    Log  ${response.headers['X-REQUEST-ID']}
    #Run Keyword If    '${response.status_code}' == 200    Log  ${response.status_code}
    Log  ${response.status_code}
