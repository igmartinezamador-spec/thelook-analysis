-- NOTA: la version ejecutada fue una sola consulta UNION ALL (17 controles, ver docs/qc_log.md; incluye ademas
-- coherencia item vs pedido y item anterior al alta del usuario). Este fichero es la version legible de los controles base.
-- 01 CONTROLES DE CALIDAD. Cada fila: check, valor, esperado. Registrar resultado real en docs/qc_log.md
SELECT 'order_items: id duplicado' AS chk, COUNT(*) - COUNT(DISTINCT id) AS valor, '0' AS esperado
FROM `bigquery-public-data.thelook_ecommerce.order_items`
UNION ALL SELECT 'order_items: sale_price nulo o <=0', COUNTIF(sale_price IS NULL OR sale_price <= 0), '0'
FROM `bigquery-public-data.thelook_ecommerce.order_items`
UNION ALL SELECT 'order_items: order_id sin pedido (huérfanos)', COUNT(*), '0'
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
LEFT JOIN `bigquery-public-data.thelook_ecommerce.orders` o USING (order_id) WHERE o.order_id IS NULL
UNION ALL SELECT 'order_items: product_id sin producto', COUNT(*), '0'
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
LEFT JOIN `bigquery-public-data.thelook_ecommerce.products` p ON p.id = oi.product_id WHERE p.id IS NULL
UNION ALL SELECT 'order_items: user_id sin usuario', COUNT(*), '0'
FROM `bigquery-public-data.thelook_ecommerce.order_items` oi
LEFT JOIN `bigquery-public-data.thelook_ecommerce.users` u ON u.id = oi.user_id WHERE u.id IS NULL
UNION ALL SELECT 'orders: order_id duplicado', COUNT(*) - COUNT(DISTINCT order_id), '0'
FROM `bigquery-public-data.thelook_ecommerce.orders`
UNION ALL SELECT 'coherencia: status=Returned sin returned_at', COUNTIF(status='Returned' AND returned_at IS NULL), '0'
FROM `bigquery-public-data.thelook_ecommerce.order_items`
UNION ALL SELECT 'coherencia: returned_at con status<>Returned', COUNTIF(status<>'Returned' AND returned_at IS NOT NULL), '0'
FROM `bigquery-public-data.thelook_ecommerce.order_items`
UNION ALL SELECT 'coherencia: returned_at < created_at', COUNTIF(returned_at < created_at), '0'
FROM `bigquery-public-data.thelook_ecommerce.order_items`
UNION ALL SELECT 'users: country nulo/vacío', COUNTIF(country IS NULL OR country=''), 'informativo'
FROM `bigquery-public-data.thelook_ecommerce.users`
UNION ALL SELECT 'products: category nula', COUNTIF(category IS NULL), '0'
FROM `bigquery-public-data.thelook_ecommerce.products`;
