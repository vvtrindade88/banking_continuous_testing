*** Settings ***
Documentation    Funcionalidade: Recebimento de PIX
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              Desejo receber um pagamento PIX
Resource         ../../../hooks/pix-dict/pix_dict_create_active_key_pix.robot
Resource         ../../../hooks/pix_payments/end_to_end_generator.robot
Resource         ../../../hooks/pix_payments/message_id_generator.robot
Resource         ../../../apis/pix-payments/post/pix_payments_create_pix_payment.robot
Resource         ../../../apis/pix-payments/post/pix_admin_receive_payment.robot
Resource         ../../../apis/pix-payments/post/pix_admin_confirm_payment.robot
Resource         ../../../apis/pix-payments/get/pix_payments_get_pix_payment.robot
Resource         ../../../asserts/status_code/status_code_validade.robot
Resource         ../../../asserts/pix-payments/recebimento/conflict.robot
Resource         ../../../asserts/pix-payments/recebimento/precondition_failed.robot
Resource         ../../../asserts/pix-payments/recebimento/asserts.robot

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

#     receber pagamento pix admin    end_to_end_id=${end_to_end_id}
#     ...                            message_id=${message_id}
#     ...                            account_number=${account_number}
#     ...                            psp_code=${psp_code}
#     ...                            account_rounting_number=${account_routing_number}
#     ...                            account_type=${account_type}
#     ...                            national_registration=${national_registration}
#
#     #################################
#     ## Validando criação da chave PIX
#     #################################
#     Run Keyword If    '${response.status_code}' != '201'  Fatal Error  msg=Erro ao receber PIX || status_code: ${response.status_code} || message: ${response.json()["message"]}
#
#     ################################
#     ## Confirmar recebimento do PIX
#     ################################
#
#     confirmar pagamento pix admin    ${end_to_end_id}
#
#
# ####################
# ## Fluxo de Exceção
# ####################
# Cenário: Receber pix sem transaction id
#     [Documentation]  Não permitir o recebimento de PIX sem o transaction id
#     [Tags]  smoke_test
#
#     #######################
#     ## Gerar End To End ID
#     ######################
#     gerar end_to_end_id
#
#     ####################
#     ## Gerar Message ID
#     ####################
#     gerar message_id
#
#     #########################################
#     # Fim Formando End To End ID e Message Id
#     #########################################
#     # Em staging, esse cenário será executado apenas para a conta 1853017169, contidas na keyword abaixo
#     #########################################
#     receber pagamento pix admin    end_to_end_id=${end_to_end_id}
#     ...                            message_id=${message_id}
#     ...                            account_number=1853017169
#     ...                            psp_code=${psp_code}
#     ...                            account_rounting_number=001
#     ...                            account_type=${account_type}
#     ...                            national_registration=00734275196
#
#
#     validar precondition failed    message=Denied by missing transactionId
#     ...                            message_code=4002
#
# Cenário: Receber pagamento PIX com end to end já recebido
#     [Documentation]  Não permitir o recebimento de PIX com o mesmo End to End
#     [Tags]  smoke_test
#
#     criar chave pix ativa    individual    national_registration
#
#     #######################
#     ## Gerar End To End ID
#     ######################
#     gerar end_to_end_id
#
#     ####################
#     ## Gerar Message ID
#     ####################
#     gerar message_id
#
#     ##########################################
#     ## Fim Formando End To End ID e Message Id
#     ##########################################
#
#     receber pagamento pix admin    end_to_end_id=${end_to_end_id}
#     ...                            message_id=${message_id}
#     ...                            account_number=${account_number}
#     ...                            psp_code=${psp_code}
#     ...                            account_rounting_number=${account_routing_number}
#     ...                            account_type=${account_type}
#     ...                            national_registration=${national_registration}
#
#     criar chave pix ativa    individual    national_registration
#
#     receber pagamento pix admin    end_to_end_id=${end_to_end_id}
#     ...                            message_id=${message_id}
#     ...                            account_number=${account_number}
#     ...                            psp_code=${psp_code}
#     ...                            account_rounting_number=${account_routing_number}
#     ...                            account_type=${account_type}
#     ...                            national_registration=${national_registration}
#
#     validar conflict    message=Duplicated endToEndId
#     ...                 message_code=4001
