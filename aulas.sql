SELECT COUNT(*) FROM TABELA_DE_CLIENTES;
SELECT COUNT(*) FROM TABELA_DE_PRODUTOS;
SELECT COUNT(*) FROM TABELA_DE_VENDEDORES;
SELECT COUNT(*) FROM NOTAS_FISCAIS;
SELECT COUNT(*) FROM ITENS_NOTAS_FISCAIS;
USE SUCOS_FRUTAS;
SELECT * FROM TABELA_DE_PRODUTOS WHERE SABOR = 'MANGA' AND TAMANHO = '470 ml';

--Aula 2 / 11
SELECT * FROM TABELA_DE_PRODUTOS WHERE SABOR IN ('lIMA/LIMAO','MORANGO/LIMAO');
SELECT * FROM TABELA_DE_PRODUTOS WHERE SABOR LIKE'%LIMAO';
SELECT * FROM TABELA_DE_PRODUTOS WHERE SABOR LIKE '%MACA%';
SELECT * FROM TABELA_DE_PRODUTOS WHERE SABOR LIKE 'MORANGO%';
SELECT * FROM TABELA_DE_PRODUTOS WHERE (SABOR LIKE 'MORANGO%') AND (EMBALAGEM = 'PET')
SELECT * FROM TABELA_DE_CLIENTES WHERE NOME LIKE '%Silva%';

--=======================================================================================
--AULA 3 / 1
SELECT  DISTINCT EMBALAGEM FROM TABELA_DE_PRODUTOS WHERE SABOR = 'MACA';
SELECT  DISTINCT EMBALAGEM, SABOR FROM TABELA_DE_PRODUTOS;

--AULA 3 / 3
SELECT TOP 5 *  FROM TABELA_DE_PRODUTOS;
SELECT TOP 5 *  FROM TABELA_DE_PRODUTOS WHERE SABOR = 'MACA';
SELECT TOP 10 * FROM NOTAS_FISCAIS WHERE DATA_VENDA = '01/10/2017' --10 primeiras vendas do dia 01/10/2017
ORDER BY CPF;

--AULA 3 / 5
SELECT * FROM TABELA_DE_PRODUTOS ORDER BY PRECO_DE_LISTA DESC;
SELECT * FROM TABELA_DE_PRODUTOS ORDER BY EMBALAGEM, NOME_DO_PRODUTO;
--Qual foi a maior venda do produto "Linha Refrescante - 1 Litro - Morango/Limao" em quantidade = 99
SELECT * FROM TABELA_DE_PRODUTOS 
WHERE NOME_DO_PRODUTO = 'Linha Refrescante - 1 Litro - Morango/Limao';
SELECT * FROM ITENS_NOTAS_FISCAIS
WHERE CODIGO_DO_PRODUTO = '1101035'
ORDER BY QUANTIDADE DESC;

--AULA 3 / 7
SELECT CIDADE, AVG(IDADE) AS IDADE, SUM(LIMITE_DE_CREDITO) AS CREDITO FROM TABELA_DE_CLIENTES
GROUP BY CIDADE
ORDER BY CIDADE;
SELECT CIDADE, COUNT(1) AS NUMERO FROM TABELA_DE_CLIENTES GROUP BY CIDADE;
--Quantas vendas foram feitas com quantidade igual a 99 litros para o produto '1101035'?
SELECT CODIGO_DO_PRODUTO, COUNT(1) AS QUANTIDADE 
FROM ITENS_NOTAS_FISCAIS
WHERE CODIGO_DO_PRODUTO = '1101035' AND QUANTIDADE = 99
GROUP BY CODIGO_DO_PRODUTO;

----AULA 3 / 9
SELECT ESTADO, SUM(LIMITE_DE_CREDITO) AS CREDITO
FROM TABELA_DE_CLIENTES GROUP BY ESTADO
HAVING SUM(LIMITE_DE_CREDITO) >= 900000;

SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS PRECO_MAX, MIN(PRECO_DE_LISTA) AS PRECO_MINIMO
FROM TABELA_DE_PRODUTOS
GROUP BY EMBALAGEM;

