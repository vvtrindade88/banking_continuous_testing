*** Settings ***
Library          FakerLibrary    locale=pt_BR
Library          String
Resource         ../../ambientes/staging/internal/create_session_staging_internal.robot
# Holder
Resource         ../../apis/accreditation/holders/post/individual/accreditation_post_holder_individual.robot
Resource         ../../apis/accreditation/holders/get/accreditation_get_holder.robot
Resource         ../../apis/accreditation/holders/post/business/accreditation_post_holder_business.robot
#Partner
Resource         ../../apis/accreditation/partners/post/individual/accreditation_post_partner_individual.robot
Resource         ../../apis/accreditation/partners/post/business/accreditation_post_partner_business.robot
#Phone
Resource         ../../apis/accreditation/phones/holder_phone/post/accreditation_post_holder_phone.robot
Resource         ../../apis/accreditation/phones/partner_phone/post/accreditation_post_partner_phone.robot
#Address
Resource         ../../apis/accreditation/addresses/holder_address/post/accreditation_post_holder_address.robot
Resource         ../../apis/accreditation/addresses/partner_address/post/accreditation_post_partner_address.robot
#Documents
Resource         ../../apis/accreditation/documents/holder_documents/post/accreditation_post_holder_document.robot
Resource         ../../apis/accreditation/documents/partner_documents/post/accreditation_post_partner_document.robot
#Approval
Resource         ../../apis/accreditation/approval/accreditation_request_approval.robot
Resource         ../../apis/accreditation/registration_approval/accreditation_risk_notification.robot
#Dados
Resource         ../../hooks/accreditation/dados_holder_individual.robot
Resource         ../../hooks/accreditation/dados_holder_business.robot
Resource         ../../hooks/accreditation/dados_partner_individual.robot
Resource         ../../hooks/accreditation/dados_partner_business.robot
#Asserts
Resource         asserts.robot

*** Keywords ***

Dado que eu deseje me cadastrar como holder em Banking
  ## Conextar com Accreditation
  conectar accreditation

Quando eu preencher todos os dados necessários para o cadastro do holder individual
  [Arguments]  ${assert_holder_status}

  ## Gerador CPF
  ${national_registration}  FakerLibrary.cpf
  ${national_registration}  Replace String    ${national_registration}    .    ${EMPTY}
  ${national_registration}  Replace String    ${national_registration}    -    ${EMPTY}

  Set Global Variable      ${national_registration}

  ## Gerador RG
  ${identity_card}   FakerLibrary.rg
  Set Global Variable      ${identity_card}

  ## Criar Holder
  criar holder individual    holder_type=individual                            holder_name=${holder_name}        email=${email}
  ...                        national_registration=${national_registration}    revenue=${revenue}                birthday=${birthday}
  ...                        mothers_name=${mothers_name}                      identity_card=${identity_card}    pep=false
  ...                        cbo=${cbo}

  ## Validar inclusão do Holder
  validar holder individual    ${assert_holder_status}

Quando eu preencher todos os dados necessários para o cadastro do holder business
  [Arguments]  ${assert_holder_status}  ${establishment_format}

  ## Gerador CNPJ
  ${national_registration}  FakerLibrary.cnpj
  ${national_registration}  Replace String    ${national_registration}    .    ${EMPTY}
  ${national_registration}  Replace String    ${national_registration}    -    ${EMPTY}
  ${national_registration}  Replace String    ${national_registration}    /    ${EMPTY}

  Set Global Variable      ${national_registration}
  Set Global Variable      ${establishment_format}

  criar holder business    holder_type=business    holder_name=${holder_name}    email_business=${email_business}    national_registration=${national_registration}
  ...                      revenue_business=${revenue_business}     cnae=${cnae}    legal_name=${legal_name}    establishment_format=${establishment_format}
  ...                      establishment_date=${establishment_date}

  ## Validar inclusão do Holder
  validar holder business    ${assert_holder_status}

