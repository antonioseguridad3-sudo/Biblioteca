with 

source as (

    select * from {{ source('raw_biblioteca', 'libros') }}

),

renamed as (

    select
        idlibro,
        titulo,
        autor,
        isbn,
        genero,
        categoria,
        editorial,
        aniopublic,
        numpaginas,
        falta,
        activo,
        creado_en,
        modificado_en

    from source

)

select * from renamed