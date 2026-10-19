# AGENTS.MD: Guía Operativa de Agentes IA y Servidor MCP (`nexus-ecommerce-mcp`)

Este documento constituye la especificación canónica y el protocolo de interacción para Agentes Autónomos y Modelos de Lenguaje (LLMs) que operan sobre la plataforma **NexusSales Ecommerce**. Define las capacidades expuestas mediante el estándar **Model Context Protocol (MCP)**, los mecanismos de seguridad criptográfica **OAuth 2.1 + PKCE S256**, las herramientas (*tools*) disponibles y las directrices de orquestación de agentes.

---

## 1. Identidad del Sistema y Arquitectura del Agente

- **Nombre del Servidor MCP**: `nexus-ecommerce-mcp`
- **Versión**: `1.0.0`
- **Era del Protocolo**: Era Moderna `2026-07-28`
- **Transporte**: `STREAMABLE-HTTP` con fallback legacy JSON-RPC 2.0
- **Endpoint MCP**: `http://localhost:4000/mcp` (o `http://backend:4000/mcp`)
- **Esquema de Autorización**: `Bearer <token>` emitido por el Authorization Server OAuth 2.1 integrado.

---

## 2. Flujo de Autenticación y Autorización de Agentes (OAuth 2.1 + PKCE)

Los agentes acceden a las herramientas del dominio de forma segura siguiendo las especificaciones RFC 8414, RFC 9728 y RFC 7636 (PKCE obligatorio con método S256).

```
   +-------------------+                     +-----------------------+
   |   Agente / LLM    |                     | Nexus OAuth 2.1 Server|
   +-------------------+                     +-----------------------+
             |                                           |
             |--- 1. GET /.well-known/oauth-... -------->| (Descubrimiento RFC 8414)
             |<-- Metadatos de Autorización y Endpoints -|
             |                                           |
             |--- 2. POST /oauth/register -------------->| (Registro Dinámico RFC 7591)
             |<-- Client ID & Configuración -------------|
             |                                           |
             |--- 3. Generar code_verifier & S256 ------>| (Generación de PKCE)
             |--- 4. GET /oauth/authorize (con reto) --->| (Pantalla de Consentimiento)
             |<-- Código de Autorización (code_...) -----|
             |                                           |
             |--- 5. POST /oauth/token ----------------->| (Canje con code_verifier)
             |<-- Access Token Bearer (validez 2h) ------|
             |                                           |
             v                                           v
   +-------------------+                     +-----------------------+
   |   Agente / LLM    |===[ Bearer Token ]==>| Servidor MCP (/mcp)   |
   +-------------------+                     +-----------------------+
```

### 2.1 Endpoints de Descubrimiento (RFC 8414 / RFC 9728)
- `GET /.well-known/oauth-authorization-server`: Retorna endpoints de autorización, token, registro dinámico y métodos PKCE soportados (`S256`).
- `GET /.well-known/oauth-protected-resource`: Retorna el identificador del recurso MCP (`/mcp`) y los scopes requeridos (`mcp:read`, `mcp:write`).

### 2.2 Proceso de Canje de Credenciales para Agentes
1. Generar un `code_verifier` aleatorio de alta entropía (mínimo 43 caracteres Base64URL).
2. Computar `code_challenge = BASE64URL(SHA256(ASCII(code_verifier)))`.
3. Solicitar autorización en `/oauth/authorize` enviando `code_challenge` y `code_challenge_method=S256`.
4. El usuario u operador aprueba la vinculación; el servidor emite un `authorization_code`.
5. Enviar solicitud POST a `/oauth/token`:
   ```bash
   curl -X POST http://localhost:4000/oauth/token \
     -H "Content-Type: application/json" \
     -d '{
       "grant_type": "authorization_code",
       "client_id": "nexus-default-mcp-client",
       "code": "code_xxxxxx",
       "redirect_uri": "http://localhost:3000/oauth/callback",
       "code_verifier": "<code_verifier_original>"
     }'
   ```
6. El token Bearer retornado debe incluirse en la cabecera `Authorization: Bearer <access_token>` para cada llamada al endpoint `/mcp`.

---

## 3. Catálogo Canónico de Herramientas MCP (*Tools*)

Las 5 herramientas registradas permiten al agente consultar y gobernar el estado transaccional del negocio.

### 3.1 `list_products`
- **Propósito**: Consulta el catálogo de productos con opciones de búsqueda semántica/textual por nombre o código SKU, o filtro por categoría.
- **Parámetros de Entrada (`inputSchema`)**:
  ```json
  {
    "type": "object",
    "properties": {
      "search": {
        "type": "string",
        "description": "Término de búsqueda opcional por nombre o código SKU"
      },
      "categoryId": {
        "type": "number",
        "description": "ID de la categoría opcional"
      }
    }
  }
  ```
- **Formato de Respuesta**: Lista JSON de objetos `Product` con id, sku, name, description, price, cost, stock, minStock y status.

### 3.2 `get_product_detail`
- **Propósito**: Recupera la ficha técnica y financiera completa de un producto determinado.
- **Parámetros de Entrada (`inputSchema`)**:
  ```json
  {
    "type": "object",
    "properties": {
      "productId": {
        "type": "number",
        "description": "ID único del producto"
      }
    },
    "required": ["productId"]
  }
  ```
