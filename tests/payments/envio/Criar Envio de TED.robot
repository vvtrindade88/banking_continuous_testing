*** Settings ***
Documentation    Funcionalidade: Enviar TED
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              Desejo realizar envio de TED
Resource         ../../../hooks/accreditation/accreditation_create_holder_active.robot
Resource         ../../../apis/payments/envio/post/payments_external_transfer_send.robot
Resource         ../../../apis/payments/envio/get/payments_get_external_transfer_send.robot
Resource         ../../../apis/accounts/post/account_generate_balance.robot
Resource        ../../../apis/accounts/get/account_get_balance.robot
Resource        ../../../asserts/accounts/asserts.robot
Resource        ../../../asserts/payments/asserts.robot
Library          FakerLibrary    locale=pt_BR

*** Variable ***
${amount}                           399
${account_receive_check_digit}      1
${bank_code_receive}                208
${routing_check_digit_receive}      1
${description}                      Teste Ted


*** Test Case ***
Cenário: Realizar Envio de ted
  [Tags]  smoke_test
  ###############################
  ## Holder que enviará o TED ##
  ##############################
  criar holder individual ativo
  ${holder_send_ted}    Set Variable    ${holder_external_key}
  ${account_send_ted}   Set Variable    ${account_external_key}

  ###################################################
  ## Gerando Saldo para o Holder que enviará o TED ##
  ###################################################
  gerar saldo para account    ${account_send_ted}

  #########################################################
  ## Buscar saldo inicial do Holder que irá enviar o TED ##
  #########################################################
  buscar account balance    marketplace_external_key=${marketplace_external_key}
  ...                       account_external_key=${account_send_ted}

  ${account_sender_balance_inicial}  Set Variable  ${account_balance}

  ###############################
  ## Holder que receber o TED ##
  ##############################
  criar holder individual ativo
  ${holder_receive_ted}                                   Set Variable    ${holder_external_key}
  ${holder_name_receive_ted}                              Set Variable    ${holder_name}
  ${holder_national_registration_receive_ted}             Set Variable    ${national_registration}
  ${account_receive_ted}                                  Set Variable    ${account_external_key}
  ${account_number_receive_ted}                           Set Variable    ${account_number}
  ${account_routing_number_receive_ted}                   Set Variable    ${account_routing_number}
  ${national_registration_receive_ted}                    Set Variable    ${national_registration}


  ################
  ## Enviar TED ##
  ################
  ${reference_id}       Uuid 4
  criar envio de ted    marketplace_external_key=${marketplace_external_key}
  ...                   holder_external_key=${holder_send_ted}
  ...                   account_external_key=${account_send_ted}
  ...                   amount=${amount}
  ...                   account_check_digit=${account_receive_check_digit}
  ...                   account_number=${account_number_receive_ted}
  ...                   bank_code=${bank_code_receive}
  ...                   document=${holder_national_registration_receive_ted}
  ...                   name=${holder_name_receive_ted}
  ...                   routing_check_digit=${routing_check_digit_receive}
  ...                   routing_number=${account_routing_number_receive_ted}
  ...                   description=${description}
  ...                   reference_id=${reference_id}

  ############################
  ## Validar criação da TED ##
  ############################
  validar ted    status_code=202
  ...            amount=${amount}
  ...            description=${description}
  ...            reference_id=${reference_id}
  ...            status=AUTHORIZED
  ...            recipient_name=${holder_name_receive_ted}
  ...            recipient_document=${holder_national_registration_receive_ted}
  ...            recipient_bank_code=${bank_code_receive}
  ...            recipient_routing_number=${account_routing_number_receive_ted}
  ...            recipient_routing_check_digit=${routing_check_digit_receive}
  ...            recipient_account_number=${account_number_receive_ted}
  ...            recipient_account_check_digit=${account_receive_check_digit}

  ####################################
  ## Validar débito na account TED ##
  ###################################
  buscar account balance    marketplace_external_key=${marketplace_external_key}
  ...                       account_external_key=${account_send_ted}

  ${account_sender_balance_final}  Set Variable  ${account_balance}


  validar debito na account    account_balance_initial=${account_sender_balance_inicial}
  ...                          account_balance_final=${account_sender_balance_final}
  ...                          amount=${amount}

  ##########################
  ## Buscando TED enviado ##
  ##########################
  FOR  ${index}  IN RANGE  20
    buscar envio de ted    marketplace_external_key=${marketplace_external_key}
    ...                    holder_external_key=${holder_send_ted}
    ...                    account_external_key=${account_send_ted}
    ...                    payment_external_key=${payment_external_key}

    Exit For Loop If    '${response.json()["status"]}' == 'PROCESSING'
  END

  ##########################################
  ## Validar atualização do status da TED ##
  ##########################################
  validar ted    status_code=200
  ...            amount=${amount}
  ...            description=${description}
  ...            reference_id=${reference_id}
  ...            status=PROCESSING
  ...            recipient_name=${holder_name_receive_ted}
  ...            recipient_document=${holder_national_registration_receive_ted}
  ...            recipient_bank_code=${bank_code_receive}
  ...            recipient_routing_number=${account_routing_number_receive_ted}
  ...            recipient_routing_check_digit=${routing_check_digit_receive}
  ...            recipient_account_number=${account_number_receive_ted}
  ...            recipient_account_check_digit=${account_receive_check_digit}
