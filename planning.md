# Planning: Reunificación, Refactorización DDD y MCP Ecommerce Ventas

## 1. Resumen Ejecutivo
A partir del análisis exhaustivo de los logs de producción (`ecommerce_backend-logs.txt`, `ecommerce_frontend-logs.txt`), los screenshots del sistema (`Swagger UI`, `MCP Inspector`, `Vistas de Frontend`, `Autorización OAuth 2.1`), la base de datos relacional PostgreSQL (`backup_completo.sql`, migraciones Drizzle) y los artefactos compilados en producción (`dist/`), se diseña el plan de acción para reunificar y refactorizar el backend NestJS y frontend Next.js hacia una arquitectura limpia guiada por el dominio (Domain-Driven Design - DDD), estandarizando el servidor MCP con el protocolo moderno `2026-07-28` y autenticación OAuth 2.1 (RFC 8414, RFC 9728, PKCE S256).

---

## 2. Inventario de Componentes Descubiertos

### 2.1 Endpoints y Rutas HTTP Identificadas

| Contexto / Módulo | Método | Ruta | Descripción |
| :--- | :--- | :--- | :--- |
| **App** | `GET` | `/` | Health check básico de la API |
| **Auth** | `POST` | `/api/auth/login` | Inicio de sesión, validación bcrypt y emisión de access token (15m) + refresh token HMAC en cookie HttpOnly |
| **Auth** | `POST` | `/api/auth/register` | Registro de nuevos usuarios con rol (`admin`, `manager`, `cashier`) |
| **Auth** | `POST` | `/api/auth/refresh` | Rotación segura de refresh token e invalidación de token anterior |
| **Auth** | `POST` | `/api/auth/logout` | Revocación de refresh token y limpieza de cookies |
| **Auth** | `GET` | `/api/auth/me` | Obtención de identidad autenticada mediante Bearer Token JWT |
| **Products** | `GET` | `/api/products` | Catálogo de productos con filtro por búsqueda (`search`) y categoría (`categoryId`) |
| **Products** | `POST` | `/api/products` | Creación de producto con validación Zod y registro automático de movimiento inicial de stock |
| **Products** | `GET` | `/api/products/categories` | Listado ordenado de categorías de productos |
| **Products** | `POST` | `/api/products/categories` | Creación de nueva categoría |
| **Products** | `GET` | `/api/products/:id` | Detalle individual de producto por ID |
| **Products** | `PUT` | `/api/products/:id` | Actualización de atributos, precio, costos y stock |
| **Products** | `DELETE` | `/api/products/:id` | Eliminación de producto |
| **Sales** | `GET` | `/api/sales` | Listado de órdenes/pedidos con desglose de ítems |
| **Sales** | `GET` | `/api/sales/metrics` | Métricas de negocio: ingresos totales, total pedidos completados, conteo de productos y stock global |
| **Sales** | `GET` | `/api/sales/:id` | Detalle de orden de venta por ID con líneas de pedido |
| **Sales** | `POST` | `/api/sales` | Creación transaccional de venta, verificación de stock disponible, deducción de existencias y generación de Kardex `SALE` |
| **Sales** | `PATCH` | `/api/sales/:id/status` | Transición de estado de orden (`completed`, `processing`, `pending`, `cancelled`) |
| **Warehouse** | `GET` | `/api/warehouse/overview` | Resumen de existencias, valorización al costo, valorización de venta y alertas |
| **Warehouse** | `GET` | `/api/warehouse/movements` | Historial inmutable de movimientos de almacén (Kardex) con producto asociado |
| **Warehouse** | `GET` | `/api/warehouse/alerts` | Productos con existencia actual menor o igual a su `minStock` |
| **Warehouse** | `POST` | `/api/warehouse/adjust` | Ajuste manual de stock (`IN`, `OUT`, `RETURN`) con actualización de inventario y Kardex |
| **OpenAPI Suite** | `POST` | `/api/openapi/invoices/issue/:orderId` | Emisión de factura electrónica SDI europea y vinculación a orden |
| **OpenAPI Suite** | `POST` | `/api/openapi/trust/verify` | Validación de reputación antifraude, análisis de correo y teléfono |
| **OpenAPI Suite** | `POST` | `/api/openapi/messaging/send-sms` | Despacho de SMS transaccional de confirmación de pedido |
| **OpenAPI Suite** | `GET` | `/api/openapi/invoices/:invoiceNumber/pdf` | Renderizado y generación de comprobante PDF oficial imprimible |
| **OAuth 2.1** | `GET` | `/.well-known/oauth-authorization-server` | Metadatos de servidor de autorización RFC 8414 |
| **OAuth 2.1** | `GET` | `/.well-known/openid-configuration` | Compatibilidad OIDC Discovery |
| **OAuth 2.1** | `GET` | `/.well-known/oauth-protected-resource` | Metadatos de recurso protegido RFC 9728 |
| **OAuth 2.1** | `POST` | `/oauth/register` | Registro dinámico de clientes RFC 7591 |
| **OAuth 2.1** | `GET` | `/oauth/authorize` | Pantalla de consentimiento HTML con validación obligatoria de PKCE S256 |
| **OAuth 2.1** | `POST` | `/oauth/authorize/decision` | Aceptación de consentimiento y emisión de `authorization_code` (validez 10 min) |
| **OAuth 2.1** | `POST` | `/oauth/token` | Canje de código de autorización por Access Token Bearer verificando PKCE `code_verifier` |
| **MCP** | `ALL` | `/mcp` | Servidor MCP Streamable HTTP Era Moderna (2026-07-28) con fallback legacy |

