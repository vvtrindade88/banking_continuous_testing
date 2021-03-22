*** Keywords ***
validar not found
  [Arguments]  ${message}  ${message_code}
  Log    Validando response nor found
  Should Be Equal As Integers   ${response.status_code}              404
  Should Be Equal               ${response.json()["status"]}         not_found
  Should Be Equal               ${response.json()["category"]}       business
  Should Be Equal As Integers   ${response.json()["code"]}           ${message_code}
  Should Be Equal As Integers   ${response.json()["status_code"]}    404
  Should Be Equal               ${response.json()["message"]}        ${message}
  Should Be Equal               ${response.json()["type"]}           not_found
