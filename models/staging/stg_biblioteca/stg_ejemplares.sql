with 

source as (

    select * from {{ source('raw_biblioteca', 'ejemplares') }}

),

renamed as (

    select
        idlibro as id_libro,
        nejemplar as n_ejemplar,
        estado,
        fadquisicion as f_adquisicion,
        fultimarev,
        ubicacion,
        activo,
        creado_en,
        modificado_en

    from source

)

select * from renamed