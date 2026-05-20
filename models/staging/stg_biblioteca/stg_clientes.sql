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
        modificado_en
    from source
    where idcliente is not null

)

select * from renamed