---

### 2.2 Servicios y Controladores a Reunificar

1. **`AppController` & `AppService`**: Controlador raíz y health-check.
2. **`AuthController` & `AuthService`**:
   - Agregado: **Identity & Access Management (IAM)**.
   - Seguridad: JWT Access Token (15 min), Refresh Token con Hash HMAC-SHA256 almacenado en base de datos, soporte de revokedAt y rotación estricta de tokens.
3. **`ProductsController` & `ProductsService`**:
   - Agregado: **Product Catalog**.
   - Entidades: Producto, Categoría.
   - Reglas de negocio: SKU único, validación de estado (`active`, `inactive`, `out_of_stock`), ajuste de inventario al crear producto con stock > 0.
4. **`SalesController` & `SalesService`**:
   - Agregado: **Sales & Order Fulfillment**.
   - Entidades: Order (Raíz de agregado), OrderItem, Customer.
   - Reglas de negocio: Validación de stock en tiempo real previo a la inserción, cálculo de subtotales e importes totales, deducción atómica de inventario, registro en Kardex con tipo `SALE`.
5. **`WarehouseController` & `WarehouseService`**:
   - Agregado: **Inventory & Warehouse (Kardex)**.
   - Entidades: InventoryMovement, WarehouseOverview (Value Object).
   - Reglas de negocio: Inmutabilidad de movimientos, soporte de tipos `IN`, `OUT`, `RETURN`, validación de no permitir stock negativo en salidas, cálculo de valorización financiera de inventario (costo vs. precio de venta).
6. **`OpenApiController` & `OpenApiService`**:
   - Agregado: **Fiscal & External Integration Context**.
   - Integraciones: OpenAPI Invoicing SDI, OpenAPI Trust, OpenAPI Messaging (SMS), OpenAPI Utilities (PDF).
   - Generación de comprobante fiscal formal con estructura HTML y estilos para impresión PDF.
7. **`OAuth2Controller` & `OAuth2Service`**:
   - Agregado: **OAuth 2.1 Authorization Provider**.
   - Cumplimiento de RFC 6749, RFC 7636 (PKCE con S256 obligatorio), RFC 8414, RFC 9728 y RFC 7591.
8. **`McpController` & `McpServerService`**:
   - Agregado: **Agentic Model Context Protocol Gateway**.
   - Protocolo: Era moderna `2026-07-28` mediante Streamable HTTP Transport y compatibilidad con JSON-RPC legacy.

---

### 2.3 Especificación del Servidor MCP (`nexus-ecommerce-mcp`)

#### Tools Expuestas:
1. **`list_products`**:
   - Parámetros: `search` (string, opcional), `categoryId` (number, opcional).
   - Descripción: Lista productos activos con información de precio, stock y categoría.
2. **`get_product_detail`**:
   - Parámetros: `productId` (number, requerido).
   - Descripción: Retorna información exhaustiva de un producto específico.
