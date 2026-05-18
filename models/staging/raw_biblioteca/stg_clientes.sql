with 

source as (
    
    select * from {{ source('raw_biblioteca', 'clientes') }}
    
),

renamed as (

    select
        idcliente as id_cliente,
        nombre,
        telefono,
        email,
        direccion,
        ciudad,
        fnacimiento as F_NACIMIENTO,
        falta as F_ALTA,
        fbaja,
        genero,
        activo,
        creado_en,
        modificado_en
    from source
)

select * from renamed