SELECT EMBALAGEM, MAX(PRECO_DE_LISTA) AS PRECO_MAX, MIN(PRECO_DE_LISTA) AS PRECO_MINIMO
FROM TABELA_DE_PRODUTOS
WHERE PRECO_DE_LISTA >= 10
GROUP BY EMBALAGEM
HAVING MAX(PRECO_DE_LISTA) >= 20;

--Verifique as quantidades totais de vendas de cada produto e ordene do maior para o menor.
SELECT CODIGO_DO_PRODUTO, SUM(QUANTIDADE) AS 'TOTAL DE VENDAS'
FROM ITENS_NOTAS_FISCAIS
GROUP BY CODIGO_DO_PRODUTO
ORDER BY 'TOTAL DE VENDAS';

--Agora, liste somente os produtos que venderam mais que 394000 litros.
SELECT CODIGO_DO_PRODUTO, SUM(QUANTIDADE) AS 'TOTAL DE VENDAS'
FROM ITENS_NOTAS_FISCAIS
GROUP BY CODIGO_DO_PRODUTO
HAVING SUM(QUANTIDADE) > 394000
ORDER BY 'TOTAL DE VENDAS';

--AULA 3 / 9
SELECT NOME_DO_PRODUTO, PRECO_DE_LISTA
FROM TABELA_DE_PRODUTOS
WHERE SABOR = 'MANGA';

SELECT NOME_DO_PRODUTO, PRECO_DE_LISTA,
(CASE WHEN PRECO_DE_LISTA >= 12 THEN 'PRODUTO CARO'
	  WHEN PRECO_DE_LISTA >= 7 AND PRECO_DE_LISTA < 12 THEN 'PRODUTO EM CONTA'
	  ELSE 'PRODUTO BARATO' END) AS CLASSIFICACAO
FROM TABELA_DE_PRODUTOS
WHERE SABOR = 'MANGA'
ORDER BY CLASSIFICACAO;

SELECT 
(CASE WHEN PRECO_DE_LISTA >= 12 THEN 'PRODUTO CARO'
	  WHEN PRECO_DE_LISTA >= 7 AND PRECO_DE_LISTA < 12 THEN 'PRODUTO EM CONTA'
	  ELSE 'PRODUTO BARATO' END) AS CLASSIFICACAO, COUNT(1) AS NUMERO
FROM TABELA_DE_PRODUTOS
GROUP BY (CASE WHEN PRECO_DE_LISTA >= 12 THEN 'PRODUTO CARO'
	  WHEN PRECO_DE_LISTA >= 7 AND PRECO_DE_LISTA < 12 THEN 'PRODUTO EM CONTA'
	  ELSE 'PRODUTO BARATO' END);
--Liste somente o nome dos clientes e os classifique por:
--Acima ou igual a 150.000 - Clientes grandes
--Entre 150.000 e 110.000 - Clientes m�dios
--Menores que 110.000 Clientes pequenos
SELECT NOME,
(CASE WHEN LIMITE_DE_CREDITO > 150000 THEN 'CLIENTES GRANDES'
	  WHEN LIMITE_DE_CREDITO > 110000 THEN 'CLIENTES M�DIOS' 
	  ELSE 'CLIENTES PEQUENOS' END) AS CLASSIFICACAO
FROM TABELA_DE_CLIENTES
ORDER BY CLASSIFICACAO;

--=======================================================================================
--AULA 4 / 1 - INNER JOIN
SELECT NOTAS_FISCAIS.MATRICULA, TABELA_DE_VENDEDORES.NOME, COUNT(1) AS NUMERO_NOTAS 
FROM TABELA_DE_VENDEDORES 
INNER JOIN NOTAS_FISCAIS
ON NOTAS_FISCAIS.MATRICULA = TABELA_DE_VENDEDORES.MATRICULA
GROUP BY NOTAS_FISCAIS.MATRICULA, TABELA_DE_VENDEDORES.NOME
ORDER BY NOTAS_FISCAIS.MATRICULA DESC;

SELECT NF.CODIGO_DO_PRODUTO, TP.NOME_DO_PRODUTO, SUM(NF.QUANTIDADE) AS QUANTIDADE 
FROM TABELA_DE_PRODUTOS TP
INNER JOIN ITENS_NOTAS_FISCAIS NF
ON NF.CODIGO_DO_PRODUTO = TP.CODIGO_DO_PRODUTO 
GROUP BY NF.CODIGO_DO_PRODUTO, TP.NOME_DO_PRODUTO
HAVING SUM(QUANTIDADE) > 394000 
ORDER BY TP.NOME_DO_PRODUTO;

