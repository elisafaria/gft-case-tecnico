-- A) Quais são as 5 operadoras com o maior número de beneficiarios ativos?

SELECT
    op.nm_razao_social AS operadora
    , SUM(b.qt_beneficiario_ativo) AS total_beneficiarios
FROM ans_data_curated.fato_beneficiarios b
JOIN ans_data_curated.dim_operadora op 
    ON b.cd_operadora = op.cd_operadora
GROUP BY op.nm_razao_social
ORDER BY total_beneficiarios DESC
LIMIT 5;


-- B) Qual é a faixa etária com mais beneficiários e quantos são?

SELECT de_faixa_etaria, total_beneficiarios
FROM (
    SELECT
        p.de_faixa_etaria,
        SUM(b.qt_beneficiario_ativo) AS total_beneficiarios,
        RANK() OVER (ORDER BY SUM(b.qt_beneficiario_ativo) DESC) AS ranking
    FROM ans_data_curated.fato_beneficiarios b
    JOIN ans_data_curated.dim_perfil p ON p.id_perfil = b.id_perfil
    GROUP BY p.de_faixa_etaria
)
WHERE ranking = 1;


-- C) Liste, de forma decrescente, a quantidade de beneficiários por município.

SELECT 
      d.nm_municipio AS municipio
    , SUM(f.qt_beneficiario_ativo) AS total_beneficiarios
FROM ans_data_curated.fato_beneficiarios f
JOIN ans_data_curated.dim_localizacao d 
    ON f.cd_municipio = d.cd_municipio
GROUP BY d.nm_municipio
ORDER BY total_beneficiarios DESC;
