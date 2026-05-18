with stg as (
    select * from {{ ref('stg_libros') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['id_libro']) }}            as sk_libro,
    id_libro,
    titulo,
    autor,
    isbn,
    genero,
    categoria,
    editorial,
    anio_publicacion,
    num_paginas,
    activo
from stg
