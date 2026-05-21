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
        fnacimiento as f_nacimiento,
        falta as f_alta,
        fbaja as f_baja,
        genero,
        activo,
        creado_en,
        modificado_en,
        fcarga as f_carga
    from source
    where idcliente is not null
    qualify row_number() over (
        partition by idcliente
        order by modificado_en desc nulls last
    ) = 1

)

select * from renamed