3. **`get_low_stock_alerts`**:
   - Parámetros: ninguno.
   - Descripción: Retorna productos cuyo stock actual sea menor o igual a su umbral mínimo configurado.
4. **`get_sales_orders`**:
   - Parámetros: `limit` (number, opcional, por defecto 20).
   - Descripción: Retorna las últimas órdenes de compra registradas con sus ítems correspondientes.
5. **`get_warehouse_movements`**:
   - Parámetros: `limit` (number, opcional, por defecto 25).
   - Descripción: Retorna los movimientos de almacén y kardex auditables.

#### Resources & Resource Templates:
- **`nexus://inventory/summary`**: Resumen de alertas de stock bajo y estado global del almacén.
- **`nexus://sales/recent`**: Últimas órdenes procesadas en el ecommerce.
- **`nexus://products/{id}`**: Detalle de producto parametrizado por ID.
- **`nexus://sales/{id}`**: Detalle de orden y líneas de pedido parametrizado por ID.

---

## 3. Plan de Pruebas (Test Plan)

Se estructuran las pruebas automatizadas con **Vitest** en el backend para validar cada bounded context:
- **Pruebas Unitarias (`vitest run`)**:
  - `auth.service.spec.ts`: Generación de tokens, hash HMAC, validación de contraseñas y rotación de refresh tokens.
  - `products.service.spec.ts`: Creación, actualización, filtrado y validación de SKU duplicado.
  - `sales.service.spec.ts`: Creación de ventas, cálculo de totales, detección de stock insuficiente y rebaja de stock.
  - `warehouse.service.spec.ts`: Ajuste manual de stock, cálculo de alertas de stock bajo y kardex.
  - `oauth.service.spec.ts`: Validación de PKCE S256, ciclo de vida de códigos de autorización y emisión de token Bearer.
- **Pruebas E2E (`vitest run --config ./vitest.config.e2e.ts`)**:
  - `app.e2e-spec.ts`: Comprobación de ruta raíz y health status.
  - `auth-flow.e2e-spec.ts`: Flujo completo de login, refresh, me y logout.
  - `mcp-protocol.e2e-spec.ts`: Verificación de endpoint `/mcp` y metadatos OAuth `/.well-known/oauth-authorization-server`.

---

## 4. Plan de Contenerización Docker y Compose

1. **`backend/Dockerfile`**:
   - Multi-stage build con Node 22/24 Alpine.
   - Etapa `builder`: Instalación de dependencias completas, generación de build NestJS con `npm run build`.
   - Etapa `runner`: Imagen Alpine reducida con `tini` como gestor de subprocesos init (PID 1), dependencias de producción, usuario no-root para seguridad, puerto `4000` expuesto.
2. **`frontend/Dockerfile`**:
   - Multi-stage build con Node Alpine y Nginx Alpine.
   - Etapa `builder`: `next build` con exportación estática a `/out`.
   - Etapa `runner`: Nginx Alpine ligero sirviendo `/out` en puerto `80` (mapeado a `3001` en host), con configuración `default.conf` que incluye compresión Gzip, enrutamiento SPA y proxy reverso hacia `http://backend:4000/api/`, `/mcp`, `/oauth/`, `/.well-known/`.
3. **`docker-compose.yml`**:
   - Actualización de los servicios `backend` y `frontend` agregando directivas `build: { context: ..., dockerfile: Dockerfile }`.
   - Mantenimiento del servicio `postgres:16-alpine` y volumen persistente `db_postgres_data`.

---

## 5. Plan de Implementación Frontend (Next.js 16 + Vercel React Best Practices & Diseño Fresco)

Para asegurar una experiencia de usuario sobresaliente y cumplir con las pautas de ingeniería de Vercel (`vercel-react-best-practices`, `vercel-composition-patterns`), el frontend se concibe no como un simple CRUD plano, sino como un **Centro de Comando Ecommerce Moderno, Fresco y Altamente Visual**.

### 5.1 Principios de Rendimiento y Arquitectura Vercel
1. **Eliminación de Waterfalls (`async-parallel`)**:
   - Agrupación de solicitudes paralelas en la carga inicial (`Promise.all([fetchMetrics, fetchProducts, fetchOrders, fetchWarehouse])`) evitando encadenamientos innecesarios.
2. **Optimización de Re-renders (`rerender-state-derivation`)**:
   - Derivación reactiva de filtros, búsquedas y cálculos de márgenes durante el renderizado en lugar de sincronizarlos a través de `useEffect`.
