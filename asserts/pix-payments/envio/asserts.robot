*** Settings ***
Library   DateTime
Library   Collections

*** Keywords ***
validar pagamento pix
  [Arguments]  ${status_code}  ${marketplace_external_key}  ${status_pix_payments}  ${amount}  ${pix_description}
  ...  ${debitor_national_registration}  ${debitor_name}  ${debitor_type}  ${debitor_holder_id}  ${debtor_account_psp_code}  ${debtor_account_psp_name}
  ...  ${debtor_digital_account}  ${debtor_account_number}  ${debtor_account_routing_number}  ${debtor_account_type}
  ...  ${creditor_national_registration}   ${creditor_name}  ${creditor_type}  ${creditor_account_psp_code}  ${creditor_account_number}
  ...  ${creditor_account_routing_number}  ${creditor_account_type}  ${refunded_amount}

  ${date}  Get Current Date  result_format=datetime
  ${date}  Convert Date      ${date}    exclude_millis=yes	result_format=%Y-%m-%d    date_format=%d-%m-%Y

  #Validar sttus code
  validar status code    ${status_code}    Fluxo de Envio de PIX com erro

  Should Be Equal                 ${response.json()["marketplace_id"]}                                  ${marketplace_external_key}
  Should Be Equal                 ${response.json()["status"]}                                          ${status_pix_payments}
  Should Contain                  ${response.json()["end_to_end_id"]}                                   E19468242

  Run Keyword If    '${response.json()["status"]}' == 'peding'   Should Contain    ${response.json()["message_id"]}    M19468242
  ...	ELSE IF	'${response.json()["status"]}' == 'executed'       Should Contain    ${response.json()["message_id"]}    M19468242
  ...	ELSE IF	'${response.json()["status"]}' == 'succeeded'      Should Contain    ${response.json()["message_id"]}    M19468242
  ...	ELSE IF	'${response.json()["status"]}' == 'canceled'       Should Not Contain Any    ${response.json()}          message_id

  #Should Not Be Empty    ${response.json()["message_id"]}

  Should Be Equal As Integers     ${response.json()["amount"]}                                          ${amount}
  #Should Contain                  ${response.json()["created_at"]}                                      ${date}
  Should Be Equal                 ${response.json()["description"]}                                     ${pix_description}

  Should Be Equal                 ${response.json()["debtor"]["national_registration"]}                 ${debitor_national_registration}
  Should Be Equal                 ${response.json()["debtor"]["name"]}                                  ${debitor_name}
  Should Be Equal                 ${response.json()["debtor"]["type"]}                                  ${debitor_type}
  Should Be Equal                 ${response.json()["debtor"]["holder_id"]}                             ${debitor_holder_id}
  Should Be Equal                 ${response.json()["debtor"]["account"]["psp"]["code"]}                ${debtor_account_psp_code}
  Should Be Equal                 ${response.json()["debtor"]["account"]["psp"]["name"]}                ${debtor_account_psp_name}
  Should Be Equal                 ${response.json()["debtor"]["account"]["digital_account_id"]}         ${debtor_digital_account}
  Should Be Equal                 ${response.json()["debtor"]["account"]["number"]}                     ${account_number}
  Should Be Equal                 ${response.json()["debtor"]["account"]["routing_number"]}             0${debtor_account_routing_number}
  Should Be Equal                 ${response.json()["debtor"]["account"]["type"]}                       ${debtor_account_type}

  Should Be Equal                 ${response.json()["creditor"]["national_registration"]}               ${creditor_national_registration}
  Should Be Equal                 ${response.json()["creditor"]["name"]}                                ${creditor_name}
  Should Be Equal                 ${response.json()["creditor"]["type"]}                                ${creditor_type}
  Should Be Equal                 ${response.json()["creditor"]["account"]["psp"]["code"]}              ${creditor_account_psp_code}
  Should Be Equal                 ${response.json()["creditor"]["account"]["number"]}                   ${creditor_account_number}
  Should Be Equal                 ${response.json()["creditor"]["account"]["routing_number"]}           ${creditor_account_routing_number}
  Should Be Equal                 ${response.json()["creditor"]["account"]["type"]}                     ${creditor_account_type}

  #Should Be Equal As Integers     ${response.json()["refunded_amount"]}                                 ${refunded_amount}
