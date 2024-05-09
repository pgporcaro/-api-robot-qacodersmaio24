*** Settings ***
Resource  ../resources/5_department.resource
Resource  ../resources/4_cost_center.resource
Resource  ../resources/0_auth.resource
Resource  ../resources/3_board.resource




*** Test Cases ***
Cenário com POST: Cadastrar um novo usuário com sucesso
  Login com usuário Sysadmin
  Cadastrar um novo usuário Board
  Cadastrar um novo usuário Cost Center
  Cadastrar um novo usuário Department
  Conferir se o novo usuário Department foi cadastrado corretamente
  Conferir os dados retornados do novo usuário Department
  Consultar os dados do usuário Department
  Alterar dados de um usuário Department