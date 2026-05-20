{{
    config(
        materialized='table',
        schema='HECHOS',
        tags=['hechos']
    )
}}

with stg as (

    select * from {{ ref('stg_prestamos') }}

),

final as (

    select
        -- surrogate key del hecho
        {{ dbt_utils.generate_surrogate_key([
            'idcliente', 'idlibro', 'nejemplar', 'fentrega'
        ]) }}                                            as sk_prestamo,

        -- FKs a dimensiones
        idcliente                                        as id_cliente,
        idlibro                                          as id_libro,
        nejemplar                                        as n_ejemplar,
        {{ dbt_utils.generate_surrogate_key(['idlibro', 'nejemplar']) }} as sk_ejemplar,
        to_number(to_char(fentrega,   'YYYYMMDD'))       as id_fecha_entrega,
        to_number(to_char(fdevolucion,'YYYYMMDD'))       as id_fecha_devolucion,
        to_number(to_char(flimite,    'YYYYMMDD'))       as id_fecha_limite,

        -- atributos
        fentrega                                         as f_entrega,
        fdevolucion                                      as f_devolucion,
        flimite                                          as f_limite,
        renovaciones,
        notas,

        -- métricas derivadas
        datediff('day', fentrega, coalesce(fdevolucion, current_date)) as dias_prestamo,
        case
            when fdevolucion is null then null
            else datediff('day', flimite, fdevolucion)
        end                                              as dias_retraso,
        case
            when fdevolucion is null and current_date > flimite then true
            when fdevolucion is not null and fdevolucion > flimite then true
            else false
        end                                              as es_retraso,
        case
            when fdevolucion is null then true
            else false
        end                                              as prestamo_abierto,

        creado_en,
        modificado_en
    from stg

)

select * from final