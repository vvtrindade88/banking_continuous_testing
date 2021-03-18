*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
receber notificação de reivindicação
    conectar pix-dict
    [Arguments]  ${key_pix}  ${account_number}  ${claimer_tax_id}  ${claimer_name}  ${claim_external_key}  ${claim_notification_status}

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ... 							"data": {
    ... 							    "claim": {
    ... 							        "type": "OWNERSHIP",
    ... 							        "key": "${key_pix}",
    ... 							        "key_type": "PHONE",
    ... 							        "claimer_account": {
    ... 							            "participant": "19468242",
    ... 							            "branch": "0001",
    ... 							            "account_number": "${account_number}",
    ... 							            "account_type": "CACC"
    ... 							        },
    ... 							        "claimer": {
    ... 							            "type": "NATURAL_PERSON",
    ... 							            "tax_id_number": "${claimer_tax_id}",
    ... 							            "name": "${claimer_name}"
    ... 							        },
    ... 							        "donor_participant": "19468242",
    ... 							        "id": "${claim_external_key}",
    ... 							        "status": "${claim_notification_status}",
    ... 							        "resolution_period_end": "2020-10-18T10:00:00.000Z",
    ... 							        "completion_period_end": "2020-10-25T10:00:00.000Z",
    ... 							        "last_modified": "2020-10-17T10:00:00.000Z"
    ... 							    }
    ... 							  }
    ... 							}
    ${response}        Post Request        pix-dict            /banking/internal/dict/claims
    ...                                                        data=${body}
    ...                                                        headers=${header}

    Log                         ${response.status_code}
