*** Settings ***
Documentation   Objetivo relizar testes de API
Library  RequestsLibrary
Library  String
Library  Collections
Resource  0_auth.resource

*** Variables ***



*** Keywords ***

Criar massa de dados de usuário company
  ${palavra_randomica_mail}  Generate Random String  length=6  chars={LETTERS}
  ${palavra_randomica_mail}  Convert To Lower Case    ${palavra_randomica_mail}
  Set Test Variable    ${MAIL}                        ${palavra_randomica_mail}@suits.com.br
  Log    ${MAIL}
  ${numero_randomico_cnpj}  Generate Random String  length=14  chars={NUMBERS}
  Set Test Variable    ${REGISTER_COMPANY}            ${numero_randomico_cnpj}
  Log    ${REGISTER_COMPANY}
  ${palavra_randomica_coporate_name}  Generate Random String  length=8  chars={LETTERS}
  Set Test Variable    ${CORPORATE_NAME}              ${palavra_randomica_coporate_name}
  Log    ${CORPORATE_NAME}
  ${palavra_randomica_matriz}  Generate Random String  length=8  chars={LETTERS}
  Set Test Variable    ${MATRIZ}                       ${palavra_randomica_matriz}
  Log    ${MATRIZ}
  ${palavra_randomica_contato}  Generate Random String  length=8  chars={LETTERS}
  Set Test Variable    ${RESPONSIBLE_CONTACT}          ${palavra_randomica_contato}
  Log    ${RESPONSIBLE_CONTACT}
  ${numero_randomico_phone}  Generate Random String  length=14  chars={NUMBERS}
  Set Test Variable    ${TELEPHONE}                    ${palavra_randomica_contato}
  Log    ${TELEPHONE}
  ${palavra_randomica_description}  Generate Random String  length=8  chars={LETTERS}
  Set Test Variable    ${SERVICE_DESCRIPTION}          ${palavra_randomica_description}
  Log    ${SERVICE_DESCRIPTION}
  ${numero_randomico_cep}  Generate Random String  length=8  chars={NUMBERS}
  Set Test Variable    ${ZIP_CODE}                     ${numero_randomico_cep}
  Log    ${ZIP_CODE}
  ${palavra_randomica_city}  Generate Random String  length=8  chars={LETTERS}
  Set Test Variable    ${CITY}                         ${palavra_randomica_city}
  Log    ${CITY}
  ${palavra_randomica_state}  Generate Random String  length=2  chars={LETTERS}
  Set Test Variable    ${STATE}                        ${palavra_randomica_state}
  Log    ${STATE}
  ${palavra_randomica_district}  Generate Random String  length=8  chars={LETTERS}
  Set Test Variable    ${DISTRICT}                     ${palavra_randomica_district}
  Log    ${DISTRICT}
  ${palavra_randomica_street}  Generate Random String  length=8  chars={LETTERS}
  Set Test Variable    ${STREET}                       ${palavra_randomica_street}
  Log    ${STREET}
  ${numero_randomico_number}  Generate Random String  length=8  chars={LETTERS}
  Set Test Variable    ${NUMBER}                       ${numero_randomico_number}
  Log    ${NUMBER}
  ${palavra_randomica_complement}  Generate Random String  length=8  chars={LETTERS}
  Set Test Variable    ${COMPLEMENT}                   ${palavra_randomica_complement}
  Log    ${COMPLEMENT}
  ${palavra_randomica_country}  Generate Random String  length=8  chars={LETTERS}
  Set Test Variable    ${COUNTRY}                      ${palavra_randomica_country}
  Log    ${COUNTRY}


  Set Test Variable    &{ADDRESS}                      zipCode=${ZIP_CODE}  city=${CITY}  state=${STATE}  district=${DISTRICT}  street=${STREET}  number=${NUMBER}  complement=${COMPLEMENT}  country=${COUNTRY}

  Set Test Variable    @{ADDRESS}                      ${ADDRESS}


Cadastrar um novo usuário Company
  Criar massa de dados de usuário Company
  ${body}  Create Dictionary   corporateName=${CORPORATE_NAME}  registerCompany=${REGISTER_COMPANY}  mail=${MAIL}  matriz=${MATRIZ}  
  ...  responsibleContact=${RESPONSIBLE_CONTACT}   telephone=${TELEPHONE}   serviceDescription=${SERVICE_DESCRIPTION}  address=${ADDRESS}
  Log  ${body}
  ${headers}  Create Dictionary  Authorization=${TOKEN}  
  ${resposta}  POST On Session  alias=Suits   url=/api/company  json=${body}   expected_status=400  headers=${headers}
  Log  ${resposta.json()}
  Set Test Variable    ${ID_COMPANY}  ${resposta.json()["newCompany"]["_id"]}
  Set Test Variable    ${RESPOSTA}  ${resposta.json()}

Consultar os dados do usuário Company
  ${headers}  Create Dictionary  Authorization=${TOKEN}
  ${resposta_consulta}  GET On Session  alias=Suits  url=api/company/${ID_COMPANY}  expected_status=200  headers={headers}
  Set Test Variable    ${RESPOSTA_CONSULTA}              ${resposta_consulta.json()}

Conferir se o novo uruário Company foi cadastrado corretamente
  Log    ${RESPOSTA}
  Dictionary Should Contain Item    ${RESPOSTA}    msg         Olá a companhia ${CORPORATE_NAME} foi cadastrada com sucesso.
  Dictionary Should Contain Item    ${RESPOSTA}    newCompany  _id

Conferir os dados retornados do novo usuário Company
  Log    ${RESPOSTA}
  Should Be Equal As Strings    ${RESPOSTA["newCompany"]["corporateName"]}  ${CORPORATE_NAME}

Alterar dados de um usuário Company
  ${headers}  Create Dictionary  Authorization={TOKEN}
    ${alterar_dados_empresa}  PUT On Session  alias=Suits  url=/api/company/${ID_COMPANY}  expected_status=201  data={"corporateName":"${CORPORATE_NAME}"}  headers={headers}
    Set Test Variable    ${ALTERAR_DADOS_EMPRESA}          ${alterar_dados_empresa.json()}
    Log    ${ALTERAR_DADOS_EMPRESA}
    Dictionary Should Contain Item    ${ALTERAR_DADOS_EMPRESA}    msg    Companhia atualizada com sucesso

