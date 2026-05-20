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

bajas as (

    select
        idlibro     as id_libro,
        nejemplar   as n_ejemplar,
        motivobaja,
        fdeteccion  as f_deteccion_baja,
        aprobado    as baja_aprobada
    from {{ ref('stg_ejemplares_para_borrar') }}

),

final as (

    select
        -- surrogate key (libro + ejemplar es clave natural compuesta)
        {{ dbt_utils.generate_surrogate_key(['e.id_libro', 'e.n_ejemplar']) }} as sk_ejemplar,
        e.id_libro,
        e.n_ejemplar,
        e.estado,
        e.f_adquisicion,
        e.fultimarev                                as f_ultima_revision,
        e.ubicacion,
        case
            when upper(e.activo) in ('S', 'SI', 'Y', 'YES', 'TRUE', '1') then true
            else false
        end                                         as es_activo,
        case
            when b.id_libro is not null then true
            else false
        end                                         as marcado_para_baja,
        b.motivobaja                                as motivo_baja,
        b.f_deteccion_baja,
        b.baja_aprobada,
        datediff('day', e.f_adquisicion, current_date) as antiguedad_dias,
        e.creado_en,
        e.modificado_en,
        current_timestamp()                         as fecha_carga_dim
    from stg e
    left join bajas b
        on  e.id_libro   = b.id_libro
        and e.n_ejemplar = b.n_ejemplar

)

select * from final