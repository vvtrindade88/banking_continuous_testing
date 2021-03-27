*** Settings ***
Documentation    Funcionalidade: Criar Chave de Endereçamento
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              Desejo criar uma chave de endereçamento PIX associada à minha conta
Resource         ../../../hooks/accreditation/accreditation_create_holder_active.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_create_entry.robot
Resource         ../../../apis/pix-dict/diretorio/get/pix_dict_verification_code.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_confirm_propriety.robot
Resource         ../../../asserts/pix-dict/diretório/asserts.robot
Resource         ../../../asserts/pix-dict/diretório/invalid_request.robot
Resource         ../../../asserts/pix-dict/diretório/not_found.robot
Resource         ../../../asserts/pix-dict/diretório/precondition_failed.robot
Library          FakerLibrary    locale=pt_BR

*** Test Case ***
###################################################
###################################### Floxo Básico
###################################################

Cenário: Criando Chave de Endereçamento do tipo EVP
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    criar holder individual ativo
    criar chave pix    type=evp
    ...                value=${EMPTY}
    ## Asserts
    validar chave pix               status_code=201
    ...                             key_status=active
    ...                             key_type=${type}
    ...                             key_value=${EMPTY}
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

Cenário: Criando Chave de Endereçamento do tipo Telefone
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

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

Cenário: Criando Chave de Endereçamento do tipo Email
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

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

Cenário: Criando Chave de Endereçamento do tipo CPF
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    criar holder individual ativo
    criar chave pix    type=national_registration
    ...                value=${EMPTY}
    ## Asserts
    validar chave pix               status_code=201
    ...                             key_status=active
    ...                             key_type=${type}
    ...                             key_value=${national_registration}
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

Cenário: Criando Chave de Endereçamento do tipo CNPJ
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    criar holder business ativo
    criar chave pix    type=national_registration
    ...                value=${EMPTY}
    ## Asserts
    validar chave pix               status_code=201
    ...                             key_status=active
    ...                             key_type=${type}
    ...                             key_value=${national_registration}
    ...                             account_external_key=${account_external_key}
    ...                             marketplace_external_key=${marketplace_external_key}
    ...                             holder_external_key=${holder_external_key}
    ...                             account_number=${account_number}
    ...                             account_routing_number=${account_routing_number}
    ...                             account_type=CACC
    ...                             owner_key_name=${legal_name}
    ...                             national_registration=${national_registration}
    ...                             holder_type=${holder_type}
    ...                             psp_code=19468242
    ...                             psp_name=Zoop Tecnologia e Meios de Pagamento S.A.


# ####################################################
# ###################################### Floxo Exceção
# ####################################################

Cenário: Extrapolar a quantidade máxima de solicitações de criação de chaves de acesso para Holder Individual
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder individual ativo
    FOR  ${index}  IN RANGE  6
        criar chave pix    type=evp
        ...                value=${EMPTY}
    END
    ## Asserts
    validar precondition failed    message=Maximum entry count allowed reached
    ...                            message_code=4001

Cenário: Extrapolar a quantidade máxima de solicitações de criação de chaves de acesso para Holder Business
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder business ativo
    FOR  ${index}  IN RANGE  21
        criar chave pix    type=evp
        ...                value=${EMPTY}
    END
    ## Asserts
    validar precondition failed    message=Maximum entry count allowed reached
    ...                            message_code=4001

Cenário: Criar chave de endereçamento "EVP" enviando valores
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder individual ativo
    criar chave pix    type=evp
    ...                value=abc1234
    ## Asserts
    validar invalid request    message=Key value must not be informed for national_registration or evp types
    ...                        message_code=1005

Cenário: Criar chave de endereçamento "National Registration" enviando valores
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder individual ativo
    criar chave pix    type=national_registration
    ...                value=11569538042
    ## Asserts
    validar invalid request    message=Key value must not be informed for national_registration or evp types
    ...                        message_code=1005

Cenário: Criar chave de endereçamento "Phone" sem informar o número do telefone
     [Tags]  regression_test
     [Documentation]  Fluxo de Exceção

     criar holder individual ativo
     criar chave pix    type=phone
     ...                value=${EMPTY}
     ## Asserts
     validar invalid request    message=Phone is required
     ...                        message_code=1000

Cenário: Criar chave de endereçamento "Phone" com telefone no formato inválido
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder individual ativo
    criar chave pix    type=phone
    ...                value=(21)959632145
    ## Asserts
    validar invalid request    message=Key value is not a valid phone format
    ...                        message_code=1001

Cenário: Criar chave de endereçamento "Email" sem informar o email
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder individual ativo
    criar chave pix    type=email
    ...                value=${EMPTY}
    ## Asserts
    validar invalid request    message=Email is required
    ...                        message_code=1000

Cenário: Criar chave de endereçamento "Email" com email no formato invalido
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder individual ativo
    criar chave pix    type=email
    ...                value=email.com.br
    ## Asserts
    validar invalid request    message=Key value is not a valid email format
    ...                        message_code=1001

Cenário: Criar chave de endereçamento "Phone" utilizando uma chave já cadastrada e ativa
    [Tags]  regression_test
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
    criar chave pix    type=phone
    ...                value=${phone_pix}
    ## Asserts
    validar precondition failed    message=Entry already created
    ...                            message_code=4000


Cenário: Criar chave de endereçamento "Email" utilizando uma chave já cadastrada e ativa
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

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

    buscar verification code    holder_external_key=${holder_external_key}
    ...                         account_external_key=${account_external_key}
    ...                         entry_external_key=${entry_external_key}

    confirmar propriedade da chave pix    verification_code=${verification_code}
    ...                                   holder_external_key=${holder_external_key}
    ...                                   account_external_key=${account_external_key}
    ...                                   entry_external_key=${entry_external_key}

    criar chave pix    type=email
    ...                value=${email_pix}
    ## Asserts
    validar precondition failed    message=Entry already created
    ...                            message_code=4000
