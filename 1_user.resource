*** Settings ***
Documentation  Objetivo realizar testes de API
Library  RequestsLibrary
Library  String
Library  Collections
Resource  0_auth.resource


*** Variables ***
${msgCadastroSucesso}        Olá Teste do Teste, cadastro realizado com sucesso. 
${msgAtualizarDadosSucesso}  Dados Atualizados com sucesso!

*** Keywords ***
 
 
 Criar sessão de usuário
  ${headers}  Create Dictionary  accept=application/json  Content-Type=application/json  Authorization=${TOKEN_USER}  
  Create Session    alias=Suits      url=https://suits.qacoders-academy.com.br  headers=${headers}

 Criar massa de dados de usuário
  ${palavra_randomica}  Generate Random String  length=8  chars=[LETTERS]
  ${palavra_randomica}  Convert To Lower Case    ${palavra_randomica}
  Set Test Variable    ${EMAIL_TEST}             ${palavra_randomica}@qacoders.com.br
  Log                  ${EMAIL_TEST}
  ${palavra_randomica_cpf}  Generate Random String  length=11  chars=[NUMBERS]
  ${palavra_randomica_cpf}  Convert To Lower Case    ${palavra_randomica_cpf}
  Set Test Variable    ${CPF}                    ${palavra_randomica_cpf}
  Log                  ${CPF}

Cadastrar um novo usuário
    Criar massa de dados de usuário
    ${body}  Create Dictionary  fullName=Teste do Teste  mail=${EMAIL_TEST}  password=1234@Test  administrador=true  accessProfile=ADMIN  cpf=${CPF}  confirmPassword=1234@Test
    Log    ${body}
    ${headers}  Create Dictionary  Authorization=${TOKEN}
    ${resposta}  POST On Session   alias=Suits  url=/api/user  json=${body}  expected_status=201  headers=${headers}
    Log  ${resposta.json()}
    Set Test Variable    ${ID_USUARIO}  ${resposta.json()["user"]["_id"]}
    Set Test Variable    ${RESPOSTA}    ${resposta.json()}
    Log  Novo usuário cadastrado com sucesso. ID do usuário: ${ID_USUARIO}
    
Consultar os dados do usuário
  ${headers}  Create Dictionary  Authorization=${TOKEN}
  ${resposta_consulta}    GET On Session    alias=Suits  url=/api/user/${ID_USUARIO}  headers=${headers}  expected_status=200
  Set Test Variable       ${RESPOSTA_CONSULTA}                     ${resposta_consulta.json()}

Conferir se o novo usuário foi cadastrado corretamente
  Log  ${RESPOSTA}
  Should Be Equal As Strings      ${resposta["msg"]}    ${msgCadastroSucesso}
  Should Be Equal As Strings      ${resposta["user"]["_id"]}    ${ID_USUARIO}
  Dictionary Should Contain Item  ${RESPOSTA}   msg    Olá Teste do Teste, cadastro realizado com sucesso.
  Dictionary Should Contain Key   ${RESPOSTA}   user   _id
  Log  Usuário cadastrado corretamente.


Conferir os dados retornardos do novo usuário
  Log    ${RESPOSTA_CONSULTA}
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}  fullName        Teste do Teste 
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}  mail            ${EMAIL_TEST} 
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}  accessProfile   ADMIN
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}  cpf             ${CPF}
  Dictionary Should Contain Item    ${RESPOSTA_CONSULTA}  _id             ${ID_USUARIO}
  
Login com usuário criado
  ${body}  Create Dictionary  mail=${EMAIL_TEST}  password=1234@Test
  Log    ${body}
  ${resposta}  POST On Session  alias=Suits  url=/api/login  json=${body}
  Log    ${resposta.json()}
  Set Test Variable    ${TOKEN_USER}  ${resposta.json()["token"]}

Validar o token user e gravar um header de autorização
  ${headers}  Create Dictionary  Authorization=${TOKEN_USER}
  ${respsota}  GET On Session  alias=Suits  url=/api/validadeToken  headers=${headers}
  Log    ${resposta.content}
  Log    ${TOKEN_USER}

Alterar dados de um usuário
  Criar sessão de usuário
    ${alterar_dados_usuario}    PUT On Session    alias=Suits     url=/api/user/${ID_USUARIO}   expected_status=200    data={"fullName":"Ana Maria", "mail":"${EMAIL_TEST}"}
    Set Test Variable    ${ALTERAR_DADOS_USUARIO}                  ${alterar_dados_usuario.json()}
    Log  ${ALTERAR_DADOS_USUARIO}
    Dictionary Should Contain Item    ${ALTERAR_DADOS_USUARIO}    msg    Dados atualizados com sucesso!