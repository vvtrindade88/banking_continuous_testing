*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
confirmar pagamento pix admin
    [Arguments]  ${end_to_end_id}

    conectar pix-payments

    ${random_number}  Random Number  digits=23  fix_len=True
    ${message_id}  Set Variable   M19468242${random_number}
    Log  ${message_id}

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ...                       "instruction_id": "${end_to_end_id}",
    ...                       "message_id": "${message_id}"
    ...                     }
    ${response}        Post Request        pix-payments        /admin/internal_operation/pix/${end_to_end_id}/confirmation
    ...                                                        data=${body}
    ...                                                        headers=${header}

    #Run Keyword If    '${response.status_code}' <> '202'    Log    ${response.json()}
    Log                         ${response.headers['X-REQUEST-ID']}
    Log                         ${response.status_code}
    Set Global Variable         ${response}
