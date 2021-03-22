*** Keywords ***
validar invalid request
  [Arguments]  ${message}  ${message_code}
  Log    Validando response invalid request
  Should Be Equal As Integers   ${response.status_code}              400
  Should Be Equal               ${response.json()["status"]}         bad_request
  Should Be Equal               ${response.json()["category"]}       business
  Should Be Equal As Integers   ${response.json()["code"]}           ${message_code}
  Should Be Equal As Integers   ${response.json()["status_code"]}    400
  Should Be Equal               ${response.json()["message"]}        ${message}
  Should Be Equal               ${response.json()["type"]}           invalid_request