3. **Patrones de Composición (`architecture-compound-components`)**:
   - Modularización en componentes desacoplados con responsabilidades únicas: `MetricStatCard`, `FilterSearchBar`, `ProductModal`, `OrderSaleModal`, `StockAdjustModal`, `TrustAnalysisCard`, `InvoicePreviewFrame`.
4. **Resiliencia y Modo Offline/Demo Inteligente**:
   - Manejo elegante de estados de red con loaders pulidos, notificaciones toast no intrusivas y sincronización de cookies/tokens con el backend.

### 5.2 Estética y Sistema de Diseño Visual Fresco
- **Look & Feel**: Diseño moderno inspirado en las mejores interfaces SaaS (Vercel, Raycast, Linear) con soporte nativo de modo oscuro (dark mode profundo `#090d16` con bordes sutiles `#1e293b` y acentos neón) y modo claro cristalino (`#f8fafc`).
- **Acentos Cromáticos Tailored**:
  - Indigo / Blur violeta para navegación y llamadas principales.
  - Emerald Green para ventas completadas, márgenes saludables y timbrado SDI.
  - Amber / Rose para alertas de stock bajo y anomalías de Trust.
  - Cyan para métricas de almacén y eventos MCP.
- **Glassmorphism y Micro-interacciones**:
  - Tarjetas con `backdrop-blur-md`, bordes translúcidos (`border-white/10`) y elevación con sombras suaves.
  - Pestañas con transiciones fluidas de hash (`#dashboard`, `#products`, `#sales`, `#warehouse`, `#openapi`).
  - Modales flotantes accesibles con cierre mediante tecla `Escape` y backdrop oscurecido.

### 5.3 Módulos de la Aplicación Frontend
1. **Dashboard Overview**:
   - Banner de bienvenida con resumen en tiempo real del estado del sistema y servidor MCP.
   - 4 Tarjetas de Métricas Principales (Ingresos Brutos, Ventas Totales, Productos en Catálogo, Unidades en Stock).
   - Tabla de actividad reciente con accesos directos de acción rápida.
2. **Gestión de Catálogo de Productos**:
   - Buscador en tiempo real por SKU o Nombre y selector de categoría.
   - Tabla estilizada con badges de estado (`active`, `out_of_stock`, `low_stock`).
   - Modal interactivo de creación y edición de producto con validación de precios y categorías dinámicas.
3. **Centro de Ventas y Pedidos**:
   - Historial de pedidos con indicador de timbrado de factura SDI y despacho de SMS.
   - **Gráfico de Rendimiento Financiero y Ganancias del Último Mes**: KPIs financieros (Ganancias Netas $4,892.40, Facturación $9,243.39, Margen 52.9%, AOV $308.11) y gráfico SVG interactivo con gradientes esmeralda/índigo y desglose semanal de ingresos vs costos.
   - Modal de "Nueva Venta" con selector de productos, cálculo automático de subtotal e impuestos, y selector de método de pago (`card`, `cash`, `transfer`, `paypal`).
4. **Control de Almacén y Kardex**:
   - Tarjetas de valorización financiera: Valor a precio de Costo vs. Valor a precio de Venta y Margen proyectado.
   - **Sección de Alertas Críticas de Unidades Bajas**: Monitorización específica de productos en riesgo crítico, destacando **`Teclado Mecánico Custom RGB`** (SKU `ELEC-TEC-003`, Stock: 3 / Mín: 8, Déficit: -5) con barra de nivel de stock y botón de acción rápida `⚡ Reabastecer (+10)` en tiempo real.
   - Auditoría inmutable de movimientos de almacén (Kardex: `IN`, `OUT`, `SALE`, `RETURN`) con timestamps legibles.
   - Modal de Ajuste Rápido de Stock.
5. **Suite OpenAPI & Comprobantes Oficiales**:
   - 5 Tarjetas modulares de servicios OpenAPI: Trust (Antifraude), Invoicing (SDI), Messaging (SMS), Utilities (PDF) y Auth (OAuth 2.1).
   - **Operaciones OpenAPI por Pedido**: Tabla interactiva con órdenes (`ORD-2026-003`, `ORD-2026-002`, `ORD-2026-001`), badges de estado para Factura SDI y SMS, y botones de acción rápida para timbrar factura, descargar PDF y despachar SMS.
   - **Comprobante Fiscal Oficial**: Corrección del enlace del botón "← Volver al Panel" para redirigir exactamente a `http://localhost:3001/#sales`.
