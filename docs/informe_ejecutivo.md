# TheLook eCommerce: qué productos y clientes impulsan las ventas
**Periodo**: oct-2025 a sep-2026 (12 meses completos). **Datos sintéticos**: las cifras sirven para practicar el método, no para decidir sobre un negocio real.
**Magnitudes**: ventas brutas 3,26 M; valor devuelto 0,38 M (11,6 %); 37.846 pedidos; ticket medio bruto 86,15.
"Bruta" incluye pedidos Processing y Shipped. "Neto tras devoluciones" (2,88 M) = bruta − devuelto; no es ingreso contable ni margen.

## Tres hallazgos
1. **El crecimiento viene del volumen, no del ticket.** Las ventas brutas mensuales pasan de 207,5 k (oct-25) a 416,2 k (sep-26), +101 %. Los pedidos suben +108 % (2.411 → 5.012) y el ticket medio bruto baja de 86,05 a 83,04 (−3,5 %). *(hoja `mensual`)*
2. **Las ventas están concentradas.** China, EE. UU. y Brasil suman el 70,5 % (34,7 / 21,5 / 14,3 %). Outerwear & Coats y Jeans suman el 23,7 % y las 5 primeras categorías el 43,1 %. Jeans pesa el 11,4 % de las ventas pero el 13,0 % del valor devuelto (tasa en valor 13,1 % frente a 11,4 % en el resto). Con 26 categorías comparadas y una diferencia en unidades de ~1,7 desviaciones estándar, esto es una **hipótesis**, no una conclusión. *(hojas `pais`, `categoria_devoluciones`)*
3. **La recompra a corto plazo es baja y el peso de recurrentes crece despacio.** Solo el 8,1 % de los clientes nuevos vuelve a comprar el mes siguiente y el 5,2 % a los 2 meses; entre los meses 4 y 10 la actividad baja del 4,7 % al 2,8 % (cada k promedia solo las cohortes ya observables, así que los k altos se basan en pocas cohortes). Los recurrentes pasan del 37,4 % al 42,7 % de los compradores activos y los clientes nuevos crecen +80 % (1.484 → 2.673). *(hojas `nuevos_vs_recurrentes`, `cohortes`)*

## Tres recomendaciones
1. **Probar palancas de ticket** (umbral de envío gratuito, packs, venta cruzada) con un experimento controlado. Evidencia: hallazgo 1, volumen +108 % con ticket a la baja. *Hipótesis a contrastar; los datos no muestran la causa.*
2. **Revisar dependencia y calidad en lo que concentra la venta**: asegurar stock y servicio en China, EE. UU. y Brasil y en Outerwear y Jeans, y auditar tallas e información de producto de Jeans. Evidencia: hallazgo 2. Antes de actuar, contrastar la diferencia de devoluciones con más datos.
3. **Pilotar una campaña de segunda compra en los primeros 60 días** con grupo de control (mensaje post-compra, incentivo a 30 días). Evidencia: hallazgo 3 (8,1 % → 5,2 %). El efecto debe medirse con el piloto; estos datos no permiten inferirlo.

## Límites
Datos sintéticos. Las fechas llegan a 2026-10-23, posterior a la fecha de ejecución (2026-10-20), señal de generación artificial. No se analizaron costes ni márgenes. Las devoluciones se atribuyen al mes de la venta. Hay 673 líneas con devolución anterior a la venta y diferencias menores entre `orders` y `order_items` (0,07–0,26 %, sin causa verificada). El dashboard de Looker Studio está terminado y guardado (ver README).
