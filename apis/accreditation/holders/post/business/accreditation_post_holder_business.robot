*** Settings ***
Library   RequestsLibrary
Library   Collections
Resource  ../../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
criar holder business
    conectar accreditation
    [Arguments]  ${holder_type}   ${business_name}   ${email_business}   ${national_registration}   ${revenue_business}    ${cnae}   ${legal_name}   ${establishment_format}   ${establishment_date}

    Set Global Variable    ${holder_type}
    Set Global Variable    ${business_name}
    Set Global Variable    ${legal_name}

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ...                         "type": "${holder_type}",
    ...                         "name": "${business_name}",
    ...                         "email": "${email_business}",
    ...                         "national_registration": "${national_registration}",
    ...                         "revenue": ${revenue_business},
    ...                         "cnae": "${cnae}",
    ...                         "legal_name": "${legal_name}",
    ...                         "establishment": {
    ...                                            "format":"${establishment_format}",
    ...                                            "date":"${establishment_date}"
    ...                                           }
    ...                      }
    ${response}        Post Request        accreditation            /marketplaces/${marketplace_external_key}/banking/accreditation/holders
    ...                                                             data=${body}
    ...                                                             headers=${header}

    Log                           ${response.json()}
    Log                           ${response.headers['X-REQUEST-ID']}
    Log                           ${body}
    Set Global Variable           ${response}

    ${holder_external_key}        Set Variable If    ${response.status_code}==201    ${response.json()["id"]}
    Set Global Variable           ${holder_external_key}
