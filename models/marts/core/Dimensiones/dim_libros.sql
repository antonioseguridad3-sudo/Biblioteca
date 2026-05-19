{{
    config(
        materialized='table',
        schema='DIMENSIONES',
        tags=['dimension']
    )
}}

with stg as (

    select * from {{ ref('stg_libros') }}

),

final as (

    select
        id_libro,
        titulo,
        autor,
        isbn,
        genero,
        categoria,
        editorial,
        anio_publicacion,
        num_paginas,
        case
            when num_paginas < 150 then 'Corto'
            when num_paginas between 150 and 400 then 'Medio'
            when num_paginas > 400 then 'Largo'
            else 'Desconocido'
        end                                         as longitud_libro,
        falta                                       as f_alta,
        case
            when upper(activo) in ('S', 'SI', 'Y', 'YES', 'TRUE', '1') then true
            else false
        end                                         as es_activo,
        creado_en,
        modificado_en,
        current_timestamp()                         as fecha_carga_dim
    from stg

)

select * from final