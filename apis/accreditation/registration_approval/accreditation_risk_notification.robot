*** Settings ***
Library   RequestsLibrary
Library   Collections
Resource  ../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
recebendo notificação de aprovação
    # [Arguments]  ${holder_status}

    ${assessment_id}  Uuid 4
    ${year}   Get Time  year
    ${month}  Get Time  month
    ${day}    Get Time  day


    ${header}  Create Dictionary  Content-Type=application/json
    ${body}     Catenate    {
    ...                         "type": "risk.assessment.result",
    ...                         "resource": "business.holder",
    ...                         "created_at": "${year}-${month}-${day} 15:28:56.747Z",
    ...                         "marketplace_id": "${marketplace_external_key}",
    ...                         "object": {
    ...                                       "result": "APPROVED",
    ...                                       "holder_id": "${holder_external_key}",
    ...                                       "applicant_id": "${application_external_key}",
    ...                                       "assessment_id": "${assessment_id}"
    ...                                    }
    ...                      }
    ${response}        Post Request        accreditation            /admin/internal_operation/marketplaces/${marketplace_external_key}/banking/accreditation/holders/${holder_external_key}/registration/approval
    ...                                                             data=${body}
    ...                                                             headers=${header}

    Log                           ${response.json()}
    Set Global Variable           ${response}

    Should Be Equal As Strings    ${response.status_code}    200
