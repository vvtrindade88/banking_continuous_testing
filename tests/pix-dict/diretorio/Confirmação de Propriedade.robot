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
Resource         ../../../resources/pix-dict/diretório/asserts.robot
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
    criar chave pix    phone    ${phone_pix}
    ## Asserts
    validar criação da chave pix

    buscar verification code    ${holder_external_key}    ${account_external_key}    ${entry_external_key}
    #confirmar propriedade da chave pix    ${verification_code}
    confirmar propriedade da chave pix    ${verification_code}    ${holder_external_key}    ${account_external_key}    ${entry_external_key}
    ## Asserts
    validar ativação da chave de endereçamento


Cenário: Confirmar propriedade de chave de endereçamento do tipo Email
    [Tags]  smoke_test
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
    ## Asserts
    validar ativação da chave de endereçamento

########################################################
###################################### Floxo Alternativo
########################################################

Cenário: Reenviar código de verificação
    [Tags]  smoke_test
    [Documentation]  Fluxo Alternativo

    ${email_pix}  Email
    Set Global Variable    ${email_pix}

    criar holder individual ativo
    criar chave pix    email    ${email_pix}
    ## Asserts
    validar criação da chave pix

    reenviar verification code
    #Asserts
    validar reenvio do codigo de verificação

    buscar verification code    ${holder_external_key}    ${account_external_key}    ${entry_external_key}
    #confirmar propriedade da chave pix    ${verification_code}
    confirmar propriedade da chave pix    ${verification_code}    ${holder_external_key}    ${account_external_key}    ${entry_external_key}
    ## Asserts
    validar ativação da chave de endereçamento

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
    criar chave pix    phone    ${phone_pix}
    ## Asserts
    validar criação da chave pix

    buscar verification code    ${holder_external_key}    ${account_external_key}    ${entry_external_key}
    #confirmar propriedade da chave pix    ${verification_code}
    confirmar propriedade da chave pix    123abc    ${holder_external_key}    ${account_external_key}    ${entry_external_key}
    ## Asserts
    validar not found    Ownership entry not found    3003

Cenário: Confirmar proprierdade de de chave de endereçamento utilizando sem informar o código de verificação
    [Tags]  smoke_test
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
    confirmar propriedade da chave pix    ${EMPTY}    ${holder_external_key}    ${account_external_key}    ${entry_external_key}

    ## Asserts
    validar not found    Ownership entry not found    3003
