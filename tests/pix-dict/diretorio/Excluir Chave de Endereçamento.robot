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
Resource         ../../../resources/pix-dict/diretório/asserts.robot
Library          FakerLibrary    locale=pt_BR

*** Test Case ***
###################################################
###################################### Floxo Básico
###################################################

Cenário: Excluir chave de endereçamento EVP
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    criar holder individual ativo
    criar chave pix    evp    ${EMPTY}
    ## Asserts
    validar criação da chave pix

    excluir chave pix
    ##Asserts
    validar exclusão da chave pix

Cenário: Excluir Chave de Endereçamento do tipo Telefone
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    ${phone}  Random Number  digits=8  fix_len=True
    ${phone_pix}   Set Variable    +55219${phone}
    Set Global Variable  ${phone_pix}

    criar holder individual ativo
    criar chave pix    phone    ${phone_pix}
    ## Asserts
    validar criação da chave pix

    excluir chave pix
    ##Asserts
    validar exclusão da chave pix

Cenário: Excluir Chave de Endereçamento do tipo Email
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    ${email_pix}  Email
    Set Global Variable    ${email_pix}

    criar holder individual ativo
    criar chave pix    email    ${email_pix}
    ## Asserts
    validar criação da chave pix

    excluir chave pix
    ##Asserts
    validar exclusão da chave pix

Cenário: Excluir Chave de Endereçamento do tipo CPF
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    criar holder individual ativo
    criar chave pix    national_registration    ${EMPTY}
    ## Asserts
    validar criação da chave pix

    excluir chave pix
    ##Asserts
    validar exclusão da chave pix

Cenário: Excluir Chave de Endereçamento do tipo CNPJ
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    criar holder business ativo
    criar chave pix    national_registration    ${EMPTY}
    ## Asserts
    validar criação da chave pix

    excluir chave pix
    ##Asserts
    validar exclusão da chave pix
