*** Settings ***
Library          RequestsLibrary
Library          Collections
Resource         ../../../ambientes/staging/internal/create_session_staging_internal.robot
Library          FakerLibrary    locale=pt_BR

*** Keywords ***
gerar saldo para account
    conectar accounts

    [Arguments]  ${account_external_key}
    ${uuid}  Uuid 4

    conectar accounts
    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate        {
    ...                             "operations": [
    ...                                             {
    ...                                               "amount": 9000000000000,
    ...                                               "authorization_code": ${uuid},
    ...                                               "transaction_id": ${uuid},
    ...                                               "id": pm.variables.get("uuid"),
    ...                                               "id_checking_account": "${account_external_key}",
    ...                                               "transfer_date": "2020-02-20T20:58:06.510Z",
    ...                                               "fee": 0,
    ...                                               "description": "Teste",
    ...                                               "object_type": "transfer",
    ...                                               "object_id": ${uuid},
    ...                                               "dflag": "ACTIVE",
    ...                                               "created_at": "2019-10-14T20:58:06.510Z",
    ...                                               "type": "Transfer"
    ...                                             }
    ...                                          ],
    ...                             "reference_id": "Criando saldo na account"
    ...                         }
    ${response}        Post Request        accounts            /admin/internal_operation/authorization/${uuid}
    ...                                                        data=${body}
    ...                                                        headers=${header}

    Log                         ${response.json()}
    Log                         ${response.headers['X-REQUEST-ID']}
    Log                         ${response.status_code}
    Set Global Variable         ${response}
