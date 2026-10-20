-- 00 INSPECCIÓN (coste ~0 bytes: INFORMATION_SCHEMA / metadatos)
-- Objetivo: confirmar tablas, columnas y tipos ANTES de usar las consultas 02-07.
SELECT table_name, column_name, data_type
FROM `bigquery-public-data.thelook_ecommerce.INFORMATION_SCHEMA.COLUMNS`
ORDER BY table_name, ordinal_position;

-- Rango real de fechas y estados (leer solo 2 columnas de order_items)
SELECT MIN(created_at) AS min_created, MAX(created_at) AS max_created,
       COUNT(*) AS filas, COUNT(DISTINCT order_id) AS pedidos
FROM `bigquery-public-data.thelook_ecommerce.order_items`;

SELECT status, COUNT(*) AS items, MIN(created_at) AS desde, MAX(created_at) AS hasta
FROM `bigquery-public-data.thelook_ecommerce.order_items`
GROUP BY status ORDER BY items DESC;
