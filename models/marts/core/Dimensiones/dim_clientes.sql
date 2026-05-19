{{
    config(
        materialized='table',
        schema='DIMENSIONES',
        tags=['dimension']
    )
}}

with stg as (

    select * from {{ ref('stg_clientes') }}

),

final as (

    select
        id_cliente,
        nombre,
        telefono,
        email,
        direccion,
        ciudad,
        f_nacimiento,
        f_alta,
        fbaja                                       as f_baja,
        genero,
        case
            when upper(activo) in ('S', 'SI', 'Y', 'YES', 'TRUE', '1') then true
            else false
        end                                         as es_activo,
        datediff('year', f_nacimiento, current_date) as edad,
        case
            when datediff('year', f_nacimiento, current_date) < 18 then 'Menor'
            when datediff('year', f_nacimiento, current_date) between 18 and 30 then 'Joven'
            when datediff('year', f_nacimiento, current_date) between 31 and 60 then 'Adulto'
            when datediff('year', f_nacimiento, current_date) > 60 then 'Senior'
            else 'Desconocido'
        end                                         as rango_edad,
        datediff('day', f_alta, current_date)       as antiguedad_dias,
        creado_en,
        modificado_en,
        current_timestamp()                         as fecha_carga_dim
    from stg

)

select * from final