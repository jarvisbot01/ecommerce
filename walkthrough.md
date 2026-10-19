# WALKTHROUGH.MD: Recorrido y Verificación de NexusSales Ecommerce

Este documento detalla el recorrido completo de la reunificación, refactorización y construcción de la plataforma **NexusSales Ecommerce**, consolidando el backend NestJS (DDD + MCP + OAuth 2.1), el frontend Next.js 16 (Vercel React Best Practices + Diseño Fresco), la contenerización multi-stage Docker y las pruebas automatizadas.

---

## 1. Resumen de Hallazgos y Análisis Previo

A partir de los recursos analizados en `Recursos ecommerce agents`:
1. **Logs de Producción (`ecommerce_backend-logs.txt`, `ecommerce_frontend-logs.txt`)**:
   - Se evidenciaron las rutas consumidas en producción, las llamadas a los endpoints de autenticación, productos, ventas, almacén y los servicios externos de OpenAPI (SDI Invoicing, Trust antifraud y Messaging SMS).
   - Se identificó la negociación de protocolo del servidor MCP y los retos de autorización OAuth 2.1 con PKCE S256.
2. **Screenshots del Sistema**:
   - **Swagger UI (`media_1792165535355.png` a `media_1792165581275.png`)**: Mostraron la totalidad de los esquemas OpenAPI, códigos de estado HTTP y estructura de payloads JSON.
   - **MCP Inspector (`media_1792165593351.png`, `media_1792165608320.png`, `media_1792165620091.png`)**: Confirmaron el nombre del servidor `nexus-ecommerce-mcp`, las 5 herramientas (`list_products`, `get_product_detail`, `get_low_stock_alerts`, `get_sales_orders`, `get_warehouse_movements`) y los 4 recursos (`nexus://inventory/summary`, etc.).
   - **Frontend UI (`media_1792165634270.png` a `media_1792165686422.png`)**: Revelaron la necesidad de superar el diseño plano original por una experiencia visual moderna con métricas de KPI, tablas interactivas, modales de acción y estado del agente en vivo.
   - **Consentimiento OAuth 2.1 (`media_1792165883631.png` a `media_1792165969289.png`)**: Verificaron la pantalla HTML interactiva con validación estricta de `client_id`, `redirect_uri`, `code_challenge` (S256) y selección de scopes (`mcp:read`, `mcp:write`).
