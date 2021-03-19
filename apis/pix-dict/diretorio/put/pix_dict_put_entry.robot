*** Settings ***
Library       RequestsLibrary
Library       Collections
Resource      ../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
alterar chave pix
    conectar pix-dict
    ${response}        Put Request        pix-dict            /marketplaces/${marketplace_external_key}/banking/dict/holders/${holder_external_key}/accounts/${account_external_key}/entries/${entry_external_key}

    Log                           ${response.json()}
    Log                           ${response.headers['X-REQUEST-ID']}
    Log                           ${response.status_code}
    Set Global Variable           ${response}
