*** Settings ***
Documentation  Objetivo realizar testes de API
Library  RequestsLibrary
Library  String
Library  Collections



*** Variables ***
${ADMIN_E-MAIL}    sysadmin@qacoders.com  
${ADMIN_PASSWORD}  1234@Test
${TOKEN}  
${EMAIL_TEST}  sysadmin@qacoders.com
${TOKEN_USER}
${URL}  https://suits.qacoders-academy.com.br

*** Keywords ***
Criar sessão
  ${headers}  Create Dictionary    Content-Type=application/json  
  Create Session    alias=Suits      url=${URL}   headers=${headers}

  
Login com usuário Sysadmin
  ${body}  Create Dictionary  mail=${ADMIN_E-MAIL}  password=${ADMIN_PASSWORD}   
  Log  ${body}
  Criar sessão     
  ${resposta}  POST On Session  alias=Suits   url=api/login  json=${body}
  Log  ${resposta.json()}
  Set Test Variable    ${TOKEN}  ${resposta.json()["token"]}

Validar o token e gravar em um header de autorização
  ${headers}   Create Dictionary  Authorization=${TOKEN}
  ${resposta}  GET On Session  alias=Suits  url=/api/validateToken  headers=${headers}
  Log  ${resposta.content}
  Log  ${TOKEN}
