with 

source as (

    select * from {{ source('raw_biblioteca', 'ejemplares_para_borrar') }}

),

renamed as (

    select
        idlibro,
        nejemplar,
        estado,
        motivobaja,
        fdeteccion,
        aprobado,
        creado_en

    from source
    where idlibro is not null

)

select * from renamed