*** Settings ***
Library          DateTime

*** Keyword ***
gerar end_to_end_id
    ${date}  Get Current Date  result_format=datetime
    ${datetime}  Convert Date	   ${date}  result_format=%Y%m%d%H%M

    ${random_number_end_to_end_id}  Random Number  digits=11  fix_len=True
    ${end_to_end_id}  Set Variable   E19468242${datetime}${random_number_end_to_end_id}

    Set Global Variable    ${end_to_end_id}
