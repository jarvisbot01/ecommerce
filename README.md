# NexusSales Ecommerce & MCP Gateway 🚀

Plataforma modular de comercio electrónico y gestión empresarial de alto rendimiento con arquitectura **Domain-Driven Design (DDD)**, interfaz web moderna y servidor **Model Context Protocol (MCP)** para agentes autónomos de IA protegido mediante **OAuth 2.1 + PKCE S256**.

---

## 🌟 Características Principales

- **Gestión Integral de Negocio**: Control de catálogo de productos, órdenes de venta, clientes e inventario en tiempo real con Kardex inmutable.
- **MCP Gateway para Agentes IA (`nexus-ecommerce-mcp`)**: Endpoint moderno Streamable HTTP (`/mcp`) para interacción con LLMs y agentes autónomos.
- **Seguridad Robusta**: Autenticación JWT con rotación HMAC de tokens de refresco y flujo OAuth 2.1 con reto PKCE S256 (RFC 8414 / RFC 9728).
- **Integraciones Fiscales y de Confianza**: Facturación electrónica europea SDI, validación antifraude (OpenAPI Trust) y notificaciones SMS transaccionales.
- **Despliegue Contenerizado**: Entorno completo multi-stage orquestado con Docker Compose.

---

## 🏛️ Arquitectura del Sistema

El proyecto sigue una arquitectura desacoplada y orientada a dominios (DDD):

```
                        +----------------------------+
                        |  Navegador Web / Agente IA |
                        +----------------------------+
                                      |
                         HTTP :3001   |   MCP / API :4000
                                      v
+-------------------------------------------------------------------------+
| Docker Network (ecommerce_network)                                      |
|                                                                         |
|  +------------------------+             +----------------------------+  |
|  | Frontend (Next.js 16)  |-- Proxy --->| Backend API (NestJS 11)    |  |
|  | Nginx Alpine (:3001)   |             | MCP Server (:4000)         |  |
|  +------------------------+             +----------------------------+  |
|                                                       |                 |
|                                                Drizzle ORM              |
|                                                       v                 |
|                                         +----------------------------+  |
|                                         | PostgreSQL 18 Relacional   |  |
|                                         | Puerto :5432               |  |
|                                         +----------------------------+  |
+-------------------------------------------------------------------------+
```

### Tecnologías Clave

- **Frontend**: Next.js 16, React 19, Tailwind CSS v4, Lucide Icons, Nginx Alpine.
- **Backend**: NestJS 11, TypeScript, Drizzle ORM, Zod, Swagger OpenAPI 3.0.
- **Base de Datos**: PostgreSQL 18 Alpine.
- **Protocolo de Agentes**: Model Context Protocol (MCP) especificación `2026-07-28` con transporte Streamable HTTP.

---

## 🤖 Capacidades para Agentes IA (MCP)

El servidor expone herramientas canónicas para que LLMs y agentes puedan auditar y operar sobre el sistema:

| Herramienta (*Tool*) | Descripción |
| :--- | :--- |
| `list_products` | Consulta y búsqueda de productos por texto o categoría. |
| `get_product_detail` | Detalle técnico, financiero y de stock de un producto por ID o SKU. |
| `get_low_stock_alerts` | Reporte de productos en nivel de stock crítico o bajo mínimo. |
| `get_sales_orders` | Listado y auditoría de órdenes de venta con filtros por estado o cliente. |
| `get_warehouse_movements` | Historial de movimientos Kardex (entradas, salidas, ajustes de inventario). |

> ℹ️ Para consultar la especificación completa del protocolo y el flujo OAuth 2.1 + PKCE, consulta [AGENTS.MD](file:///home/jose/Proyectos/LLC/ecommerce_ventas/AGENTS.MD).

---

## 🚀 Inicio Rápido con Docker

### Prerrequisitos
- [Docker Engine](https://docs.docker.com/engine/) y [Docker Compose](https://docs.docker.com/compose/) instalados.

### 1. Variables de Entorno
Copia el archivo de ejemplo y ajusta los valores necesarios:
```bash
cp .env.example .env
```

### 2. Levantar la Plataforma
Inicia todos los contenedores (`postgres`, `backend`, `frontend`):
```bash
docker compose up -d --build
```

### 3. Servicios Disponibles

| Servicio | URL Local | Descripción |
| :--- | :--- | :--- |
| **Frontend Web** | [http://localhost:3001](http://localhost:3001) | Dashboard interactivo y gestión SPA |
| **Backend REST API** | [http://localhost:4000/api](http://localhost:4000/api) | API central de la plataforma |
| **Swagger Docs** | [http://localhost:4000/docs](http://localhost:4000/docs) | Documentación interactiva OpenAPI |
| **Servidor MCP** | [http://localhost:4000/mcp](http://localhost:4000/mcp) | Gateway Streamable HTTP para Agentes |
| **PostgreSQL** | `localhost:5432` | Base de datos relacional (`ecommerce_ventas`) |

---

## 📂 Estructura del Repositorio

```
ecommerce_ventas/
├── backend/              # API NestJS, módulos de dominio y servidor MCP
│   ├── src/
│   │   ├── modules/      # Auth, Products, Sales, Warehouse, OpenApi, Mcp
│   │   └── database/     # Esquemas y migraciones con Drizzle ORM
├── frontend/             # SPA Next.js 16 con Tailwind CSS v4
│   └── src/components/   # Componentes modulares del dashboard
├── docker-compose.yml    # Orquestación de contenedores y redes
├── ARCHITECTURE.MD       # Especificación arquitectónica y modelo C4 detallado
└── AGENTS.MD             # Protocolo MCP canónico y guía operativa para agentes IA
```

---

## 📖 Documentación Adicional

- [ARCHITECTURE.MD](ARCHITECTURE.MD): Detalle en profundidad de DDD, C4, agregados y optimizaciones.
- [AGENTS.MD](AGENTS.MD): Protocolo de interacción y especificación formal de herramientas para agentes IA.
