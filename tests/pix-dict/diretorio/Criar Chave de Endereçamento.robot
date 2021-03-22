*** Settings ***
Documentation    Funcionalidade: Criar Chave de Endereçamento
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              Desejo criar uma chave de endereçamento PIX associada à minha conta
Resource         ../../../hooks/accreditation/accreditation_create_holder_active.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_create_entry.robot
Resource         ../../../apis/pix-dict/diretorio/get/pix_dict_verification_code.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_confirm_propriety.robot
Resource         ../../../asserts/pix-dict/diretório/asserts.robot
Library          FakerLibrary    locale=pt_BR

*** Test Case ***
###################################################
###################################### Floxo Básico
###################################################

Cenário: Criando Chave de Endereçamento do tipo EVP
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    criar holder individual ativo
    criar chave pix    evp    ${EMPTY}
    ## Asserts
    validar criação da chave pix

Cenário: Criando Chave de Endereçamento do tipo Telefone
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    ${phone}  Random Number  digits=8  fix_len=True
    ${phone_pix}   Set Variable    +55219${phone}
    Set Global Variable  ${phone_pix}

    criar holder individual ativo
    criar chave pix    phone    ${phone_pix}
    ## Asserts
    validar criação da chave pix

Cenário: Criando Chave de Endereçamento do tipo Email
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    ${email_pix}  Email
    Set Global Variable    ${email_pix}

    criar holder individual ativo
    criar chave pix    email    ${email_pix}
    ## Asserts
    validar criação da chave pix

Cenário: Criando Chave de Endereçamento do tipo CPF
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    criar holder individual ativo
    criar chave pix    national_registration    ${EMPTY}
    ## Asserts
    validar criação da chave pix

Cenário: Criando Chave de Endereçamento do tipo CNPJ
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    criar holder business ativo
    criar chave pix    national_registration    ${EMPTY}
    ## Asserts
    validar criação da chave pix


####################################################
###################################### Floxo Exceção
####################################################

Cenário: Extrapolar a quantidade máxima de solicitações de criação de chaves de acesso para Holder Individual
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder individual ativo
    FOR  ${index}  IN RANGE  6
        criar chave pix    evp    ${EMPTY}
    END
    ## Asserts
    validar precondition failed    Maximum entry count allowed reached  4001

Cenário: Extrapolar a quantidade máxima de solicitações de criação de chaves de acesso para Holder Business
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder business ativo
    FOR  ${index}  IN RANGE  21
        criar chave pix    evp    ${EMPTY}
    END
    ## Asserts
    validar precondition failed    Maximum entry count allowed reached  4001

Cenário: Criar chave de endereçamento "EVP" enviando valores
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder individual ativo
    criar chave pix    evp    abc1234
    ## Asserts
    validar invalid request    Key value must not be informed for national_registration or evp types  1005

Cenário: Criar chave de endereçamento "National Registration" enviando valores
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder individual ativo
    criar chave pix    national_registration    11569538042
    ## Asserts
    validar invalid request    Key value must not be informed for national_registration or evp types  1005

Cenário: Criar chave de endereçamento "Phone" sem informar o número do telefone
     [Tags]  regression_test
     [Documentation]  Fluxo de Exceção

     criar holder individual ativo
     criar chave pix    phone    ${EMPTY}
     ## Asserts
     validar invalid request    Phone is required  1000

Cenário: Criar chave de endereçamento "Phone" com telefone no formato inválido
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder individual ativo
    criar chave pix    phone    (21)959632145
    ## Asserts
    validar invalid request    Key value is not a valid phone format  1001

Cenário: Criar chave de endereçamento "Email" sem informar o email
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder individual ativo
    criar chave pix    email    ${EMPTY}
    ## Asserts
    validar invalid request    Email is required  1000

Cenário: Criar chave de endereçamento "Email" com email no formato invalido
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    criar holder individual ativo
    criar chave pix    email    email.com.br
    ## Asserts
    validar invalid request    Key value is not a valid email format  1001

Cenário: Criar chave de endereçamento "Phone" utilizando uma chave já cadastrada e ativa
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    ${phone}  Random Number  digits=8  fix_len=True
    ${phone_pix}   Set Variable    +55219${phone}
    Set Global Variable  ${phone_pix}

    criar holder individual ativo
    criar chave pix    phone    ${phone_pix}
    ## Asserts
    validar criação da chave pix

    buscar verification code    ${holder_external_key}    ${account_external_key}    ${entry_external_key}
    #confirmar propriedade da chave pix    ${verification_code}
    confirmar propriedade da chave pix    ${verification_code}    ${holder_external_key}    ${account_external_key}    ${entry_external_key}

    criar chave pix    phone    ${phone_pix}
    ## Asserts
    validar precondition failed    Entry already created    4000


Cenário: Criar chave de endereçamento "Email" utilizando uma chave já cadastrada e ativa
    [Tags]  regression_test
    [Documentation]  Fluxo de Exceção

    ${email_pix}  Email
    Set Global Variable    ${email_pix}

    criar holder individual ativo
    criar chave pix    email    ${email_pix}
    ## Asserts
    validar criação da chave pix

    buscar verification code    ${holder_external_key}    ${account_external_key}    ${entry_external_key}
    #confirmar propriedade da chave pix    ${verification_code}
    confirmar propriedade da chave pix    ${verification_code}    ${holder_external_key}    ${account_external_key}    ${entry_external_key}

    criar chave pix    email    ${email_pix}
    ## Asserts
    validar precondition failed    Entry already created    4000