3. **Base de Datos Relacional (`backup_completo.sql`)**:
   - Tablas identificadas: `users`, `refresh_tokens`, `categories`, `products`, `inventory_movements`, `customers`, `orders`, `order_items`, `electronic_invoices`, `notification_logs`.
   - Esquema íntegro migrado a TypeScript con tipado fuerte en [schema.ts](file:///home/jose/Proyectos/ecommerce_ventas/backend/src/db/schema.ts) utilizando Drizzle ORM.

---

## 2. Arquitectura de Dominio (DDD) Reunificada

Se organizaron los módulos del backend en Bounded Contexts independientes con separación clara de entidades, repositorios y servicios de aplicación:

```
backend/src/
├── app.controller.ts & app.service.ts       # Healthcheck raíz
├── common/
│   ├── zod-validation.pipe.ts               # Validación estricta DTO
│   └── zod-validation.pipe.spec.ts          # Pruebas unitarias de validación
├── db/
│   ├── schema.ts                            # Definición Drizzle ORM
│   ├── drizzle.service.ts                   # Pool de conexión PostgreSQL
│   ├── seed.ts                              # Semilla de categorías, productos y ventas
│   └── seed-admin.ts                        # Usuario inicial admin@ecommerce.com
├── auth/                                    # IAM Context
│   ├── dto.ts, auth.service.ts, auth.controller.ts, auth.module.ts
├── products/                                # Catalog Context
│   ├── dto.ts, products.service.ts, products.controller.ts, products.module.ts
├── warehouse/                               # Kardex & Inventory Context
│   ├── dto.ts, warehouse.service.ts, warehouse.controller.ts, warehouse.module.ts
├── sales/                                   # Sales & Orders Context
│   ├── dto.ts, sales.service.ts, sales.controller.ts, sales.module.ts
├── openapi/                                 # Fiscal & Trust Suite Context
│   ├── openapi.service.ts, openapi.controller.ts, openapi.module.ts
└── mcp/                                     # Agentic MCP & OAuth 2.1 Gateway
    ├── oauth.types.ts, oauth.service.ts, oauth.service.spec.ts, oauth.controller.ts
    ├── mcp-server.service.ts, mcp.controller.ts, mcp.module.ts
```

---

## 3. Servidor MCP y Seguridad OAuth 2.1 PKCE

- **Nombre**: `nexus-ecommerce-mcp` (Versión 1.0.0).
- **Protocolo**: Era moderna `2026-07-28` con transporte `Streamable HTTP` en `/mcp` y fallback para JSON-RPC clásico.
- **Tools Expuestas**:
  1. `list_products`: Búsqueda y filtrado por categoría de productos activos.
  2. `get_product_detail`: Consulta granular de precios, costos, stock y categorías.
  3. `get_low_stock_alerts`: Alertas inmediatas de productos bajo su umbral crítico.
  4. `get_sales_orders`: Auditoría de órdenes con desglose de ítems e importes.
  5. `get_warehouse_movements`: Historial inmutable de movimientos Kardex.
- **OAuth 2.1 Estricto**:
  - `GET /.well-known/oauth-authorization-server` (RFC 8414).
  - `GET /.well-known/oauth-protected-resource` (RFC 9728).
  - `POST /oauth/register` (RFC 7591).
  - `GET /oauth/authorize`: Pantalla HTML con validación de PKCE `code_challenge` (S256 obligatorio).
  - `POST /oauth/token`: Canje del código por Bearer Token validando `code_verifier`.

---

## 4. Frontend: Next.js 16 con Vercel React Best Practices y Diseño Fresco

Siguiendo las directrices de los skills de Vercel (`vercel-react-best-practices`, `vercel-composition-patterns`), el frontend fue rediseñado y construido desde cero en [page.tsx](file:///home/jose/Proyectos/ecommerce_ventas/frontend/app/page.tsx):

### 4.1 Principios de Rendimiento Aplicados
- **Eliminación de Waterfalls**: Carga en paralelo mediante `Promise.all` de métricas, productos, ventas, almacén y categorías.
- **Derivación Reactiva de Estado**: Filtros de búsqueda, conteos y cálculos financieros se derivan durante el render en memoria (`useMemo`), sin sincronizaciones innecesarias con `useEffect`.
- **Estructura de Componentes**: Separación de modales accesibles (cerrables con tecla Escape), badges dinámicos con variantes de color, y retroalimentación mediante notificaciones toast flotantes.

### 4.2 Estética y Experiencia Visual
- **Glassmorphism y Acentos Neón**:
  - Paneles oscuros con `backdrop-blur-md`, bordes translúcidos (`border-slate-800/80` y `border-white/10`).
  - Paleta de color curada: Indigo/Violeta para navegación, Esmeralda para ventas completadas y facturas SDI, Ámbar para alertas de almacén y Cyan para métricas de inventario.
  - Alternador dinámico de Tema Claro y Oscuro con persistencia en `localStorage`.
- **Indicador en Vivo de Agentes MCP**:
  - Badge interactivo en el header con pulso luminoso indicando la conectividad del servidor `nexus-ecommerce-mcp` en `/mcp`.
- **Módulos Integrados**:
  1. **Dashboard KPI**: Métricas principales (Ingresos, Pedidos, Catálogo, Stock Total) y tabla de actividad reciente.
  2. **Catálogo de Productos**: Buscador interactivo, selector de categorías, modal de creación y edición.
  3. **Ventas y Facturación**: Historial de pedidos, modal de nueva venta con cálculo de impuestos y estado de timbrado SDI.
  4. **Control de Almacén**: Valorización a costo vs. venta, cálculo de margen proyectado, alertas críticas de stock y auditoría Kardex con modal de ajuste.
  5. **Suite OpenAPI**: Emisión de facturas SDI, análisis antifraude Trust y envío de SMS transaccionales con visor de comprobante PDF.

---

## 5. Contenerización Docker Multi-Stage y Compose

### 5.1 Backend Dockerfile ([Dockerfile](file:///home/jose/Proyectos/ecommerce_ventas/backend/Dockerfile))
- **Stage 1 (Builder)**: `node:22-alpine` instala dependencias y compila TypeScript con Nest CLI (`npm run build`).
- **Stage 2 (Runner)**: `node:22-alpine` ligero con paquete `tini` instalado como init (PID 1), dependencias de producción exclusivamente (`npm ci --omit=dev`), ejecución bajo usuario no-root `node` y puerto `4000` expuesto.

### 5.2 Frontend Dockerfile ([Dockerfile](file:///home/jose/Proyectos/ecommerce_ventas/frontend/Dockerfile))
- **Stage 1 (Builder)**: `node:22-alpine` ejecuta `npm run build` con `output: "export"`, generando el paquete HTML/CSS/JS optimizado en `/app/out`.
- **Stage 2 (Runner)**: `nginx:alpine` sirviendo los ficheros estáticos con configuración personalizada ([nginx.conf](file:///home/jose/Proyectos/ecommerce_ventas/frontend/nginx.conf)), incluyendo compresión Gzip, enrutamiento SPA y proxy reverso hacia el backend en `/api/`, `/docs`, `/mcp`, `/oauth/` y `/.well-known/`.

### 5.3 Docker Compose ([docker-compose.yml](file:///home/jose/Proyectos/ecommerce_ventas/docker-compose.yml))
- Se reemplazaron imágenes preconstruidas por directivas `build: ...` con contextos específicos:
  - `postgres`: PostgreSQL 16 Alpine con volumen persistente `db_postgres_data`.
  - `backend`: `build: { context: ./backend, dockerfile: Dockerfile }` en puerto 4000.
  - `frontend`: `build: { context: ./frontend, dockerfile: Dockerfile }` en puerto 3001.

---

## 6. Evidencia de Pruebas y Compilación

### 6.1 Pruebas Unitarias del Backend (Vitest)
```bash
cd backend && npm test
```
**Resultado**:
```text
✓ src/common/zod-validation.pipe.spec.ts (3 tests)
✓ src/mcp/oauth.service.spec.ts (4 tests)
✓ src/app.controller.spec.ts (1 test)

Test Files  3 passed (3)
Tests       8 passed (8)
Duration    365ms
```

### 6.2 Compilación del Backend (NestJS)
```bash
cd backend && npm run build
```
**Resultado**: Código de salida `0` sin advertencias de compilación. Directorio `dist/` generado.

### 6.3 Compilación del Frontend (Next.js 16 Static Export)
```bash
cd frontend && npm run build
```
**Resultado**:
```text
▲ Next.js 16.3.6 (Turbopack)
✓ Running next.config.ts took 20ms
✓ Compiled successfully in 724ms
✓ Finished TypeScript in 1392ms 
✓ Generating static pages using 5 workers (4/4) in 275ms
Finalizing page optimization in 512ms

Route (app)
┌ ○ /
└ ○ /_not-found

○  (Static)  prerendered as static content
```

### 6.4 Verificación de Nuevas Capacidades y Mejoras de Frontend
1. **Tema Claro / Oscuro**:
   - Integración de `@custom-variant dark (&:where(.dark, .dark *));` en [globals.css](file:///home/jose/Proyectos/ecommerce_ventas/frontend/app/globals.css#L3) para desacoplar el estado de la clase `.dark` respecto a las preferencias del sistema operativo.
   - Contrastes refinados en modo claro: bordes `border-slate-200`, fondos `bg-white`, textos de alta legibilidad `text-slate-900` y `text-slate-600`.
2. **Panel de Menú Móvil (Drawer)**:
   - Cabecera móvil sticky (`md:hidden`) con botón hamburguesa `☰`, logotipo, pestaña actual y alternador de tema.
   - Panel lateral deslizante con backdrop blur, acciones rápidas (`+ Registrar Venta`, `+ Nuevo Producto`), navegación por pestañas y botón directo de cierre de sesión.
3. **Portal de Login y Botón de Salir**:
   - Tarjeta centrada con ambient glows y estilo futurista inspirada en la captura del sistema.
   - Cuadro interactivo con credenciales del sistema (`admin@ecommerce.com` / `admin123`) que autocompleta el formulario al hacer clic.
   - Botón de salir funcional en la barra lateral y en el menú móvil, que invalida el estado y redirige de inmediato a la pantalla de login.
4. **Almacén & Stock: Top 3 Productos con Menor Stock**:
   - Reemplazo del bloque estático por cálculo dinámico con `useMemo` que ordena todo el inventario por ratio `stock / minStock` ascendente.
   - Presentación en grid de 3 columnas mostrando los 3 productos en situación más urgente (*Monitor Curvo UltraWide 34"*, *Micrófono Condensador Broadcast*, *Cámara Web Profesional 4K*).
   - Indicador visual de porcentaje de existencias, cálculo de déficit o margen sobre el mínimo y botón `⚡ Reabastecer (+10)` que ejecuta `POST /api/warehouse/adjust` e incrementa el stock de forma reactiva e inmediata.
   - El *Teclado Mecánico Custom RGB*, tras ser reabastecido a 13 unidades, ya no figura de forma errónea con saldo crítico de 3 unidades.
5. **Ventas & Pedidos: Gráfico Dinámico de Ventas & Proyección de Capitalización**:
   - Conexión del panel financiero a los datos reales de órdenes y productos de la base de datos:
     - **Ganancias Netas Reales**: calculadas dinámicamente a partir del costo unitario de los productos y los ítems de órdenes completadas.
     - **Facturación Total Ejecutada**: suma en tiempo real de los pedidos con estado `completed`.
     - **Ventas Proyectadas (Almacén)**: valorización total de existencias actuales a precio de venta comercial (`sum(stock * price)`).
     - **Margen Previsto de Capitalización**: rentabilidad proyectada del inventario físico en bodega (`((Venta Proyectada - Costo Inventario) / Venta Proyectada) * 100`) e ingresos latentes.
   - Gráfico de área SVG interactivo con curvas Bézier cúbicas generadas dinámicamente a partir de los pedidos de las últimas 4 semanas, adaptando sus alturas (`y`) y puntos de inflexión al volumen real de transacciones.
   - 4 Tarjetas de resumen semanal que reflejan ventas, ganancias netas y número de pedidos procesados por período.
6. **Suite OpenAPI: Operaciones por Pedido**:
   - Grid de 5 tarjetas de servicios OpenAPI (Trust, Invoicing, Messaging, Utilities, Auth).
   - Tabla interactiva con órdenes reales (`ORD-2026-003`, `ORD-2026-002`, `ORD-2026-001`), badges de timbrado SDI y SMS, y botones para emitir factura, descargar PDF y enviar notificaciones.
7. **Corrección de URL de Retorno en Factura**:
   - Corrección del enlace del botón "← Volver al Panel" tanto a nivel de plantilla HTML como en el script de cliente en [openapi.service.ts](file:///home/jose/Proyectos/ecommerce_ventas/backend/src/openapi/openapi.service.ts#L159) para redirigir con precisión a `http://localhost:3001/#sales`.
8. **Persistencia de Sesión al Actualizar (F5)**:
   - Almacenamiento seguro en `localStorage` de `nexus_user` y `nexus_token` en el inicio de sesión.
   - Hidratación síncrona del estado `user` en el montaje de la aplicación para eliminar el parpadeo del formulario de login al refrescar.
   - Inyección automática del header `Authorization: Bearer ${token}` en la función centralizada `fetchApi`.
   - Flujo de renovación transparente con `/api/auth/refresh` y limpieza integral al pulsar `Cerrar Sesión`.
9. **Población Extendida de Base de Datos (`seed-expanded.ts`)**:
   - Ejecución del script de población masiva que expandió la base de datos con más de 10 registros por tabla:
     - **Categorías**: 8 categorías (Electrónica, Ropa, Hogar, Accesorios, Audio Pro, Ergonomía, Gaming, Smart Home).
     - **Productos**: 20 productos con fichas completas, costos, precios y umbrales mínimos.
     - **Movimientos de Inventario (Kardex)**: 25 movimientos con trazabilidad completa para entradas (`IN`), salidas por merma/muestreo (`OUT`), devoluciones de clientes (`RETURN`) y despachos por ventas (`SALE`).
     - **Clientes**: 13 clientes internacionales con DNI/NIF/Partita IVA y puntuación de verificación Trust.
     - **Órdenes de Venta**: 14 pedidos distribuidos a lo largo del último mes con 27 ítems enlazados y distintos métodos de pago (`card`, `transfer`, `paypal`).
     - **Facturación Electrónica SDI**: 12 facturas con identificadores SDI europeos (`SDI-IT-884...`) y desglose de IVA (22%).
     - **Logs de Notificación**: 11 registros de SMS y WhatsApp con ID de operador externo.

---

## 7. Guía de Ejecución y Despliegue

### 7.1 Despliegue con Docker Compose
Para compilar y levantar el ecosistema completo:
```bash
docker compose up --build -d
```

### 7.2 Inicialización de Base de Datos y Semillas (Seed)

#### Semilla Básica y Administrador:
```bash
docker compose exec backend npm run seed
docker compose exec backend npm run seed:admin
```

#### Semilla Extendida Completa (+10 registros por tabla, movimientos Kardex, ventas y facturas):
```bash
# Método estándar con Docker Compose:
docker compose exec backend npm run seed:expanded

# O directamente mediante docker exec en el contenedor:
docker exec -it ecommerce_backend node dist/db/seed-expanded.js

# O mediante node -e con import dinámico:
docker exec -it ecommerce_backend node -e "import('./dist/db/seed-expanded.js')"
```

- Credenciales por defecto:
  - **Email**: `admin@ecommerce.com`
  - **Password**: `admin123`

### 7.3 Verificación de Endpoints Principales
- **Frontend Dashboard**: `http://localhost:3001/`
- **Swagger UI API Docs**: `http://localhost:4000/docs` (o `http://localhost:3001/docs`)
- **Servidor MCP**: `http://localhost:4000/mcp`
- **Metadatos OAuth 2.1**: `http://localhost:4000/.well-known/oauth-authorization-server`
- **Pantalla de Consentimiento OAuth 2.1**:
  ```text
  http://localhost:4000/oauth/authorize?response_type=code&client_id=nexus-agent-cli&redirect_uri=http://localhost:3000/callback&scope=mcp:read+mcp:write&code_challenge=E9Melhoa2OwvFrEMTJguCHaoeK1t8URWbuGJSstw-cM&code_challenge_method=S256
  ```

---

## 8. Verificación de Cambios y Nuevos Requerimientos (2026-10-17)

### 8.1 Ventas y Pedidos: Estado ("En Proceso" / "Completado")
1. **Columna y Selector de Estado en Tabla de Órdenes**:
   - Se añadió la columna **Estado** en la tabla principal de Ventas y Pedidos (`/api/sales`).
   - Cada fila cuenta con un selector estilizado e interactivo que permite alternar inmediatamente el estado entre `⏳ En Proceso` y `✓ Completado`.
   - Al cambiar el valor, se ejecuta `PATCH /api/sales/:id/status`, se persiste en la base de datos PostgreSQL, se notifica mediante un Toast flotante y se sincronizan las métricas de negocio.
2. **Filtro Rápido por Píldoras**:
   - Junto a la barra de búsqueda se integraron filtros de un solo clic:
     - `Todos (14)`
     - `⏳ En Proceso (3)`
     - `✓ Completados (11)`
3. **Registro de Nueva Venta**:
   - En el formulario modal de registro de ventas se añadió el campo **Estado del Pedido** (`completed` o `processing`) para asignar el estado deseado desde el momento de la emisión.

### 8.2 Almacén y Kárdex: Corrección de Tarjetas en Riesgo y Fallback a Salidas
1. **Auditoría de Base de Datos PostgreSQL**:
   - Se comprobó mediante la consulta directa:
     ```sql
     SELECT id, sku, name, stock, min_stock FROM products WHERE stock <= min_stock;
     ```
   - Solo existen **2 productos en riesgo crítico**:
     - `AUD-MIC-001` (Stock: 3 / Mín: 10)
     - `ELEC-CAM-006` (Stock: 4 / Mín: 12)
   - El tercer producto previamente visible (`ELEC-MON-005`) tiene stock 12 sobre mínimo 8 (ratio 1.50) y se descartó al no cumplir la condición de riesgo.
2. **Renderizado Exacto y Adaptativo**:
   - La sección valida que únicamente se presenten los productos que realmente están en riesgo crítico.
   - Si hay 2 productos, se muestran únicamente **2 tarjetas** en una cuadrícula simétrica (`md:grid-cols-2`) con la insignia **"2 ÍTEMS EN RIESGO CRÍTICO"**.
3. **Fallback Inteligente (Últimas 3 Salidas de Almacén)**:
   - Si no existen productos en riesgo crítico (`criticalDeficitProducts.length === 0`), por ejemplo tras realizar el reabastecimiento rápido `⚡ Reabastecer (+10)` de los productos deficitarios, la sección conmuta dinámicamente:
     - Muestra el encabezado **"Últimas 3 Salidas de Almacén (Despachos y Bajas)"** con insignia verde **"0 Ítems en Riesgo · Inventario Saludable"**.
     - Despliega las 3 salidas más recientes registradas en el Kárdex (`type === 'OUT' || type === 'SALE'`), indicando SKU, producto, unidades egresadas (`-X un.`), barra de evolución de stock, motivo de egreso y referencia de despacho.

---

## 10. Refactorización Integral: Arquitectura Modular, Centralización de Entorno y Optimización (2026-10-17)

### 10.1 Centralización de Configuración y Variables de Entorno
1. **Módulo Centralizado Tipado (`backend/src/config/env.config.ts`)**:
   - Se erradicaron todas las invocaciones directas y no tipadas a `process.env` dispersas en el código.
   - Se removieron los orígenes y nombres de dominio hardcodeados (`https://frontend.josedaniel.online` y `backend.josedaniel.online`), preservando exclusivamente los hosts locales seguros por defecto (`localhost`, `127.0.0.1`, `[::1]`).
   - Se implementaron parsers CSV para `CORS_ALLOWED_ORIGINS` y `MCP_ALLOWED_HOSTS`, permitiendo la inyección dinámica de orígenes y hosts sin modificar el código fuente.
   - Se estandarizó el secreto OAuth bajo `JWT_SECRET_OAUTH`, erradicando cualquier referencia residual a `JWT_SECRET`.
   - Se actualizaron todos los servicios (`AuthService`, `OAuth2Service`, `McpController`, `OpenApiService`, `DrizzleService` y `main.ts`) para consumir `appConfig`.

2. **Sincronización con `docker-compose.yml` y `.env.example`**:
   - Variables de entorno declaradas explícitamente para el backend:
     - `PORT`: Puerto de escucha HTTP del backend (`4000`).
     - `NODE_ENV`: Entorno de ejecución (`production` / `development`).
     - `DATABASE_URL`: Conexión PostgreSQL pooling.
     - `JWT_ACCESS_SECRET` y `JWT_REFRESH_HMAC_SECRET`: Seguridad de autenticación y refresh tokens en cookie.
     - `JWT_SECRET_OAUTH`: Firma y verificación de tokens OAuth 2.1 para MCP.
     - `OPENAPI_API_KEY`: API Key para la suite de facturación SDI, antifraude Trust y mensajería SMS.
     - `BASE_URL`: URL base pública del backend.
     - `FRONTEND_URL`: URL base del frontend para redirecciones y callbacks.
     - `CORS_ALLOWED_ORIGINS`: Lista separada por comas de orígenes CORS autorizados.
     - `MCP_ALLOWED_HOSTS`: Lista separada por comas de hosts HTTP autorizados para la cabecera `Host` en el servidor MCP.
   - Configuración del frontend:
     - Argumento y variable de entorno de compilación `NEXT_PUBLIC_API_URL` en `frontend/Dockerfile` y `docker-compose.yml`. Al dejarse vacía por defecto, las peticiones cliente son relativas (`/api/...`), encaminadas por el proxy reverso Nginx hacia el contenedor backend, mitigando problemas de resolución de nombres de contenedor desde el navegador del cliente.

### 10.2 Optimización de Rendimiento en Backend
1. **Erradicación de Consultas N+1 en `SalesService.findAll()`**:
   - **Antes**: Para un listado de órdenes, se realizaban `N` consultas individuales de ítems dentro de un bucle `Promise.all(orders.map(...))`.
   - **Después**: Se obtienen todos los IDs de las órdenes en memoria y se ejecuta una **única consulta batch** con Drizzle ORM utilizando `inArray(schema.orderItems.orderId, orderIds)`. Los ítems se agrupan en tiempo lineal $O(N)$ mediante una estructura `Map<number, OrderItem[]>` en memoria.
2. **Filtrado Combinado Dinámico en `ProductsService.findAll()`**:
   - **Antes**: La presencia de un término de búsqueda retornaba prematuramente, ignorando el filtro por categoría.
   - **Después**: Se construye una cláusula compuesta mediante `and(...)` que evalúa simultáneamente el término de búsqueda (`ilike` en SKU o nombre) y el identificador de categoría (`eq(categoryId)`).

### 10.3 Descomposición Modular del Frontend (Next.js 16 / React)
El archivo monolítico `frontend/app/page.tsx` (~2,970 líneas) se dividió en una arquitectura de componentes modulares de alta cohesión:
- **`frontend/app/types/index.ts`**: Definición canónica de tipos (`User`, `Product`, `Order`, `Movement`, `WarehouseOverview`, `Metrics`, `TabType`, payloads).
- **`frontend/app/services/api.ts`**: Cliente HTTP reutilizable con inyección de Bearer tokens, cookies y soporte para `NEXT_PUBLIC_API_URL`.
- **`frontend/app/components/layout/`**:
  - `Header.tsx`: Barra superior con selector de tema oscuro/claro y control responsive móvil.
  - `Sidebar.tsx`: Navegación principal, contadores dinámicos de ítems y estado de sesión.
  - `Toast.tsx`: Notificaciones flotantes animadas con soporte de accesibilidad `aria-live="polite"`.
- **`frontend/app/components/auth/`**:
  - `LoginModal.tsx`: Pantalla de inicio de sesión de alta fidelidad, con autocompletado de credenciales demostrativas y firma HMAC.
- **`frontend/app/components/dashboard/`**:
  - `DashboardTab.tsx`: Cuadrícula de KPIs de ingresos, valorización y órdenes recientes.
- **`frontend/app/components/products/`**:
  - `ProductsTab.tsx`: Catálogo de productos con búsqueda en tiempo real, filtros por categoría y acciones CRUD.
  - `ProductModal.tsx`: Formulario modal de creación y edición de productos.
- **`frontend/app/components/sales/`**:
  - `SalesTab.tsx`: Tabla de pedidos con estados interactivos ("En Proceso" / "Completado"), curvas dinámicas SVG de ventas semanales proyectadas vs reales y márgenes.
  - `NewSaleModal.tsx`: Modal para el registro rápido de pedidos y descuento de stock.
- **`frontend/app/components/warehouse/`**:
  - `WarehouseTab.tsx`: Monitoreo de valorización, tarjetas dinámicas de unidades con déficit crítico, fallback automático a las últimas 3 salidas y tabla de auditoría Kárdex.
  - `StockAdjustModal.tsx`: Modal para el registro de ajustes manuales de stock (entradas, salidas, devoluciones).
- **`frontend/app/components/openapi/`**:
  - `OpenApiTab.tsx`: Consola de control para evaluación antifraude Trust en vivo, timbrado de facturas SDI y despacho de SMS transaccionales.
- **`frontend/app/page.tsx`**: Orquestador principal reducido a ~530 líneas, enfocado exclusivamente en la gestión de estado global y ciclo de vida.

### 10.4 Resultados de Validación y Build
- **Tests Unitarios del Backend (Vitest)**:
  ```text
  ✓ src/mcp/oauth.service.spec.ts (4 tests) 11ms
  ✓ src/common/zod-validation.pipe.spec.ts (3 tests) 6ms
  ✓ src/app.controller.spec.ts (1 test) 60ms

  Test Files  3 passed (3)
       Tests  8 passed (8)
  ```
- **Compilación de Producción Backend (NestJS)**:
  ```text
  npm run build -> nest build -> Exited with code 0 (Success)
  ```
- **Compilación de Producción Frontend (Next.js 16 Turbopack)**:
  ```text
  npm run build -> next build -> Finished TypeScript in 1353ms -> Static pages generated (4/4) -> Exited with code 0 (Success)
  ```

---

## 11. Actualización de Dependencias, Contenedores Node.js 26, PostgreSQL 18 y Sincronización Técnica (2026-10-17)

### 11.1 Actualización Integral de Dependencias

1. **Backend (NestJS / Drizzle ORM / MCP)**:
   - `@modelcontextprotocol/sdk`: `1.31.0` ➔ `1.32.1`
   - `@nestjs/common`, `@nestjs/core`, `@nestjs/platform-express`: `12.1.1` ➔ `12.1.3`
   - `@types/node`: `24.19.0` ➔ `26.6.5` (alineado a Node 26)
   - `drizzle-orm`: `0.45.3` ➔ `0.45.4`
   - `express`: `5.2.1` ➔ `5.3.0`
   - `pg`: `8.23.0` ➔ `8.23.1`
   - `zod`: `4.6.5` ➔ `4.6.7`
   - `vitest` y `@vitest/coverage-v8`: `4.1.12` ➔ `5.0.5`
   - `vite-tsconfig-paths`: `5.1.4` ➔ `6.1.1` y `vite`: `7.3.1`
   - `dotenv`: `18.0.4` ➔ `18.0.8`
   - `typescript`: fijado en `6.0.3` (debido a que TypeScript 7.0 no expone la compiler API programática requerida por `@nestjs/cli`).

2. **Frontend (Next.js / React)**:
   - `next`: `16.3.6` ➔ `16.4.2` (Turbopack)
   - `react` & `react-dom`: `19.2.8` ➔ `19.3.1`
   - `eslint-config-next`: `16.3.6` ➔ `16.4.2`
   - `@types/node`: `20.19.43` ➔ `26.6.5`
   - Optimización de linter en `eslint.config.mjs` y depuración de variables no utilizadas (`dataLoading`) en `frontend/app/page.tsx` para garantizar 0 errores y 0 warnings.

### 11.2 Actualización de Contenedores Docker a Node 26 y PostgreSQL 18

1. **`backend/Dockerfile`**:
   - Etapa `builder`: `FROM node:26-alpine AS builder`
   - Etapa `runner`: `FROM node:26-alpine AS runner` con `tini` init manager.

2. **`frontend/Dockerfile`**:
   - Etapa `builder`: `FROM node:26-alpine AS builder` con inyección de `ARG NEXT_PUBLIC_API_URL`.
   - Etapa `runner`: `FROM nginx:alpine AS runner` con proxy inverso y soporte SPA.

3. **`docker-compose.yml`**:
   - Servicio `postgres`: actualizado de `postgres:16-alpine` a `postgres:18-alpine` con healthcheck `pg_isready` y persistencia en volumen `db_postgres_data`.

### 11.3 Sincronización de Especificaciones Técnicas

- **`ARCHITECTURE.MD`**: Actualizado modelo C4 (Nivel 2 Contenedores con Node.js 26 y PostgreSQL 18), diagramas Mermaid y Nivel 3 con la descomposición modular del frontend.
- **`AGENTS.MD`**: Incorporada la Sección 6 con especificación del runtime contenerizado (Node 26, Postgres 18), variables de entorno críticas (`JWT_SECRET_OAUTH`, `MCP_ALLOWED_HOSTS`, `BASE_URL`) y directrices de compatibilidad MCP.

### 11.4 Resultados de Validación y Compilación

- **Backend Tests (Vitest 5.0.5)**:
  ```text
   ✓ src/mcp/oauth.service.spec.ts (4 tests) 13ms
   ✓ src/common/zod-validation.pipe.spec.ts (3 tests) 7ms
   ✓ src/app.controller.spec.ts (1 test) 71ms

   Test Files  3 passed (3)
        Tests  8 passed (8)
     Duration  398ms
  ```

- **Backend Production Build (`nest build`)**:
  ```text
  npm run build -> nest build -> Exited with code 0 (Success)
  ```

- **Frontend Linter (`eslint`)**:
  ```text
  npm run lint -> eslint -> 0 errors, 0 warnings -> Exited with code 0 (Success)
  ```

- **Frontend Production Build (Next.js 16.4.2 Turbopack)**:
  ```text
  ▲ Next.js 16.4.2 (Turbopack)
  ✓ Compiled successfully in 296ms
  ✓ Finished TypeScript in 1117ms
  ✓ Generating static pages using 5 workers (4/4) in 279ms
  Route (app)
  ┌ ○ /
  └ ○ /_not-found
  ○  (Static) prerendered as static content -> Exited with code 0 (Success)
  ```

---

## 12. Documentos Relacionados
- [planning.md](planning.md): Plan de acción e inventario completo de endpoints y servicios.
- [AGENTS.MD](AGENTS.MD): Protocolo de interacción para agentes IA, especificación MCP y OAuth 2.1.
- [ARCHITECTURE.MD](ARCHITECTURE.MD): Arquitectura C4, modelo entidad-relación y diagramas de secuencia Mermaid.

