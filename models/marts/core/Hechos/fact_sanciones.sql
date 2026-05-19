{{
    config(
        materialized='table',
        schema='HECHOS',
        tags=['hechos']
    )
}}

with stg as (

    select * from {{ ref('stg_sanciones') }}

),

final as (

    select
        idsancion                                        as id_sancion,

        -- FKs a dimensiones
        idcliente                                        as id_cliente,
        idlibro                                          as id_libro,
        nejemplar                                        as n_ejemplar,
        {{ dbt_utils.generate_surrogate_key(['idlibro', 'nejemplar']) }} as sk_ejemplar,
        to_number(to_char(fentrega,    'YYYYMMDD'))      as id_fecha_entrega,
        to_number(to_char(fsancion,    'YYYYMMDD'))      as id_fecha_sancion,
        to_number(to_char(flimitepago, 'YYYYMMDD'))      as id_fecha_limite_pago,
        to_number(to_char(fpago,       'YYYYMMDD'))      as id_fecha_pago,

        -- atributos
        fentrega                                         as f_entrega,
        tiposancion                                      as tipo_sancion,
        descripcion,
        fsancion                                         as f_sancion,
        flimitepago                                      as f_limite_pago,
        estado,
        fpago                                            as f_pago,
        metodopago                                       as metodo_pago,
        aprobado_por,

        -- métricas
        importe,
        case
            when fpago is not null then importe else 0
        end                                              as importe_cobrado,
        case
            when fpago is null then importe else 0
        end                                              as importe_pendiente,
        case
            when fpago is not null then datediff('day', fsancion, fpago)
            else null
        end                                              as dias_hasta_pago,
        case
            when fpago is not null and fpago > flimitepago then true
            when fpago is null and current_date > flimitepago then true
            else false
        end                                              as pago_fuera_plazo,
        case
            when fpago is null then true else false
        end                                              as sancion_pendiente,

        creado_en,
        modificado_en
    from stg

)

select * from final