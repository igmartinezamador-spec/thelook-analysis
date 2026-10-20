-- Proyecto: <tu-proyecto> (BigQuery Sandbox). Fuente: bigquery-public-data.thelook_ecommerce
-- Ventana: 2025-10-01 a 2026-09-30 (12 meses completos; MAX(created_at) en datos = 2026-10-23, octubre-26 parcial, excluido).
-- Venta = linea de order_items con status <> 'Cancelled'. Devuelta = status = 'Returned'. Mes = mes de created_at de la linea.
-- 06 Recompra por cohortes mensuales. Cohorte = mes de primera compra no cancelada (historial completo), limitada a oct-25..sep-26.
-- k = meses desde la cohorte. Actividad en k = cliente de la cohorte con compra en el mes cohorte+k (NO acumulada).
-- Mismo tiempo de observacion: solo se emite (cohorte,k) si cohorte+k <= 2026-09-01; el agregado por k usa solo cohortes observables en k.
WITH act AS (SELECT DISTINCT user_id, DATE_TRUNC(DATE(created_at),MONTH) AS mth
             FROM `bigquery-public-data.thelook_ecommerce.order_items` WHERE status<>'Cancelled'),
f AS (SELECT user_id, MIN(mth) AS cohort FROM act GROUP BY user_id HAVING cohort BETWEEN '2025-10-01' AND '2026-09-01'),
sz AS (SELECT cohort, COUNT(*) AS cohort_size FROM f GROUP BY cohort),
r AS (SELECT f.cohort, DATE_DIFF(a.mth,f.cohort,MONTH) AS k, COUNT(DISTINCT a.user_id) AS active_users
      FROM f JOIN act a USING(user_id) WHERE a.mth<='2026-09-01' GROUP BY 1,2)
SELECT sz.cohort, sz.cohort_size, k, IFNULL(r.active_users,0) AS active_users
FROM sz CROSS JOIN UNNEST(GENERATE_ARRAY(0,11)) AS k
LEFT JOIN r ON r.cohort=sz.cohort AND r.k=k
WHERE DATE_ADD(sz.cohort,INTERVAL k MONTH)<='2026-09-01' ORDER BY sz.cohort, k;
