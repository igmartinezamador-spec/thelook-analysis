# Guía breve para reproducir
1. **Acceso**: proyecto de Google Cloud en Sandbox (sin facturación) y abrir BigQuery. El dataset público `bigquery-public-data.thelook_ecommerce` se consulta sin copiarlo.
2. **Inspección** (`sql/00`) y **controles** (`sql/01`): confirmar columnas, estados y `MAX(created_at)`. Si el máximo cambia, cambiar la ventana (12 meses completos) en todas las consultas.
3. **Análisis** (`sql/02`–`06`): cada consulta se ejecutó por separado (6,99–10 MB; el editor muestra los bytes antes de ejecutar).
4. **Hechos** (`sql/07`): Guardar resultados → Hojas de cálculo de Google. Genera la hoja `fact_mes_pais_categoria`.
5. **Agregados**: los resultados de 02–06 se copiaron a las hojas `mensual`, `categoria_devoluciones`, `pais`, `nuevos_vs_recurrentes` y `cohortes`. Las tasas y totales son fórmulas.
6. **Validación**: la hoja `qc_log` contiene controles con fórmulas vivas contra la tabla de hechos.
7. **Dashboard**: en Looker Studio, fuente "Google Sheets" sobre la hoja de hechos. Añadir control de fecha (`month`) y listas de `country` y `category`. Medidas aditivas: `gross_sales`, `returned_value`, `items`. Tasa de devolución como campo calculado `SUM(returned_value)/SUM(gross_sales)` con división segura.
8. Los números del informe se pueden recomputar desde las hojas.
