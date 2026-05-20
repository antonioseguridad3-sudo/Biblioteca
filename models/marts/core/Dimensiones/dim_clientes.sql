{{
    config(
        materialized='incremental',
        unique_key='id_cliente',
        incremental_strategy='merge'
    )
}}

with stg as (
    select *
    from {{ ref('stg_clientes') }}
    {% if is_incremental() %}
    where modificado_en > (
        select coalesce(max(modificado_en), '1900-01-01'::timestamp_ntz)
        from {{ this }}
    )
    {% endif %}
),

dedup as (
    select *
    from stg
    qualify row_number() over (
        partition by id_cliente
        order by modificado_en desc
    ) = 1
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
            when upper(activo) in ('S','SI','Y','YES','TRUE','1') then true
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
        modificado_en
    from dedup

)

select * from final