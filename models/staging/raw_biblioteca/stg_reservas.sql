with 

source as (

    select * from {{ source('raw_biblioteca', 'reservas') }}

),

renamed as (

    select
        idreserva,
        idcliente,
        idlibro,
        freserva,
        fexpiracion,
        fatencion,
        estado,
        canal,
        notas,
        creado_en,
        modificado_en

    from source

)

select * from renamed