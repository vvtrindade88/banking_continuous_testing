*** Settings ***
Library   RequestsLibrary
Library   Collections
Resource  ../../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
criar partner individual
    [Arguments]  ${partner_individual_type}   ${partner_individual_name}   ${partner_individual_email}   ${partner_individual_national_registration}   ${partner_individual_revenue}
    ...          ${partner_individual_birthday}   ${partner_individual_mothers_name}   ${partner_individual_identity_card}   ${partner_individual_pep}   ${partner_individual_percentage}
    ...          ${partner_individual_adm}     ${partner_individual_cbo}

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ...                         "type": "${partner_individual_type}",
    ...                         "name": "${partner_individual_name}",
    ...                         "email": "${partner_individual_email}",
    ...                         "national_registration": "${partner_individual_national_registration}",
    ...                         "revenue": ${partner_individual_revenue},
    ...                         "birthday": "${partner_individual_birthday}",
    ...                         "mothers_name": "${partner_individual_mothers_name}",
    ...                         "identity_card": "${partner_individual_identity_card}",
    ...                         "pep": false,
    ...                         "percentage": ${partner_individual_percentage},
    ...                         "adm": ${partner_individual_adm},
    ...                         "cbo": ${partner_individual_cbo}
    ...                      }
    ${response}        Post Request        accreditation            /marketplaces/${marketplace_external_key}/banking/accreditation/holders/${holder_external_key}/partners
    ...                                                             data=${body}
    ...                                                             headers=${header}

    Log                           ${response.json()}
    Log                           ${response.headers['X-REQUEST-ID']}
    Set Global Variable           ${response}

    ${partner_external_key}        Set Variable If    ${response.status_code}==201    ${response.json()["id"]}
    Set Global Variable            ${partner_external_key}
