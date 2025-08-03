#!/usr/bin/env python3
"""
DuckDB Sales Pipeline

Este script executa o pipeline completo de análise de vendas:
1. Conecta ao banco de dados DuckDB
2. Executa os scripts SQL de ingestão, transformação e análise
3. Gera visualizações dos resultados
"""

import duckdb
import pandas as pd
import matplotlib.pyplot as plt
import os
from datetime import datetime

# Configuração
DB_PATH = 'vendas.duckdb'
DATA_DIR = 'data'
SCRIPTS_DIR = 'scripts'
OUTPUT_DIR = 'output'

# Criar diretório de saída se não existir
os.makedirs(OUTPUT_DIR, exist_ok=True)

def connect_db():
    """Conecta ao banco de dados DuckDB"""
    conn = duckdb.connect(DB_PATH)
    # Habilitar extensões úteis
    conn.execute("INSTALL 'httpfs'; LOAD 'httpfs';")
    conn.execute("INSTALL 'parquet'; LOAD 'parquet';")
    return conn

def run_sql_script(conn, script_path):
    """Executa um script SQL a partir de um arquivo"""
    try:
        with open(script_path, 'r') as f:
            sql_script = f.read()
        
        # Executa cada comando separadamente
        for statement in sql_script.split(';'):
            statement = statement.strip()
            if statement:
                conn.execute(statement)
        return True
    except Exception as e:
        print(f"Erro ao executar o script {script_path}: {str(e)}")
        return False

def generate_visualizations(conn):
    """Gera visualizações a partir dos dados processados"""
    # Usando um estilo disponível por padrão
    plt.style.use('ggplot')
    
    # 1. Vendas por Categoria
    df_cat = conn.execute("""
        SELECT categoria, SUM(valor_total) as receita_total 
        FROM vendas_detalhadas 
        GROUP BY categoria 
        ORDER BY receita_total DESC
    """).fetchdf()
    
    plt.figure(figsize=(10, 6))
    plt.bar(df_cat['categoria'], df_cat['receita_total'], color='skyblue')
    plt.title('Receita por Categoria de Produto')
    plt.xlabel('Categoria')
    plt.ylabel('Receita Total (R$)')
    plt.xticks(rotation=45, ha='right')
    plt.tight_layout()
    plt.savefig(f'{OUTPUT_DIR}/receita_por_categoria.png')
    plt.close()
    
    # 2. Vendas Mensais (2023 vs 2024)
    df_mensal = conn.execute("""
        SELECT 
            mes, 
            SUM(CASE WHEN ano = '2023' THEN valor_total ELSE 0 END) as receita_2023,
            SUM(CASE WHEN ano = '2024' THEN valor_total ELSE 0 END) as receita_2024
        FROM vendas_detalhadas
        GROUP BY mes
        ORDER BY mes
    """).fetchdf()
    
    plt.figure(figsize=(12, 6))
    plt.plot(df_mensal['mes'], df_mensal['receita_2023'], 'o-', label='2023')
    plt.plot(df_mensal['mes'], df_mensal['receita_2024'], 's-', label='2024')
    plt.title('Receita Mensal: 2023 vs 2024')
    plt.xlabel('Mês')
    plt.ylabel('Receita (R$)')
    plt.xticks(range(1, 13))
    plt.legend()
    plt.grid(True, linestyle='--', alpha=0.7)
    plt.tight_layout()
    plt.savefig(f'{OUTPUT_DIR}/receita_mensal_comparativo.png')
    plt.close()
    
    # 3. Top 5 Clientes
    df_clientes = conn.execute("""
        SELECT nome_cliente, SUM(valor_total) as valor_total_gasto
        FROM vendas_detalhadas
        GROUP BY nome_cliente
        ORDER BY valor_total_gasto DESC
        LIMIT 5
    """).fetchdf()
    
    plt.figure(figsize=(10, 6))
    plt.barh(df_clientes['nome_cliente'], df_clientes['valor_total_gasto'], color='lightgreen')
    plt.title('Top 5 Clientes por Valor Gasto')
    plt.xlabel('Valor Gasto (R$)')
    plt.tight_layout()
    plt.savefig(f'{OUTPUT_DIR}/top_clientes.png')
    plt.close()

def export_to_excel(conn):
    """Exporta os dados para arquivo Excel"""
    with pd.ExcelWriter(f'{OUTPUT_DIR}/relatorio_vendas.xlsx') as writer:
        # Dados de vendas detalhadas
        df_vendas = conn.execute("SELECT * FROM vendas_detalhadas").fetchdf()
        df_vendas.to_excel(writer, sheet_name='Vendas Detalhadas', index=False)
        
        # Métricas mensais
        df_metricas = conn.execute("SELECT * FROM metricas_vendas_mensais").fetchdf()
        df_metricas.to_excel(writer, sheet_name='Métricas Mensais', index=False)
        
        # Ranking de produtos
        df_produtos = conn.execute("SELECT * FROM ranking_produtos").fetchdf()
        df_produtos.to_excel(writer, sheet_name='Ranking Produtos', index=False)
        
        # Análise de clientes
        df_clientes = conn.execute("SELECT * FROM analise_clientes").fetchdf()
        df_clientes.to_excel(writer, sheet_name='Análise Clientes', index=False)

def main():
    print("Iniciando o pipeline de análise de vendas...")
    start_time = datetime.now()
    
    # Conectar ao banco de dados
    conn = connect_db()
    
    try:
        # Executar scripts SQL em ordem
        scripts = [
            os.path.join(SCRIPTS_DIR, '01_ingestao_duckdb.sql'),
            os.path.join(SCRIPTS_DIR, '02_transformacoes.sql'),
            os.path.join(SCRIPTS_DIR, '03_analises.sql')
        ]
        
        for script in scripts:
            print(f"Executando {script}...")
            if not run_sql_script(conn, script):
                print(f"Erro ao executar o script {script}. Abortando...")
                return
        
        # Gerar visualizações
        print("Gerando visualizações...")
        generate_visualizations(conn)
        
        # Exportar para Excel
        print("Exportando dados para Excel...")
        export_to_excel(conn)
        
        # Tempo de execução
        exec_time = (datetime.now() - start_time).total_seconds()
        print(f"\nPipeline concluído com sucesso em {exec_time:.2f} segundos!")
        print(f"Arquivos gerados no diretório: {os.path.abspath(OUTPUT_DIR)}")
        
    except Exception as e:
        print(f"Erro durante a execução do pipeline: {str(e)}")
    finally:
        conn.close()

if __name__ == "__main__":
    main()
