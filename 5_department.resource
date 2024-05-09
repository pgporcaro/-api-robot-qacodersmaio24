*** Settings ***
Documentation  Objetivo de realizar testes de API
Library  RequestsLibrary
Library  String
Library  Collections
Resource  0_auth.resource
Resource  3_board.resource
Resource  4_cost_center.resource

*** Variables ***

*** Keywords ***

Criar massa de dados do usuário Department
  ${palavra_randomica}  Generate Random String  length=8  chars={LETTERS}
  ${palavra_randomica}  Convert To Lower Case    ${palavra_randomica}
  Set Test Variable    ${DEPARTMENT_NAME}        ${palavra_randomica}
  Log    ${DEPARTMENT_NAME}

Cadastrar um novo usuário Department
  Criar massa de dados de usuário Department
  ${body}  Create Dictionary  departmentName=${DEPARTMENT_NAME}  costCenterId=${ID_COST_CENTER}
  Log    ${body}
  ${headers}  Create Dictionary  Authorization=${TOKEN}
  ${resposta}  POST On Session  alias=Suits  url=/api/department  json=${body}  expected_status=201  headers=${headers}
  Log    ${resposta.json()}
  Set Test Variable    ${ID_DEPARTMENT}  ${resposta.json()["newDepartment"]["_id"]}
  Set Test Variable    ${RESPOSTA}       ${resposta.json()}

Consultar os dados do usuário Department
  ${headers}  Create Dictionary  Authorization=${TOKEN}
  ${resposta_consulta}  GET On Session  alias=suits  url=/api/department/${ID_DEPARTMENT}  expected_status=200  headers=${headers}
  Set Test Variable    ${RESPOSTA_CONSULTA}  ${resposta_consulta.json()}

Conferir se o novo usuário Department foi cadastrado corretamente
  Log    ${RESPOSTA}
  Dictionary Should Contain Item    ${RESPOSTA}    msg    Cadastro realizado com sucesso.
  Dictionary Should Contain Item    ${RESPOSTA}    newDepartment    _id

Conferir os dados retornados do novo usuário Department
  Log    ${RESPOSTA}
  Should Be Equal As Strings    ${RESPOSTA["newDepartment"]["departmentName"]}    ${DEPARTMENT_NAME}

Alterar dados de um usuário Department
  ${headers}  Create Dictionary  Authorization=${TOKEN}
   ${alterar_dados_departamento}  PUT On Session  alias=Suits  url=/api/department/${ID_DEPARTMENT}  expected_status=200  data={"departmentName":"${DEPARTMENT_NAME}", "costCenterId":"${ID_COST_CENTER}"}  headers=${headers}
   Set Test Variable    ${ALTERAR_DADOS_DEPARTAMENTO}  ${alterar_dados_departamento.json()}
   Log    ${ALTERAR_DADOS_DEPARTAMENTO}
   Dictionary Should Contain Item    ${ALTERAR_DADOS_DEPARTAMENTO}    msg    Cadastro atualizado com sucesso.