--AULA 4 / 5 - LEFT JOIN
SELECT DISTINCT
TC.CPF AS CPF_DO_CADASTRO
, TC.NOME AS NOME_DO_CLIENTE
, NF.CPF AS CPF_DA_NOTA
FROM TABELA_DE_CLIENTES TC
left JOIN NOTAS_FISCAIS NF
ON TC.CPF = NF.CPF;

INSERT INTO TABELA_DE_CLIENTES
(CPF, NOME, ENDERECO_1, ENDERECO_2, BAIRRO,
CIDADE, ESTADO, CEP, DATA_DE_NASCIMENTO, IDADE,
GENERO,LIMITE_DE_CREDITO, VOLUME_DE_COMPRA, PRIMEIRA_COMPRA)
VALUES('08342484506', 'Andre Lopes Neres', 'R. Salvador Ferreira', '', 'Centro',
'Maring�', 'PR', '17850000', '1999-10-04', 23, 'M', 180000, 24500, 0);

--AULA 4 / 7- PRATICANDO OUTROS TIPOS DE JOIN'S
SELECT COUNT(1) FROM TABELA_DE_CLIENTES; --16
SELECT COUNT(1) FROM TABELA_DE_VENDEDORES; --4

SELECT DISTINCT
TV.NOME AS NOME_DO_VENDEDOR
,TV.BAIRRO AS BAIRRO_DO_VENDEDOR
,TC.BAIRRO AS BAIRRO_DO_CLIENTE
,TC.NOME AS NOME_DO_CLIENTE
FROM TABELA_DE_CLIENTES TC
INNER JOIN TABELA_DE_VENDEDORES TV
ON TC.BAIRRO = TV.BAIRRO;

--VENDEDORES QUE N�O TEM CLIENTES EM SEUS BAIRROS
SELECT DISTINCT
TV.NOME AS NOME_DO_VENDEDOR
,TV.BAIRRO AS BAIRRO_DO_VENDEDOR
FROM TABELA_DE_CLIENTES TC
RIGHT JOIN TABELA_DE_VENDEDORES TV
ON TC.BAIRRO = TV.BAIRRO
WHERE TC.NOME IS NULL;

--CLIENTES QUE N�O TEM VENDEDORES EM SEUS BAIRROS
SELECT DISTINCT
TC.NOME AS NOME_DO_CLIENTE
,TC.BAIRRO AS BAIRRO_DO_CLIENTE
FROM TABELA_DE_CLIENTES TC
LEFT JOIN TABELA_DE_VENDEDORES TV
ON TC.BAIRRO = TV.BAIRRO
WHERE TV.NOME IS NULL;

--SELE��O DE CLIENTES E VENDEDORES QUE N�O TEM CLIENTES OU VENDEDORES EM SEUS BAIRROS 
-- COM O FULL JOIN A GENTE TEM UMA MACRO JUN��O DE TODOS OS CAMPOS E ASSIM TEMOS NOSSA SELE��O POR COMPLETA
SELECT DISTINCT
TV.NOME AS NOME_DO_VENDEDOR
,TV.BAIRRO AS BAIRRO_DO_VENDEDOR
,TC.BAIRRO AS BAIRRO_DO_CLIENTE
,TC.NOME AS NOME_DO_CLIENTE
FROM TABELA_DE_CLIENTES TC
FULL JOIN TABELA_DE_VENDEDORES TV
ON TC.BAIRRO = TV.BAIRRO
WHERE TC.NOME IS NULL OR TV.NOME IS NULL;

