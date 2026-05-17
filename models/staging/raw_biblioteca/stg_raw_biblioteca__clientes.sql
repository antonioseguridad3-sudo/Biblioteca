with source as (
    select * 
    from {{ source('raw_biblioteca', 'clientes') }}
),

renamed as (

    select
        idcliente,
        nombre,
        telefono,
        email,
        direccion,
        ciudad,
        fnacimiento,
        falta,
        fbaja,
        genero,
        activo,
        creado_en,
        modificado_en

    from source
)

select * from renamed