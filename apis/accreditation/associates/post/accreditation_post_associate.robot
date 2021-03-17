Library   RequestsLibrary
Library   Collections
Resource  ../../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
criar associate
    [Arguments]  ${associate_name}   ${email}   ${national_registration}   ${revenue}    ${birthday}   ${mothers_name}   ${identity_card}   ${pep}   ${cbo}

    ${header}  Create Dictionary  Content-Type=application/json
    ${body}    Catenate    {
    ...                         "name": "${associate_name}",
    ...                         "email": "${email}",
    ...                         "national_registration": "${national_registration}",
    ...                         "revenue": ${revenue},
    ...                         "birthday": "${birthday}",
    ...                         "mothers_name": "${mothers_name}",
    ...                         "identity_card": "${identity_card}",
    ...                         "pep": false,
    ...                         "cbo": ${cbo}
    ...                      }
    ${response}        Post Request        accreditation            /marketplaces/${marketplace_external_key}/banking/accreditation/holders
    ...                                                             data=${body}
    ...                                                             headers=${header}

    Log                           ${response.json()}
    Set Global Variable           ${response}

    ${holder_external_key}        Set Variable If    ${response.status_code}==201    ${response.json()["id"]}
    Set Global Variable           ${holder_external_key}
