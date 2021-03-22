*** Keywords ***
validar status da reivindicação
    [Arguments]  ${claim_status}
    Should Be Equal    ${response.json()["status"]}    ${claim_status}
