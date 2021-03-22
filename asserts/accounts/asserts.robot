*** Keywords ***
validar debito na account
    [Arguments]  ${account_balance_initial}  ${account_balance_final}  ${amount}
    Log  ${account_balance_initial}
    Log  ${amount}
    ${account_balance_actual}    Evaluate    ${account_balance_initial} - (${amount}/100)

    ${account_balance_final}  Convert To Number    ${account_balance_final}

    Should Be Equal    ${account_balance_final}    ${account_balance_actual}


validar crédito na account
    [Arguments]  ${account_balance_initial}  ${account_balance_final}  ${amount}
    Log  ${account_balance_initial}
    Log  ${amount}
    ${account_balance_actual}    Evaluate    ${account_balance_initial} + (${amount}/100)

    ${account_balance_final}  Convert To Number    ${account_balance_final}

    Should Be Equal    ${account_balance_final}    ${account_balance_actual}