6. **Autenticación, Tema y Vista Móvil**:
   - **Portal de Acceso (Login)**: Pantalla de login centrada y espaciosa con ambient glows, glassmorphism y caja destacada de credenciales del sistema (`admin@ecommerce.com` / `admin123`) con autocompletado en un clic.
   - **Botón de Salir (Logout)**: Función de cierre de sesión en desktop y móvil que invalida la sesión y regresa de inmediato al portal de acceso.
   - **Panel de Menú Móvil (Drawer)**: Cabecera móvil con botón hamburguesa `☰` y panel deslizante con navegación completa, contadores, estado MCP y botón de salida.
   - **Tema Claro / Oscuro**: Corrección de `@custom-variant dark` en Tailwind CSS v4 para garantizar legibilidad, contraste y diseño estético en modo claro.

---

## 6. Estado de Avance y Próximos Pasos

- [x] Análisis de recursos, logs, capturas y volcados SQL.
- [x] Creación de `planning.md` exhaustivo con inventario de rutas, controladores, servicios y tests.
- [x] Refactorización completa del backend NestJS reunificando agregados DDD (`src/db`, `src/auth`, `src/products`, `src/warehouse`, `src/sales`, `src/openapi`, `src/mcp`).
- [x] Pruebas unitarias en backend con Vitest (8 pruebas pasando al 100% de aserciones).
- [x] Creación de `backend/Dockerfile` multi-stage con Alpine y `tini` (PID 1).
- [x] Creación del frontend Next.js 16 con Vercel React Best Practices, diseño fresco, glassmorphism, microinteracciones y Suite OpenAPI integrada.
- [x] Creación de `frontend/Dockerfile` multi-stage (Next.js build estático + Nginx Alpine) y `nginx.conf` con proxy reverso.
- [x] Actualización de `docker-compose.yml` con `name: ecommerce` y `build: ...` para backend y frontend.
- [x] Generación de `AGENTS.MD` con especificación de herramientas MCP, recursos y OAuth 2.1 PKCE.
- [x] Generación de `ARCHITECTURE.MD` con arquitectura C4, Diagrama ER y secuencias Mermaid.
- [x] Corrección de tema claro (`@custom-variant dark`) e interfaces de alto contraste.
- [x] Implementación de panel lateral deslizante (Drawer) para navegación en vista móvil.
- [x] Portal de Login llamativo y espacioso con credenciales por defecto destacadas y botón de salida funcional.
- [x] Corrección de Alerta de Existencias: Eliminación de fallback estático y cálculo dinámico de los **Top 3 Productos con Menor Existencia / Bajo Stock** ordenados por ratio de existencias sobre stock mínimo y reabastecimiento en vivo (+10).
- [x] Persistencia de Sesión al Actualizar (F5): Implementación de almacenamiento en `localStorage` (`nexus_user` y `nexus_token`), inyección de cabecera `Authorization: Bearer` en `fetchApi` y renovación automática por cookie HttpOnly.
- [x] Población Masiva de Base de Datos: Script `seed-expanded.ts` ejecutado exitosamente con 10+ registros por tabla (20 productos, 25 movimientos Kardex, 13 clientes, 14 pedidos, 27 líneas de pedido, 12 facturas SDI, 11 logs de notificación).
- [x] Gráfico Dinámico de Ventas, Capitalización y Proyección: Cálculo en tiempo real de facturación ejecutada, ganancias netas reales, valorización de inventario a costo (capitalización) y precio de venta (ventas proyectadas), margen de capitalización dinámico y curvas SVG adaptadas a los pedidos reales en 4 semanas.
- [x] Reconstrucción y despliegue en Docker: Contenedores `ecommerce_backend`, `ecommerce_frontend` y `ecommerce_postgres` activos y sincronizados.
- [x] Actualización de `planning.md` y `walkthrough.md`.

---

## 7. Verificación de Requerimientos Recientes

