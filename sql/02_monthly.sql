-- Proyecto: <tu-proyecto> (BigQuery Sandbox). Fuente: bigquery-public-data.thelook_ecommerce
-- Ventana: 2025-10-01 a 2026-09-30 (12 meses completos; MAX(created_at) en datos = 2026-10-23, octubre-26 parcial, excluido).
-- Venta = linea de order_items con status <> 'Cancelled'. Devuelta = status = 'Returned'. Mes = mes de created_at de la linea.
-- 02 Evolucion mensual. Grano: 1 fila = 1 linea (order_items.id). Calendario generado => meses sin actividad salen con 0.
-- Ticket medio bruto = ventas brutas / pedidos distintos no cancelados (SAFE_DIVIDE evita division por cero).
WITH months AS (SELECT m FROM UNNEST(GENERATE_DATE_ARRAY('2025-10-01','2026-09-01',INTERVAL 1 MONTH)) m),
agg AS (
  SELECT DATE_TRUNC(DATE(created_at),MONTH) AS mth,
         ROUND(SUM(sale_price),2) AS gross,
         ROUND(SUM(IF(status='Returned',sale_price,0)),2) AS ret,
         COUNT(DISTINCT order_id) AS orders, COUNT(*) AS items, COUNT(DISTINCT user_id) AS buyers
  FROM `bigquery-public-data.thelook_ecommerce.order_items`
  WHERE status<>'Cancelled' GROUP BY mth)
SELECT m, IFNULL(gross,0) AS gross, IFNULL(ret,0) AS ret, IFNULL(orders,0) AS orders,
       IFNULL(items,0) AS items, IFNULL(buyers,0) AS buyers, ROUND(SAFE_DIVIDE(gross,orders),2) AS aov
FROM months LEFT JOIN agg ON agg.mth=months.m ORDER BY m;