E realizar o cadastro de um sócio pessoal física
  [Arguments]  ${assert_holder_status}  ${partner_individual_percentage}  ${partner_individual_adm}

  ## Criar partner Individual

  ## Gerador CPF
  ${partner_individual_national_registration}  FakerLibrary.cpf
  ${partner_individual_national_registration}  Replace String    ${partner_individual_national_registration}    .    ${EMPTY}
  ${partner_individual_national_registration}  Replace String    ${partner_individual_national_registration}    -    ${EMPTY}

  Set Global Variable      ${partner_individual_national_registration}

  ## Gerador RG
  ${partner_individual_identity_card}   FakerLibrary.rg
  Set Global Variable      ${partner_individual_identity_card}

  criar partner individual    partner_individual_type=individual    partner_individual_name=${partner_individual_name}    partner_individual_email=${partner_individual_email}
  ...                         partner_individual_national_registration=${partner_individual_national_registration}    partner_individual_revenue=${partner_individual_revenue}
  ...                         partner_individual_birthday=${partner_individual_birthday}    partner_individual_mothers_name=${partner_individual_mothers_name}
  ...                         partner_individual_identity_card=${partner_individual_identity_card}    partner_individual_pep=false    partner_individual_percentage=${partner_individual_percentage}
  ...                         partner_individual_adm=${partner_individual_adm}  partner_individual_cbo=${partner_individual_cbo}

  ## Validar inclusão do Holder
  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

E realizar o cadastro de um sócio pessoal jurídica
  [Arguments]  ${assert_holder_status}  ${partner_business_establishment_format}  ${partner_business_percentage}  ${partner_business_adm}

  ## Criar partner Business
  ## Gerador CNPJ
  ${partner_business_national_registration}  FakerLibrary.cnpj
  ${partner_business_national_registration}  Replace String    ${partner_business_national_registration}    .    ${EMPTY}
  ${partner_business_national_registration}  Replace String    ${partner_business_national_registration}    -    ${EMPTY}
  ${partner_business_national_registration}  Replace String    ${partner_business_national_registration}    /    ${EMPTY}

  criar partner business    partner_business_type=business    partner_holder_name=${partner_holder_name}    partner_business_email=${partner_business_email}
  ...                       partner_business_national_registration=${partner_business_national_registration}   partner_business_revenue=${partner_business_revenue}    partner_business_cnae=${partner_business_cnae}
  ...                       partner_business_legal_name=${partner_business_legal_name}    partner_business_adm=${partner_business_adm}   partner_business_percentage=${partner_business_percentage}
  ...                       partner_business_establishment_format=${partner_business_establishment_format}   partner_business_establishment_date=${partner_business_establishment_date}


E realizar o cadastro do telefone do sócio
  [Arguments]  ${assert_holder_status}
  criar partner phone    21    51    996554785

  ## Validar inclusão do Holder
  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

E realizar o cadastro do endereço do sócio
  [Arguments]  ${assert_holder_status}
  criar partner address    Rio de Janeiro    Rio de Janeiro    Brasil    Bairro de Testes    Rua de Testes    61    apto 201    21550478

  ## Validar inclusão do Holder
  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

E realizar o cadastro da Selfie do Sócio
  [Arguments]  ${assert_holder_status}  ${document_type}
  criar partner document     ${document_type}

  ## Validar inclusão do Holder
  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

E realizar o cadastro da frente do RG do sócio
  [Arguments]  ${assert_holder_status}   ${document_type}
  criar partner document     ${document_type}

  ## Validar inclusão do Holder
  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

E realizar o cadastro do verso do RG do sócio
  [Arguments]  ${assert_holder_status}   ${document_type}
  criar partner document     ${document_type}

  ## Validar inclusão do Holder
  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

E realizar o cadastro do meu telefone
  [Arguments]  ${assert_holder_status}
  ## Criar Telefone do Holder
  criar holder phone    21    51    996221236

  ## Validar inclusão do Holder
  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

E realizar o cadastro do meu endereço
  [Arguments]  ${assert_holder_status}
  ## Criar Endereço do holder
  criar holder address    Rio de Janeiro    Rio de Janeiro    Brasil    Bairro de Testes    Rua de Testes    90    apto 200    21550987

  ## Validar inclusão do Holder
  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

E realizar o cadastro da minha Selfie
  [Arguments]  ${assert_holder_status}  ${document_type}
  criar holder document    ${document_type}

  ## Validar inclusão do Holder
  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

E realizar o cadastro da frente do meu RG
  [Arguments]  ${assert_holder_status}  ${document_type}
  criar holder document    ${document_type}

  ## Validar inclusão do Holder
  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

