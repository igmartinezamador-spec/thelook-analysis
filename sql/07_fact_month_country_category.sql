-- Proyecto: <tu-proyecto> (BigQuery Sandbox). Fuente: bigquery-public-data.thelook_ecommerce
-- Ventana: 2025-10-01 a 2026-09-30 (12 meses completos; MAX(created_at) en datos = 2026-10-23, octubre-26 parcial, excluido).
-- Venta = linea de order_items con status <> 'Cancelled'. Devuelta = status = 'Returned'. Mes = mes de created_at de la linea.
-- 07 Tabla de hechos para el dashboard (se exporto a Google Sheets, hoja fact_mes_pais_categoria; 3.283 filas, 9,61 MB procesados).
-- Solo medidas aditivas (lineas, ventas, devueltas). Pedidos/ticket NO se incluyen: no son aditivos entre categorias.
SELECT DATE_TRUNC(DATE(oi.created_at),MONTH) AS month, u.country, p.category,
       COUNT(*) AS items, ROUND(SUM(oi.sale_price),2) AS gross_sales,
       COUNTIF(oi.status='Returned') AS returned_items, ROUND(SUM(IF(oi.status='Returned',oi.sale_price,0)),2) AS returned_value
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
JOIN `bigquery-public-data.thelook_ecommerce.products` p ON p.id=oi.product_id
JOIN `bigquery-public-data.thelook_ecommerce.users` u ON u.id=oi.user_id
WHERE oi.status<>'Cancelled' AND DATE(oi.created_at) BETWEEN '2025-10-01' AND '2026-09-30'
GROUP BY 1,2,3 ORDER BY 1,2,3;