- **Formato de Respuesta**: Objeto `Product` individual. Lanza error 404 si el ID no existe.

### 3.3 `get_low_stock_alerts`
- **Propósito**: Detección proactiva de riesgos de desabastecimiento. Devuelve todos los artículos con `stock <= minStock`.
- **Parámetros de Entrada (`inputSchema`)**:
  ```json
  {
    "type": "object",
    "properties": {}
  }
  ```
- **Recomendación para el Agente**: Invocar esta tool al iniciar análisis diarios de abastecimiento o antes de confirmar pedidos mayoristas.

### 3.4 `get_sales_orders`
- **Propósito**: Auditoría y seguimiento de ventas y órdenes de compra recientes.
- **Parámetros de Entrada (`inputSchema`)**:
  ```json
  {
    "type": "object",
    "properties": {
      "limit": {
        "type": "number",
        "description": "Número máximo de órdenes a retornar (por defecto 20)"
      }
    }
  }
  ```
- **Formato de Respuesta**: Lista de objetos `Order` con sus líneas de pedido (`items`), datos del cliente, total gravado, estado y banderas de facturación SDI y despacho SMS.

### 3.5 `get_warehouse_movements`
- **Propósito**: Inspección del Kardex inmutable de almacén.
- **Parámetros de Entrada (`inputSchema`)**:
  ```json
  {
    "type": "object",
    "properties": {
      "limit": {
        "type": "number",
        "description": "Número de movimientos a retornar (por defecto 25)"
      }
    }
  }
  ```
- **Formato de Respuesta**: Lista de movimientos que incluye `type` (`IN`, `OUT`, `SALE`, `RETURN`), cantidades, variaciones de existencias (`previousStock` ➔ `newStock`), motivo y referencia documental.

---

## 4. Recursos Directos y Plantillas de Recursos (*Resources*)

El servidor expone URIs estandarizadas que los agentes pueden leer directamente sin necesidad de invocar herramientas activas:

### 4.1 Recursos Fijos
1. **`nexus://inventory/summary`**:
   - MimeType: `application/json`
   - Contenido: Estado de salud global del inventario, conteo de ítems críticos y array de alertas.
2. **`nexus://sales/recent`**:
   - MimeType: `application/json`
   - Contenido: Últimas 10 órdenes procesadas, conteos y timestamps.

### 4.2 Plantillas Parametrizadas (*Resource Templates*)
1. **`nexus://products/{id}`**: Detalle estático de producto identificado por su ID numérico.
2. **`nexus://sales/{id}`**: Detalle estático de venta identificado por su ID numérico.

---

## 5. Directrices de Orquestación Multi-Agente

Para sistemas multi-agente que interactúan con NexusSales:

1. **Agente de Inventario & Kardex**:
   - Debe monitorizar periódicamente `nexus://inventory/summary` o invocar `get_low_stock_alerts`.
   - Cuando detecte un producto con stock crítico, sugerirá reorden de compra antes de que el stock llegue a cero.
2. **Agente de Ventas & Fulfillment**:
   - Previo a la confirmación de pedidos, verificará existencias llamando a `get_product_detail`.
   - Si el stock es insuficiente, rechazará o dividirá la orden de forma proactiva.
3. **Agente Fiscal & Notificaciones**:
   - Al detectarse órdenes en estado `completed` con `invoiceIssued: false`, solicitará la emisión de comprobante SDI mediante `/api/openapi/invoices/issue/:orderId`.
   - Tras la emisión, activará el despacho del SMS transaccional con `/api/openapi/messaging/send-sms`.
4. **Idempotencia y Manejo de Errores**:
   - Los agentes deben esperar códigos de respuesta estándar JSON-RPC 2.0 (`-32600`, `-32602`, `-32603`).
   - Las sesiones de Streamable HTTP caducan tras 2 horas de inactividad; en caso de error 401, el agente renovará su token mediante el flujo de autorización OAuth 2.1.

---

## 6. Entorno de Ejecución Contenerizado y Configuración de Agentes

El stack operacional para agentes y servicios se encuentra desplegado en contenedores de última generación:

- **Motor de Ejecución Backend**: **Node.js 26 Alpine** (`node:26-alpine`) gestionado bajo subproceso `tini` para manejo seguro de señales POSIX y mitigación de procesos huérfanos.
- **Motor de Persistencia**: **PostgreSQL 18 Alpine** (`postgres:18-alpine`) con volumen persistente `db_postgres_data` y pool transaccional de Drizzle ORM.
- **Variables Críticas de Entorno para Agentes**:
  - `JWT_SECRET_OAUTH`: Clave simétrica dedicada exclusivamente a la firma y validación de tokens Bearer OAuth 2.1 para agentes IA.
  - `MCP_ALLOWED_HOSTS`: Lista separada por comas que autoriza las cabeceras `Host` recibidas en `/mcp` (`localhost,127.0.0.1,[::1]` y dominios autorizados adicionales).
  - `BASE_URL`: URL base pública del backend para la generación de metadatos RFC 8414 en `/.well-known/oauth-authorization-server`.
  - `DATABASE_URL`: Cadena de conexión a PostgreSQL 18.
- **Compatibilidad MCP**:
  - Compatible con clientes MCP de escritorio (Cursor, Windsurf, Claude Desktop) y subagentes autónomos programáticos mediante transporte Streamable HTTP en `http://localhost:4000/mcp`.
