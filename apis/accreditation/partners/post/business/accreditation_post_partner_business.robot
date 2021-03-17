*** Settings ***
Library   RequestsLibrary
Library   Collections
Resource  ../../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
criar partner business
    [Arguments]  ${partner_business_type}   ${partner_business_name}   ${partner_business_email}   ${partner_business_national_registration}   ${partner_business_revenue}    ${partner_business_cnae}
    ...          ${partner_business_legal_name}   ${partner_business_adm}   ${partner_business_percentage}   ${partner_business_establishment_format}   ${partner_business_establishment_date}

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ...                         "type": "${partner_business_type}",
    ...                         "name": "${partner_business_name}",
    ...                         "email": "${partner_business_email}",
    ...                         "national_registration": "${partner_business_national_registration}",
    ...                         "revenue": ${partner_business_revenue},
    ...                         "cnae": "${partner_business_cnae}",
    ...                         "legal_name": "${partner_business_legal_name}",
    ...                         "adm": ${partner_business_adm},
    ...                         "percentage": ${partner_business_percentage},
    ...                         "establishment": {
    ...                                            "format":"${partner_business_establishment_format}",
    ...                                            "date":"${partner_business_establishment_date}"
    ...                                           }
    ...                      }
    ${response}        Post Request        accreditation            /marketplaces/${marketplace_external_key}/banking/accreditation/holders/${holder_external_key}/partners
    ...                                                             data=${body}
    ...                                                             headers=${header}

    Log                           ${body}
    Log                           ${response.json()}
    Set Global Variable           ${response}

    ${partner_external_key}        Set Variable If    ${response.status_code}==201    ${response.json()["id"]}
    Set Global Variable            ${partner_external_key}
