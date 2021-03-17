*** Keywords ***
validar status da chave após criação da reivindicação
    Should Be Equal    ${response.json()["status"]}    waiting_ownership_claiming   
