*** Settings ***
Library          FakerLibrary    locale=pt_BR
Resource         ../../ambientes/staging/internal/create_session_staging_internal.robot
Resource         ../accreditation/accreditation_create_holder_active.robot
Resource         ../../apis/pix-dict/diretorio/post/pix_dict_create_entry.robot
Resource         ../../apis/pix-dict/diretorio/get/pix_dict_verification_code.robot
Resource         ../../apis/pix-dict/diretorio/post/pix_dict_confirm_propriety.robot
Resource         ../../apis/accounts/post/account_generate_balance.robot
Resource         ../../asserts/pix-dict/diretório/asserts.robot
Resource         ../../asserts/status_code/status_code_validade.robot

*** Keywords ***
criar chave pix ativa
    [Arguments]  ${holder_type}   ${pix_type}

    ## Criar Telefone
    ${phone}  Random Number  digits=8  fix_len=True
    ${phone_pix}   Set Variable    +55219${phone}
    Set Global Variable  ${phone_pix}

    ## Criar Email
    ${email_pix}  Email
    Set Global Variable    ${email_pix}


    Run Keyword If    '${holder_type}' == 'business'     criar holder business ativo
    ...	ELSE IF	'${holder_type}' == 'individual'         criar holder individual ativo


    gerar saldo para account    ${account_external_key}
    validar status code    status_code=200
    ...                    message_error=Erro ao gerar saldo

    Run Keyword If    '${pix_type}' == 'phone'                        criar chave pix    ${pix_type}    ${phone_pix}
    ...	ELSE IF	'${pix_type}' == 'email'                              criar chave pix    ${pix_type}    ${email_pix}
    ...	ELSE IF	'${pix_type}' == 'evp'                                criar chave pix    ${pix_type}    ${EMPTY}
    ...	ELSE IF	'${pix_type}' == 'national_registration'              criar chave pix    ${pix_type}    ${EMPTY}

    Run Keyword If    '${pix_type}' == 'phone'                        validar status code    status_code=202  message_error=Erro ao criar chave do tipo ${pix_type}
    ...	ELSE IF	'${pix_type}' == 'email'                              validar status code    status_code=202  message_error=Erro ao criar chave do tipo ${pix_type}
    ...	ELSE IF	'${pix_type}' == 'evp'                                validar status code    status_code=201  message_error=Erro ao criar chave do tipo ${pix_type}
    ...	ELSE IF	'${pix_type}' == 'national_registration'              validar status code    status_code=201  message_error=Erro ao criar chave do tipo ${pix_type}


    Run Keyword If    '${pix_type}' == 'phone'     buscar verification code    ${holder_external_key}    ${account_external_key}    ${entry_external_key}
    ...	ELSE IF	'${pix_type}' == 'email'           buscar verification code    ${holder_external_key}    ${account_external_key}    ${entry_external_key}
    validar status code    status_code=200
    ...                    message_error=Erro ao buscar verification code

    Run Keyword If    '${pix_type}' == 'phone'     confirmar propriedade da chave pix    ${verification_code}    ${holder_external_key}    ${account_external_key}    ${entry_external_key}
    ...	ELSE IF	'${pix_type}' == 'email'           confirmar propriedade da chave pix    ${verification_code}    ${holder_external_key}    ${account_external_key}    ${entry_external_key}
    validar status code    status_code=201
    ...                    message_error=Erro ao confirmar propriedade da chave pix
