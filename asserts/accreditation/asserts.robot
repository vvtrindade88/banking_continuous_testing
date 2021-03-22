*** Settings ***
Resource         ../../hooks/accreditation/dados_holder_individual.robot
Resource         ../../apis/accreditation/holders/get/accreditation_get_holder.robot

*** Keywords ***
validar holder individual
  [Arguments]  ${assert_holder_status}

  Should Be Equal As Strings    ${response.json()["type"]}                      individual
  Should Be Equal As Strings    ${response.json()["status"]}                    ${assert_holder_status}
  Should Be Equal As Strings    ${response.json()["name"]}                      ${holder_name}
  Should Be Equal As Strings    ${response.json()["email"]}                     ${email}
  Should Be Equal As Strings    ${response.json()["national_registration"]}     ${national_registration}
  Should Be Equal As Numbers    ${response.json()["revenue"]}                   ${revenue}
  Should Be Equal As Strings    ${response.json()["birthday"]}                  ${birthday}
  Should Be Equal As Strings    ${response.json()["mothers_name"]}              ${mothers_name}
  Should Be Equal As Strings    ${response.json()["identity_card"]}             ${identity_card}
  Should Be Equal As Strings    ${response.json()["pep"]}                       False
  Should Be Equal As Strings    ${response.json()["cbo"]}                       ${cbo}

validar holder business
  [Arguments]  ${assert_holder_status}

  Should Be Equal As Strings    ${response.json()["type"]}                      business
  Should Be Equal As Strings    ${response.json()["status"]}                    ${assert_holder_status}
  Should Be Equal As Strings    ${response.json()["name"]}                      ${holder_name}
  Should Be Equal As Strings    ${response.json()["email"]}                     ${email_business}
  Should Be Equal As Strings    ${response.json()["national_registration"]}     ${national_registration}
  Should Be Equal As Numbers    ${response.json()["revenue"]}                   ${revenue_business}
  Should Be Equal As Strings    ${response.json()["legal_name"]}                ${legal_name}
  Should Be Equal As Strings    ${response.json()["establishment"]["format"]}   ${establishment_format}
  Should Be Equal As Strings    ${response.json()["establishment"]["date"]}     ${establishment_date}
  Should Be Equal As Strings    ${response.json()["cnae"]}                      ${cnae}

validar holder phone

validar holder address

validar partner phone

validar partner address

validar invalid_request
  [Arguments]  ${message_error}

  Run Keyword If    '${field}' == 'type'                      Should Be Equal As Strings    ${response.json()["fields"]["type"]}                    ${message_error}
  ...	ELSE IF	'${field}' == 'name'                            Should Be Equal As Strings    ${response.json()["fields"]["name"]}                    ${message_error}
  ...	ELSE IF	'${field}' == 'email'                           Should Be Equal As Strings    ${response.json()["fields"]["email"]}                   ${message_error}
  ...	ELSE IF	'${field}' == 'national_registration'           Should Be Equal As Strings    ${response.json()["fields"]["national_registration"]}   ${message_error}
  ...	ELSE IF	'${field}' == 'revenue'                         Should Be Equal As Strings    ${response.json()["fields"]["revenue"]}                 ${message_error}
  ...	ELSE IF	'${field}' == 'cnae'                            Should Be Equal As Strings    ${response.json()["fields"]["cnae"]}                    ${message_error}
  ...	ELSE IF	'${field}' == 'legal_name'                      Should Be Equal As Strings    ${response.json()["fields"]["legal_name"]}              ${message_error}
  ...	ELSE IF	'${field}' == 'establishment_format'            Should Be Equal As Strings    ${response.json()["fields"]["establishment.format"]}    ${message_error}
  ...	ELSE IF	'${field}' == 'establishment_date'              Should Be Equal As Strings    ${response.json()["fields"]["establishment.date"]}      ${message_error}
  ...	ELSE IF	'${field}' == 'birthday'                        Should Be Equal As Strings    ${response.json()["fields"]["birthday"]}                ${message_error}
  ...	ELSE IF	'${field}' == 'mothers_name'                    Should Be Equal As Strings    ${response.json()["fields"]["mothers_name"]}            ${message_error}
  ...	ELSE IF	'${field}' == 'cbo'                             Should Be Equal As Strings    ${response.json()["fields"]["cbo"]}                     ${message_error}
