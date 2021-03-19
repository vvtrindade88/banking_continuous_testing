*** Settings ***
Documentation    Funcionalidade: Criar Chave de Endereçamento
...              Eu, como um Holder, portador de uma conta ativa em Banking
...              Desejo criar uma chave de endereçamento PIX associada à minha conta
Resource         ../../../hooks/pix-dict/pix_dict_create_active_key_pix.robot
Resource         ../../../apis/pix-payments/post/pix_payments_create_pix_payment.robot
#Resource         ../../../resources/pix-payments/envio/asserts.robot

*** Test Cases ***
Cenário: Criar pagamento PIX de para holder business utilizando dados completos da conta de destino
  criar chave pix ativa    business    email
  criar pagamento pix com dados completos    2000    0243882974    0500    cacc    Massa ITI PFNAUmNNO    42808422644    17192451    Envio de PIX    ${EMPTY}

# Cenário: Criar pagamento PIX de holder individual utilizando dados completos da conta de destino
#   criar chave pix ativa    individual    phone
#   criar pagamento pix com dados completos    2000    0243882974    0500    cacc    Massa ITI PFNAUmNNO    42808422644    17192451    Envio de PIX    ${EMPTY}