1. **Top 3 Productos con Bajo Stock en Almacén**:
   - Algoritmo dinámico `useMemo`: ordena el inventario por ratio `stock / minStock` ascendente y toma los 3 primeros.
   - Si el producto tiene déficit (`stock <= minStock`), muestra badge rojo de riesgo crítico y unidades faltantes.
   - Al pulsar `⚡ Reabastecer (+10)`, se emite `POST /api/warehouse/adjust` con tipo `IN`, el stock en base de datos sube de inmediato y la lista se reorganiza automáticamente sin fallbacks estáticos.
2. **Persistencia de Autenticación**:
   - `fetchApi` adjunta automáticamente el token guardado en `localStorage`.
   - El estado inicial de `user` en React se hidrata inmediatamente desde `localStorage`, eliminando el parpadeo y la solicitud de login al presionar F5 o refrescar la página.
3. **Población de Datos en Tablas PostgreSQL**:
   - `products`: 20 registros activos.
   - `inventory_movements`: 25 movimientos históricos (`IN`, `OUT`, `RETURN`, `SALE`).
   - `customers`: 13 clientes verificados con `tax_id` y `trust_score`.
   - `orders` & `order_items`: 14 pedidos con 27 ítems detallados.
   - `electronic_invoices`: 12 comprobantes fiscales con identificador SDI.
   - `notification_logs`: 11 notificaciones SMS/WhatsApp enviadas.
4. **Gráfico Dinámico de Ventas & Capitalización**:
   - Tarjetas KPI: Ganancias Netas Reales, Facturación Total, Ventas Proyectadas (Almacén) y Margen Previsto de Capitalización.
   - Gráfico SVG con curvas Bézier cúbicas generadas dinámicamente a partir de los pedidos agrupados cronológicamente en las últimas 4 semanas.
   - Actualización en caliente: al registrar ventas o movimientos de almacén, los montos y curvas se recalculan al instante.

---

## 8. Procedimiento de Población de Base de Datos (`seed-expanded`)

Para inicializar y poblar la base de datos con los datos completos de prueba (+10 registros por tabla, movimientos de Kardex con entradas, salidas, mermas y devoluciones, órdenes de venta y facturación electrónica):

### 8.1 Scripts NPM Integrados en Backend
En `backend/package.json` se definieron los comandos:
- `npm run seed`: Carga el catálogo inicial base.
- `npm run seed:admin`: Asegura la existencia del usuario administrador (`admin@ecommerce.com` / `admin123`).
- `npm run seed:expanded`: Ejecuta la población masiva e idempotente de 20 productos, 25 movimientos de Kardex, 13 clientes, 14 pedidos, 27 líneas de venta, 12 facturas SDI y 11 logs de notificación.

### 8.2 Comandos de Ejecución en Entornos Docker / VM de Producción
```bash
# Opción 1: Ejecución estándar mediante Docker Compose
docker compose exec backend npm run seed:expanded

# Opción 2: Ejecución directa en el contenedor backend
docker exec -it ecommerce_backend node dist/db/seed-expanded.js

# Opción 3: Ejecución mediante node -e con import dinámico
docker exec -it ecommerce_backend node -e "import('./dist/db/seed-expanded.js')"
```

> [!NOTE]
> El script `seed-expanded.ts` cuenta con control de idempotencia mediante Drizzle ORM (`eq(schema.products.sku, 'ELEC-MON-005')`). Si el script ya ha sido ejecutado en la base de datos destino, abortará limpiamente sin producir violaciones de unicidad de clave.

---

## 9. Actualizaciones y Mejoras del Día (2026-10-17)

### 9.1 Gestión de Estados de Pedidos en Ventas ("En Proceso" / "Completado")
- **Control de Estado en Backend (`SalesContext`)**:
  - Actualización de `CreateOrderSchema` y `CreateOrderDto` con soporte para `status` (`completed`, `processing`, `pending`, `cancelled`).
  - Validación de estados en `PATCH /api/sales/:id/status` con excepción explícita si el estado es inválido.
- **Visualización y Filtrado en Frontend (`Next.js`)**:
  - Incorporación de columna interactiva **Estado** en la tabla principal de Ventas y Pedidos.
  - Insignia y selector directo que permite alternar con un clic entre **"⏳ En Proceso"** (`processing`, con tono ámbar) y **"✓ Completado"** (`completed`, con tono esmeralda).
  - Píldoras de filtrado dinámico en la cabecera: **"Todos"**, **"⏳ En Proceso"** y **"✓ Completados"** con contadores en tiempo real.
  - Selector de estado inicial en el modal de **Registrar Nueva Venta / Pedido**.
  - Actualización del indicador de estado en la tabla de órdenes recientes del Dashboard.

