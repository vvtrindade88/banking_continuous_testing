*** Keywords ***
validar criação da chave pix

### Validando status_code
  Log     Validando status_code
  Run Keyword If    '${type}' == 'evp'                 Should Be Equal As Integers    ${response.status_code}          201
  ...	ELSE IF	'${type}' == 'phone'                     Should Be Equal As Integers    ${response.status_code}          202
  ...	ELSE IF	'${type}' == 'email'                     Should Be Equal As Integers    ${response.status_code}          202
  ...	ELSE IF	'${type}' == 'national_registration'     Should Be Equal As Integers    ${response.status_code}          201


### Validar status da chave
  Log     Validar status da chave
  Run Keyword If    '${type}' == 'evp'                 Should Be Equal As Strings    ${response.json()["status"]}          active
  ...	ELSE IF	'${type}' == 'phone'                     Should Be Equal As Strings    ${response.json()["status"]}          waiting_ownership_verification
  ...	ELSE IF	'${type}' == 'email'                     Should Be Equal As Strings    ${response.json()["status"]}          waiting_ownership_verification
  ...	ELSE IF	'${type}' == 'national_registration'     Should Be Equal As Strings    ${response.json()["status"]}          active

#### Validando Tipo da chave PIX
  Log    Validando Tipo da chave PIX
  Run Keyword If    '${type}' == 'evp'                 Should Be Equal As Strings    ${response.json()["key"]["type"]}          ${type}
  ...	ELSE IF	'${type}' == 'phone'                     Should Be Equal As Strings    ${response.json()["key"]["type"]}          ${type}
  ...	ELSE IF	'${type}' == 'email'                     Should Be Equal As Strings    ${response.json()["key"]["type"]}          ${type}
  ...	ELSE IF	'${type}' == 'national_registration'     Should Be Equal As Strings    ${response.json()["key"]["type"]}          ${type}

#### Validando Valor da chave PIX
  Log    Validando Valor da chave PIX
  Run Keyword If    '${type}' == 'evp'                 Should Not Be Empty           ${response.json()["key"]["value"]}
  ...	ELSE IF	'${type}' == 'phone'                     Should Be Equal As Strings    ${response.json()["key"]["value"]}          ${phone_pix}
  ...	ELSE IF	'${type}' == 'email'                     Should Be Equal As Strings    ${response.json()["key"]["value"]}          ${email_pix}
  ...	ELSE IF	'${type}' == 'national_registration'     Should Be Equal As Strings    ${response.json()["key"]["value"]}          ${national_registration}

### Validando dados da conta
  Log    Validando dados da conta
  Should Be Equal    ${response.json()["account"]["id"]}               ${account_external_key}
  Should Be Equal    ${response.json()["account"]["marketplace"]}      ${marketplace_external_key}
  Should Be Equal    ${response.json()["account"]["holder"]}           ${holder_external_key}
  Should Be Equal    ${response.json()["account"]["number"]}           ${account_number}
  Should Be Equal    ${response.json()["account"]["routing_number"]}   ${account_routing_number}
  Should Be Equal    ${response.json()["account"]["type"]}             CACC


### Validar Account Owner
  Log    Validar Proprietário da Account Owner
  Run Keyword If    '${holder_type}' == 'individual'   Should Be Equal As Strings    ${response.json()["account"]["owner"]["name"]}          ${holder_name}
  ...	ELSE IF	'${holder_type}' == 'business'           Should Be Equal As Strings    ${response.json()["account"]["owner"]["name"]}          ${legal_name}

  Log    Validar national_registration da Account Owner
  Run Keyword If    '${holder_type}' == 'individual'   Should Be Equal As Strings    ${response.json()["account"]["owner"]["national_registration"]}    ${national_registration}
  ...	ELSE IF	'${holder_type}' == 'business'           Should Be Equal As Strings    ${response.json()["account"]["owner"]["national_registration"]}    ${national_registration}

  Log    Validar Holder Type do Account Owner
  Run Keyword If    '${holder_type}' == 'individual'   Should Be Equal As Strings    ${response.json()["account"]["owner"]["type"]}   ${holder_type}
  ...	ELSE IF	'${holder_type}' == 'business'           Should Be Equal As Strings    ${response.json()["account"]["owner"]["type"]}   ${holder_type}

### Validar PSP
  Log    Validar PSP
  Should Be Equal    ${response.json()["psp"]["code"]}  19468242
  Should Be Equal    ${response.json()["psp"]["name"]}  Zoop Tecnologia e Meios de Pagamento S.A.


