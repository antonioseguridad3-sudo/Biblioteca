-- Dimensión de fecha generada en dbt, sin fuente en los CSVs
-- Rango: desde el primer evento histórico hasta 2 años a futuro

with date_spine as (
    {{ dbt_utils.date_spine(
        datepart = "day",
        start_date = "cast('2010-01-01' as date)",
        end_date   = "dateadd(year, 2, current_date())"
    ) }}
),

dates as (
    select
        cast(date_day as date)                                      as fecha
    from date_spine
)

select
    {{ dbt_utils.generate_surrogate_key(['fecha']) }}               as sk_fecha,
    fecha,
    year(fecha)                                                     as anio,
    quarter(fecha)                                                  as trimestre,
    month(fecha)                                                    as mes,
    monthname(fecha)                                                as nombre_mes,
    weekofyear(fecha)                                               as semana,
    dayofweek(fecha)                                                as dia_semana,
    dayname(fecha)                                                  as nombre_dia,
    -- Fines de semana marcados como festivo (puedes cruzar con tabla de festivos reales)
    case when dayofweek(fecha) in (0, 6) then true else false end   as es_festivo

from dates