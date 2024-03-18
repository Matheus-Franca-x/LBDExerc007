
/*Considere a tabela Produto com os seguintes atributos:
Produto (Codigo | Nome | Valor)
Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos:
(Codigo_Transacao | Codigo_Produto | Quantidade | Valor_Total)
*/

CREATE DATABASE produto
GO
USE produto
GO
CREATE TABLE produto
(
	codigo		INT				NOT NULL,
	nome		VARCHAR(50)		NOT NULL,
	valor		DECIMAL(7, 2)	NOT NULL
	PRIMARY KEY (codigo)
)
GO
CREATE TABLE entrada
(
	codigo_transacao 	INT				NOT NULL,
	codigo_produto		INT				NOT NULL,
	quantidade			INT				NOT NULL,
	valor_total			DECIMAL(7, 2)	NOT NULL
	PRIMARY KEY (codigo_transacao)
	FOREIGN KEY (codigo_produto) REFERENCES produto (codigo)
)
GO
CREATE TABLE saida
(
	codigo_transacao 	INT				NOT NULL,
	codigo_produto		INT				NOT NULL,
	quantidade			INT				NOT NULL,
	valor_total			DECIMAL(7, 2)	NOT NULL
	PRIMARY KEY (codigo_transacao)
	FOREIGN KEY (codigo_produto) REFERENCES produto (codigo)
)


/*
Cada produto que a empresa compra, entra na tabela ENTRADA. Cada produto que a empresa vende, entra na tabela SAIDA.
Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA), criar uma exceção de erro para código inválido, 
receba o codigo_transacao, codigo_produto e a quantidade e preencha a tabela correta, 
com o valor_total de cada transação de cada produto.
*/

DROP PROCEDURE sp_entrada_saida_produto

CREATE PROCEDURE sp_entrada_saida_produto 
(
	@acao VARCHAR(1), 
	@codigo_produto INT, 
	@nome VARCHAR(50), 
	@valor DECIMAL(7, 2),
	@codigo_transacao INT,
	@quantidade INT,
	@saida VARCHAR(100) OUTPUT
)
AS
	DECLARE @tabela VARCHAR(20),
			@query VARCHAR(200),
			@valor_total DECIMAL(7, 2),
			@erro VARCHAR(100)
	SET @tabela = 'entrada'
	IF (@acao = 's')
	BEGIN
		SET @tabela = 'saida'
	END
	IF (@valor IS NOT NULL AND @quantidade IS NOT NULL)
	BEGIN
		SET @valor_total = @valor * @quantidade 
	END
	ELSE IF (@valor IS NULL AND @quantidade IS NULL)
	BEGIN
		SET @erro = 'Valor e quantidade não inserido.'
		RAISERROR(@erro, 16, 1)
	END
	ELSE IF (@valor IS NULL)
	BEGIN 
		SET @erro = 'Valor não inserido.'
		RAISERROR(@erro, 16, 1)
	END
	ELSE
	BEGIN 
		SET @erro = 'Quantidade não inserido.'
		RAISERROR(@erro, 16, 1)
	END
	SET @query = CONCAT('INSERT INTO ', @tabela, ' VALUES (', 
	CAST(@codigo_transacao AS VARCHAR(10)), ', ',
	CAST(@codigo_produto AS VARCHAR(10)), ', ',
	CAST(@quantidade AS VARCHAR(10)), ', ',
	CAST(@valor_total AS VARCHAR(10)), ')')
	BEGIN TRY
		INSERT INTO produto VALUES 
		(
			@codigo_produto,
			@nome,
			@valor
		)
		EXEC (@query)
		SET @saida = CONCAT(UPPER(@tabela), ' inserido com sucesso!')
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%')
		BEGIN 
			SET @erro = 'Produto duplicado'
		END
		ELSE
		BEGIN 
			SET @erro = CONCAT('Erro na inserção da tabela ', UPPER(@tabela)) 
		END
		RAISERROR (@erro, 16, 1)
	END CATCH
	
	
DECLARE @out VARCHAR(100)
EXEC sp_entrada_saida_produto 's', 1, 'algum nome', 10, 1, 10, @out OUTPUT 
PRINT @out
	
DECLARE @out VARCHAR(100)
EXEC sp_entrada_saida_produto 's', 2, 'algum nome', 10, 2, 10, @out OUTPUT 
PRINT @out
	
DECLARE @out VARCHAR(100)
EXEC sp_entrada_saida_produto 'e', 3, 'algum nome', 10, 1, 10, @out OUTPUT 
PRINT @out

