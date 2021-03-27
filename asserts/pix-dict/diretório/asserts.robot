*** Keywords ***
validar chave pix
  [Arguments]  ${status_code}  ${key_status}  ${key_type}  ${key_value}  ${account_external_key}  ${marketplace_external_key}  ${holder_external_key}  ${account_number}  ${account_routing_number}
  ...          ${account_type}  ${owner_key_name}  ${national_registration}  ${holder_type}  ${psp_code}  ${psp_name}

### Validar status code

  Run Keyword If    '${response.status_code}' != '${status_code}'  Fatal Error  msg=Erro ao criar chave de endereçamento || status_code: ${response.status_code} || message: ${response.json()["message"]}

### Validar status da chave
  Log     Validar status da chave
  Should Be Equal As Strings    ${response.json()["status"]}          ${key_status}

#### Validando Tipo da chave PIX
  Log    Validando Tipo da chave PIX
  Should Be Equal As Strings    ${response.json()["key"]["type"]}          ${key_type}

#### Validando Valor da chave PIX
  Log    Validando Valor da chave PIX
  Run Keyword If    '${type}' == 'evp'        Should Not Be Empty           ${response.json()["key"]["value"]}
  ...	ELSE IF	'${type}' != 'evp'              Should Be Equal As Strings    ${response.json()["key"]["value"]}          ${key_value}

### Validando dados da conta
  Log    Validando dados da conta
  Should Be Equal    ${response.json()["account"]["id"]}               ${account_external_key}
  Should Be Equal    ${response.json()["account"]["marketplace"]}      ${marketplace_external_key}
  Should Be Equal    ${response.json()["account"]["holder"]}           ${holder_external_key}
  Should Be Equal    ${response.json()["account"]["number"]}           ${account_number}
  Should Be Equal    ${response.json()["account"]["routing_number"]}   ${account_routing_number}
  Should Be Equal    ${response.json()["account"]["type"]}             ${account_type}


### Validar Account Owner
  Log    Validar Proprietário da Account Owner
  Should Be Equal As Strings    ${response.json()["account"]["owner"]["name"]}          ${owner_key_name}

  Log    Validar national_registration da Account Owner
  Should Be Equal As Strings    ${response.json()["account"]["owner"]["national_registration"]}    ${national_registration}

  Log    Validar Holder Type do Account Owner
  Should Be Equal As Strings    ${response.json()["account"]["owner"]["type"]}   ${holder_type}

### Validar PSP
  Log    Validar PSP
  Should Be Equal    ${response.json()["psp"]["code"]}  ${psp_code}
  Should Be Equal    ${response.json()["psp"]["name"]}  ${psp_name}


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


validar reenvio do codigo de verificação
  [Arguments]   ${message}
  Should Be Equal As Integers   ${response.status_code}          200
  Should Be Equal               ${response.json()["message"]}    ${message}


validar exclusão da chave pix
  [Arguments]   ${message}
  Should Be Equal As Integers   ${response.status_code}          200
  Should Be Equal               ${response.json()["message"]}    ${message}
