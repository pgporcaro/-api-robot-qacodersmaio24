*** Settings ***
Resource    ../resources/0_auth.resource
Resource    ../resources/3_board.resource
Resource    ../resources/1_user.resource
*** Variables ***



*** Test Cases ***

Cenário com Post: Cadastrar um novo usuário com sucesso
  Login com usuário Sysadmin
  Cadastrar um novo usuário Board
  Confere se o novo usuário foi cadastrado corretamente
  Conferir os dados retornados do novo usuário
  Consultar os dados do usuário board
  Alterar dados de um usuário board

