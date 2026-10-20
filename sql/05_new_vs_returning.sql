-- Proyecto: <tu-proyecto> (BigQuery Sandbox). Fuente: bigquery-public-data.thelook_ecommerce
-- Ventana: 2025-10-01 a 2026-09-30 (12 meses completos; MAX(created_at) en datos = 2026-10-23, octubre-26 parcial, excluido).
-- Venta = linea de order_items con status <> 'Cancelled'. Devuelta = status = 'Returned'. Mes = mes de created_at de la linea.
-- 05 Clientes nuevos vs recurrentes por mes. Primera compra calculada sobre TODO el historial (2019+), no solo la ventana.
-- Nuevo en M: su primera compra no cancelada cae en M. Recurrente: compro en M y su primera compra fue en un mes anterior.
-- pct_recurrentes = recurrentes / clientes activos del mes (activos = compradores distintos).
WITH act AS (SELECT DISTINCT user_id, DATE_TRUNC(DATE(created_at),MONTH) AS mth
             FROM `bigquery-public-data.thelook_ecommerce.order_items` WHERE status<>'Cancelled'),
f AS (SELECT user_id, MIN(mth) AS first_m FROM act GROUP BY user_id)
SELECT a.mth, COUNTIF(f.first_m=a.mth) AS new_c, COUNTIF(f.first_m<a.mth) AS ret_c, COUNT(*) AS active,
       ROUND(SAFE_DIVIDE(COUNTIF(f.first_m<a.mth),COUNT(*)),4) AS ret_share
FROM act a JOIN f USING(user_id)
WHERE a.mth BETWEEN '2025-10-01' AND '2026-09-01' GROUP BY a.mth ORDER BY a.mth;
