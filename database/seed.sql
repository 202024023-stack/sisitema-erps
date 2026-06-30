-- =====================================================
-- DATOS INICIALES - EJEMPLO DE USO
-- =====================================================

-- 1. Insertar una empresa de ejemplo
INSERT INTO empresas (
    ruc, razon_social, nombre_comercial, direccion, 
    ubigeo, departamento, provincia, distrito, estado
) VALUES (
    '20123456789',
    'ACME CORPORATION SAC',
    'ACME',
    'Avenida Paseo de la República 3500',
    '150131',
    'LIMA',
    'LIMA',
    'SAN ISIDRO',
    TRUE
) ON CONFLICT (ruc) DO NOTHING;

-- 2. Insertar sucursal principal
INSERT INTO sucursales (
    empresa_id, codigo_sunat, nombre, direccion, telefono, estado
) VALUES (
    (SELECT id FROM empresas WHERE ruc = '20123456789'),
    '0000',
    'Oficina Principal',
    'Avenida Paseo de la República 3500',
    '01-2345678',
    TRUE
) ON CONFLICT (empresa_id, codigo_sunat) DO NOTHING;

-- 3. Insertar Plan Contable (PCGE - Estructura Básica)
INSERT INTO plan_contable (
    empresa_id, cuenta, descripcion, tipo_cuenta, nivel, 
    permite_asiento, moneda, estado
) VALUES
-- CLASE 1: ACTIVOS
((SELECT id FROM empresas WHERE ruc = '20123456789'), '1', 'ACTIVO', 'Activo', 1, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '10', 'ACTIVO CIRCULANTE', 'Activo', 2, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '104', 'CAJA Y BANCOS', 'Activo', 3, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '1041', 'CAJA', 'Activo', 4, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '10411', 'CAJA - MONEDA NACIONAL', 'Activo', 5, TRUE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '1042', 'BANCOS', 'Activo', 4, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '10421', 'BANCO A - CUENTA CORRIENTE', 'Activo', 5, TRUE, 'PEN', TRUE),

-- CLASE 2: PASIVOS
((SELECT id FROM empresas WHERE ruc = '20123456789'), '2', 'PASIVO', 'Pasivo', 1, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '20', 'PASIVO CIRCULANTE', 'Pasivo', 2, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '201', 'TRIBUTOS POR PAGAR', 'Pasivo', 3, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '2011', 'IMPUESTO A LA RENTA', 'Pasivo', 4, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '20111', 'IMPUESTO A LA RENTA - TERCERA CATEGORÍA', 'Pasivo', 5, TRUE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '2012', 'IMPUESTO GENERAL A LAS VENTAS', 'Pasivo', 4, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '20121', 'IGV - DÉBITO', 'Pasivo', 5, TRUE, 'PEN', TRUE),

-- CLASE 3: PATRIMONIO
((SELECT id FROM empresas WHERE ruc = '20123456789'), '3', 'PATRIMONIO', 'Patrimonio', 1, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '30', 'CAPITAL', 'Patrimonio', 2, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '301', 'CAPITAL SOCIAL', 'Patrimonio', 3, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '3011', 'CAPITAL CONTRIBUIDO', 'Patrimonio', 4, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '30111', 'CAPITAL SOCIAL - CONSTITUÍDO', 'Patrimonio', 5, TRUE, 'PEN', TRUE),

-- CLASE 4: INGRESOS
((SELECT id FROM empresas WHERE ruc = '20123456789'), '4', 'INGRESOS', 'Ingreso', 1, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '40', 'INGRESOS DE ACTIVIDADES ORDINARIAS', 'Ingreso', 2, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '401', 'VENTAS DE BIENES', 'Ingreso', 3, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '4011', 'VENTAS INTERNAS DE BIENES', 'Ingreso', 4, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '40111', 'VENTAS INTERNAS DE BIENES - GRAVADAS', 'Ingreso', 5, TRUE, 'PEN', TRUE),

