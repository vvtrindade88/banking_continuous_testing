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
#Accounts
Resource         ../../apis/accounts/get/accounts_get_accounts_by_holder.robot
#Dados
Resource         ../../hooks/accreditation/dados_holder_individual.robot
Resource         ../../hooks/accreditation/dados_holder_business.robot
Resource         ../../hooks/accreditation/dados_partner_individual.robot
Resource         ../../hooks/accreditation/dados_partner_business.robot

*** Keywords ***
criar holder individual ativo

    conectar accreditation
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

    Set Global Variable      ${holder_name}
    Should Be Equal As Integers    ${response.status_code}  201

    ## Criar Telefone do Holder
    criar holder phone    21    51    996221236
    Should Be Equal As Integers    ${response.status_code}  201

    ## Criar Endereço do Holder
    criar holder address    Rio de Janeiro    Rio de Janeiro    Brasil    Bairro de Testes    Rua de Testes    90    apto 200    21550987
    Should Be Equal As Integers    ${response.status_code}  201

    ## Criar Documento Selfie do Holder
    criar holder document    SELFIE
    Should Be Equal As Integers    ${response.status_code}  201

    ## Criar Documento RG Frente do Holder
    criar holder document    RG_FRENTE
    Should Be Equal As Integers    ${response.status_code}  201

    ## Criar Documento RG Verso do Holder
    criar holder document    RG_VERSO
    Should Be Equal As Integers    ${response.status_code}  201

    ## Solicitar aprovação do holder
    solicitar aprovação do holder
    Should Be Equal As Integers    ${response.status_code}  200

    ## Receber notificação de aprovação
    recebendo notificação de aprovação
    Should Be Equal As Integers    ${response.status_code}  200

    ## Buscar account do holder
    buscar account por holder
    Should Be Equal As Integers    ${response.status_code}  200


criar holder business ativo

    conectar accreditation
    ## Gerador CNPJ
    ${national_registration}  FakerLibrary.cnpj
    ${national_registration}  Replace String    ${national_registration}    .    ${EMPTY}
    ${national_registration}  Replace String    ${national_registration}    -    ${EMPTY}
    ${national_registration}  Replace String    ${national_registration}    /    ${EMPTY}

    Set Global Variable      ${national_registration}

    ## Gerador RG
    ${identity_card}   FakerLibrary.rg
    Set Global Variable      ${identity_card}

    ## Criar Holder
    criar holder business    holder_type=business    holder_name=${holder_name}    email_business=${email_business}    national_registration=${national_registration}
    ...                      revenue_business=${revenue_business}     cnae=${cnae}    legal_name=${legal_name}    establishment_format=mei
    ...                      establishment_date=${establishment_date}
    Should Be Equal As Integers    ${response.status_code}  201

    ## Criar Telefone do Holder
    criar holder phone    21    51    996221236
    Should Be Equal As Integers    ${response.status_code}  201

    ## Criar Endereço do Holder
    criar holder address    Rio de Janeiro    Rio de Janeiro    Brasil    Bairro de Testes    Rua de Testes    90    apto 200    21550987
    Should Be Equal As Integers    ${response.status_code}  201


    ## Criar documento do Holder
    criar holder document    CCMEI
    Should Be Equal As Integers    ${response.status_code}  201


    ## Criar Partner Individual
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
    ...                         partner_individual_identity_card=${partner_individual_identity_card}    partner_individual_pep=false    partner_individual_percentage=100
    ...                         partner_individual_adm=true  partner_individual_cbo=${partner_individual_cbo}
    Should Be Equal As Integers    ${response.status_code}  201

    ## Cadstrar telefone do Partner
    criar partner phone    21    51    996554785
    Should Be Equal As Integers    ${response.status_code}  201

    ## Cadstrar Endereço do Partner
    criar partner address    Rio de Janeiro    Rio de Janeiro    Brasil    Bairro de Testes    Rua de Testes    61    apto 201    21550478
    Should Be Equal As Integers    ${response.status_code}  201

    ## Cadastrar Selfie do Partner
    criar partner document     SELFIE
    Should Be Equal As Integers    ${response.status_code}  201

    ## Cadastrar RG Frente do Partner
    criar partner document     RG_FRENTE
    Should Be Equal As Integers    ${response.status_code}  201

    ## Cadastrar RG Verso do Partner
    criar partner document     RG_VERSO
    Should Be Equal As Integers    ${response.status_code}  201

    ## Solicitar aprovação do holder
    solicitar aprovação do holder
    Should Be Equal As Integers    ${response.status_code}  200

    ## Receber notificação de aprovação
    recebendo notificação de aprovação
    Should Be Equal As Integers    ${response.status_code}  200

    ## Buscar account do holder
    buscar account por holder
    Should Be Equal As Integers    ${response.status_code}  200
