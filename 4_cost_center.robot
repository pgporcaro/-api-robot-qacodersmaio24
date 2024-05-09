*** Settings ***
Resource  ../resources/4_cost_center.resource
Resource  ../resources/3_board.resource
Resource  ../resources/0_auth.resource

*** Variables ***



*** Test Cases ***
Cenário com Post: Cadastrar um novo usuário com sucesso
  Login com usuário Sysadmin
  Cadastrar um novo usuário Board
  Cadastrar um novo usuário Cost Center
  Conferir se o novo usuário Cost Center foi cadastrado corretamente
  Conferir os dados retornados do novo usuário Cost Center
  Consultar os dados do usuário Cost Center
  Alterar dados de um usuário Cost Center