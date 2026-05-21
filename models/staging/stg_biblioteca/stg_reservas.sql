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
        coalesce(notas, 'Sin notas')        as notas,
        creado_en,
        coalesce(modificado_en, creado_en)  as modificado_en

    from source

)

select * from renamed