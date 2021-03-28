*** Settings ***
Documentation    Funcionalidade: Recebimento de PIX
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              Desejo receber um pagamento PIX
Resource         ../../../hooks/pix-dict/pix_dict_create_active_key_pix.robot
Resource         ../../../hooks/pix_payments/end_to_end_generator.robot
Resource         ../../../hooks/pix_payments/message_id_generator.robot
Resource         ../../../apis/accounts/get/account_get_balance.robot
Resource         ../../../apis/pix-payments/post/pix_payments_create_pix_payment.robot
Resource         ../../../apis/pix-payments/post/pix_admin_receive_payment.robot
Resource         ../../../apis/pix-payments/post/pix_admin_confirm_payment.robot
Resource         ../../../apis/pix-payments/get/pix_payments_get_pix_payment.robot
Resource         ../../../asserts/status_code/status_code_validade.robot
Resource         ../../../asserts/pix-payments/recebimento/conflict.robot
Resource         ../../../asserts/pix-payments/recebimento/precondition_failed.robot
Resource         ../../../asserts/pix-payments/recebimento/asserts.robot
Resource         ../../../asserts/accounts/asserts.robot

*** Variables ***
${psp_code}      19468242
${account_type}  cacc

*** Test Cases ***
#####################
### Fluxo de Básico
#####################
Cenário: Receber PIX
    [Documentation]  Receber PIX com sucesso
    [Tags]  smoke_test

    criar chave pix ativa    holder_type=individual
    ...                      pix_type=phone

    buscar account balance     marketplace_external_key=${marketplace_external_key}
    ...                        account_external_key=${account_external_key}

    ${account_balance_initial}  Set Variable    ${account_balance}

    #######################
    ## Gerar End To End ID
    ######################
    gerar end_to_end_id

    ####################
    ## Gerar Message ID
    ####################
    gerar message_id

    #################
    ## Recebendo PIX
    #################

    receber pagamento pix admin    amount=5000000
    ...                            end_to_end_id=${end_to_end_id}
    ...                            message_id=${message_id}
    ...                            account_number=${account_number}
    ...                            psp_code=${psp_code}
    ...                            account_rounting_number=${account_routing_number}
    ...                            account_type=${account_type}
    ...                            national_registration=${national_registration}

    validar status code    status_code=201
    ...                    message_error=Erro ao receber PIX

    ################################
    ## Confirmar recebimento do PIX
    ################################
    confirmar pagamento pix admin    ${end_to_end_id}

    FOR  ${index}  IN RANGE  100
        buscar account balance     marketplace_external_key=${marketplace_external_key}
        ...                        account_external_key=${account_external_key}

        Exit For Loop If    '${account_balance}' != '${account_balance_initial}'
    END

    ${account_balance_final}  Set Variable    ${account_balance}

    validar crédito na account    account_balance_initial=${account_balance_initial}
    ...                           account_balance_final=${account_balance_final}
    ...                           amount=${amount}


#####################
### Fluxo Alternativo
###########################################################################
### O Teste deverá ser executado apenas com as massas contidas nesse teste
###########################################################################
Cenário: Receber PIX do destinatário com o mesmo documento do remetente
    [Documentation]  A conta que realiza o envio e que recebe o PIX possuem o mesmo documento (CPF ou CNPJ). O PIX deverá ser recebido com sucesso.
    [Tags]  smoke_test

    ${account_external_key}  Set Variable  9908064892484490ab5d7eb832f385ea

    buscar account balance     marketplace_external_key=${marketplace_external_key}
    ...                        account_external_key=${account_external_key}

    ${account_balance_initial}  Set Variable    ${account_balance}

    #######################
    ## Gerar End To End ID
    ######################
    gerar end_to_end_id

    ####################
    ## Gerar Message ID
    ####################
    gerar message_id

    #################
    ## Recebendo PIX
    #################

    receber pagamento pix admin    amount=5000000
    ...                            end_to_end_id=${end_to_end_id}
    ...                            message_id=${message_id}
    ...                            account_number=4604866635
    ...                            psp_code=${psp_code}
    ...                            account_rounting_number=001
    ...                            account_type=${account_type}
    ...                            national_registration=42808422644

    validar status code    status_code=201
    ...                    message_error=Erro ao receber PIX

    ################################
    ## Confirmar recebimento do PIX
    ################################
    confirmar pagamento pix admin    ${end_to_end_id}

    FOR  ${index}  IN RANGE  100
        buscar account balance     marketplace_external_key=${marketplace_external_key}
        ...                        account_external_key=${account_external_key}

        Exit For Loop If    '${account_balance}' != '${account_balance_initial}'
    END

    ${account_balance_final}  Set Variable    ${account_balance}

    validar crédito na account    account_balance_initial=${account_balance_initial}
    ...                           account_balance_final=${account_balance_final}
    ...                           amount=${amount}


####################
## Fluxo de Exceção
####################
Cenário: Receber pix sem transaction id
    [Documentation]  Não permitir o recebimento de PIX sem o transaction id
    [Tags]  smoke_test

    #######################
    ## Gerar End To End ID
    ######################
    gerar end_to_end_id

    ####################
    ## Gerar Message ID
    ####################
    gerar message_id

    #########################################
    # Fim Formando End To End ID e Message Id
    #########################################
    # Em staging, esse cenário será executado apenas para a conta 1853017169, contidas na keyword abaixo
    #########################################
    receber pagamento pix admin    amount=5000000
    ...                            end_to_end_id=${end_to_end_id}
    ...                            message_id=${message_id}
    ...                            account_number=1853017169
    ...                            psp_code=${psp_code}
    ...                            account_rounting_number=001
    ...                            account_type=${account_type}
    ...                            national_registration=00734275196

    validar precondition failed    message=Denied by missing transactionId
    ...                            message_code=4002

Cenário: Receber pagamento PIX com end to end já recebido
    [Documentation]  Não permitir o recebimento de PIX com o mesmo End to End
    [Tags]  smoke_test

    criar chave pix ativa    holder_type=individual
    ...                      pix_type=phone

    #######################
    ## Gerar End To End ID
    ######################
    gerar end_to_end_id

    ####################
    ## Gerar Message ID
    ####################
    gerar message_id

    ##########################################
    ## Fim Formando End To End ID e Message Id
    ##########################################

    receber pagamento pix admin    amount=5000000
    ...                            end_to_end_id=${end_to_end_id}
    ...                            message_id=${message_id}
    ...                            account_number=${account_number}
    ...                            psp_code=${psp_code}
    ...                            account_rounting_number=${account_routing_number}
    ...                            account_type=${account_type}
    ...                            national_registration=${national_registration}

    criar chave pix ativa    holder_type=individual
    ...                      pix_type=phone

    receber pagamento pix admin    amount=5000000
    ...                            end_to_end_id=${end_to_end_id}
    ...                            message_id=${message_id}
    ...                            account_number=${account_number}
    ...                            psp_code=${psp_code}
    ...                            account_rounting_number=${account_routing_number}
    ...                            account_type=${account_type}
    ...                            national_registration=${national_registration}

    validar conflict    message=Duplicated endToEndId
    ...                 message_code=4001
