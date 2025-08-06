WITH HIST AS (
    SELECT
        HS.CLIENTE_ID,
        HS.STATUS_ANTERIOR,
        HS.STATUS_ALTERADO,
        CASE
            WHEN HS.STATUS_ANTERIOR = 3
            AND HS.STATUS_ALTERADO = 33 THEN 'INADIMPLENCIA'
            ELSE 'REATIVACAO'
        END AS ALTERACAO,
        HS.DATA_ALTERACAO
    FROM
        HISTORICO_STATUS HS
    WHERE
        HS.STATUS_ALTERADO IN (3, 33)
        AND HS.STATUS_ANTERIOR IN (3, 33)
),
CLUSTERS AS (
    SELECT
        CLIENTE_ID,
        COUNT(*) AS QTD_REATIVACOES,
        CASE
            WHEN COUNT(*) <= 1 THEN 'OCASIONAL'
            WHEN COUNT(*) <= 2 THEN 'MEDIANO'
            ELSE 'OFENSOR'
        END AS CLUSTER_ATUAL
    FROM
        HIST
    WHERE
        ALTERACAO = 'REATIVACAO'
        AND DATA_ALTERACAO >= DATEADD(MONTH, -6, GETDATE())
    GROUP BY
        CLIENTE_ID
),
HIST_COM_CLUSTER AS (
    SELECT
        H.*,
        CASE
            WHEN H.ALTERACAO = 'INADIMPLENCIA'
            AND C.CLUSTER_ATUAL IS NULL THEN 'SEM REATIVACAO'
            ELSE C.CLUSTER_ATUAL
        END AS CLUSTER_ATUAL
    FROM
        HIST H
        LEFT JOIN (
            SELECT
                CLIENTE_ID,
                MAX(CLUSTER_ATUAL) AS CLUSTER_ATUAL
            FROM
                CLUSTERS
            GROUP BY
                CLIENTE_ID
        ) C ON H.CLIENTE_ID = C.CLIENTE_ID
),
HIST_INAD AS (
    SELECT
        C.ID,
        C.DATA_INICIO_PLANO,
        /*------------------------------------------------*/
        CASE
            WHEN DATEDIFF(
                DAY,
                C.DATA_INICIO_PLANO,
                CONVERT(DATE, GETDATE())
            ) < 2 THEN '1 Dia'
            WHEN DATEDIFF(
                DAY,
                C.DATA_INICIO_PLANO,
                CONVERT(DATE, GETDATE())
            ) <= 30 THEN CONCAT(
                DATEDIFF(
                    DAY,
                    C.DATA_INICIO_PLANO,
                    CONVERT(DATE, GETDATE())
                ),
                ' Dias'
            )
            ELSE CONCAT(
                ROUND(
                    DATEDIFF(
                        DAY,
                        C.DATA_INICIO_PLANO,
                        CONVERT(DATE, GETDATE())
                    ) / 30,
                    1
                ),
                ' Meses'
            )
        END AS TEMPO_DE_CASA,
        /*------------------------------------------------*/
        C.DATA_NASCIMENTO,
        C.IDADE,
        C.NOME,
        C.TELEFONE_FIXO,
        C.TELEFONE_3,
        C.TELEFONE_4,
        C.CPF,
        C.ENDERECO_ID,
        TRIM(REPLACE(E.CEP, '	', '')) AS CEP,
        C.STATUS_CLIENTE_ID,
        SC.NOME AS STATUS_CLIENTE,
        C.FORMA_PAGAMENTO_ID,
        FP.NOME AS FORMA_PAGAMENTO,
        C.PLANO_ID,
        P.NOME AS PLANO,
        C.TIPO_CONTRATO,
        C.GENERO,
        CASE
            WHEN C.FORMA_PAGAMENTO_ID = 14 THEN CASE
                WHEN C.VALOR_DESCONTO_CARNE = 0
                OR C.VALOR_DESCONTO_CARNE IS NULL THEN P.MENSALIDADE_CARNE
                ELSE C.VALOR_DESCONTO_CARNE
            END
            WHEN C.FORMA_PAGAMENTO_ID = 13 THEN CASE
                WHEN C.VALOR_DESCONTO_CARTAO_CREDITO = 0
                OR C.VALOR_DESCONTO_CARTAO_CREDITO IS NULL THEN P.MENSALIDADE_CARTAO_CREDITO
                ELSE C.VALOR_DESCONTO_CARTAO_CREDITO
            END
            ELSE NULL
        END AS DESCONTO_VALOR,
        I.DATA_ALTERACAO,
        I.STATUS_ANTERIOR,
        I.STATUS_ALTERADO,
        I.ALTERACAO,
        I.CLUSTER_ATUAL AS CLUSTER
    FROM
        CLIENTES C
        LEFT JOIN PLANOS P ON C.PLANO_ID = P.ID
        LEFT JOIN FORMAS_PAGAMENTO FP ON C.FORMA_PAGAMENTO_ID = FP.ID
        LEFT JOIN STATUS_CLIENTE SC ON C.STATUS_CLIENTE_ID = SC.ID
        LEFT JOIN ENDERECOS E ON C.ENDERECO_ID = E.ID
        LEFT JOIN HIST_COM_CLUSTER I ON C.ID = I.CLIENTE_ID
    WHERE
        C.STATUS_CLIENTE_ID = 33
        AND C.FORMA_PAGAMENTO_ID IN (13, 14)
        AND C.ID NOT IN ('111295', '111302', '111304')
)
SELECT
    *
FROM
    HIST_INAD
ORDER BY
    ID,
    DATA_ALTERACAO DESC;