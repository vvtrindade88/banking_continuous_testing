*** Settings ***
Library          DateTime

*** Keyword ***
gerar message_id
    ${date}  Get Current Date  result_format=datetime
    ${datetime}  Convert Date	   ${date}  result_format=%Y%m%d%H%M

    ${random_number_message_id}  Random Number  digits=23  fix_len=True
    ${message_id}  Set Variable   M19468242${random_number_message_id}

    Set Global Variable    ${message_id}
