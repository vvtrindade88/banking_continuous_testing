*** Settings ***
Library   RequestsLibrary
Library   Collections
Resource  ../../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
criar partner address
    [Arguments]  ${city}   ${state}   ${country}   ${neighborhood}   ${street}   ${number}   ${complement}   ${postal_code}

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ...                         "city": "${city}",
    ...                         "state": "${state}",
    ...                         "country": "${country}",
    ...                         "neighborhood": "${neighborhood}",
    ...                         "street": "${street}",
    ...                         "number": "${number}",
    ...                         "complement": "${complement}",
    ...                         "postal_code": "${postal_code}"
    ...                      }
    ${response}        Post Request        accreditation            /marketplaces/${marketplace_external_key}/banking/accreditation/holders/${holder_external_key}/partners/${partner_external_key}/addresses
    ...                                                             data=${body}
    ...                                                             headers=${header}

    Log                           ${response.json()}
    Set Global Variable           ${response}

    ${address_external_key}       Set Variable If    ${response.status_code}==201    ${response.json()["id"]}
    Set Global Variable           ${address_external_key}