--AULA 4 / 8 - UNINDO CONSULTAS
SELECT DISTINCT BAIRRO FROM TABELA_DE_CLIENTES; --> 12 BAIRROS RELACIONADOS A CLIENTES
SELECT DISTINCT BAIRRO FROM TABELA_DE_VENDEDORES; --> 4 BAIRROS RELACIONADOS A VENDEDORES
SELECT DISTINCT BAIRRO FROM TABELA_DE_CLIENTES
UNION  
SELECT DISTINCT BAIRRO FROM TABELA_DE_VENDEDORES; --> 13 BAIRROS PORQUE O UNION TEM O DISTINCT DENTRO E N�O MOSTRA OS RESULTADOS REPETIDOS
SELECT DISTINCT BAIRRO FROM TABELA_DE_CLIENTES
UNION ALL
SELECT DISTINCT BAIRRO FROM TABELA_DE_VENDEDORES; --> 16 BAIRROS PORQUE O UNION ALL TR�S TODOS OS RESULTADOS
SELECT DISTINCT BAIRRO, 'CLIENTE' FROM TABELA_DE_CLIENTES
UNION ALL
SELECT DISTINCT BAIRRO, 'VENDEDOR' FROM TABELA_DE_VENDEDORES;

--AULA 4 / 11 - Subconsultas no comando IN (Sub query)
SELECT DISTINCT BAIRRO FROM TABELA_DE_VENDEDORES;

SELECT * FROM TABELA_DE_CLIENTES
WHERE BAIRRO IN (SELECT DISTINCT BAIRRO FROM TABELA_DE_VENDEDORES);
--consulta abaixo que foi resposta de um exerc�cio anterior.
--Ela nos d� os produtos cuja soma das vendas s�o maiores que 394000.
--Liste os sabores destes produtos que s�o selecionados nesta consulta.
SELECT DISTINCT SABOR FROM TABELA_DE_PRODUTOS
WHERE  CODIGO_DO_PRODUTO IN 
( 
	SELECT INF.CODIGO_DO_PRODUTO
	FROM ITENS_NOTAS_FISCAIS INF
	INNER JOIN TABELA_DE_PRODUTOS TP 
	ON INF.CODIGO_DO_PRODUTO = TP.CODIGO_DO_PRODUTO
	GROUP BY INF.CODIGO_DO_PRODUTO, TP.NOME_DO_PRODUTO HAVING SUM(INF.QUANTIDADE) > 394000 
);

--AULA 4 / 13 - Subconsultas substituindo o HAVING
--CONSULTA USANDO HAVING
SELECT EMBALAGEM, AVG(PRECO_DE_LISTA) AS PRECO_MEDIO
FROM TABELA_DE_PRODUTOS
GROUP BY EMBALAGEM
HAVING AVG(PRECO_DE_LISTA) <= 10;
--CONSULTA USANDO SUBQUERY
SELECT MEDIA_EMBALAGENS.EMBALAGEM, MEDIA_EMBALAGENS.PRECO_MEDIO
FROM (
	SELECT EMBALAGEM, AVG(PRECO_DE_LISTA) AS PRECO_MEDIO
	FROM TABELA_DE_PRODUTOS
	GROUP BY EMBALAGEM) MEDIA_EMBALAGENS
WHERE MEDIA_EMBALAGENS.PRECO_MEDIO <= 10;

--CONSULTA DAS AULAS ANTERIORES USANDO SUB QUERY'S
SELECT DISTINCT PROD.CODIGO_DO_PRODUTO, PROD.NOME_DO_PRODUTO, PROD.QUANTIDADE
FROM(
	SELECT INF.CODIGO_DO_PRODUTO, TP.NOME_DO_PRODUTO, SUM(INF.QUANTIDADE) AS QUANTIDADE 
	FROM ITENS_NOTAS_FISCAIS INF
	INNER JOIN TABELA_DE_PRODUTOS TP 
	ON INF.CODIGO_DO_PRODUTO = TP.CODIGO_DO_PRODUTO
	GROUP BY INF.CODIGO_DO_PRODUTO, TP.NOME_DO_PRODUTO) PROD
WHERE QUANTIDADE > 394000
ORDER BY PROD.QUANTIDADE DESC;

--AULA 4 / 15 - VIEWS
--CRIA��O DE UMA VIS�O
CREATE VIEW MEDIA_EMBALAGENS AS
SELECT EMBALAGEM, AVG(PRECO_DE_LISTA) AS PRECO_MEDIO
FROM TABELA_DE_PRODUTOS
GROUP BY EMBALAGEM

