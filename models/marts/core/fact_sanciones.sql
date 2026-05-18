with sanciones as (
    select * from {{ ref('stg_sanciones') }}
),

dim_clientes as (
    select sk_cliente, id_cliente_src from {{ ref('dim_clientes') }}
),

dim_libros as (
    select sk_libro, id_libro_src from {{ ref('dim_libros') }}
),

dim_ejemplares as (
    select sk_ejemplar, id_libro_src, n_ejemplar from {{ ref('dim_ejemplares') }}
),

dim_fecha as (
    select sk_fecha, fecha from {{ ref('dim_fecha') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['s.id_sancion']) }}        as sk_sancion,

    -- foreign keys
    c.sk_cliente                                                    as fk_cliente,
    l.sk_libro                                                      as fk_libro,
    e.sk_ejemplar                                                   as fk_ejemplar,
    fs.sk_fecha                                                     as fk_fecha_sancion,

    -- métricas y atributos
    s.tipo_sancion,
    s.importe,
    s.estado,
    s.metodo_pago

from sanciones s
left join dim_clientes   c  on c.id_cliente_src = s.id_cliente
left join dim_libros     l  on l.id_libro_src   = s.id_libro
left join dim_ejemplares e  on e.id_libro_src   = s.id_libro and e.n_ejemplar = s.n_ejemplar
left join dim_fecha      fs on fs.fecha         = s.f_sancion