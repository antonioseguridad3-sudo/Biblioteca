with 

source as (

    select * from {{ source('raw_biblioteca', 'ejemplares') }}

),

renamed as (

    select
        idlibro,
        nejemplar,
        estado,
        fadquisicion,
        fultimarev,
        ubicacion,
        activo,
        creado_en,
        modificado_en

    from source

)

select * from renamed