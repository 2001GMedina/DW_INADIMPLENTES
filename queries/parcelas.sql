SELECT
    CLIENTE_ID,
    COUNT(*) AS QTD_FATURAS_ABERTO
FROM
    (
        SELECT
            CLIENTE_ID
        FROM
            FATURAS_CARTAO_CREDITO
        WHERE
            STATUS_PROVIDER = 'pending'
        UNION
        ALL
        SELECT
            CLIENTE_ID
        FROM
            FATURAS_CARNE
        WHERE
            STATUS_PROVIDER = 'overdue'
    ) AS FATURAS_ABERTAS
GROUP BY
    CLIENTE_ID