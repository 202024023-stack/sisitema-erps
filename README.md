# Sistema ERP - Contabilidad Peruana (PCGE)

## 📋 Descripción

Sistema ERP contable que implementa el **Plan Contable General de Empresas (PCGE)** de Perú, con integración a **SUNAT** para facturación electrónica.

## 🏗️ Arquitectura de Base de Datos

### Tablas Principales

#### 1. **empresas**
- Registro de empresas con datos tributarios
- Integración con SUNAT (SOL, certificado digital)
- Información de ubicación geográfica (UBIGEO)

```
Campos: id, ruc, razon_social, nombre_comercial, direccion, ubigeo, 
        departamento, provincia, distrito, token_sunat_sol, 
        usuario_sunat_sol, clave_sunat_sol, certificado_digital_nom,
        estado, created_at, updated_at
```

#### 2. **sucursales**
- Sucursales por empresa
- Código SUNAT (0000 = Principal)
- Relación 1:N con empresas

```
Campos: id, empresa_id, codigo_sunat, nombre, direccion, telefono, estado, created_at
```

#### 3. **plan_contable (PCGE)**
- Catálogo de cuentas por empresa
- Clasificación: Activo, Pasivo, Patrimonio, Ingreso, Gasto
- Soporte multimoneda (PEN, USD, etc.)

```
Campos: id, empresa_id, cuenta, descripcion, tipo_cuenta, nivel, 
        permite_asiento, moneda, estado
```

#### 4. **asientos_diario**
- Cabecera del Libro Diario
- Trazabilidad: usuario, módulo origen, fecha
- Período contable en formato YYYYMM

```
Campos: id, empresa_id, sucursal_id, periodo, fecha_asiento, correlativo,
        glosa, modulo_origen, documento_referencia_id, usuario_id, 
        estado, created_at
```

#### 5. **asiento_diario_detalles**
- Partidas/apuntes contables (Débito/Crédito)
- Principio de Partida Doble (Débito = Crédito)
- Soporte de tipo de cambio para moneda extranjera

```
Campos: id, asiento_diario_id, cuenta_contable, centro_costo_id,
        debe, haber, moneda, tipo_cambio, debe_extranjero, haber_extranjero,
        documento_tipo, documento_serie_numero
```

## 🔗 Relaciones

```
empresas (1) ──── (N) sucursales
    │
    └─── (N) plan_contable
    └─── (N) asientos_diario
              │
              └─── (N) asiento_diario_detalles
```

## ✨ Características Principales

✅ **Conformidad PCGE** - Plan Contable General de Empresas (Perú)  
✅ **Integración SUNAT** - Facturación electrónica y tributario  
✅ **Multiempresa** - Soporte para múltiples empresas  
✅ **Multisucursal** - Gestión de sucursales por empresa  
✅ **Multimoneda** - Soporte de múltiples monedas con tipo de cambio  
✅ **Auditoría** - Trazabilidad de operaciones (usuario, fecha, módulo)  
✅ **Integridad** - Constraints de partida doble y referencias  

## 📊 Ejemplo de Uso

### Insertar una Empresa
```sql
INSERT INTO empresas (ruc, razon_social, nombre_comercial, direccion, ubigeo, 
                     departamento, provincia, distrito)
VALUES ('20123456789', 'Mi Empresa SAC', 'Mi Empresa', 
        'Av. Principal 123', '150131', 'Lima', 'Lima', 'San Isidro');
```

### Crear una Sucursal Principal
```sql
INSERT INTO sucursales (empresa_id, codigo_sunat, nombre, direccion, telefono)
VALUES ((SELECT id FROM empresas WHERE ruc = '20123456789'), 
        '0000', 'Oficina Principal', 'Av. Principal 123', '01-2345678');
```

### Registrar un Asiento Contable
```sql
INSERT INTO asientos_diario (empresa_id, sucursal_id, periodo, fecha_asiento, 
                            correlativo, glosa, modulo_origen, usuario_id, estado)
VALUES (...) RETURNING id;

-- Luego registrar detalles (Partidas)
INSERT INTO asiento_diario_detalles (asiento_diario_id, cuenta_contable, debe, haber)
VALUES 
  ('asiento-uuid', '10411', 1000.00, 0.00),    -- DEBE: Caja
  ('asiento-uuid', '40000', 0.00, 1000.00);    -- HABER: Ingresos
```

## 🛠️ Instalación

1. Crear base de datos PostgreSQL
2. Ejecutar `schema.sql`:
```bash
psql -U postgres -d nombre_db -f database/schema.sql
```

## 📁 Estructura del Proyecto

```
sisitema-erps/
├── database/
│   ├── schema.sql          # Esquema base de datos
│   ├── seed.sql            # Datos iniciales
│   └── migrations/          # Migraciones futuras
├── src/
│   ├── models/             # Modelos de datos
│   ├── services/           # Lógica de negocio
│   ├── controllers/        # Controladores API
│   └── middleware/         # Middleware
├── README.md               # Este archivo
└── .env.example            # Variables de entorno
```

## 📝 Notas Técnicas

- **UUIDs**: Todas las tablas usan UUID para PKs (escalabilidad)
- **Índices**: Optimizados para búsquedas frecuentes
- **Constraints**: Validaciones a nivel DB para integridad
- **Auditoría**: Campos `created_at` y `updated_at` en entidades clave
- **Soft Delete**: Usar campo `estado` para desactivación lógica

## 🔐 Seguridad

- Credenciales SUNAT encriptadas en producción
- Validación de RUC contra SUNAT
- Auditoría completa de operaciones contables
- Control de acceso por usuario y módulo

---

**Versión**: 1.0.0  
**Última actualización**: 2026-06-30  
**Autor**: Sistema ERP
