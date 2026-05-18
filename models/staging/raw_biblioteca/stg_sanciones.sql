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
        tiposancion,
        descripcion,
        importe,
        fsancion,
        flimitepago,
        estado,
        fpago,
        metodopago,
        aprobado_por,
        creado_en,
        modificado_en

    from source

)

select * from renamed