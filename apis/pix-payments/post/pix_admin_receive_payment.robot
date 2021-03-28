*** Settings ***
Library       RequestsLibrary
Library       Collections
Library       DateTime
Resource      ../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
receber pagamento pix admin
    [Arguments]  ${amount}  ${end_to_end_id}  ${message_id}  ${account_number}  ${psp_code}  ${account_rounting_number}  ${account_type}  ${national_registration}

    ${date}  Get Current Date  result_format=datetime
    ${datetime}  Convert Date	   ${date}  result_format=%Y-%m-%d

    Set Global Variable    ${amount}

    conectar pix-payments

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate        {
    ...                            "acceptance_date_time": "${datetime}T15:55:43.269Z",
    ...                            "amount": ${amount},
    ...                            "end_to_end_id": "${end_to_end_id}",
    ...                            "message_id": "${message_id}",
    ...                            "receiver": {
    ...                                   "account_details": {
    ...                                         "number": "${account_number}",
    ...                                         "psp": "${psp_code}",
    ...                                         "routing_number": "${account_rounting_number}",
    ...                                         "type": "${account_type}"
    ...                                   },
    ...                                   "document": "${national_registration}"
    ...                            },
    ...                            "remittance_information": "Teste Crédito PIX",
    ...                            "sender": {
    ...                                   "account_details": {
    ...                                         "number": "0243882974",
    ...                                         "psp": "17192451",
    ...                                         "routing_number": "0500",
    ...                                         "type": "cacc"
    ...                                   },
    ...                                   "document": "42808422644",
    ...                                   "identification": "Teste de Recebimento de PIX",
    ...                                   "name": "Massa ITI PFNAUmNNO"
    ...                            }
    ...                         }
    ${response}        Post Request        pix-payments        /admin/internal_operation/pix
    ...                                                        data=${body}
    ...                                                        headers=${header}

    Log                         ${response.json()}
    Log                         ${response.headers['X-REQUEST-ID']}
    Log                         ${response.status_code}
    Set Global Variable         ${response}
