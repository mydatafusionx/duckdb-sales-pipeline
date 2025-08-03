import pandas as pd
import numpy as np
from datetime import datetime, timedelta
import random

# Configuração
np.random.seed(42)
random.seed(42)

# Dados de exemplo
clientes = list(range(1, 11))  # 10 clientes
produtos = list(range(1, 11))   # 10 produtos
formas_pagamento = ['crédito', 'débito', 'pix']

# Gerar dados de vendas para 2024 (até a data atual)
hoje = datetime.now()
inicio_2024 = datetime(2024, 1, 1)
dias = (hoje - inicio_2024).days

vendas = []
for i in range(1, 100):  # Gerar 100 vendas
    data_venda = inicio_2024 + timedelta(days=random.randint(0, dias-1))
    id_cliente = random.choice(clientes)
    id_produto = random.choice(produtos)
    quantidade = random.randint(1, 3)
    preco = round(random.uniform(100, 5000), 2)
    valor_total = round(preco * quantidade, 2)
    forma_pagamento = random.choice(formas_pagamento)
    
    vendas.append({
        'id_venda': i,
        'id_cliente': id_cliente,
        'id_produto': id_produto,
        'quantidade': quantidade,
        'valor_total': valor_total,
        'data_venda': data_venda.strftime('%Y-%m-%d'),
        'forma_pagamento': forma_pagamento
    })

# Criar DataFrame e salvar como Parquet
df = pd.DataFrame(vendas)
df.to_parquet('data/vendas_2024.parquet', index=False)

print(f"Arquivo 'data/vendas_2024.parquet' gerado com sucesso com {len(vendas)} registros.")
