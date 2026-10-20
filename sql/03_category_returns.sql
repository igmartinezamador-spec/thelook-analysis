-- Proyecto: <tu-proyecto> (BigQuery Sandbox). Fuente: bigquery-public-data.thelook_ecommerce
-- Ventana: 2025-10-01 a 2026-09-30 (12 meses completos; MAX(created_at) en datos = 2026-10-23, octubre-26 parcial, excluido).
-- Venta = linea de order_items con status <> 'Cancelled'. Devuelta = status = 'Returned'. Mes = mes de created_at de la linea.
-- 03 Ventas y devoluciones por categoria. JOIN N:1 a products (sin duplicar lineas; validado en 01).
-- Tasa unidades = lineas Returned / lineas no canceladas. Tasa valor = valor Returned / ventas brutas.
SELECT p.category, COUNT(*) AS items, COUNTIF(oi.status='Returned') AS ret_items,
       ROUND(SUM(oi.sale_price),2) AS gross, ROUND(SUM(IF(oi.status='Returned',oi.sale_price,0)),2) AS ret_val
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.products` p ON p.id=oi.product_id
WHERE oi.status<>'Cancelled' AND DATE(oi.created_at) BETWEEN '2025-10-01' AND '2026-09-30'
GROUP BY p.category ORDER BY gross DESC;
