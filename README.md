## GFT -  Pipeline de Dados para Case Técnico

### 1) Objetivo do Projeto

Este projeto tem como objetivo construir um pipeline de dados para processar, limpar e modelar a base de beneficiários da Agência Nacional de Saúde Suplementar (ANS). O foco principal é transformar dados brutos em um formato otimizado para consultas analíticas e responder a perguntas de negócio com a melhor performance.

Link do Dataset:  https://dadosabertos.ans.gov.br/FTP/PDA/informacoes_consolidadas_de_beneficiarios-024/202508/

### 2) Arquitetura e Pipeline de Dados

O pipeline foi desenhado utilizando a Arquitetura Medallion em um ambiente de Data Lakehouse na AWS, utilizando o Amazon S3 para armazenamento e o Amazon Athena como motor de processamento distribuído.

O fluxo dos dados é dividido em três camadas:

- Camada Raw (Bronze): Dados brutos.
    - Ingestão do arquivo original em formato CSV, sem alterações estruturais.
    - Todos os campos foram carregados inicialmente como string, garantindo flexibilidade no tratamento posterior.
- Camada Refined (Silver): Limpeza e padronização.
    - Conversão de tipos de dados (datas, inteiros e textos).
    - Tratamento da coluna de competência (formato YYYY-MM), convertendo para o tipo date com adoção do primeiro dia do mês como padrão.
    - Conversão do formato de armazenamento para Parquet, com compressão Snappy, visando melhor performance e redução de custo em consultas.
- Camada Curated (Gold): Camada voltada para consumo analítico, onde os dados são organizados em um modelo otimizado para consultas.
    - Foi adotado um modelo dimensional (Star Schema), separando métricas quantitativas de atributos descritivos, reduzindo redundância e melhorando a performance.

### 3) Modelagem Dimensional (Star Schema)

Para a camada Curated, optou-se por um modelo Star Schema, com uma tabela fato central e tabelas dimensão auxiliares. preparando a base para consumo em ferramentas de Business Intelligence.

- Fato (fato_beneficiarios): Contém as métricas de beneficiários (ativos, aderidos, cancelados) e as chaves estrangeiras.
    - id_cmpt_movel (Chave de Tempo e FK dim_calendario)
    - dt_carga (Controle de Carga)
    - cd_operadora (FK - dim_operadora)
    - cd_municipio (FK - dim_localizacao)
    - cd_plano (FK - dim_plano)
    - id_perfil (FK - dim_perfil)
    - qt_beneficiario_ativo (Métrica)
    - qt_beneficiario_aderido (Métrica)
    - qt_beneficiario_cancelado (Métrica)

- Dimensões:

  - dim_operadora: Dados cadastrais das empresas de saúde.
      - cd_operadora (PK)
      - nm_razao_social
      - nr_cnpj
      - modalidade_operadora
  
  - dim_localizacao: Localização (Município e UF).
      - cd_municipio (PK)
      - nm_municipio
      - sg_uf
        
  - dim_plano: Características contratuais do plano de saúde.
      - cd_plano (PK)
      - tp_vigencia_plano
      - de_contratacao_plano
      - de_segmentacao_plano
      - de_abrg_geografica_plano
      - cobertura_assist_plan
    
  - dim_perfil: Agrupa características demográficas (sexo, faixa etária, tipo de vínculo). Uma chave primária baseada em hash MD5 foi implementada para garantir a unicidade e integridade referencial com a tabela fato.
      - id_perfil (PK)
      - tp_sexo
      - de_faixa_etaria
      - de_faixa_etaria_reaj
      - tipo_vinculo
 
  - dim_tempo: Permite análises temporais.
    - id_cmpt_movel (PK)
    - ano
    - mes
    - trimestre
   
### 4) Perguntas Analíticas

A estrutura construída permite responder eficientemente perguntas de negócio como:

  a) Quais são as operadoras com o maior número de beneficiarios ativos?
  
  b) Qual é a faixa etária com mais beneficiários e quantos são?
  
  c) A quantidade de beneficiários por município.  


### 5) Estrutura de pastas do repositório

A lógica de transformação está versionada na pasta codigos/, enumerada na ordem exata de execução do pipeline:
- 01_raw.sql: Criação dos bancos de dados e mapeamento da tabela externa bruta.
- 02_refined.sql: Tratamento de tipos e conversão para Parquet.
- 02_curated.sql: Criação das tabelas fato e dimensão.
- 04_business_queries.sql: Consultas analíticas finais.
  
Os resultados brutos em CSV estão disponíveis na pasta resultados/:
- query_a_top_operadoras.csv
- query_b_faixa_etaria.csv
- query_c_municipios.csv
