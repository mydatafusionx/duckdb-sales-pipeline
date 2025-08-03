-- Script 03: Análises de Dados
-- Consultas analíticas para geração de relatórios

-- 1. Visão Geral das Vendas
SELECT 
    ano,
    COUNT(DISTINCT id_venda) as total_vendas,
    COUNT(DISTINCT id_cliente) as clientes_ativos,
    ROUND(SUM(valor_total), 2) as receita_total,
    ROUND(SUM(lucro_bruto), 2) as lucro_bruto,
    ROUND(SUM(lucro_bruto) / SUM(valor_total) * 100, 2) as margem_bruta_percentual,
    ROUND(SUM(valor_total) / COUNT(DISTINCT id_venda), 2) as ticket_medio
FROM 
    vendas_detalhadas
GROUP BY 
    ano
ORDER BY 
    ano;

-- 2. Vendas por Categoria de Produto
SELECT 
    categoria,
    COUNT(DISTINCT id_venda) as total_vendas,
    ROUND(SUM(valor_total), 2) as receita_total,
    ROUND(SUM(valor_total) / SUM(SUM(valor_total)) OVER () * 100, 2) as percentual_receita,
    ROUND(SUM(lucro_bruto), 2) as lucro_bruto,
    ROUND(AVG(margem_bruta) * 100, 2) as margem_bruta_media
FROM 
    vendas_detalhadas
GROUP BY 
    categoria
ORDER BY 
    receita_total DESC;

-- 3. Vendas por Estado
SELECT 
    estado,
    COUNT(DISTINCT id_venda) as total_vendas,
    ROUND(SUM(valor_total), 2) as receita_total,
    COUNT(DISTINCT id_cliente) as total_clientes,
    ROUND(SUM(valor_total) / COUNT(DISTINCT id_cliente), 2) as ticket_medio_por_cliente
FROM 
    vendas_detalhadas
GROUP BY 
    estado
ORDER BY 
    receita_total DESC;

-- 4. Análise de Forma de Pagamento
SELECT 
    forma_pagamento,
    COUNT(DISTINCT id_venda) as total_vendas,
    ROUND(SUM(valor_total), 2) as valor_total,
    ROUND(AVG(valor_total), 2) as ticket_medio,
    ROUND(COUNT(DISTINCT id_venda) * 100.0 / SUM(COUNT(DISTINCT id_venda)) OVER (), 2) as percentual_vendas
FROM 
    vendas_detalhadas
GROUP BY 
    forma_pagamento
ORDER BY 
    valor_total DESC;

-- 5. Análise de Sazonalidade Mensal
SELECT 
    mes,
    COUNT(DISTINCT CASE WHEN ano = '2023' THEN id_venda END) as vendas_2023,
    COUNT(DISTINCT CASE WHEN ano = '2024' THEN id_venda END) as vendas_2024,
    ROUND(SUM(CASE WHEN ano = '2023' THEN valor_total END), 2) as receita_2023,
    ROUND(SUM(CASE WHEN ano = '2024' THEN valor_total END), 2) as receita_2024
FROM 
    vendas_detalhadas
GROUP BY 
    mes
ORDER BY 
    mes;

-- 6. Top 5 Clientes por Valor Gasto
SELECT 
    id_cliente,
    nome_cliente,
    estado,
    COUNT(DISTINCT id_venda) as total_compras,
    ROUND(SUM(valor_total), 2) as valor_total_gasto,
    ROUND(AVG(valor_total), 2) as ticket_medio
FROM 
    vendas_detalhadas
GROUP BY 
    id_cliente, nome_cliente, estado
ORDER BY 
    valor_total_gasto DESC
LIMIT 5;

-- 7. Produtos mais Lucrativos
SELECT 
    id_produto,
    nome_produto,
    categoria,
    SUM(quantidade) as quantidade_vendida,
    ROUND(SUM(valor_total), 2) as receita_total,
    ROUND(SUM(lucro_bruto), 2) as lucro_bruto,
    ROUND(AVG(margem_bruta) * 100, 2) as margem_bruta_media
FROM 
    vendas_detalhadas
GROUP BY 
    id_produto, nome_produto, categoria
ORDER BY 
    lucro_bruto DESC
LIMIT 10;