E realizar o cadastro do verso do meu RG
  [Arguments]  ${assert_holder_status}  ${document_type}
  criar holder document    ${document_type}

  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

E realizar o cadastro do documento
  [Arguments]  ${assert_holder_status}  ${document_type}
  criar holder document    ${document_type}

  ## Validar inclusão do Holder
  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

E realizar a solicitação da aprovação do meu cadastro
  [Arguments]  ${assert_holder_status}
  ## Solicitar aprovação do Holder
  solicitar aprovação do holder
  Should Be Equal As Strings    ${response.status_code}    200

  ## Validar inclusão do Holder
  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

  recebendo notificação de aprovação

Então o sistema deverá realizar o meu cadastro com sucesso
  [Arguments]  ${assert_holder_status}

  buscar holder
  Run Keyword If	'${response.json()["type"]}' == 'individual'	validar holder individual    ${assert_holder_status}
  ...	ELSE IF	'${response.json()["type"]}' == 'business'	validar holder business    ${assert_holder_status}

Mas para holder individual não preencho o campo
  [Arguments]  ${field}
  Set Global Variable    ${field}

  ## Gerador CPF
  ${national_registration}  FakerLibrary.cpf
  ${national_registration}  Replace String    ${national_registration}    .    ${EMPTY}
  ${national_registration}  Replace String    ${national_registration}    -    ${EMPTY}

  Set Global Variable      ${national_registration}

  ## Gerador RG
  ${identity_card}   FakerLibrary.rg
  Set Global Variable      ${identity_card}

  Run Keyword If  '${field}' == 'type'  criar holder individual  holder_type=${EMPTY}  holder_name=${holder_name}  email=${email}
  ...                                                            national_registration=${national_registration}  revenue=${revenue}  birthday=${birthday}
  ...                                                            mothers_name=${mothers_name}  identity_card=${identity_card}  pep=false  cbo=${cbo}

  ...	ELSE IF	'${field}' == 'name'  criar holder individual  holder_type=individual  holder_name=${EMPTY}  email=${email}
  ...                                                        national_registration=${national_registration}  revenue=${revenue}  birthday=${birthday}
  ...                                                        mothers_name=${mothers_name}  identity_card=${identity_card}  pep=false  cbo=${cbo}

  ...	ELSE IF	'${field}' == 'email'  criar holder individual  holder_type=individual  holder_name=${holder_name}  email=${EMPTY}
  ...                                                         national_registration=${national_registration}  revenue=${revenue}  birthday=${birthday}
  ...                                                         mothers_name=${mothers_name}  identity_card=${identity_card}  pep=false  cbo=${cbo}

  ...	ELSE IF	'${field}' == 'national_registration'  criar holder individual  holder_type=individual  holder_name=${holder_name}  email=${email}
  ...                                                         national_registration=${EMPTY}  revenue=${revenue}  birthday=${birthday}
  ...                                                         mothers_name=${mothers_name}  identity_card=${identity_card}  pep=false  cbo=${cbo}

  ...	ELSE IF	'${field}' == 'revenue'  criar holder individual  holder_type=individual  holder_name=${holder_name}  email=${email}
  ...                                                         national_registration=${national_registration}  revenue="${EMPTY}"  birthday=${birthday}
  ...                                                         mothers_name=${mothers_name}  identity_card=${identity_card}  pep=false  cbo=${cbo}

  ...	ELSE IF	'${field}' == 'birthday'  criar holder individual  holder_type=individual  holder_name=${holder_name}  email=${email}
  ...                                                         national_registration=${national_registration}  revenue=${revenue}  birthday=${EMPTY}
  ...                                                         mothers_name=${mothers_name}  identity_card=${identity_card}  pep=false  cbo=${cbo}

  ...	ELSE IF	'${field}' == 'mothers_name'  criar holder individual  holder_type=individual  holder_name=${holder_name}  email=${email}
  ...                                                         national_registration=${national_registration}  revenue=${revenue}  birthday=${birthday}
  ...                                                         mothers_name=${EMPTY}  identity_card=${identity_card}  pep=false  cbo=${cbo}

  ...	ELSE IF	'${field}' == 'cbo'      criar holder individual  holder_type=individual  holder_name=${holder_name}  email=${email}
  ...                                                           national_registration=${national_registration}  revenue=${revenue}  birthday=${birthday}
  ...                                                           mothers_name=${mothers_name}  identity_card=${identity_card}  pep=false  cbo="${EMPTY}"

