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

)

select * from renamed