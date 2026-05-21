with 

source as (

    select * from {{ source('raw_biblioteca', 'sanciones') }}

),

renamed as (

    select
        idsancion,
        idcliente,
        idlibro,
        nejemplar,
        fentrega,

        -- normaliza a minúsculas y rellena los tipos faltantes
        coalesce(lower(tiposancion), 'desconocido')     as tiposancion,

        descripcion,
        importe,

        -- si no hay fecha de sanción, aproximamos con la fecha de creación
        coalesce(fsancion, creado_en::date)             as fsancion,

        flimitepago,
        estado,
        fpago,
        metodopago,
        aprobado_por,
        creado_en,
        coalesce(modificado_en, creado_en)              as modificado_en

    from source
    where idsancion is not null      -- descarta sanciones sin clave (datos incompletos)

)

select * from renamed