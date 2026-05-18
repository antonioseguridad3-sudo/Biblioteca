with stg as (
    select * from {{ ref('stg_clientes') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['id_cliente']) }}          as sk_cliente,
    id_cliente                                                      as id_cliente,
    nombre,
    email,
    telefono,
    ciudad,
    genero,
    f_nacimiento,
    f_alta,
    activo
from stg