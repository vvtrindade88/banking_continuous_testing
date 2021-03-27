*** Settings ***
Documentation    Funcionalidade: Confirmação de Propriedade de Chave de Endereçamento
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              E portador de uma chave de endereçamento do tipo Email ou Telefone
...              Desejo confirmar a propriedade da chave de endereçamento
Resource         ../../../hooks/accreditation/accreditation_create_holder_active.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_create_entry.robot
Resource         ../../../apis/pix-dict/diretorio/get/pix_dict_verification_code.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_confirm_propriety.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_resend_verification_code.robot
Resource         ../../../asserts/pix-dict/diretório/asserts.robot
Resource         ../../../asserts/pix-dict/diretório/not_found.robot
Library          FakerLibrary    locale=pt_BR

*** Test Case ***
###################################################
###################################### Floxo Básico
###################################################

Cenário: Confirmar propriedade de chave de endereçamento do tipo Phone
    [Tags]  smoke_test
    [Documentation]  Fluxo de Exceção

    ${phone}  Random Number  digits=8  fix_len=True
    ${phone_pix}   Set Variable    +55219${phone}
    Set Global Variable  ${phone_pix}

    criar holder individual ativo
    criar chave pix    type=phone
    ...                value=${phone_pix}
    ## Asserts
    validar chave pix               status_code=202
    ...                             key_status=waiting_ownership_verification
    ...                             key_type=${type}
    ...                             key_value=${value}
    ...                             account_external_key=${account_external_key}
    ...                             marketplace_external_key=${marketplace_external_key}
    ...                             holder_external_key=${holder_external_key}
    ...                             account_number=${account_number}
    ...                             account_routing_number=${account_routing_number}
    ...                             account_type=CACC
    ...                             owner_key_name=${holder_name}
    ...                             national_registration=${national_registration}
    ...                             holder_type=${holder_type}
    ...                             psp_code=19468242
    ...                             psp_name=Zoop Tecnologia e Meios de Pagamento S.A.

    buscar verification code    holder_external_key=${holder_external_key}
    ...                         account_external_key=${account_external_key}
    ...                         entry_external_key=${entry_external_key}

    confirmar propriedade da chave pix    verification_code=${verification_code}
    ...                                   holder_external_key=${holder_external_key}
    ...                                   account_external_key=${account_external_key}
    ...                                   entry_external_key=${entry_external_key}

    ## Asserts
    validar chave pix               status_code=201
    ...                             key_status=active
    ...                             key_type=${type}
    ...                             key_value=${value}
    ...                             account_external_key=${account_external_key}
    ...                             marketplace_external_key=${marketplace_external_key}
    ...                             holder_external_key=${holder_external_key}
    ...                             account_number=${account_number}
    ...                             account_routing_number=${account_routing_number}
    ...                             account_type=CACC
    ...                             owner_key_name=${holder_name}
    ...                             national_registration=${national_registration}
    ...                             holder_type=${holder_type}
    ...                             psp_code=19468242
    ...                             psp_name=Zoop Tecnologia e Meios de Pagamento S.A.


Cenário: Confirmar propriedade de chave de endereçamento do tipo Email
    [Tags]  smoke_test
    [Documentation]  Fluxo de Exceção

    ${email_pix}  Email
    Set Global Variable    ${email_pix}

    criar holder individual ativo
    criar chave pix    type=email
    ...                value=${email_pix}
    ## Asserts
    ## Asserts
    validar chave pix               status_code=202
    ...                             key_status=waiting_ownership_verification
    ...                             key_type=${type}
    ...                             key_value=${value}
    ...                             account_external_key=${account_external_key}
    ...                             marketplace_external_key=${marketplace_external_key}
    ...                             holder_external_key=${holder_external_key}
    ...                             account_number=${account_number}
    ...                             account_routing_number=${account_routing_number}
    ...                             account_type=CACC
    ...                             owner_key_name=${holder_name}
    ...                             national_registration=${national_registration}
    ...                             holder_type=${holder_type}
    ...                             psp_code=19468242
    ...                             psp_name=Zoop Tecnologia e Meios de Pagamento S.A.

    buscar verification code    holder_external_key=${holder_external_key}
    ...                         account_external_key=${account_external_key}
    ...                         entry_external_key=${entry_external_key}

    confirmar propriedade da chave pix    verification_code=${verification_code}
    ...                                   holder_external_key=${holder_external_key}
    ...                                   account_external_key=${account_external_key}
    ...                                   entry_external_key=${entry_external_key}
    ## Asserts
    validar chave pix               status_code=201
    ...                             key_status=active
    ...                             key_type=${type}
    ...                             key_value=${value}
    ...                             account_external_key=${account_external_key}
    ...                             marketplace_external_key=${marketplace_external_key}
    ...                             holder_external_key=${holder_external_key}
    ...                             account_number=${account_number}
    ...                             account_routing_number=${account_routing_number}
    ...                             account_type=CACC
    ...                             owner_key_name=${holder_name}
    ...                             national_registration=${national_registration}
    ...                             holder_type=${holder_type}
    ...                             psp_code=19468242
    ...                             psp_name=Zoop Tecnologia e Meios de Pagamento S.A.

########################################################
###################################### Floxo Alternativo
########################################################