SELECT * FROM MEDIA_EMBALAGENS
--MESMA CONSULTA ACIMA USANDO VIS�O
SELECT MEDIA_EMBALAGENS.EMBALAGEM, MEDIA_EMBALAGENS.PRECO_MEDIO
FROM  MEDIA_EMBALAGENS
WHERE MEDIA_EMBALAGENS.PRECO_MEDIO <= 10;

--EXERCICIO
CREATE VIEW QUANTIDADE_TOTAL AS
SELECT INF.CODIGO_DO_PRODUTO, TP.NOME_DO_PRODUTO, SUM(INF.QUANTIDADE) AS QUANTIDADE
FROM ITENS_NOTAS_FISCAIS  INF
INNER JOIN TABELA_DE_PRODUTOS TP 
ON INF.CODIGO_DO_PRODUTO = TP.CODIGO_DO_PRODUTO
GROUP BY INF.CODIGO_DO_PRODUTO, TP.NOME_DO_PRODUTO;

SELECT * FROM QUANTIDADE_TOTAL 
WHERE QUANTIDADE > 394000
ORDER BY QUANTIDADE DESC;

--===============================================================================================
--FUN�OES
--AULA 05 / 1 
SELECT NOME, LOWER(NOME) AS NOME_MINUSCULO FROM TABELA_DE_CLIENTES;
SELECT NOME, UPPER(NOME) AS NOME_MAIUSCULO FROM TABELA_DE_CLIENTES;
SELECT NOME, CONCAT(ENDERECO_1, ', ', BAIRRO, ', ', CIDADE, ', ',ESTADO, ' - ',CEP) FROM TABELA_DE_CLIENTES;
SELECT NOME, ENDERECO_1 + ', ' + BAIRRO + ', ' + CIDADE + ', ' + ESTADO + ' - ' + CEP FROM TABELA_DE_CLIENTES;
SELECT NOME_DO_PRODUTO, UPPER(LEFT(NOME_DO_PRODUTO, 3)) AS TRES_PRIMEIROS_CHAR FROM TABELA_DE_PRODUTOS;
SELECT TAMANHO, REPLACE(REPLACE(TAMANHO, 'Litros', 'L'), 'Litro', 'L' ) AS TAMANHO_MODIFICADO FROM TABELA_DE_PRODUTOS;

--Fa�a uma consulta que traga somente o primeiro nome de cada cliente.
SELECT LEFT(NOME , CHARINDEX(' ', NOME, 1))
FROM TABELA_DE_CLIENTES;

--AULA 05 / 05 Fun��es de datas
SELECT GETDATE() AS DATAATUAL,
DATEADD(DAY, 10, GETDATE()) AS DATA_DAQUI_A_DEZ_DIAS,
DATEADD(DAY, -48, GETDATE()) AS DATA_48_DIAS_ATRAS,
DATEDIFF(DAY, '2023-01-01', GETDATE())AS DIAS_DESDE_INICIO_ANO
SELECT DATEPART(DAY, GETDATE()) AS DIA_DE_HOJE
SELECT ISDATE(DATETIMEFROMPARTS(2020,02,29,00,00,00,00)); -- RETORNAR 1 � PORQUE EXISTE

--Como seria a consulta que retornasse o nome do cliente e sua 
--data de nascimento por extenso dia, dia da semana, m�s e ano?
SELECT 
	NOME, 
	DATENAME(DAY, DATA_DE_NASCIMENTO)+ ' - ' +
	DATENAME(WEEKDAY, DATA_DE_NASCIMENTO)+ ', ' +
	DATENAME(MONTH, DATA_DE_NASCIMENTO)+  ' - ' +
	DATENAME(YEAR, DATA_DE_NASCIMENTO) AS 'DATA POR EXTENSO'
FROM TABELA_DE_CLIENTES;

--AULA 05 / 06 Fun��es num�ricas
SELECT ROUND (3.433, 2);
SELECT CEILING (3.433); -- MAIOR INTEIRO DEPOIS DO INTEIRO DO NUMERO
SELECT FLOOR (3.433); -- O PROPRIO NUMERO INTEIRO DO NUMERO
SELECT POWER (12, 2);
SELECT EXP (3);
SELECT SQRT(81);
SELECT ABS(-153);

