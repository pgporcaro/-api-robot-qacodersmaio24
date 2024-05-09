*** Settings ***
Documentation  Objetivo realizar testes de API
Library  RequestsLibrary
Library  String
Library  Collections
Resource  0_auth.resource
Resource  3_board.resource

*** Variables ***


*** Keywords ***

Criar massa de dados de usuário Cost Center
  ${palavra_randomica}  Generate Random String  length=8  chars={LETTERS}
  ${palavra_randomica}  Convert To Lower Case    ${palavra_randomica}
  Set Test Variable    ${COST_CENTER_NAME}       ${palavra_randomica}
  Log                  ${COST_CENTER_NAME}

Cadastrar um novo usuário Cost Center
  Criar massa de dados de usuário Cost Center
  ${body}  Create Dictionary  costCenterName=${COST_CENTER_NAME}  boardId=${ID_BOARD}
  Log    ${body}
  ${headers}  Create Dictionary  Authorization=${TOKEN}
  ${resposta}  POST On Session  alias=Suits  url=/api/costCenter  json=${body}  expected_status=201  headers=${headers}
  Log    ${resposta.json()}
  Set Test Variable    ${ID_COST_CENTER}  ${resposta.json()["newCostCenter"]["_id"]}
  Set Test Variable    ${RESPOSTA}        ${resposta.json()}

Consultar os dados do usuário Cost Center
  ${headers}  Create Dictionary  Authorization=${TOKEN}
  ${resposta_consulta}  GET On Session  alias=Suits  url=/api/costCenter/${ID_COST_CENTER}  expected_status=200  headers=${headers}
  Set Test Variable    ${RESPOSTA_CONSULTA}  ${resposta_consulta.json()}

Conferir se o novo usuário Cost Center foi cadastrado corretamente
  Log    ${RESPOSTA}
  Dictionary Should Contain Item    ${RESPOSTA}    msg    Cadastro realizado com sucesso.
  Dictionary Should Contain Item    ${RESPOSTA}    newCostCenter    _id

Conferir os dados retornados do novo usuário Cost Center
  Log    ${RESPOSTA}
  Should Be Equal As Strings    ${RESPOSTA["newCostCenter"]["costCenterName"]}    ${COST_CENTER_NAME}

Alterar dados de um usuário Cost Center
  ${headers}  Create Dictionary  Authorization=${TOKEN}
   ${alterar_dados_centro_de_custos}  PUT On Session  alias=Suits  url=/api/costCenter/${ID_COST_CENTER}  expected_status=200  data=${"costCenterName":"${COST_CENTER_NAME}","boardId":"${ID_BOARD}"}  headers=${headers}
   Set Test Variable    ${ALTERAR_DADOS_CENTRO_DE_CUSTOS}  ${alterar_dados_centro_de_custos.json()}
   Log    ${ALTERAR_DADOS_CENTRO_DE_CUSTOS}
   Dictionary Should Contain Item    ${ALTERAR_DADOS_CENTRO_DE_CUSTOS}    msg    Cadastro atualizado com sucesso.

  