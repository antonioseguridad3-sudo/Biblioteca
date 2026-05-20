{{
    config(
        materialized='table',
        schema='DIMENSIONES',
        tags=['dimension']
    )
}}

with fechas as (

    select
        dateadd('day', seq4(), to_date('2015-01-01')) as fecha
    from table(generator(rowcount => 7305))   -- ~20 años hasta 2034

),

final as (

    select
        to_number(to_char(fecha, 'YYYYMMDD'))           as id_fecha,
        fecha,
        year(fecha)                                      as anio,
        quarter(fecha)                                   as trimestre,
        month(fecha)                                     as mes,
        to_char(fecha, 'MMMM')                           as nombre_mes,
        day(fecha)                                       as dia,
        dayofweek(fecha)                                 as dia_semana,
        to_char(fecha, 'DY')                             as nombre_dia,
        weekofyear(fecha)                                as semana_anio,
        case
            when dayofweek(fecha) in (6, 0) then true
            else false
        end                                              as es_fin_de_semana,
        case
            when day(fecha) = 1 then true else false
        end                                              as es_inicio_mes,
        case
            when fecha = last_day(fecha) then true else false
        end                                              as es_fin_mes
    from fechas

)

select * from final