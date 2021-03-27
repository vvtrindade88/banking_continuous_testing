*** Settings ***
Documentation    Funcionalidade: Confirmação de Propriedade de Chave de Endereçamento
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              E portador de uma chave de endereçamento
...              Desejo excluir uma chave de endereçamento
Resource         ../../../hooks/accreditation/accreditation_create_holder_active.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_create_entry.robot
Resource         ../../../apis/pix-dict/diretorio/get/pix_dict_verification_code.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_confirm_propriety.robot
Resource         ../../../apis/pix-dict/diretorio/delete/pix_dict_delete_entry.robot
Resource         ../../../asserts/pix-dict/diretório/asserts.robot
Library          FakerLibrary    locale=pt_BR

*** Test Case ***
###################################################
###################################### Floxo Básico
###################################################

Cenário: Excluir chave de endereçamento EVP
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

    excluir chave pix    holder_external_key=${holder_external_key}
    ...                  account_external_key=${account_external_key}
    ...                  entry_external_key=${entry_external_key}
    ##Asserts
    validar exclusão da chave pix    message=Entry removed successfully

Cenário: Excluir Chave de Endereçamento do tipo Telefone
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

    excluir chave pix    holder_external_key=${holder_external_key}
    ...                  account_external_key=${account_external_key}
    ...                  entry_external_key=${entry_external_key}
    ##Asserts
    validar exclusão da chave pix    message=Entry removed successfully

Cenário: Excluir Chave de Endereçamento do tipo Email
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

    excluir chave pix    holder_external_key=${holder_external_key}
    ...                  account_external_key=${account_external_key}
    ...                  entry_external_key=${entry_external_key}
    ##Asserts
    validar exclusão da chave pix    message=Entry removed successfully

Cenário: Excluir Chave de Endereçamento do tipo CPF
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

    excluir chave pix    holder_external_key=${holder_external_key}
    ...                  account_external_key=${account_external_key}
    ...                  entry_external_key=${entry_external_key}
    ##Asserts
    validar exclusão da chave pix    message=Entry removed successfully

Cenário: Excluir Chave de Endereçamento do tipo CNPJ
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

    excluir chave pix    holder_external_key=${holder_external_key}
    ...                  account_external_key=${account_external_key}
    ...                  entry_external_key=${entry_external_key}
    ##Asserts
    validar exclusão da chave pix    message=Entry removed successfully
