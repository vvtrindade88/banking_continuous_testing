*** Keywords ***
validar precondition failed
  [Arguments]  ${message}  ${message_code}
  Log    Validando response precondition failed
  Should Be Equal As Integers   ${response.status_code}              412
  Should Be Equal               ${response.json()["status"]}         precondition_failed
  Should Be Equal               ${response.json()["category"]}       business
  Should Be Equal As Integers   ${response.json()["code"]}           ${message_code}
  Should Be Equal As Integers   ${response.json()["status_code"]}    412
  Should Be Equal               ${response.json()["message"]}        ${message}
  Should Be Equal               ${response.json()["type"]}           precondition_failed