validar ativação da chave de endereçamento
  Should Be Equal    ${response.json()["status"]}    active


validar busca da chave pix
  Should Be Equal As Integers   ${response.status_code}              200

### Validar status da chave
  Log     Validar status da chave
  Run Keyword If    '${type}' == 'evp'                 Should Be Equal As Strings    ${response.json()["status"]}          active
  ...	ELSE IF	'${type}' == 'phone'                     Should Be Equal As Strings    ${response.json()["status"]}          waiting_ownership_verification
  ...	ELSE IF	'${type}' == 'email'                     Should Be Equal As Strings    ${response.json()["status"]}          waiting_ownership_verification
  ...	ELSE IF	'${type}' == 'national_registration'     Should Be Equal As Strings    ${response.json()["status"]}          active

#### Validando Tipo da chave PIX
  Log    Validando Tipo da chave PIX
  Run Keyword If    '${type}' == 'evp'                 Should Be Equal As Strings    ${response.json()["key"]["type"]}          ${type}
  ...	ELSE IF	'${type}' == 'phone'                     Should Be Equal As Strings    ${response.json()["key"]["type"]}          ${type}
  ...	ELSE IF	'${type}' == 'email'                     Should Be Equal As Strings    ${response.json()["key"]["type"]}          ${type}
  ...	ELSE IF	'${type}' == 'national_registration'     Should Be Equal As Strings    ${response.json()["key"]["type"]}          ${type}

#### Validando Valor da chave PIX
  Log    Validando Valor da chave PIX
  Run Keyword If    '${type}' == 'evp'                 Should Not Be Empty           ${response.json()["key"]["value"]}
  ...	ELSE IF	'${type}' == 'phone'                     Should Be Equal As Strings    ${response.json()["key"]["value"]}          ${phone_pix}
  ...	ELSE IF	'${type}' == 'email'                     Should Be Equal As Strings    ${response.json()["key"]["value"]}          ${email_pix}
  ...	ELSE IF	'${type}' == 'national_registration'     Should Be Equal As Strings    ${response.json()["key"]["value"]}          ${national_registration}

### Validando dados da conta
  Log    Validando dados da conta
  Should Be Equal    ${response.json()["account"]["id"]}               ${account_external_key}
  Should Be Equal    ${response.json()["account"]["marketplace"]}      ${marketplace_external_key}
  Should Be Equal    ${response.json()["account"]["holder"]}           ${holder_external_key}
  Should Be Equal    ${response.json()["account"]["number"]}           ${account_number}
  Should Be Equal    ${response.json()["account"]["routing_number"]}   ${account_routing_number}
  Should Be Equal    ${response.json()["account"]["type"]}             CACC


### Validar Account Owner
  Log    Validar Proprietário da Account Owner
  Run Keyword If    '${holder_type}' == 'individual'   Should Be Equal As Strings    ${response.json()["account"]["owner"]["name"]}          ${holder_name}
  ...	ELSE IF	'${holder_type}' == 'business'           Should Be Equal As Strings    ${response.json()["account"]["owner"]["name"]}          ${legal_name}

  Log    Validar national_registration da Account Owner
  Run Keyword If    '${holder_type}' == 'individual'   Should Be Equal As Strings    ${response.json()["account"]["owner"]["national_registration"]}    ${national_registration}
  ...	ELSE IF	'${holder_type}' == 'business'           Should Be Equal As Strings    ${response.json()["account"]["owner"]["national_registration"]}    ${national_registration}

  Log    Validar Holder Type do Account Owner
  Run Keyword If    '${holder_type}' == 'individual'   Should Be Equal As Strings    ${response.json()["account"]["owner"]["type"]}   ${holder_type}
  ...	ELSE IF	'${holder_type}' == 'business'           Should Be Equal As Strings    ${response.json()["account"]["owner"]["type"]}   ${holder_type}


### Validar PSP
  Log    Validar PSP
  Should Be Equal    ${response.json()["psp"]["code"]}  19468242
  Should Be Equal    ${response.json()["psp"]["name"]}  Zoop Tecnologia e Meios de Pagamento S.A.


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


validar reenvio do codigo de verificação
  Should Be Equal As Integers   ${response.status_code}          200
  Should Be Equal               ${response.json()["message"]}    Ownership verification code recreated and sent successfully


validar exclusão da chave pix
  Should Be Equal As Integers   ${response.status_code}          200
  Should Be Equal               ${response.json()["message"]}    Entry removed successfully

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
