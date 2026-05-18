with reservas as (
    select * from {{ ref('stg_reservas') }}
),

dim_clientes as (
    select sk_cliente, id_cliente_src from {{ ref('dim_clientes') }}
),

dim_libros as (
    select sk_libro, id_libro_src from {{ ref('dim_libros') }}
),

dim_fecha as (
    select sk_fecha, fecha from {{ ref('dim_fecha') }}
)

select
    {{ dbt_utils.generate_surrogate_key(['r.id_reserva']) }}        as sk_reserva,

    -- foreign keys
    c.sk_cliente                                                    as fk_cliente,
    l.sk_libro                                                      as fk_libro,
    fr.sk_fecha                                                     as fk_fecha_reserva,
    fe.sk_fecha                                                     as fk_fecha_expir,

    -- métricas y atributos
    r.estado,
    r.canal,
    r.atendida

from reservas r
left join dim_clientes c   on c.id_cliente_src = r.id_cliente
left join dim_libros   l   on l.id_libro_src   = r.id_libro
left join dim_fecha    fr  on fr.fecha         = r.f_reserva
left join dim_fecha    fe  on fe.fecha         = r.f_expiracion