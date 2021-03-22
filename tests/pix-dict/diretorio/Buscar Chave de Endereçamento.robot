*** Settings ***
Documentation    Funcionalidade: Criar Chave de Endereçamento
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              Desejo criar uma chave de endereçamento PIX associada à minha conta
Resource         ../../../hooks/accreditation/accreditation_create_holder_active.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_create_entry.robot
Resource         ../../../apis/pix-dict/diretorio/get/pix_dict_verification_code.robot
Resource         ../../../apis/pix-dict/diretorio/get/pix_dict_get_entry.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_confirm_propriety.robot
Resource         ../../../asserts/pix-dict/diretório/asserts.robot
Library          FakerLibrary    locale=pt_BR

*** Test Case ***
###################################################
###################################### Floxo Básico
###################################################

Cenário: Buscar chave de endereçamento do tipo EVP
    [Tags]  smoke_test
    [Documentation]  Fluxo Básico

    criar holder individual ativo
    criar chave pix    evp    ${EMPTY}
    buscar chave pix    ${holder_external_key}
    ...                 ${account_external_key}
    ...                 ${entry_external_key}
    ## Asserts
    validar busca da chave pix

Cenário: Buscar chave de endereçamento do tipo Phone
    [Tags]  smoke_test
    [Documentation]  Fluxo Básico

    ${phone}  Random Number  digits=8  fix_len=True
    ${phone_pix}   Set Variable    +55219${phone}
    Set Global Variable  ${phone_pix}

    criar holder individual ativo
    criar chave pix    phone    ${phone_pix}
    buscar chave pix    ${holder_external_key}
    ...                 ${account_external_key}
    ...                 ${entry_external_key}
    ## Asserts
    validar busca da chave pix

Cenário: Buscar chave de endereçamento do tipo Email
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    ${email_pix}  Email
    Set Global Variable    ${email_pix}

    criar holder individual ativo
    criar chave pix    email    ${email_pix}
    buscar chave pix    ${holder_external_key}
    ...                 ${account_external_key}
    ...                 ${entry_external_key}
    ## Asserts
    validar busca da chave pix

Cenário: Buscar chave de endereçamento do tipo CPF
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    criar holder individual ativo
    criar chave pix    national_registration    ${EMPTY}
    buscar chave pix    ${holder_external_key}
    ...                 ${account_external_key}
    ...                 ${entry_external_key}
    ## Asserts
    validar busca da chave pix

Cenário: Buscar chave de endereçamento do tipo CNPJ
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    criar holder business ativo
    criar chave pix    national_registration    ${EMPTY}
    buscar chave pix    ${holder_external_key}
    ...                 ${account_external_key}
    ...                 ${entry_external_key}
    ## Asserts
    validar busca da chave pix
