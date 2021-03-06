*** Settings ***
Documentation    Funcionalidade: Confirmar Chave de Endereçamento
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              Desejo confirmar o pagamento de um envio de PIX
Resource         ../../../hooks/pix-dict/pix_dict_create_active_key_pix.robot
Resource         ../../../apis/accreditation/holders/post/business/accreditation_post_holder_business.robot
Resource         ../../../apis/accreditation/holders/post/individual/accreditation_post_holder_individual.robot
Resource         ../../../apis/accounts/get/account_get_balance.robot
Resource         ../../../apis/pix-payments/post/pix_payments_create_pix_payment.robot
Resource         ../../../apis/pix-payments/post/pix_payments_confirm_pix_payment.robot
Resource         ../../../apis/pix-payments/post/pix_admin_confirm_payment.robot
Resource         ../../../apis/pix-payments/get/pix_payments_get_pix_payment.robot
Resource         ../../../asserts/pix-payments/envio/asserts.robot
Resource         ../../../asserts/accounts/asserts.robot

*** Variables ***
${amount}                                 290
${debtor_account_psp_code}                19468242
${debtor_account_psp_name}                Zoop Tecnologia e Meios de Pagamento S.A.
${debtor_account_type}                    cacc
${creditor_account_number}                0243882974
${creditor_routing_number}                0500
${creditor_account_type}                  cacc
${creditor_name}                          Massa iti PF NauNNMO
${creditor_national_registration}         42808422644
${creditor_psp}                           17192451
${pix_description}                        Envio de PIX

*** Test Cases ***
Cenário: Confirmar pagamento PIX de para holder individual utilizando dados completos da conta de destino
  [Tags]  regression_test
  [Documentation]  Envio de PIX com sucesso para uma conta Iti, a partir de um Holder Business

  criar chave pix ativa    holder_type=individual
  ...                      pix_type=email

  buscar account balance     marketplace_external_key=${marketplace_external_key}
  ...                        account_external_key=${account_external_key}

  ${account_balance_initial}  Set Variable    ${account_balance}

  criar pagamento pix com dados completos    amount=${amount}
  ...                                        creditor_account_number=${creditor_account_number}
  ...                                        creditor_routing_number=${creditor_routing_number}
  ...                                        creditor_account_type=${creditor_account_type}
  ...                                        creditor_name=${creditor_name}
  ...                                        creditor_national_registration=${creditor_national_registration}
  ...                                        creditor_psp=${creditor_psp}
  ...                                        pix_description=${pix_description}

  validar pagamento pix    status_code=201
  ...                      marketplace_external_key=${marketplace_external_key}
  ...                      status_pix_payments=pending
  ...                      amount=${amount}
  ...                      pix_description=${pix_description}
  ...                      debitor_national_registration=${national_registration}
  ...                      debitor_name=${holder_name}
  ...                      debitor_type=${holder_type}
  ...                      debitor_holder_id=${holder_external_key}
  ...                      debtor_account_psp_code=${debtor_account_psp_code}
  ...                      debtor_account_psp_name=${debtor_account_psp_name}
  ...                      debtor_digital_account=${account_external_key}
  ...                      debtor_account_number=${account_number}
  ...                      debtor_account_routing_number=${account_routing_number}
  ...                      debtor_account_type=${debtor_account_type}
  ...                      creditor_national_registration=${creditor_national_registration}
  ...                      creditor_name=${creditor_name}
  ...                      creditor_type=individual
  ...                      creditor_account_psp_code=${creditor_psp}
  ...                      creditor_account_number=${creditor_account_number}
  ...                      creditor_account_routing_number=${creditor_routing_number}
  ...                      creditor_account_type=${creditor_account_type}
  ...                      refunded_amount=0

  confirmar pagamento pix    holder_external_key=${holder_external_key}
  ...                        account_external_key=${account_external_key}
  ...                        payment_external_key=${payment_external_key}

  validar pagamento pix    status_code=202
  ...                      marketplace_external_key=${marketplace_external_key}
  ...                      status_pix_payments=executed
  ...                      amount=${amount}
  ...                      pix_description=${pix_description}
  ...                      debitor_national_registration=${national_registration}
  ...                      debitor_name=${holder_name}
  ...                      debitor_type=${holder_type}
  ...                      debitor_holder_id=${holder_external_key}
  ...                      debtor_account_psp_code=${debtor_account_psp_code}
  ...                      debtor_account_psp_name=${debtor_account_psp_name}
  ...                      debtor_digital_account=${account_external_key}
  ...                      debtor_account_number=${account_number}
  ...                      debtor_account_routing_number=${account_routing_number}
  ...                      debtor_account_type=${debtor_account_type}
  ...                      creditor_national_registration=${creditor_national_registration}
  ...                      creditor_name=${creditor_name}
  ...                      creditor_type=individual
  ...                      creditor_account_psp_code=${creditor_psp}
  ...                      creditor_account_number=${creditor_account_number}
  ...                      creditor_account_routing_number=${creditor_routing_number}
  ...                      creditor_account_type=${creditor_account_type}
  ...                      refunded_amount=0


  confirmar pagamento pix admin    ${end_to_end_id}

  FOR  ${index}  IN RANGE  60
      buscar pagamento pix    holder_external_key=${holder_external_key}
      ...                     account_external_key=${account_external_key}
      ...                     entry_external_key=${entry_external_key}
      ...                     payment_external_key=${payment_external_key}

      Exit For Loop If    '${response.json()["status"]}' == 'succeeded'

  END

  validar pagamento pix    status_code=200
  ...                      marketplace_external_key=${marketplace_external_key}
  ...                      status_pix_payments=succeeded
  ...                      amount=${amount}
  ...                      pix_description=${pix_description}
  ...                      debitor_national_registration=${national_registration}
  ...                      debitor_name=${holder_name}
  ...                      debitor_type=${holder_type}
  ...                      debitor_holder_id=${holder_external_key}
  ...                      debtor_account_psp_code=${debtor_account_psp_code}
  ...                      debtor_account_psp_name=${debtor_account_psp_name}
  ...                      debtor_digital_account=${account_external_key}
  ...                      debtor_account_number=${account_number}
  ...                      debtor_account_routing_number=${account_routing_number}
  ...                      debtor_account_type=${debtor_account_type}
  ...                      creditor_national_registration=${creditor_national_registration}
  ...                      creditor_name=${creditor_name}
  ...                      creditor_type=individual
  ...                      creditor_account_psp_code=${creditor_psp}
  ...                      creditor_account_number=${creditor_account_number}
  ...                      creditor_account_routing_number=${creditor_routing_number}
  ...                      creditor_account_type=${creditor_account_type}
  ...                      refunded_amount=0

  buscar account balance     marketplace_external_key=${marketplace_external_key}
  ...                        account_external_key=${account_external_key}

  ${account_balance_final}  Set Variable    ${account_balance}

  validar debito na account    account_balance_initial=${account_balance_initial}
  ...                          account_balance_final=${account_balance_final}
  ...                          amount=${amount}
