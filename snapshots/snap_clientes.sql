{% snapshot snap_clientes %}

{{
    config(
        target_database='BIBLIOTECA_DEV_SILVER_DB',
        target_schema='SNAPSHOTS',
        unique_key='idcliente',
        strategy='timestamp',
        updated_at='modificado_en',
        invalidate_hard_deletes=True
    )
}}

select * from {{ source('raw_biblioteca', 'clientes') }}

{% endsnapshot %}