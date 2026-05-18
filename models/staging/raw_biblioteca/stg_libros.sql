with 

source as (

    select * from {{ source('raw_biblioteca', 'libros') }}

),

renamed as (

    select
        idlibro as id_libro,
        titulo,
        autor,
        isbn,
        genero,
        categoria,
        editorial,
        aniopublic  as anio_publicacion,
        numpaginas  as num_paginas,
        falta,
        activo,
        creado_en,
        modificado_en

    from source

)

select * from renamed