*** Settings ***
Library   RequestsLibrary
Library   Collections

*** Variables ***
${marketplace_external_key}  f71a8951368a4cc085cf7875ff44e61c
${application_external_key}  bcc25a6751c14b52af1340d40dba78c5

${accreditation_url_base}    https://banking-accreditation-internal.staging.zoop.tech
${account_url_base}          https://banking-accounts-internal.staging.zoop.tech
${pix_dict_url_base}         https://banking-pix-dict-internal.staging.zoop.tech
${pix_payments_url_base}     https://banking-pix-payments-internal.staging.zoop.tech
${subscription_url_base}     https://banking-subscriptions-internal.staging.zoop.tech
${scheduler_url_base}        https://banking-scheduler-internal.staging.zoop.tech
${history_url_base}          https://banking-history-internal.staging.zoop.tech
${card-manager_url_base}     https://banking-card-manager-internal.staging.zoop.tech
${billing_url_base}          https://banking-billing-internal.staging.zoop.tech
${payments_url_base}         https://banking-payments-internal.staging.zoop.tech


*** Keywords ***
conectar accreditation
      Create Session    alias=accreditation    url=${accreditation_url_base}     disable_warnings=true

conectar accounts
      Create Session    alias=accounts         url=${account_url_base}           disable_warnings=true

conectar pix-dict
      Create Session    alias=pix-dict         url=${pix_dict_url_base}          disable_warnings=true

conectar pix-payments
      Create Session    alias=pix-dict         url=${${pix_dict_url_base}        disable_warnings=true

conectar subscription
      Create Session    alias=subscription     url=${subscription_url_base}      disable_warnings=true

conectar scheduler
      Create Session    alias=scheduler        url=${scheduler_url_base}         disable_warnings=true

conectar history
      Create Session    alias=history          url=${history_url_base}           disable_warnings=true

conectar card-manager
      Create Session    alias=card-manager     url=${card-manager_url_base}      disable_warnings=true

conectar billing
      Create Session    alias=billing          url=${billing_url_base}           disable_warnings=true

conectar payments
      Create Session    alias=billing          url=${payments_url_base}          disable_warnings=true
