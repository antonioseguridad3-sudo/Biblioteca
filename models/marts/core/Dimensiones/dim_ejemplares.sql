{{
    config(
        materialized='table',
        schema='DIMENSIONES',
        tags=['dimension']
    )
}}

with stg as (

    select * from {{ ref('stg_ejemplares') }}

),

final as (

    select
        -- surrogate key (libro + ejemplar es clave natural compuesta)
        {{ dbt_utils.generate_surrogate_key(['id_libro', 'n_ejemplar']) }} as sk_ejemplar,
        id_libro,
        n_ejemplar,
        estado,
        f_adquisicion,
        f_ultima_revision,
        ubicacion,
        case
            when upper(activo) in ('S', 'SI', 'Y', 'YES', 'TRUE', '1') then true
            else false
        end                                         as es_activo,

        -- enriquecimiento de bajas (ya resuelto en staging)
        marcado_para_baja,
        motivo_baja,
        f_deteccion_baja,
        baja_aprobada,

        datediff('day', f_adquisicion, current_date) as antiguedad_dias,
        creado_en,
        modificado_en,
        current_timestamp()                         as fecha_carga_dim
    from stg

)

select * from final