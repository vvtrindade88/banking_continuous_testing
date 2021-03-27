*** Settings ***
Documentation    Funcionalidade: Cancelar Envio de Pagamento PIX
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              Desejo cancelar o pagamento de um envio de PIX
Resource         ../../../hooks/pix-dict/pix_dict_create_active_key_pix.robot
Resource         ../../../apis/accreditation/holders/post/business/accreditation_post_holder_business.robot
Resource         ../../../apis/accreditation/holders/post/individual/accreditation_post_holder_individual.robot
Resource         ../../../apis/pix-payments/post/pix_payments_create_pix_payment.robot
Resource         ../../../apis/pix-payments/post/pix_payments_cancel_pix_payment.robot
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
Cenário: Cancelar pagamento PIX
  [Tags]  smoke_test
  [Documentation]  Cancelamento de pagament PIX, efetuado antes da confirmação do pagamento

  criar chave pix ativa    holder_type=individual
  ...                      pix_type=email

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

  cancelar pagamento pix    holder_external_key=${holder_external_key}
  ...                       account_external_key=${account_external_key}
  ...                       payment_external_key=${payment_external_key}

  validar pagamento pix    status_code=201
  ...                      marketplace_external_key=${marketplace_external_key}
  ...                      status_pix_payments=canceled
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
