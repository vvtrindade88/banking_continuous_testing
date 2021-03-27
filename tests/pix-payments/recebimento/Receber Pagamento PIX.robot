*** Settings ***
Documentation    Funcionalidade: Recebimento de PIX
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              Desejo receber um pagamento PIX
Library          DateTime
Resource         ../../../hooks/pix-dict/pix_dict_create_active_key_pix.robot
Resource         ../../../apis/pix-payments/post/pix_payments_create_pix_payment.robot
Resource         ../../../apis/pix-payments/post/pix_admin_receive_payment.robot
Resource         ../../../apis/pix-payments/get/pix_payments_get_pix_payment.robot
Resource         ../../../asserts/pix-payments/recebimento/conflict.robot

*** Variables ***
${psp_code}      19468242
${account_type}  cacc

*** Test Cases ***
#####################
### Fluxo de Básico
#####################



#####################
### Fluxo de Exceção
#####################
Cenário: Receber pix sem transaction id
    [Documentation]  Não permitir o recebimento de PIX sem o transaction id
    [Tags]  transaction

    ######################################
    ## Formando End To End ID e Message Id
    ######################################

    ${date}  Get Current Date  result_format=datetime
    ${datetime}  Convert Date	   ${date}  result_format=%Y%m%d%H%M

    ${random_number_message_id}  Random Number  digits=23  fix_len=True
    ${message_id}  Set Variable   M19468242${random_number_message_id}

    ${random_number_end_to_end_id}  Random Number  digits=11  fix_len=True
    ${end_to_end_id}  Set Variable   E19468242${datetime}${random_number_end_to_end_id}

    ##########################################
    ## Fim Formando End To End ID e Message Id
    ##########################################
    receber pagamento pix admin    end_to_end_id=${end_to_end_id}
    ...                            message_id=${message_id}
    ...                            account_number=1853017169
    ...                            psp_code=${psp_code}
    ...                            account_rounting_number=001
    ...                            account_type=${account_type}
    ...                            national_registration=00734275196


Cenário: Receber pagamento PIX com end to end já recebido
    [Documentation]  Não permitir o recebimento de PIX com o mesmo End to End
    [Tags]  smoke_test

    criar chave pix ativa    individual    national_registration

    ######################################
    ## Formando End To End ID e Message Id
    ######################################

    ${date}  Get Current Date  result_format=datetime
    ${datetime}  Convert Date	   ${date}  result_format=%Y%m%d%H%M

    ${random_number_message_id}  Random Number  digits=23  fix_len=True
    ${message_id}  Set Variable   M19468242${random_number_message_id}

    ${random_number_end_to_end_id}  Random Number  digits=11  fix_len=True
    ${end_to_end_id}  Set Variable   E19468242${datetime}${random_number_end_to_end_id}

    ##########################################
    ## Fim Formando End To End ID e Message Id
    ##########################################

    receber pagamento pix admin    end_to_end_id=${end_to_end_id}
    ...                            message_id=${message_id}
    ...                            account_number=${account_number}
    ...                            psp_code=${psp_code}
    ...                            account_rounting_number=${account_routing_number}
    ...                            account_type=${account_type}
    ...                            national_registration=${national_registration}


    criar chave pix ativa    individual    national_registration

    receber pagamento pix admin    end_to_end_id=${end_to_end_id}
    ...                            message_id=${message_id}
    ...                            account_number=${account_number}
    ...                            psp_code=${psp_code}
    ...                            account_rounting_number=${account_routing_number}
    ...                            account_type=${account_type}
    ...                            national_registration=${national_registration}

    validar conflict    message=Duplicated endToEndId
    ...                 message_code=4001
