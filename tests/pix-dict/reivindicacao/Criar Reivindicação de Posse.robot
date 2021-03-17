*** Settings ***
Documentation    Funcionalidade: Criar Reivindicação de Posse
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              Desejo reivindicar a posse de uma chave de endereçamento
Resource         ../../../hooks/accreditation/accreditation_create_holder_active.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_create_entry.robot
Resource         ../../../apis/pix-dict/diretorio/get/pix_dict_verification_code.robot
Resource         ../../../apis/pix-dict/diretorio/get/pix_dict_get_entry.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_confirm_propriety.robot
Resource         ../../../apis/pix-dict/reivindicação/post/pix_dict_create_claims.robot
Resource         ../../../apis/pix-dict/reivindicação/get/pix_dict_get_claims.robot
Resource         ../../../apis/pix-dict/reivindicação/post/pix_dict_confirm_claims.robot
Resource         ../../../apis/pix-dict/reivindicação/post/pix_dict_receive_claim_notification.robot
Resource         ../../../resources/pix-dict/diretório/asserts.robot
Resource         ../../../resources/pix-dict/reividincacao/asserts.robot
Library          FakerLibrary    locale=pt_BR
Library          Collections


*** Test Cases ***
###################################################
###################################### Floxo Básico
###################################################
Cenário: Criar Reivindicação de Posse para chave do tipo telefone
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    ${phone}  Random Number  digits=8  fix_len=True
    ${phone_pix}   Set Variable    +55219${phone}
    Set Global Variable  ${phone_pix}

    ## Criando primeira chave de endereçamento com status active
    criar holder individual ativo
    criar chave pix    phone    ${phone_pix}

    buscar verification code
    confirmar propriedade da chave pix    ${verification_code}
    ## Asserts
    validar ativação da chave de endereçamento

    ## Criando segunda chave de endereçamento com status waiting_ownership_claiming
    criar holder individual ativo
    criar chave pix    phone    ${phone_pix}

    buscar verification code
    confirmar propriedade da chave pix    ${verification_code}
    #Asserts
    validar status da chave após criação da reivindicação

    criar reivindicação de posse
    receber notificação de reivindicação    ${value}    ${account_number}    ${national_registration}    ${holder_name}    ${claim_external_key}
    confirmar reivindicação de posse
    buscar reivindicação de posse


# Cenário: Criar Reivindicação de Posse para chave do tipo email
#     [Tags]  smoke_test
#     [Documentation]  Fluxo de Exceção
#
#     ${email_pix}  Email
#     Set Global Variable    ${email_pix}
#
#     ## Criando primeira chave de endereçamento com status active
#     criar holder individual ativo
#     criar chave pix    email    ${email_pix}
#     ## Asserts
#     validar criação da chave pix
#
#     buscar verification code
#     confirmar propriedade da chave pix    ${verification_code}
#     ## Asserts
#     validar ativação da chave de endereçamento
#
#     ## Criando segunda chave de endereçamento com status waiting_ownership_claiming
#     criar holder individual ativo
#     criar chave pix    email    ${email_pix}
#     ## Asserts
#     validar criação da chave pix
#
#     buscar verification code
#     confirmar propriedade da chave pix    ${verification_code}
#     #Asserts
#     validar status da chave após criação da reivindicação
