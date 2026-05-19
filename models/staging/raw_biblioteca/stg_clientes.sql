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
        fbaja as F_BAJA,
        genero,
        activo,
        creado_en,
        modificado_en,
        fcarga as f_carga
    from source
    where idcliente is not null
)

select * from renamed