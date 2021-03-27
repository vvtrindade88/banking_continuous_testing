*** Settings ***
Library          DateTime
Resource         ../../status_code/status_code_validade.robot

*** Keywords ***
validar reivindicação
    [Arguments]  ${status_code}  ${marketplace_external_key}  ${claim_type}  ${claim_status}  ${key_value}  ${key_type}   ${claimer_name}  ${claimer_national_registration}
    ...          ${claimer_type}  ${claimer_marketplace}  ${claimer_holder_id}  ${claimer_account_id}  ${claimer_routing_number}  ${claimer_account_number}
    ...          ${claimer_account_type}  ${claimer_psp_code}  ${claimer_psp_name}  ${donor_name}  ${donor_national_registration}  ${donor_type}  ${donor_marketplace}
    ...          ${donor_holder_id}  ${donor_account_id}  ${donor_routing_number}  ${donor_account_number}  ${donor_account_type}  ${donor_psp_code}  ${donor_psp_name}
    ...          ${claim_resource}

    ${date}  Get Current Date  result_format=datetime
    ${date}  Convert Date      ${date}    exclude_millis=yes	result_format=%Y-%m-%d    date_format=%d-%m-%Y

    ## validar status code
    validar status code    ${status_code}    Erro ao realizar reivindicação de posse

    Should Not Be Empty    ${response.json()["id"]}
    Should Be Equal        ${response.json()["marketplace"]}                                                ${marketplace_external_key}
    Should Contain         ${response.json()["created_at"]}                                                 ${date}
    Should Contain         ${response.json()["updated_at"]}                                                 ${date}
    Should Be Equal        ${response.json()["type"]}                                                       ${claim_type}
    Should Be Equal        ${response.json()["status"]}                                                     ${claim_status}

    Should Be Equal        ${response.json()["key"]["value"]}                                               ${key_value}
    Should Be Equal        ${response.json()["key"]["type"]}                                                ${key_type}

    Should Be Equal        ${response.json()["claimer"]["name"]}                                            ${claimer_name}
    Should Be Equal        ${response.json()["claimer"]["national_registration"]}                           ${claimer_national_registration}
    Should Be Equal        ${response.json()["claimer"]["type"]}                                            ${claimer_type}
    Should Be Equal        ${response.json()["claimer"]["marketplace"]}                                     ${claimer_marketplace}
    Should Be Equal        ${response.json()["claimer"]["holder"]}                                          ${claimer_holder_id}
    Should Be Equal        ${response.json()["claimer"]["account"]["digital_account_id"]}                   ${claimer_account_id}
    Should Be Equal        ${response.json()["claimer"]["account"]["routing_number"]}                       ${claimer_routing_number}
    Should Be Equal        ${response.json()["claimer"]["account"]["number"]}                               ${claimer_account_number}
    Should Be Equal        ${response.json()["claimer"]["account"]["type"]}                                 ${claimer_account_type}
    Should Be Equal        ${response.json()["claimer"]["psp"]["code"]}                                     ${claimer_psp_code}
    Should Be Equal        ${response.json()["claimer"]["psp"]["name"]}                                     ${claimer_psp_name}

    Should Be Equal        ${response.json()["donor"]["name"]}                                              ${donor_name}
    Should Be Equal        ${response.json()["donor"]["national_registration"]}                             ${donor_national_registration}
    Should Be Equal        ${response.json()["donor"]["type"]}                                              ${donor_type}
    Should Be Equal        ${response.json()["donor"]["marketplace"]}                                       ${donor_marketplace}
    Should Be Equal        ${response.json()["donor"]["holder"]}                                            ${donor_holder_id}
    Should Be Equal        ${response.json()["donor"]["account"]["digital_account_id"]}                     ${donor_account_id}
    Should Be Equal        ${response.json()["donor"]["account"]["routing_number"]}                         ${donor_routing_number}
    Should Be Equal        ${response.json()["donor"]["account"]["number"]}                                 ${donor_account_number}
    Should Be Equal        ${response.json()["donor"]["account"]["type"]}                                   ${donor_account_type}
    Should Be Equal        ${response.json()["donor"]["psp"]["code"]}                                       ${donor_psp_code}
    Should Be Equal        ${response.json()["donor"]["psp"]["name"]}                                       ${donor_psp_name}

    Should Be Equal        ${response.json()["resource"]}                                                   ${claim_resource}
