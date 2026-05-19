{{
    config(
        materialized='incremental',
        unique_key='id_cliente'
    )
}}

with

{% if is_incremental() %}
max_carga as (
    select max(f_carga) as max_f_carga from {{ this }}
),
{% endif %}

stg as (
    select s.*
    from {{ ref('stg_clientes') }} s
    {% if is_incremental() %}
    cross join max_carga m
    where s.f_carga > m.max_f_carga
    {% endif %}
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
        f_baja,
        genero,
        case
            when upper(activo) in ('S', 'SI', 'Y', 'YES', 'TRUE', '1') then true
            else false
        end as es_activo,
        datediff('year', f_nacimiento, current_date) as edad,
        case
            when datediff('year', f_nacimiento, current_date) < 18 then 'Menor'
            when datediff('year', f_nacimiento, current_date) between 18 and 30 then 'Joven'
            when datediff('year', f_nacimiento, current_date) between 31 and 60 then 'Adulto'
            when datediff('year', f_nacimiento, current_date) > 60 then 'Senior'
            else 'Desconocido'
        end as rango_edad,
        datediff('day', f_alta, current_date) as antiguedad_dias,
        creado_en,
        modificado_en,
        f_carga
    from stg

)

select * from final