Cenário: Reenviar código de verificação
    [Tags]  smoke_test
    [Documentation]  Fluxo Alternativo

    ${email_pix}  Email
    Set Global Variable    ${email_pix}

    criar holder individual ativo
    criar chave pix    type=email
    ...                value=${email_pix}
    ## Asserts
    validar chave pix               status_code=202
    ...                             key_status=waiting_ownership_verification
    ...                             key_type=${type}
    ...                             key_value=${value}
    ...                             account_external_key=${account_external_key}
    ...                             marketplace_external_key=${marketplace_external_key}
    ...                             holder_external_key=${holder_external_key}
    ...                             account_number=${account_number}
    ...                             account_routing_number=${account_routing_number}
    ...                             account_type=CACC
    ...                             owner_key_name=${holder_name}
    ...                             national_registration=${national_registration}
    ...                             holder_type=${holder_type}
    ...                             psp_code=19468242
    ...                             psp_name=Zoop Tecnologia e Meios de Pagamento S.A.

    reenviar verification code    holder_external_key=${holder_external_key}
    ...                           account_external_key=${account_external_key}
    ...                           entry_external_key=${entry_external_key}
    #Asserts
    validar reenvio do codigo de verificação    message=Ownership verification code recreated and sent successfully

    buscar verification code    holder_external_key=${holder_external_key}
    ...                         account_external_key=${account_external_key}
    ...                         entry_external_key=${entry_external_key}

    confirmar propriedade da chave pix    verification_code=${verification_code}
    ...                                   holder_external_key=${holder_external_key}
    ...                                   account_external_key=${account_external_key}
    ...                                   entry_external_key=${entry_external_key}
    ## Asserts
    validar chave pix               status_code=201
    ...                             key_status=active
    ...                             key_type=${type}
    ...                             key_value=${value}
    ...                             account_external_key=${account_external_key}
    ...                             marketplace_external_key=${marketplace_external_key}
    ...                             holder_external_key=${holder_external_key}
    ...                             account_number=${account_number}
    ...                             account_routing_number=${account_routing_number}
    ...                             account_type=CACC
    ...                             owner_key_name=${holder_name}
    ...                             national_registration=${national_registration}
    ...                             holder_type=${holder_type}
    ...                             psp_code=19468242
    ...                             psp_name=Zoop Tecnologia e Meios de Pagamento S.A.

####################################################
###################################### Floxo Exceção
####################################################

Cenário: Confirmar proprierdade de de chave de endereçamento utilizando o código de verificação inválido
    [Tags]  smoke_test
    [Documentation]  Fluxo de Exceção

    ${phone}  Random Number  digits=8  fix_len=True
    ${phone_pix}   Set Variable    +55219${phone}
    Set Global Variable  ${phone_pix}

    criar holder individual ativo
    criar chave pix    type=phone
    ...                value=${phone_pix}
    ## Asserts
    validar chave pix               status_code=202
    ...                             key_status=waiting_ownership_verification
    ...                             key_type=${type}
    ...                             key_value=${value}
    ...                             account_external_key=${account_external_key}
    ...                             marketplace_external_key=${marketplace_external_key}
    ...                             holder_external_key=${holder_external_key}
    ...                             account_number=${account_number}
    ...                             account_routing_number=${account_routing_number}
    ...                             account_type=CACC
    ...                             owner_key_name=${holder_name}
    ...                             national_registration=${national_registration}
    ...                             holder_type=${holder_type}
    ...                             psp_code=19468242
    ...                             psp_name=Zoop Tecnologia e Meios de Pagamento S.A.

    buscar verification code    holder_external_key=${holder_external_key}
    ...                         account_external_key=${account_external_key}
    ...                         entry_external_key=${entry_external_key}

    confirmar propriedade da chave pix    verification_code=123abc
    ...                                   holder_external_key=${holder_external_key}
    ...                                   account_external_key=${account_external_key}
    ...                                   entry_external_key=${entry_external_key}
    ## Asserts
    validar not found    message=Ownership entry not found
    ...                  message_code=3003

Cenário: Confirmar proprierdade de de chave de endereçamento utilizando sem informar o código de verificação
    [Tags]  smoke_test
    [Documentation]  Fluxo de Exceção

    ${phone}  Random Number  digits=8  fix_len=True
    ${phone_pix}   Set Variable    +55219${phone}
    Set Global Variable  ${phone_pix}

    criar holder individual ativo
    criar chave pix    type=phone
    ...                value=${phone_pix}
    ## Asserts
    validar chave pix               status_code=202
    ...                             key_status=waiting_ownership_verification
    ...                             key_type=${type}
    ...                             key_value=${value}
    ...                             account_external_key=${account_external_key}
    ...                             marketplace_external_key=${marketplace_external_key}
    ...                             holder_external_key=${holder_external_key}
    ...                             account_number=${account_number}
    ...                             account_routing_number=${account_routing_number}
    ...                             account_type=CACC
    ...                             owner_key_name=${holder_name}
    ...                             national_registration=${national_registration}
    ...                             holder_type=${holder_type}
    ...                             psp_code=19468242
    ...                             psp_name=Zoop Tecnologia e Meios de Pagamento S.A.

    buscar verification code    holder_external_key=${holder_external_key}
    ...                         account_external_key=${account_external_key}
    ...                         entry_external_key=${entry_external_key}

    confirmar propriedade da chave pix    verification_code=${EMPTY}
    ...                                   holder_external_key=${holder_external_key}
    ...                                   account_external_key=${account_external_key}
    ...                                   entry_external_key=${entry_external_key}
    ## Asserts
    validar not found    message=Ownership entry not found
    ...                  message_code=3003
