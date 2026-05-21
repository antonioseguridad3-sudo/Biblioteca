with 

ejemplares as (

    select * from {{ source('raw_biblioteca', 'ejemplares') }}

),

bajas as (

    select
        idlibro,
        nejemplar,
        motivobaja,
        fdeteccion,
        aprobado
    from {{ source('raw_biblioteca', 'ejemplares_para_borrar') }}

),

renamed as (

    select
        e.idlibro                                   as id_libro,
        e.nejemplar                                 as n_ejemplar,
        e.estado,
        e.fadquisicion                              as f_adquisicion,
        e.fultimarev                                as f_ultima_revision,
        e.ubicacion,
        e.activo,

        -- enriquecimiento desde ejemplares_para_borrar
        coalesce(b.motivobaja, 'Sin baja')          as motivo_baja,
        b.fdeteccion                                as f_deteccion_baja,
        coalesce(b.aprobado, 'N')                   as baja_aprobada,
        case
            when b.idlibro is not null then true
            else false
        end                                         as marcado_para_baja,

        e.creado_en,
        coalesce(e.modificado_en, e.creado_en)      as modificado_en

    from ejemplares e
    left join bajas b
        on  e.idlibro   = b.idlibro
        and e.nejemplar = b.nejemplar

)

select * from renamed