Mas para holder business não preencho o campo
  [Arguments]  ${field}
  Set Global Variable    ${field}

  ## Gerador CNPJ
  ${national_registration}  FakerLibrary.cnpj
  ${national_registration}  Replace String    ${national_registration}    .    ${EMPTY}
  ${national_registration}  Replace String    ${national_registration}    -    ${EMPTY}
  ${national_registration}  Replace String    ${national_registration}    /    ${EMPTY}

  Set Global Variable      ${national_registration}

  Run Keyword If  '${field}' == 'type'    criar holder business    holder_type=${EMPTY}    holder_name=${holder_name}    email_business=${email_business}
  ...                                                              national_registration=${national_registration}  revenue_business=${revenue_business}     cnae=${cnae}
  ...                                                              legal_name=${legal_name}    establishment_format=${establishment_format}  establishment_date=${establishment_date}

  ...	ELSE IF	'${field}' == 'name'  criar holder business    holder_type=business    holder_name=${EMPTY}    email_business=${email_business}
  ...                                                        national_registration=${national_registration}  revenue_business=${revenue_business}     cnae=${cnae}
  ...                                                        legal_name=${legal_name}    establishment_format=${establishment_format}  establishment_date=${establishment_date}

  ...	ELSE IF	'${field}' == 'email'  criar holder business    holder_type=business    holder_name=${holder_name}    email_business=${EMPTY}
  ...                                                         national_registration=${national_registration}  revenue_business=${revenue_business}     cnae=${cnae}
  ...                                                         legal_name=${legal_name}    establishment_format=${establishment_format}  establishment_date=${establishment_date}

  ...	ELSE IF	'${field}' == 'national_registration'   criar holder business    holder_type=business    holder_name=${holder_name}    email_business=${email_business}
  ...                                                                          national_registration=${EMPTY}  revenue_business=${revenue_business}     cnae=${cnae}
  ...                                                                          legal_name=${legal_name}    establishment_format=${establishment_format}  establishment_date=${establishment_date}

  ...	ELSE IF	'${field}' == 'revenue'    criar holder business    holder_type=business    holder_name=${holder_name}    email_business=${email_business}
  ...                                                             national_registration=${national_registration}  revenue_business="${EMPTY}"    cnae=${cnae}
  ...                                                             legal_name=${legal_name}    establishment_format=${establishment_format}  establishment_date=${establishment_date}

  ...	ELSE IF	'${field}' == 'cnae'       criar holder business    holder_type=business    holder_name=${holder_name}    email_business=${email_business}
  ...                                                             national_registration=${national_registration}  revenue_business=${revenue_business}     cnae=${EMPTY}
  ...                                                             legal_name=${legal_name}    establishment_format=${establishment_format}  establishment_date=${establishment_date}

  ...	ELSE IF	'${field}' == 'legal_name'       criar holder business    holder_type=business    holder_name=${holder_name}    email_business=${email_business}
  ...                                                                   national_registration=${national_registration}  revenue_business=${revenue_business}     cnae=${cnae}
  ...                                                                   legal_name=${EMPTY}    establishment_format=${establishment_format}  establishment_date=${establishment_date}

  ...	ELSE IF	'${field}' == 'establishment_format'       criar holder business    holder_type=business    holder_name=${holder_name}    email_business=${email_business}
  ...                                                                             national_registration=${national_registration}  revenue_business=${revenue_business}     cnae=${cnae}
  ...                                                                             legal_name=${legal_name}    establishment_format=${EMPTY}  establishment_date=${establishment_date}

  ...	ELSE IF	'${field}' == 'establishment_date'       criar holder business    holder_type=business    holder_name=${holder_name}    email_business=${email_business}
  ...                                                                           national_registration=${national_registration}  revenue_business=${revenue_business}     cnae=${cnae}
  ...                                                                           legal_name=${legal_name}    establishment_format=${establishment_format}  establishment_date=${EMPTY}


Então o sistema deverá exibir uma mensgam de critica impedindo o cadstro do Holder
  [Arguments]  ${message_error}

  validar invalid_request    ${message_error}