-- CLASE 6: GASTOS
((SELECT id FROM empresas WHERE ruc = '20123456789'), '6', 'GASTOS', 'Gasto', 1, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '60', 'COSTO DE VENTAS', 'Gasto', 2, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '601', 'COSTO DE MERCADERÍAS VENDIDAS', 'Gasto', 3, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '6011', 'COSTO DE MERCADERÍAS VENDIDAS', 'Gasto', 4, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '60111', 'MERCADERÍAS', 'Gasto', 5, TRUE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '63', 'GASTOS DE ADMINISTRACIÓN', 'Gasto', 3, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '631', 'REMUNERACIONES', 'Gasto', 4, FALSE, 'PEN', TRUE),
((SELECT id FROM empresas WHERE ruc = '20123456789'), '6311', 'SUELDOS Y SALARIOS', 'Gasto', 5, TRUE, 'PEN', TRUE)
ON CONFLICT (empresa_id, cuenta) DO NOTHING;

-- 4. Crear un asiento de ejemplo (Capitalización)
INSERT INTO asientos_diario (
    empresa_id, sucursal_id, periodo, fecha_asiento, 
    correlativo, glosa, modulo_origen, usuario_id, estado
) VALUES (
    (SELECT id FROM empresas WHERE ruc = '20123456789'),
    (SELECT id FROM sucursales WHERE codigo_sunat = '0000' 
     AND empresa_id = (SELECT id FROM empresas WHERE ruc = '20123456789')),
    '202606',
    '2026-06-30',
    'AST-001',
    'Constitución de capital social - Aporte en efectivo',
    'VENTAS',
    '00000000-0000-0000-0000-000000000001'::UUID,
    'CUADRADO'
);

-- 5. Insertar detalles del asiento (Partida doble)
INSERT INTO asiento_diario_detalles (
    asiento_diario_id, cuenta_contable, debe, haber, moneda, 
    documento_tipo, documento_serie_numero
) VALUES
(
    (SELECT id FROM asientos_diario WHERE correlativo = 'AST-001'),
    '10411',
    50000.00,
    0.00,
    'PEN',
    NULL,
    NULL
),
(
    (SELECT id FROM asientos_diario WHERE correlativo = 'AST-001'),
    '30111',
    0.00,
    50000.00,
    'PEN',
    NULL,
    NULL
);

-- 6. Crear un asiento de venta
INSERT INTO asientos_diario (
    empresa_id, sucursal_id, periodo, fecha_asiento, 
    correlativo, glosa, modulo_origen, usuario_id, estado
) VALUES (
    (SELECT id FROM empresas WHERE ruc = '20123456789'),
    (SELECT id FROM sucursales WHERE codigo_sunat = '0000' 
     AND empresa_id = (SELECT id FROM empresas WHERE ruc = '20123456789')),
    '202606',
    '2026-06-30',
    'AST-002',
    'Venta de mercadería - Factura electrónica',
    'VENTAS',
    '00000000-0000-0000-0000-000000000001'::UUID,
    'CUADRADO'
);

-- 7. Insertar detalles de venta (con IGV)
INSERT INTO asiento_diario_detalles (
    asiento_diario_id, cuenta_contable, debe, haber, moneda, 
    documento_tipo, documento_serie_numero
) VALUES
-- DEBE: Caja (efectivo recibido)
(
    (SELECT id FROM asientos_diario WHERE correlativo = 'AST-002'),
    '10411',
    11800.00,
    0.00,
    'PEN',
    '01',
    'F001-000001'
),
-- HABER: Ventas gravadas
(
    (SELECT id FROM asientos_diario WHERE correlativo = 'AST-002'),
    '40111',
    0.00,
    10000.00,
    'PEN',
    '01',
    'F001-000001'
),
-- HABER: IGV por pagar
(
    (SELECT id FROM asientos_diario WHERE correlativo = 'AST-002'),
    '20121',
    0.00,
    1800.00,
    'PEN',
    '01',
    'F001-000001'
);
