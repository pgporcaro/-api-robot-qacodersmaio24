*** Settings ***
Resource  ../resources/2_company.resource
Resource  ../resources/0_auth.resource

*** Variables ***



*** Test Cases ***
Cenário com POST: Cadastrar um novo usuário com sucesso
  Login com usuário Sysadmin
  Cadastrar um novo usuário company
  Conferir se o novo uruário Company foi cadastrado corretamente
  Conferir os dados retornados do novo usuário Company
  Consultar os dados do usuário Company
  Alterar dados de um usuário Company
  