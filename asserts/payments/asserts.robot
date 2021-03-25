*** Keywords ***
validar ted
  [Arguments]  ${status_code}  ${amount}  ${description}  ${reference_id}  ${status}  ${recipient_name}  ${recipient_document}
  ...          ${recipient_bank_code}  ${recipient_routing_number}  ${recipient_routing_check_digit}  ${recipient_account_number}  ${recipient_account_check_digit}

  Should Be Equal As Strings    ${response.status_code}                                 ${status_code}
  Should Be Equal As Strings    ${response.json()["amount"]}                            ${amount}
  Should Be Equal              ${response.json()["formated_amount"]}                    ${formated_amount}
  Should Be Equal               ${response.json()["description"]}                       ${description}
  Should Be Equal               ${response.json()["reference_id"]}                      ${reference_id}
  Should Be Equal               ${response.json()["status"]}                            ${status}
  Should Be Equal        		    ${response.json()["recipient"]["name"]}                 ${recipient_name}
  Should Be Equal        		    ${response.json()["recipient"]["document"]}             ${recipient_document}
  Should Be Equal        		    ${response.json()["recipient"]["bank_code"]}            ${recipient_bank_code}
  Should Be Equal        		    ${response.json()["recipient"]["routing_number"]}       ${recipient_routing_number}
  Should Be Equal        		    ${response.json()["recipient"]["routing_check_digit"]}  ${recipient_routing_check_digit}
  Should Be Equal        		    ${response.json()["recipient"]["account_number"]}       ${recipient_account_number}
  Should Be Equal        		    ${response.json()["recipient"]["account_check_digit"]}  ${recipient_account_check_digit}
