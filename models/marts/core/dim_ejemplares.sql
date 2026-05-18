with int as (
    select * from {{ ref('stg_ejemplares') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['id_libro', 'n_ejemplar']) }} as sk_ejemplar,
    id_libro,
    n_ejemplar,
    estado,
    ubicacion,
    f_adquisicion,
    activo,
    pendiente_baja
from int