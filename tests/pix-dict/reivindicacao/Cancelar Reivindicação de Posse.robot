*** Settings ***
Documentation    Funcionalidade: Cancelar Reivindicação de Posse
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              Desejo cancelar a reivindicação de posse de uma chave de endereçamento
Resource         ../../../hooks/accreditation/accreditation_create_holder_active.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_create_entry.robot
Resource         ../../../apis/pix-dict/diretorio/get/pix_dict_verification_code.robot
Resource         ../../../apis/pix-dict/diretorio/get/pix_dict_get_entry.robot
Resource         ../../../apis/pix-dict/diretorio/post/pix_dict_confirm_propriety.robot
Resource         ../../../apis/pix-dict/reivindicação/post/pix_dict_create_claims.robot
Resource         ../../../apis/pix-dict/reivindicação/get/pix_dict_get_claims.robot
Resource         ../../../apis/pix-dict/reivindicação/post/pix_dict_cancel_claims.robot
Resource         ../../../apis/pix-dict/reivindicação/post/pix_dict_receive_claim_notification.robot
Resource         ../../../asserts/pix-dict/diretório/asserts.robot
Resource         ../../../asserts/pix-dict/reividincacao/asserts.robot
Library          FakerLibrary    locale=pt_BR


*** Test Case ***
Cenário: Cancelamento de Reivindiação pelo Reivindicador
    #####################################
    ## Criando chave pix do tipo telefone
    #####################################
    [Tags]  smoke_test  regression_test
    [Documentation]  Fluxo Básico

    ${phone}  Random Number  digits=8  fix_len=True
    ${phone_pix}   Set Variable    +55219${phone}
    Set Global Variable  ${phone_pix}

    ############################################################
    ## Criando primeira chave de endereçamento com status active
    ############################################################
    criar holder individual ativo
    criar chave pix    phone    ${phone_pix}

    ###################################################################
    ## Coleta de váriaveis do Holder Owner (proprietário da chave pix)
    ###################################################################
    ${holder_owner}                         Set Variable   ${holder_external_key}
    ${holder_name_owner}                    Set Variable   ${holder_name}
    ${national_registration_owner}          Set Variable   ${national_registration}
    ${account_owner}                        Set Variable   ${account_external_key}
    ${account_number_owner}                 Set Variable   ${account_number}
    ${entry_owner}                          Set Variable   ${entry_external_key}

    Log  Holder Owner :: ${holder_owner}
    Log  Account Owner :: ${account_owner}
    Log  Account Number Owner :: ${account_number_owner}
    Log  National Registration Holder Owner :: ${national_registration_owner}
    Log  Entry Owner :: ${entry_owner}

    ######################################
    ## Confirmar propriedade da chave pix
    #####################################
    buscar verification code    ${holder_owner}    ${account_owner}    ${entry_owner}
    confirmar propriedade da chave pix    ${verification_code}    ${holder_owner}    ${account_owner}    ${entry_owner}

    ## Asserts
    validar ativação da chave de endereçamento

    ################################################################################
    ## Criando segunda chave de endereçamento com status waiting_ownership_claiming
    ################################################################################
    criar holder individual ativo
    criar chave pix    phone    ${phone_pix}

    #####################################################################
    ## Coleta de váriaveis do Holder Claimer (reivindicador da chave pix)
    #####################################################################
    ${holder_claimer}   Set Variable   ${holder_external_key}
    ${account_claimer}  Set Variable   ${account_external_key}
    ${entry_claimer}    Set Variable   ${entry_external_key}
    Log  Holder Claimer :: ${holder_claimer}
    Log  Account Claimer :: ${account_claimer}
    Log  Entry Claimer :: ${entry_claimer}

    #####################################
    ## Confirmar propriedade da chave pix
    #####################################
    buscar verification code    ${holder_claimer}    ${account_claimer}    ${entry_claimer}
    confirmar propriedade da chave pix    ${verification_code}    ${holder_claimer}    ${account_claimer}    ${entry_claimer}

    #Asserts
    #buscar chave pix
    validar status da chave após criação da reivindicação

    ####################################################
    ## [Holder Claimer] - Criando reivindicação de posse
    ####################################################
    criar reivindicação de posse    ${holder_claimer}    ${account_claimer}    ${entry_claimer}

    ##################################
    ## Validar status da reivindicação
    ##################################
    buscar reivindicação de posse    ${holder_claimer}    ${account_claimer}    ${claim_external_key}
    validar status da reivindicação    open

    ########################################################################################
    ## [Holder Owner] - Recebendo notificação da reivindicação de posse [WAITING_RESOLUTION]
    ########################################################################################
    receber notificação de reivindicação    ${phone_pix}    ${account_number_owner}    ${national_registration_owner}    ${holder_name_owner}    ${claim_external_key}    WAITING_RESOLUTION

    ##################################
    ## Validar status da reivindicação
    ##################################
    buscar reivindicação de posse    ${holder_claimer}    ${account_claimer}    ${claim_external_key}
    validar status da reivindicação    waiting_resolution

    ##############################################
    ## [Holder Owner] - Cancelar reivindicação
    ##############################################
    FOR  ${index}  IN RANGE  20
        cancelar reivindicação de posse    ${holder_owner}    ${account_owner}    ${claim_external_key}
        Exit For Loop If    '${response.json()["message"]}' == 'Claim cancelled successfully'
        Sleep  10
    END

    ##################################
    ## Validar status da reivindicação
    ##################################
    buscar reivindicação de posse    ${holder_claimer}    ${account_claimer}    ${claim_external_key}
    validar status da reivindicação    waiting_entry_ownership_confirm_to_cancel


# Cenário: Cancelamento de Reivindiação pelo Doador
