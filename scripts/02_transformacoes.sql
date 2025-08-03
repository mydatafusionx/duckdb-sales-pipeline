-- Script 02: Transformações de Dados
-- Criação de tabelas e views para análise

-- 1. Criação de view com dados de vendas detalhados
CREATE OR REPLACE VIEW vendas_detalhadas AS
SELECT 
    v.id_venda,
    v.data_venda,
    EXTRACT(YEAR FROM v.data_venda) as ano,
    EXTRACT(MONTH FROM v.data_venda) as mes,
    c.id_cliente,
    c.nome as nome_cliente,
    c.estado,
    c.cidade,
    p.id_produto,
    p.nome as nome_produto,
    p.categoria,
    v.quantidade,
    v.valor_total,
    v.forma_pagamento,
    p.preco as preco_unitario,
    p.custo as custo_unitario,
    (v.valor_total - (p.custo * v.quantidade)) as lucro_bruto,
    (v.valor_total - (p.custo * v.quantidade)) / v.valor_total as margem_bruta
FROM 
    vendas v
    JOIN clientes c ON v.id_cliente = c.id_cliente
    JOIN produtos p ON v.id_produto = p.id_produto;

-- 2. Métricas de Vendas por Mês/Ano
CREATE OR REPLACE VIEW metricas_vendas_mensais AS
SELECT 
    ano,
    mes,
    COUNT(DISTINCT id_venda) as total_vendas,
    COUNT(DISTINCT id_cliente) as clientes_unicos,
    SUM(quantidade) as itens_vendidos,
    ROUND(SUM(valor_total), 2) as receita_total,
    ROUND(SUM(lucro_bruto), 2) as lucro_bruto_total,
    ROUND(AVG(valor_total), 2) as ticket_medio,
    ROUND(SUM(lucro_bruto) / SUM(valor_total) * 100, 2) as margem_bruta_percentual
FROM 
    vendas_detalhadas
GROUP BY 
    ano, mes
ORDER BY 
    ano, mes;

-- 3. Ranking de Produtos
CREATE OR REPLACE VIEW ranking_produtos AS
SELECT 
    id_produto,
    nome_produto,
    categoria,
    COUNT(DISTINCT id_venda) as vezes_vendido,
    SUM(quantidade) as quantidade_vendida,
    ROUND(SUM(valor_total), 2) as receita_total,
    ROUND(SUM(lucro_bruto), 2) as lucro_bruto_total,
    ROUND(SUM(lucro_bruto) / SUM(valor_total) * 100, 2) as margem_bruta_media
FROM 
    vendas_detalhadas
GROUP BY 
    id_produto, nome_produto, categoria
ORDER BY 
    receita_total DESC;

-- 4. Análise de Clientes
CREATE OR REPLACE VIEW analise_clientes AS
SELECT 
    c.id_cliente,
    c.nome,
    c.estado,
    c.cidade,
    COUNT(DISTINCT v.id_venda) as total_compras,
    ROUND(SUM(v.valor_total), 2) as valor_total_gasto,
    ROUND(AVG(v.valor_total), 2) as ticket_medio,
    MIN(v.data_venda) as primeira_compra,
    MAX(v.data_venda) as ultima_compra,
    DATE_DIFF('day', MIN(v.data_venda), MAX(v.data_venda)) as dias_entre_primeira_ultima_compra
FROM 
    clientes c
    LEFT JOIN vendas v ON c.id_cliente = v.id_cliente
GROUP BY 
    c.id_cliente, c.nome, c.estado, c.cidade
ORDER BY 
    valor_total_gasto DESC;
