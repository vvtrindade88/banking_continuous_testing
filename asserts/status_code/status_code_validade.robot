*** Keyword ***
validar status code
    [Arguments]  ${status_code}  ${message_error}
    Run Keyword If    '${response.status_code}' == '500'  Fatal Error  msg=|| Fatal Error || EXECUÇÃO DA SUITE DE TESTE INTERROMPIDA :: status_code: ${response.status_code} || message: ${response.json()["message"]} || X-REQUEST-ID: ${response.headers['X-REQUEST-ID']}
    ...	ELSE IF	'${response.status_code}' != '${status_code}'  Fail  msg=${message_error} :: status_code: ${response.status_code} || message: ${response.json()["message"]} || X-REQUEST-ID: ${response.headers['X-REQUEST-ID']}
