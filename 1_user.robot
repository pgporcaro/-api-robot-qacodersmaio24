*** Settings ***
Resource    ../resources/0_auth.resource
Resource    ../resources/1_user.resource

*** Variables ***



*** Test Cases ***
Cenário com POST: Cadastrar um novo usuário com sucesso
  Login com usuário Sysadmin
  Cadastrar um novo usuário
  Conferir se o novo usuário foi cadastrado corretamente
  

Cenário com GET: Consultar os dados do usuário
   Login com usuário Sysadmin
   Cadastrar um novo usuário
   Conferir se o novo usuário foi cadastrado corretamente
  

Cenario com PUT: Alterar o perfil de acesso
  Login com usuário Sysadmin
  Cadastrar um novo usuário
  Login com usuário criado
  Alterar dados de um usuário

Cenário com GET
  Login com usuário Sysadmin
  Cadastrar um novo usuário
  Consultar os dados do usuário
  Conferir os dados retornardos do novo usuário

Cenário com PUT
  Login com usuário Sysadmin
  Cadastrar um novo usuário
  Login com usuário criado
  Alterar dados de um usuário

  