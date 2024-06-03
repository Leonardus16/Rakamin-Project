CREATE TABLE rakamin-kf-analytics-425310.kimia_farma.kf_analisa1 AS
SELECT
    t.transaction_id,
    t.date,
    t.branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,
    t.customer_name,
    t.product_id,
    p.product_name,
    t.price AS actual_price,
    t.discount_percentage,
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS persentase_gross_laba,
    t.price * (1 - t.discount_percentage / 100) AS nett_sales,
    (t.price * (1 - t.discount_percentage / 100)) *
    CASE
        WHEN t.price <= 50000 THEN 0.10
        WHEN t.price > 50000 AND t.price <= 100000 THEN 0.15
        WHEN t.price > 100000 AND t.price <= 300000 THEN 0.20
        WHEN t.price > 300000 AND t.price <= 500000 THEN 0.25
        ELSE 0.30
    END AS nett_profit,
    t.rating AS rating_transaksi
FROM (
    SELECT DISTINCT
        transaction_id,
        date,
        branch_id,
        customer_name,
        product_id,
        price,
        discount_percentage,
        rating
    FROM `rakamin-kf-analytics-425310.kimia_farma.kf_final_transaction`
) t
JOIN (
    SELECT DISTINCT
        product_id,
        product_name
    FROM `rakamin-kf-analytics-425310.kimia_farma.kf_product`
) p ON t.product_id = p.product_id
JOIN (
    SELECT DISTINCT
        branch_id,
        branch_name,
        kota,
        provinsi,
        rating
    FROM `rakamin-kf-analytics-425310.kimia_farma.kf_kantor_cabang`
) c ON t.branch_id = c.branch_id;
