with 

source as (

    select * from {{ source('raw_biblioteca', 'prestamos') }}

),

renamed as (

    select
        idcliente,
        idlibro,
        nejemplar,
        fentrega,
        fdevolucion,
        flimite,
        renovaciones,
        notas,
        creado_en,
        modificado_en

    from source

)

select * from renamed