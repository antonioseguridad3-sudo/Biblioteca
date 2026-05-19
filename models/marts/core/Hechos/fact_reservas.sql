{{
    config(
        materialized='table',
        schema='HECHOS',
        tags=['hechos']
    )
}}

with stg as (

    select * from {{ ref('stg_reservas') }}

),

final as (

    select
        idreserva                                        as id_reserva,

        -- FKs a dimensiones
        idcliente                                        as id_cliente,
        idlibro                                          as id_libro,
        to_number(to_char(freserva,    'YYYYMMDD'))      as id_fecha_reserva,
        to_number(to_char(fexpiracion, 'YYYYMMDD'))      as id_fecha_expiracion,
        to_number(to_char(fatencion,   'YYYYMMDD'))      as id_fecha_atencion,

        -- atributos
        freserva                                         as f_reserva,
        fexpiracion                                      as f_expiracion,
        fatencion                                        as f_atencion,
        estado,
        canal,
        notas,

        -- métricas derivadas
        case
            when fatencion is not null then datediff('day', freserva, fatencion)
            else null
        end                                              as dias_hasta_atencion,
        case
            when fatencion is not null then true else false
        end                                              as fue_atendida,
        case
            when fatencion is null and current_date > fexpiracion then true
            else false
        end                                              as esta_expirada,

        creado_en,
        modificado_en
    from stg

)

select * from final