-- Script 01: Ingestão de Dados no DuckDB
-- Criação do banco de dados e tabelas

-- Criar ou conectar ao banco de dados DuckDB
CREATE OR REPLACE TABLE clientes AS 
SELECT * FROM read_csv_auto('data/clientes.csv');

CREATE OR REPLACE TABLE produtos AS 
SELECT * FROM read_csv_auto('data/produtos.csv');

-- Criar view para vendas de 2023 com conversão explícita de data
CREATE OR REPLACE VIEW vendas_2023 AS 
SELECT 
    id_venda,
    id_cliente,
    id_produto,
    quantidade,
    valor_total,
    CAST(data_venda AS DATE) as data_venda,
    forma_pagamento
FROM read_csv_auto('data/vendas_2023.csv');

-- Criar view para vendas de 2024 (parquet) com conversão explícita de data
CREATE OR REPLACE VIEW vendas_2024 AS 
SELECT 
    id_venda,
    id_cliente,
    id_produto,
    quantidade,
    valor_total,
    CAST(data_venda AS DATE) as data_venda,
    forma_pagamento
FROM read_parquet('data/vendas_2024.parquet');

-- Criar view unificada de vendas
CREATE OR REPLACE VIEW vendas AS
SELECT *, '2023' as ano FROM vendas_2023
UNION ALL
SELECT *, '2024' as ano FROM vendas_2024;

-- Verificar contagem de registros
SELECT 'Clientes' as tabela, COUNT(*) as total FROM clientes
UNION ALL
SELECT 'Produtos' as tabela, COUNT(*) as total FROM produtos
UNION ALL
SELECT 'Vendas 2023' as tabela, COUNT(*) as total FROM vendas_2023
UNION ALL
SELECT 'Vendas 2024' as tabela, COUNT(*) as total FROM vendas_2024;
