*** Settings ***
Library   RequestsLibrary
Library   Collections
Library   OperatingSystem
Resource  ../../../../../ambientes/staging/internal/create_session_staging_internal.robot

*** Keywords ***
criar holder document
    [Arguments]  ${document_type}

    ${header}          Create Dictionary        Content-Type=image/jpeg
    ## O caminho que está inserido no  path do Get Binary File está diretamente relacionado à pasta onde os testes serão executados
    ## Sendo assim para que essa keyword funcione, momentaneamente, o comando "robot" deve ser executado no path "\tests\accreditation\holders"
    ## Esse problema será ajustado futuramente
    ${data}            Get Binary File          ./../../images/accreditation/image.jpg
    ${response}        Post Request             accreditation            /marketplaces/${marketplace_external_key}/banking/accreditation/holders/${holder_external_key}/documents?type=${document_type}
    ...                                                                  data=${data}
    ...                                                                  headers=${header}

    Log                           ${response.json()}
    Log                           ${response.headers['X-REQUEST-ID']}
    Set Global Variable           ${response}

    ${document_external_key}       Set Variable If    ${response.status_code}==201    ${response.json()["id"]}
    Set Global Variable            ${document_external_key}
