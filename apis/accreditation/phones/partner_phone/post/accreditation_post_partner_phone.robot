*** Settings ***
Library   RequestsLibrary
Library   Collections
Resource  ../../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
criar partner phone
    [Arguments]  ${phone_area_code}   ${phone_country_code}   ${phone_number}

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ...                         "area_code": "${phone_area_code}",
    ...                         "country_code": "${phone_country_code}",
    ...                         "number": "${phone_number}"
    ...                      }
    ${response}        Post Request        accreditation            /marketplaces/${marketplace_external_key}/banking/accreditation/holders/${holder_external_key}/partners/${partner_external_key}/phones/
    ...                                                             data=${body}
    ...                                                             headers=${header}

    Log                           ${response.json()}
    Set Global Variable           ${response}

    ${holder_external_key}        Set Variable If    ${response.status_code}==201    ${response.json()["id"]}
    Set Global Variable           ${phone_external_key}