--Calcule o valor do imposto pago no ano de 2016, arredondando para o menor inteiro.
SELECT YEAR(DATA_VENDA) AS ANO, FLOOR(SUM(IMPOSTO * (QUANTIDADE * PRECO))) AS 'IMPOSTO DO ANO'
FROM NOTAS_FISCAIS NF 
INNER JOIN ITENS_NOTAS_FISCAIS INF
ON NF.NUMERO = INF.NUMERO
WHERE YEAR( DATA_VENDA) = 2016 
GROUP BY YEAR( DATA_VENDA);

--AULA 05 / 10 - Fun��es de convers�o
SELECT CONVERT (VARCHAR(10), GETDATE(), 121);
SELECT CONVERT (VARCHAR(23), GETDATE(), 121);
SELECT DATA_DE_NASCIMENTO, CONVERT(varchar(25), DATA_DE_NASCIMENTO, 106)
FROM TABELA_DE_CLIENTES;
SELECT NOME_DO_PRODUTO, CONCAT('O pre�o de lista �: ', PRECO_DE_LISTA)
FROM TABELA_DE_PRODUTOS;
SELECT NOME_DO_PRODUTO, CONCAT('O pre�o de lista �: ', CAST(PRECO_DE_LISTA AS VARCHAR(10))) AS PRECO
FROM TABELA_DE_PRODUTOS;
SELECT * FROM TABELA_DE_CLIENTES
WHERE NOME =  'Andre Lopes Neres'

--Queremos construir um SQL cujo resultado seja para cada cliente:
--"O cliente Jo�o da Silva comprou R$ 121222,12 no ano de 2016".
SELECT 'O cliente ' + TC.NOME + ' comprou R$ ' + 
TRIM(STR(SUM(INF.QUANTIDADE * INF.PRECO) ,10,2)) + ' no ano de ' + DATENAME(YEAR, NF.DATA_VENDA)
FROM NOTAS_FISCAIS NF
INNER JOIN ITENS_NOTAS_FISCAIS INF ON NF.NUMERO = INF.NUMERO
INNER JOIN TABELA_DE_CLIENTES TC ON NF.CPF = TC.CPF
WHERE YEAR(NF.DATA_VENDA) = '2016'
GROUP BY TC.NOME, NF.DATA_VENDA;

--=======================================================================================
--AULA 06 / 01 - VENDAS V�LIDAS
--QUERY PARA VERIFICAR QUAIS FORAM AS VENDAS V�LIDAS E INV�LIDAS NO MES DE JANEIRO DE 2015 
SELECT 
TC.CPF, TC.NOME, TC.VOLUME_DE_COMPRA, TV.MES_ANO, TV.QUANTIDADE_TOTAL, 
ROUND (((1 - (TC.VOLUME_DE_COMPRA / TV.QUANTIDADE_TOTAL)) * 100), 2) AS DIFERENCA,
(CASE WHEN TC.VOLUME_DE_COMPRA  >= TV.QUANTIDADE_TOTAL THEN 'VENDAS V�LIDAS'
	  ELSE 'VENDAS INV�LIDAS' END) AS RESULTADO
FROM TABELA_DE_CLIENTES TC
INNER JOIN(
	SELECT NF.CPF, CONVERT(VARCHAR(7), NF.DATA_VENDA,  120) AS MES_ANO, SUM(INF.QUANTIDADE) AS QUANTIDADE_TOTAL
	FROM NOTAS_FISCAIS NF
	INNER JOIN ITENS_NOTAS_FISCAIS INF
	ON NF.NUMERO = INF.NUMERO
	GROUP BY NF.CPF, CONVERT(VARCHAR(7), NF.DATA_VENDA,  120)
) TV
ON TC.CPF = TV.CPF
WHERE TV.MES_ANO = '2015-01' AND (TC.VOLUME_DE_COMPRA - TV.QUANTIDADE_TOTAL) < 0
ORDER BY TC.VOLUME_DE_COMPRA 