### 9.2 Validación Estricta de Almacén y Visualización de Salidas Kárdex
- **Auditoría en Base de Datos PostgreSQL**:
  - Consulta ejecutada: `SELECT id, sku, name, stock, min_stock FROM products WHERE stock <= min_stock;`.
  - Resultado confirmado: Únicamente 2 productos (`AUD-MIC-001` con 3/10 y `ELEC-CAM-006` con 4/12) presentan déficit crítico real. El producto `ELEC-MON-005` (stock 12 / mín 8, ratio 1.50) no presenta riesgo.
- **Validación Estricta de Tarjetas en Almacén**:
  - Se eliminó el `slice(0, 3)` indiscriminado sobre el catálogo total. Ahora se evalúa exclusivamente `criticalDeficitProducts` (`stock <= minStock`).
  - Si existen 2 productos críticos, se renderizan exactamente **2 tarjetas** adaptadas con layout de 2 columnas (`md:grid-cols-2`) y badge **"2 ÍTEMS EN RIESGO CRÍTICO"**.
- **Comportamiento Dinámico de Fallback (Últimas 3 Salidas)**:
  - Cuando no existen productos en riesgo crítico (por ejemplo, tras reabastecer las unidades o tener stock saludable en el 100% del catálogo), la sección conmuta automáticamente hacia **"Últimas 3 Salidas de Almacén (Despachos y Bajas)"**.
  - Muestra las 3 salidas más recientes registradas en el Kárdex (`type IN ('OUT', 'SALE')`), detallando cantidad egresada (`-X un.`), evolución de existencias, motivo, referencia y fecha, acompañado del badge **"0 ÍTEMS EN RIESGO · INVENTARIO SALUDABLE"**.

---

## 10. Fase de Refactorización Integral: Configuración Centralizada, Optimización Backend y Descomposición Modular Frontend (2026-10-17)

