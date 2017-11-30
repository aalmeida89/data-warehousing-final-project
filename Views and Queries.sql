VIEWS:
CREATE MATERIALIZED VIEW [VW_qntDeProd] AS
SELECT 
	COUNT(1) AS NumProdutos
	, DP.cod_prod
	, DP.nome
FROM FATO_PRODUCAO AS FP
INNER JOIN DIMENSAO_PRODUTO AS DP 
	ON FP.cod_produto = DP.cod_produto
GROUP BY 
	DP.cod_prod
	, DP.nome;
CREATE UNIQUE INDEX UQVW_codProd_nome ON VW_qntDeProd (nome, cod_prod);



CREATE MATERIALIZED VIEW [VW_entidadeProdutor] AS
SELECT 
	DE.cod_entidade
	, DE.nome AS NomeEntidade
	, DP.cod_produtor
	, DP.nome AS NomeProdutor
FROM FATO_PRODUCAO AS FP
INNER JOIN DIMENSAO_PRODUTOR AS DP
	ON FP.cod_produtor = DP.cod_produtor
INNER JOIN DIMENSAO_ENTIDADE AS DE
	ON FP.cod_entidade = DE.cod_entidade
GROUP BY 
	 DE.cod_entidade
	 , DE.nome
	 , DP.cod_produtor
	 , DP.nome;
CREATE UNIQUE INDEX UQVW_codEntidade_codProdutor ON VW_entidadeProdutor (cod_entidade, cod_produtor);


CREATE MATERIALIZED VIEW [VW_ProdutoPorLugar] AS
SELECT 
	DP.nome
	, DL.pais
	, DL.uf
	, DL.cidade
	, COUNT(*) AS NumProdutos
FROM FATO_PRODUCAO AS FP
INNER JOIN DIMENSAO_PRODUTO AS DP
	ON FP.cod_produto = DP.cod_produto
INNER JOIN FP.DIMENSAO_LUGAR AS DL
	ON FP.cod_lugar = DL.cod_lugar
GROUP BY
	DP.nome
	, DL.pais
	, DL.uf
	, DL.cidade;
CREATE UNIQUE INDEX UQVW_nome_pais_uf_cidade ON VW_ProdutoPorLugar (nome, pais, uf, cidade);


CREATE MATERIALIZED VIEW [VW_ProdutorPorCidade] AS
SELECT 
	DP.nome
	, DL.pais
	, DL.uf
	, COUNT(*) AS produtoresPorUF
FROM FATO_PRODUCAO AS FP
INNER JOIN DIMENSAO_PRODUTOR AS DP
	ON FP.cod_produtor = DP.cod_produtor
INNER JOIN FP.DIMENSAO_LUGAR AS DL
	ON FP.cod_lugar = DL.cod_lugar
GROUP BY
	DP.nome
	, DL.pais
	, DL.uf
CREATE UNIQUE INDEX UQVW_nome_pais_uf_cidade ON VW_ProdutorPorCidade (nome, pais, uf, cidade);


CREATE MATERIALIZED VIEW [VW_QntEscopo] AS
SELECT 
	  DP.cod_produto
	, DP.nome
	, COUNT(*) AS QntEscopo
FROM FATO_PRODUCAO AS FP
INNER JOIN DIMENSAO_PRODUTO AS DP
	ON FP.cod_produto = DP.cod_produto
GROUP BY
	  DP.cod_produto
	, DP.nome
CREATE UNIQUE INDEX UQVW_categoria_pais_uf_cidade ON VW_QntEscopo (cod_produto, nome);


-- QUERIES
• Qual produto organico mais produzido pelo produtores
SELECT TOP 10
	NumProdutos
	, cod_prod
	, nome
FROM VW_qntDeProd
ORDER BY 
	NumProdutos DESC

• Qual entidade mais tem produtores
SELECT TOP 20
	  NomeEntidade
	, COUNT(*) AS NumProdutores
FROM VW_entidadeProdutor
GROUP BY
	  NomeEntidade
ORDER BY
	NumProdutores DESC

• Quantos produtores tem mais de uma entidade
SELECT TOP 20
	  NomeProdutor
	, COUNT(*) AS NumEntidades
FROM VW_entidadeProdutor
GROUP BY
	  NomeProdutor
HAVING 
	COUNT(*) > 1
ORDER BY
	NumEntidades DESC
	
• Qual e a atividade mais comum entre produtores orgánicos em um determinado estado
SELECT TOP 20
	  nome
	, pais
	, uf
	, cidade
	, NumProdutos
FROM VW_ProdutoPorLugar
--WHERE <pais/UF/cidade> = ?
ORDER BY 
	NumProdutos DESC

• Qual estado tem mais produtores
SELECT 
	  nome
	, pais
	, uf
	, produtoresPorUF
FROM VW_ProdutorPorCidade
order by produtoresPorUF


• Qual o escopo e mais utilizado
SELECT TOP 10
      cod_produto
	, nome
	, QntEscopo
FROM VW_QntEscopo
ORDER BY 
	QntEscopo DESC




