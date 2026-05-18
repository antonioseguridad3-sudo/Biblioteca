with prestamos as (
    select * from {{ ref('stg_prestamos') }}
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
    {{ dbt_utils.generate_surrogate_key(['p.id_cliente', 'p.id_libro', 'p.n_ejemplar', 'p.f_entrega']) }}
                                                                    as sk_prestamo,

    -- foreign keys
    c.sk_cliente                                                    as fk_cliente,
    l.sk_libro                                                      as fk_libro,
    e.sk_ejemplar                                                   as fk_ejemplar,
    fe.sk_fecha                                                     as fk_fecha_entrega,
    fl.sk_fecha                                                     as fk_fecha_limite,
    fd.sk_fecha                                                     as fk_fecha_devol,

    -- métricas
    p.renovaciones,
    p.devuelto_tarde,
    p.dias_retraso,
    p.importe_sancion

from prestamos p
left join dim_clientes   c  on c.id_cliente_src = p.id_cliente
left join dim_libros     l  on l.id_libro_src   = p.id_libro
left join dim_ejemplares e  on e.id_libro_src   = p.id_libro and e.n_ejemplar = p.n_ejemplar
left join dim_fecha      fe on fe.fecha         = p.f_entrega
left join dim_fecha      fl on fl.fecha         = p.f_limite
left join dim_fecha      fd on fd.fecha         = p.f_devolucion