--TOTAL DE VENDAS POR TIPO DO PRODUTO DURANTE O ANO DE 2015
SELECT TP.SABOR, YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS QUANTIDADE_TOTAL
FROM TABELA_DE_PRODUTOS TP
INNER JOIN ITENS_NOTAS_FISCAIS INF
ON TP.CODIGO_DO_PRODUTO = INF.CODIGO_DO_PRODUTO
INNER JOIN NOTAS_FISCAIS NF
ON NF.NUMERO = INF.NUMERO
WHERE YEAR(NF.DATA_VENDA) = '2015'
GROUP BY TP.SABOR, YEAR(NF.DATA_VENDA) 
ORDER BY QUANTIDADE_TOTAL DESC

--TOTAL DE VENDAS NO ANO DE 2015
SELECT YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS VENDA_TOTAL_ANO
FROM NOTAS_FISCAIS NF
INNER JOIN ITENS_NOTAS_FISCAIS INF
ON NF.NUMERO = INF.NUMERO
WHERE YEAR(NF.DATA_VENDA) = '2015'
GROUP BY YEAR(NF.DATA_VENDA)

--TOTAL DE VENDAS POR SABOR MOSTRANDO O PERCENTUAL QUE CADA SABOR CORRESPONDE � VENDA NO ANO DE 2015
SELECT VS.SABOR, VS.ANO, VS.VENDA_ANO, 
ROUND(((CONVERT(FLOAT, VS.VENDA_ANO) / CONVERT(FLOAT, VA.VENDA_TOTAL_ANO))* 100), 2) AS TOTAL
FROM(
	SELECT TP.SABOR, YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS VENDA_ANO
	FROM TABELA_DE_PRODUTOS TP
	INNER JOIN ITENS_NOTAS_FISCAIS INF
	ON TP.CODIGO_DO_PRODUTO = INF.CODIGO_DO_PRODUTO
	INNER JOIN NOTAS_FISCAIS NF
	ON NF.NUMERO = INF.NUMERO
	WHERE YEAR(NF.DATA_VENDA) = '2015'
	GROUP BY TP.SABOR, YEAR(NF.DATA_VENDA) 
) VS -- VENDA SABOR
INNER JOIN(
	SELECT YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS VENDA_TOTAL_ANO
	FROM NOTAS_FISCAIS NF
	INNER JOIN ITENS_NOTAS_FISCAIS INF
	ON NF.NUMERO = INF.NUMERO
	WHERE YEAR(NF.DATA_VENDA) = '2015'
	GROUP BY YEAR(NF.DATA_VENDA)
) VA -- VENDA DO ANO
ON VS.ANO = VA.ANO
ORDER BY VS.VENDA_ANO DESC 

--TOTAL DE VENDAS POR TAMANHO MOSTRANDO O PERCENTUAL QUE CADA TAMANHO CORRESPONDE � VENDA NO ANO DE 2016 
SELECT VS.TAMANHO, VS.ANO, VS.VENDA_ANO, 
ROUND(((CONVERT(FLOAT, VS.VENDA_ANO) / CONVERT(FLOAT, VA.VENDA_TOTAL_ANO))* 100), 2) AS TOTAL
FROM(
	SELECT TP.TAMANHO, YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS VENDA_ANO
	FROM TABELA_DE_PRODUTOS TP
	INNER JOIN ITENS_NOTAS_FISCAIS INF
	ON TP.CODIGO_DO_PRODUTO = INF.CODIGO_DO_PRODUTO
	INNER JOIN NOTAS_FISCAIS NF
	ON NF.NUMERO = INF.NUMERO
	WHERE YEAR(NF.DATA_VENDA) = '2016'
	GROUP BY TP.TAMANHO, YEAR(NF.DATA_VENDA) 
) VS -- VENDA SABOR
INNER JOIN(
	SELECT YEAR(NF.DATA_VENDA) AS ANO, SUM(INF.QUANTIDADE) AS VENDA_TOTAL_ANO
	FROM NOTAS_FISCAIS NF
	INNER JOIN ITENS_NOTAS_FISCAIS INF
	ON NF.NUMERO = INF.NUMERO
	WHERE YEAR(NF.DATA_VENDA) = '2016'
	GROUP BY YEAR(NF.DATA_VENDA)
) VA -- VENDA DO ANO
ON VS.ANO = VA.ANO
ORDER BY VS.VENDA_ANO DESC 