### 10.1 Objetivos de la Refactorización
1. **Centralización de Configuración Tipada (`backend/src/config/env.config.ts`)**:
   - Extraer todos los accesos directos a `process.env` dispersos en el código.
   - Eliminar orígenes y dominios de terceros hardcodeados (`https://frontend.josedaniel.online` en CORS y `backend.josedaniel.online` en cabeceras MCP).
   - Preservar exclusivamente los orígenes locales seguros por defecto (`localhost`, `127.0.0.1`, `[::1]`) y permitir extender orígenes dinámicamente mediante `CORS_ALLOWED_ORIGINS` y `MCP_ALLOWED_HOSTS`.
   - Estandarizar el secreto OAuth exclusivamente en `JWT_SECRET_OAUTH`, eliminando toda referencia al anterior `JWT_SECRET`.
   - Declarar exhaustivamente todas las variables en [docker-compose.yml](file:///home/jose/Proyectos/ecommerce_ventas/docker-compose.yml) y [.env.example](file:///home/jose/Proyectos/ecommerce_ventas/.env.example).

2. **Optimización de Servicios Backend (NestJS / Drizzle ORM)**:
   - **Resolución de N+1 en Ventas**: Optimizar `SalesService.findAll()` reemplazando las consultas individuales en `Promise.all` por una consulta batch unificada con `inArray(schema.orderItems.orderId, orderIds)`.
   - **Búsqueda Combinada en Productos**: Permitir que `ProductsService.findAll(search, categoryId)` filtre simultáneamente por coincidencia de texto y categoría mediante composición lógica `and(...)`.
   - **Tipado estricto y desacoplamiento**: Inyección de configuración centralizada en `AuthService`, `OAuth2Service`, `McpController`, `OpenApiService`, `DrizzleService` y `main.ts`.

3. **Descomposición Modular del Frontend (Next.js 16 / Vercel React Best Practices)**:
   - Desacoplar el archivo monolítico `frontend/app/page.tsx` (~3,000 líneas) en una arquitectura de componentes modulares de alta cohesión:
     - `frontend/app/types/index.ts`: Interfaces canónicas (`User`, `Product`, `Order`, `InventoryMovement`, `WarehouseOverview`, `SalesMetrics`).
     - `frontend/app/services/api.ts`: Cliente HTTP `fetchApi` desacoplado con soporte configurable para `NEXT_PUBLIC_API_URL`.
     - `frontend/app/components/layout/`: `Header.tsx`, `Sidebar.tsx`, `Toast.tsx`.
     - `frontend/app/components/auth/`: `LoginModal.tsx`.
     - `frontend/app/components/dashboard/`: `DashboardTab.tsx` (KPIs, curvas SVG reactivas y pedidos recientes).
     - `frontend/app/components/products/`: `ProductsTab.tsx` y `ProductModal.tsx`.
     - `frontend/app/components/sales/`: `SalesTab.tsx` y `NewSaleModal.tsx`.
     - `frontend/app/components/warehouse/`: `WarehouseTab.tsx` y `StockAdjustModal.tsx`.
     - `frontend/app/components/openapi/`: `OpenApiTab.tsx` e `InvoicePdfModal.tsx`.
     - `frontend/app/page.tsx`: Orquestador principal limpio, ligero y mantenible.
   - Aplicación rigurosa de directrices Vercel: reducción de re-renders mediante `useMemo` y `useCallback`, estados derivados sin dependencias cíclicas, y accesibilidad ARIA completa con soporte de tecla Escape en modales.




---

## 11. Actualización de Dependencias, Contenedores Node.js 26, PostgreSQL 18 y Documentación (2026-10-17)

### 11.1 Objetivos de la Tarea
1. **Actualización Integral de Dependencias**:
   - **Backend**: Actualizar todas las dependencias del ecosistema a sus versiones más recientes compatibles (@modelcontextprotocol/sdk@1.32.1, @nestjs/*@12.1.3, @types/node@^26.6.5, drizzle-orm@0.45.4, express@5.3.0, pg@8.23.1, zod@4.6.7, vitest@5.0.5, @vitest/coverage-v8@5.0.5, vite-tsconfig-paths@6.1.1, vite@7.3.1, dotenv@18.0.8). Mantener typescript@^6.0.3 por compatibilidad estricta requerida por el compilador programático de NestJS CLI (@nestjs/cli).
   - **Frontend**: Actualizar a next@16.4.2, react@19.3.1, react-dom@19.3.1, eslint-config-next@16.4.2, @types/node@^26.6.5.
   - **Linter y React 19 Compiler**: Ajustar configuración en eslint.config.mjs y sanear variables no utilizadas (dataLoading) en frontend/app/page.tsx para lograr 0 errores y 0 warnings en npm run lint.

2. **Actualización de Entornos Contenerizados**:
   - **backend/Dockerfile**: Elevar etapas builder y runner a node:26-alpine.
   - **frontend/Dockerfile**: Implementar multi-stage con node:26-alpine (builder) con soporte para build argument NEXT_PUBLIC_API_URL y nginx:alpine (runner).
   - **docker-compose.yml**: Elevar el servicio postgres a la imagen oficial postgres:18-alpine con healthcheck pg_isready y persistencia en volumen db_postgres_data.

3. **Sincronización de Especificaciones Técnicas**:
   - **ARCHITECTURE.MD**: Actualizar diagramas C4 y descripciones de contenedores reflejando Node.js 26 Alpine, PostgreSQL 18, y la arquitectura modular del frontend.
   - **AGENTS.MD**: Incorporar la Sección 6 con el entorno de ejecución contenerizado, Node 26, persistencia PostgreSQL 18, variables de entorno MCP y secreto dedicado JWT_SECRET_OAUTH.

### 11.2 Plan de Verificación y Criterios de Aceptación
- [x] npm test en backend ejecuta los 8 tests unitarios pasando exitosamente con Vitest 5.
- [x] npm run build en backend (nest build) compila con código de salida 0.
- [x] npm run lint en frontend pasa con 0 errores y 0 warnings.
- [x] npm run build en frontend (next build con Turbopack) compila 4/4 páginas estáticas sin fallas.
- [x] backend/Dockerfile y frontend/Dockerfile configurados con node:26-alpine.
- [x] docker-compose.yml configurado con postgres:18-alpine.
- [x] ARCHITECTURE.MD y AGENTS.MD actualizados con las nuevas versiones y directrices.
