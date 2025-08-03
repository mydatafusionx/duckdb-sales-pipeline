# 🦆 DuckDB Sales Pipeline

Um pipeline completo para análise de dados de vendas utilizando DuckDB, SQL e Python.

## 📋 Visão Geral

Este projeto implementa um pipeline de dados completo para análise de vendas, desde a ingestão de dados brutos até a geração de relatórios e visualizações. O projeto utiliza DuckDB como banco de dados analítico, permitindo processamento rápido de grandes volumes de dados com baixa sobrecarga.

## 🚀 Funcionalidades

- **Ingestão de Dados**: Carrega dados de múltiplas fontes (CSV, Parquet) diretamente no DuckDB
- **Transformações SQL**: Processa e modela os dados para análise
- **Análises Avançadas**: Gera métricas e KPI's de vendas
- **Visualizações**: Cria gráficos automáticos para análise exploratória
- **Exportação**: Gera relatórios em Excel com os resultados

## 🛠️ Estrutura do Projeto

```
duckdb-sales-pipeline/
│
├── data/                    # Dados brutos
│   ├── clientes.csv         # Cadastro de clientes
│   ├── produtos.csv         # Catálogo de produtos
│   ├── vendas_2023.csv      # Vendas do ano de 2023
│   └── vendas_2024.parquet  # Vendas do ano de 2024 (Parquet)
│
├── scripts/                 # Scripts SQL
│   ├── 01_ingestao_duckdb.sql  # Carga inicial dos dados
│   ├── 02_transformacoes.sql   # Transformações e modelagem
│   └── 03_analises.sql         # Consultas analíticas
│
├── output/                  # Resultados e relatórios
│   ├── receita_por_categoria.png
│   ├── receita_mensal_comparativo.png
│   ├── top_clientes.png
│   └── relatorio_vendas.xlsx
│
├── pipeline.py              # Script principal do pipeline
├── generate_2024_data.py    # Gerador de dados de exemplo
└── README.md
```

## 🚀 Como Usar

1. **Pré-requisitos**
   - Python 3.8+
   - DuckDB
   - Bibliotecas Python: `duckdb`, `pandas`, `matplotlib`, `openpyxl`

2. **Instalação**
   ```bash
   # Clonar o repositório
   git clone https://github.com/seu-usuario/duckdb-sales-pipeline.git
   cd duckdb-sales-pipeline
   
   # Criar ambiente virtual (opcional, mas recomendado)
   python -m venv venv
   source venv/bin/activate  # No Windows: venv\Scripts\activate
   
   # Instalar dependências
   pip install -r requirements.txt
   ```

3. **Gerar Dados de Exemplo (opcional)**
   ```bash
   python generate_2024_data.py
   ```

4. **Executar o Pipeline**
   ```bash
   python pipeline.py
   ```

5. **Resultados**
   - Gráficos serão salvos em `output/`
   - Relatório consolidado em Excel: `output/relatorio_vendas.xlsx`

## 📊 Análises Disponíveis

O pipeline gera as seguintes análises:

1. **Visão Geral**
   - Total de vendas por ano
   - Receita total e ticket médio
   - Margem bruta

2. **Análise de Produtos**
   - Ranking de produtos por receita
   - Margem por categoria
   - Produtos mais vendidos

3. **Análise de Clientes**
   - Top clientes por valor gasto
   - Frequência de compras
   - Ticket médio por cliente

4. **Análise Temporal**
   - Vendas mensais (2023 vs 2024)
   - Sazonalidade
   - Comparativo entre anos

## 📝 Personalização

- **Novas Fontes de Dados**: Adicione novos arquivos CSV ou Parquet no diretório `data/`
- **Novas Análises**: Edite os scripts SQL em `scripts/`
- **Novos Gráficos**: Modifique a função `generate_visualizations()` em `pipeline.py`

## 📄 Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo [LICENSE](LICENSE) para detalhes.

## 🤝 Contribuição

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues e enviar pull requests.

---

Desenvolvido com ❤️ por [Seu Nome]