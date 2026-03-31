-- Dimensão Operadora
CREATE TABLE ans_data_curated.dim_operadora
WITH (
    format = 'PARQUET',
    external_location = 's3://gft-case-ans-data/curated-layer/dim_operadora/',
    write_compression = 'SNAPPY'
) AS
SELECT DISTINCT
      cd_operadora -- PK
    , nm_razao_social
    , nr_cnpj
    , modalidade_operadora
FROM ans_data_refined.beneficiarios;

-- Dimensão Localização
CREATE TABLE ans_data_curated.dim_localizacao
WITH (
    format = 'PARQUET',
    external_location = 's3://gft-case-ans-data/curated-layer/dim_localizacao/',
    write_compression = 'SNAPPY'
) AS
SELECT DISTINCT
      cd_municipio -- PK
    , nm_municipio
    , sg_uf
FROM ans_data_refined.beneficiarios;

-- Dimensão Plano
CREATE TABLE ans_data_curated.dim_plano
WITH (
    format = 'PARQUET',
    external_location = 's3://gft-case-ans-data/curated-layer/dim_plano/',
    write_compression = 'SNAPPY'
) AS
SELECT DISTINCT
      cd_plano -- PK
    , tp_vigencia_plano
    , de_contratacao_plano
    , de_segmentacao_plano
    , de_abrg_geografica_plano
    , cobertura_assist_plan
FROM ans_data_refined.beneficiarios;

-- Dimensão Calendario
CREATE TABLE ans_data_curated.dim_calendario
WITH (
    format = 'PARQUET',
    external_location = 's3://gft-case-ans-data/curated-layer/dim_calendario/',
    write_compression = 'SNAPPY'
) AS
SELECT DISTINCT
      id_cmpt_movel -- PK
    , year(id_cmpt_movel) AS ano
    , month(id_cmpt_movel) AS mes
    , quarter(id_cmpt_movel) AS trimestre
FROM ans_data_refined.beneficiarios;

--Dimensão Perfil dos Beneficiários
CREATE TABLE ans_data_curated.dim_perfil
WITH (
    format = 'PARQUET',
    external_location = 's3://gft-case-ans-data/curated-layer/dim_perfil/',
    write_compression = 'SNAPPY'
) AS
SELECT DISTINCT
    to_hex(
     md5(
      to_utf8(
        coalesce(tp_sexo, '') ||
        coalesce(de_faixa_etaria, '') ||
        coalesce(de_faixa_etaria_reaj, '') ||
        coalesce(tipo_vinculo, '')
    )
  )
) AS id_perfil -- PK
    , tp_sexo
    , de_faixa_etaria
    , de_faixa_etaria_reaj
    , tipo_vinculo
FROM ans_data_refined.beneficiarios;

-- Fato: Beneficiários
CREATE TABLE ans_data_curated.fato_beneficiarios
WITH (
    format = 'PARQUET',
    external_location = 's3://gft-case-ans-data/curated-layer/fato_beneficiarios/',
    write_compression = 'SNAPPY'
) AS
SELECT
      id_cmpt_movel -- FK
    , cd_operadora -- FK
    , cd_municipio -- FK
    , cd_plano -- FK
    , to_hex(
       md5(
        to_utf8(
            coalesce(tp_sexo, '') ||
            coalesce(de_faixa_etaria, '') ||
            coalesce(de_faixa_etaria_reaj, '') ||
            coalesce(tipo_vinculo, '')
        )
      )
    ) AS id_perfil -- FK
    , qt_beneficiario_ativo
    , qt_beneficiario_aderido
    , qt_beneficiario_cancelado
FROM ans_data_refined.beneficiarios;