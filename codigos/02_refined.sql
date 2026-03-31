-- ETAPA 3: Criação da tabela na camada silver
CREATE TABLE ans_data_refined.beneficiarios
WITH (
    format = 'PARQUET',
    external_location = 's3://gft-case-ans-data/refined-layer/',
    write_compression = 'SNAPPY'
) AS
SELECT
    -- Datas
    CAST(date_parse(concat(trim(id_cmpt_movel), '-01'), '%Y-%m-%d') AS date) AS id_cmpt_movel,
    CAST(date_parse(dt_carga, '%Y-%m-%d') AS date) AS dt_carga,

    -- Identificadores
    CAST(cd_operadora AS varchar) AS cd_operadora,
    CAST(nm_razao_social AS varchar) AS nm_razao_social,
    CAST(nr_cnpj AS varchar) AS nr_cnpj,
    CAST(modalidade_operadora AS varchar) AS modalidade_operadora,
    CAST(sg_uf AS varchar) AS sg_uf,
    CAST(cd_municipio AS varchar) AS cd_municipio,
    CAST(nm_municipio AS varchar) AS nm_municipio,
    CAST(tp_sexo AS varchar) AS tp_sexo,
    CAST(de_faixa_etaria AS varchar) AS de_faixa_etaria,
    CAST(de_faixa_etaria_reaj AS varchar) AS de_faixa_etaria_reaj,
    CAST(cd_plano AS varchar) AS cd_plano,
    CAST(tp_vigencia_plano AS varchar) AS tp_vigencia_plano,
    CAST(de_contratacao_plano AS varchar) AS de_contratacao_plano,
    CAST(de_segmentacao_plano AS varchar) AS de_segmentacao_plano,
    CAST(de_abrg_geografica_plano AS varchar) AS de_abrg_geografica_plano,
    CAST(cobertura_assist_plan AS varchar) AS cobertura_assist_plan,
    CAST(tipo_vinculo AS varchar) AS tipo_vinculo,

    -- Métricas
    CAST(qt_beneficiario_ativo AS integer) AS qt_beneficiario_ativo,
    CAST(qt_beneficiario_aderido AS integer) AS qt_beneficiario_aderido,
    CAST(qt_beneficiario_cancelado AS integer) AS qt_beneficiario_cancelado

FROM ans_data_raw.beneficiarios;