# LBDExerc007


## Considere a tabela Produto com os seguintes atributos:
### Produto 
Codigo(PK) | Nome | Valor
-|-|-

Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos:

### Entrada
Codigo_Transacao(PK) | Codigo_Produto(FK) | Quantidade | Valor_Total
-|-|-|-

### Saida
Codigo_Transacao(PK) | Codigo_Produto(FK) | Quantidade | Valor_Total)
-|-|-|-

Cada produto que a empresa compra, entra na tabela ENTRADA. Cada produto que a empresa vende, entra na tabela SAIDA.
Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA), criar uma exceção de erro para código inválido, receba o codigo_transacao, codigo_produto e a quantidade e preencha a tabela correta, com o valor_total de cada transação de cada produto.
