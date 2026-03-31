-- ETAPA1: Criação dos bancos para cada camada
CREATE database ans_data_raw;
CREATE database ans_data_refined;
CREATE database ans_data_curated;

-- ETAPA 2: Criação da tabela crua na camada bronze
CREATE EXTERNAL TABLE ans_data_raw.beneficiarios (
    ID_CMPT_MOVEL string,
    CD_OPERADORA string,
    NM_RAZAO_SOCIAL string,
    NR_CNPJ string,
    MODALIDADE_OPERADORA string,
    SG_UF string,
    CD_MUNICIPIO string,
    NM_MUNICIPIO string,
    TP_SEXO string,
    DE_FAIXA_ETARIA string,
    DE_FAIXA_ETARIA_REAJ string,
    CD_PLANO string,
    TP_VIGENCIA_PLANO string,
    DE_CONTRATACAO_PLANO string,
    DE_SEGMENTACAO_PLANO string,
    DE_ABRG_GEOGRAFICA_PLANO string,
    COBERTURA_ASSIST_PLAN string,
    TIPO_VINCULO string,
    QT_BENEFICIARIO_ATIVO string,
    QT_BENEFICIARIO_ADERIDO string,
    QT_BENEFICIARIO_CANCELADO string,
    DT_CARGA string
)
ROW FORMAT SERDE 'org.apache.hadoop.hive.serde2.OpenCSVSerde'
WITH SERDEPROPERTIES (
    "separatorChar" = ";"
)
LOCATION 's3://gft-case-ans-data/raw-layer/'
TBLPROPERTIES (
    'skip.header.line.count'='1'
);