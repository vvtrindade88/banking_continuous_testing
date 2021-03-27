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
Resource         ../../../asserts/pix-dict/diretório/not_found.robot
Resource         ../../../asserts/pix-dict/reividincacao/asserts.robot
Library          FakerLibrary    locale=pt_BR


*** Variables ***
${psp_code}                19468242
${psp_name}                Zoop Tecnologia e Meios de Pagamento S.A.

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
    criar chave pix    type=phone
    ...                value=${phone_pix}

    ###################################################################
    ## Coleta de váriaveis do Holder Owner (proprietário da chave pix)
    ###################################################################
    ${holder_owner}                         Set Variable   ${holder_external_key}
    ${holder_type_owner}                    Set Variable   ${holder_type}
    ${holder_name_owner}                    Set Variable   ${holder_name}
    ${national_registration_owner}          Set Variable   ${national_registration}
    ${account_owner}                        Set Variable   ${account_external_key}
    ${account_number_owner}                 Set Variable   ${account_number}
    ${account_routing_number_owner}         Set Variable   ${account_routing_number}
    ${entry_owner}                          Set Variable   ${entry_external_key}

    ######################################
    ## Confirmar propriedade da chave pix
    #####################################
    buscar verification code    holder_external_key=${holder_owner}
    ...                         account_external_key=${account_owner}
    ...                         entry_external_key=${entry_owner}

    confirmar propriedade da chave pix    verification_code=${verification_code}
    ...                                   holder_external_key=${holder_owner}
    ...                                   account_external_key=${account_owner}
    ...                                   entry_external_key=${entry_owner}

    ## Asserts
    validar chave pix               key_status=active
    ...                             key_type=${type}
    ...                             key_value=${value}
    ...                             account_external_key=${account_owner}
    ...                             marketplace_external_key=${marketplace_external_key}
    ...                             holder_external_key=${holder_owner}
    ...                             account_number=${account_number_owner}
    ...                             account_routing_number=${account_routing_number_owner}
    ...                             account_type=CACC
    ...                             owner_key_name=${holder_name_owner}
    ...                             national_registration=${national_registration_owner}
    ...                             holder_type=${holder_type}
    ...                             psp_code=19468242
    ...                             psp_name=Zoop Tecnologia e Meios de Pagamento S.A.

    ################################################################################
    ## Criando segunda chave de endereçamento com status waiting_ownership_claiming
    ################################################################################
    criar holder individual ativo
    criar chave pix    type=phone
    ...                value=${phone_pix}

    #####################################################################
    ## Coleta de váriaveis do Holder Claimer (reivindicador da chave pix)
    #####################################################################
    ${holder_claimer}                         Set Variable   ${holder_external_key}
    ${holder_type_claimer}                    Set Variable   ${holder_type}
    ${holder_name_claimer}                    Set Variable   ${holder_name}
    ${national_registration_claimer}          Set Variable   ${national_registration}
    ${account_claimer}                        Set Variable   ${account_external_key}
    ${account_number_claimer}                 Set Variable   ${account_number}
    ${account_routing_number_claimer}         Set Variable   ${account_routing_number}
    ${entry_claimer}                          Set Variable   ${entry_external_key}

    #####################################
    ## Confirmar propriedade da chave pix
    #####################################
    buscar verification code    holder_external_key=${holder_claimer}
    ...                         account_external_key=${account_claimer}
    ...                         entry_external_key=${entry_claimer}

    confirmar propriedade da chave pix    verification_code=${verification_code}
    ...                                   holder_external_key=${holder_claimer}
    ...                                   account_external_key=${account_claimer}
    ...                                   entry_external_key=${entry_claimer}

    #Asserts
    validar chave pix               key_status=waiting_ownership_claiming
    ...                             key_type=${type}
    ...                             key_value=${value}
    ...                             account_external_key=${account_claimer}
    ...                             marketplace_external_key=${marketplace_external_key}
    ...                             holder_external_key=${holder_claimer}
    ...                             account_number=${account_number_claimer}
    ...                             account_routing_number=${account_routing_number_claimer}
    ...                             account_type=CACC
    ...                             owner_key_name=${holder_name_claimer}
    ...                             national_registration=${national_registration_claimer}
    ...                             holder_type=${holder_type}
    ...                             psp_code=19468242
    ...                             psp_name=Zoop Tecnologia e Meios de Pagamento S.A.

    ####################################################
    ## [Holder Claimer] - Criando reivindicação de posse
    ####################################################
    criar reivindicação de posse    holder_external_key=${holder_claimer}
    ...                             account_external_key=${account_claimer}
    ...                             entry_external_key=${entry_claimer}

    ##################################
    ## Validar status da reivindicação
    ##################################
    buscar reivindicação de posse    holder_external_key=${holder_claimer}
    ...                              account_external_key=${account_claimer}
    ...                              claim_external_key=${claim_external_key}

    validar reivindicação    marketplace_external_key=${marketplace_external_key}
    ...                      claim_type=OWNERSHIP
    ...                      claim_status=open
    ...                      key_value=${value}
    ...                      key_type=${type}
    ...                      claimer_name=${holder_name_claimer}
    ...                      claimer_national_registration=${national_registration_claimer}
    ...                      claimer_type=${holder_type_claimer}
    ...                      claimer_marketplace=${marketplace_external_key}
    ...                      claimer_holder_id=${holder_claimer}
    ...                      claimer_account_id=${account_claimer}
    ...                      claimer_routing_number=${account_routing_number_claimer}
    ...                      claimer_account_number=${account_number_claimer}
    ...                      claimer_account_type=CACC
    ...                      claimer_psp_code=${psp_code}
    ...                      claimer_psp_name=${psp_name}
    ...                      donor_name=${holder_name_owner}
    ...                      donor_national_registration=${national_registration_owner}
    ...                      donor_type=${holder_type_owner}
    ...                      donor_marketplace=${marketplace_external_key}
    ...                      donor_holder_id=${holder_owner}
    ...                      donor_account_id=${account_owner}
    ...                      donor_routing_number=${account_routing_number_owner}
    ...                      donor_account_number=${account_number_owner}
    ...                      donor_account_type=CACC
    ...                      donor_psp_code=${psp_code}
    ...                      donor_psp_name=${psp_name}
    ...                      claim_resource=pix.claim

    ########################################################################################
    ## [Holder Owner] - Recebendo notificação da reivindicação de posse [WAITING_RESOLUTION]
    ########################################################################################
    receber notificação de reivindicação    key_pix=${value}
    ...                                     account_number=${account_number_owner}
    ...                                     claimer_tax_id=${national_registration_owner}
    ...                                     claimer_name=${holder_name_owner}
    ...                                     claim_external_key=${claim_external_key}
    ...                                     claim_notification_status=WAITING_RESOLUTION

    ##################################
    ## Validar status da reivindicação
    ##################################

    buscar reivindicação de posse    holder_external_key=${holder_claimer}
    ...                              account_external_key=${account_claimer}
    ...                              claim_external_key=${claim_external_key}

    validar reivindicação    marketplace_external_key=${marketplace_external_key}
    ...                      claim_type=OWNERSHIP
    ...                      claim_status=waiting_resolution
    ...                      key_value=${value}
    ...                      key_type=${type}
    ...                      claimer_name=${holder_name_claimer}
    ...                      claimer_national_registration=${national_registration_claimer}
    ...                      claimer_type=${holder_type_claimer}
    ...                      claimer_marketplace=${marketplace_external_key}
    ...                      claimer_holder_id=${holder_claimer}
    ...                      claimer_account_id=${account_claimer}
    ...                      claimer_routing_number=${account_routing_number_claimer}
    ...                      claimer_account_number=${account_number_claimer}
    ...                      claimer_account_type=CACC
    ...                      claimer_psp_code=${psp_code}
    ...                      claimer_psp_name=${psp_name}
    ...                      donor_name=${holder_name_owner}
    ...                      donor_national_registration=${national_registration_owner}
    ...                      donor_type=${holder_type_owner}
    ...                      donor_marketplace=${marketplace_external_key}
    ...                      donor_holder_id=${holder_owner}
    ...                      donor_account_id=${account_owner}
    ...                      donor_routing_number=${account_routing_number_owner}
    ...                      donor_account_number=${account_number_owner}
    ...                      donor_account_type=CACC
    ...                      donor_psp_code=${psp_code}
    ...                      donor_psp_name=${psp_name}
    ...                      claim_resource=pix.claim

    ##############################################
    ## [Holder Owner] - Confirmando reivindicação
    ##############################################
    FOR  ${index}  IN RANGE  60
        cancelar reivindicação de posse     holder_external_key=${holder_claimer}
        ...                                 account_external_key=${account_claimer}
        ...                                 claim_external_key=${claim_external_key}

        Exit For Loop If    '${response.json()["message"]}' == 'Claim cancelled successfully'
        #Sleep  10
    END

    ##################################
    ## Validar status da reivindicação
    ##################################
    buscar reivindicação de posse    holder_external_key=${holder_claimer}
    ...                              account_external_key=${account_claimer}
    ...                              claim_external_key=${claim_external_key}

    validar not found    message=Claim not found
    ...                  message_code=3004

#Cenário: Cancelamento de Reivindiação pelo Doador
