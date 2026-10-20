-- Proyecto: <tu-proyecto> (BigQuery Sandbox). Fuente: bigquery-public-data.thelook_ecommerce
-- Ventana: 2025-10-01 a 2026-09-30 (12 meses completos; MAX(created_at) en datos = 2026-10-23, octubre-26 parcial, excluido).
-- Venta = linea de order_items con status <> 'Cancelled'. Devuelta = status = 'Returned'. Mes = mes de created_at de la linea.
-- 04 Ventas por pais (users.country = pais del cliente; cada usuario tiene un unico pais, asi pedidos suman entre paises).
-- Nota: existen etiquetas 'Spain' y 'España' sin unificar (ver qc_log).
SELECT u.country, COUNT(DISTINCT oi.order_id) AS orders, COUNT(DISTINCT oi.user_id) AS buyers, COUNT(*) AS items,
       ROUND(SUM(oi.sale_price),2) AS gross, ROUND(SUM(IF(oi.status='Returned',oi.sale_price,0)),2) AS ret_val
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.users` u ON u.id=oi.user_id
WHERE oi.status<>'Cancelled' AND DATE(oi.created_at) BETWEEN '2025-10-01' AND '2026-09-30'
GROUP BY u.country ORDER BY gross DESC;
