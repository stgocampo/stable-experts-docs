# Diagrama de Contenedores

Este documento detalla la arquitectura de contenedores del sistema **Stable Experts**, mostrando las decisiones de diseño sobre microservicios y almacenamiento de datos.

## Estrategia de Base de Datos y Servicios

El sistema utiliza un enfoque híbrido para equilibrar la consistencia de datos global con la autonomía operativa local:

1.  **Nube (Cloud):**
    *   **Base de Datos Centralizada:** Servicios como *Auth* y *Core Management* comparten una base de datos relacional robusta (ej. PostgreSQL) para garantizar la integridad de usuarios, roles y configuración global.
    *   **Almacenamiento de Objetos:** Los videos y clips se almacenan en un servicio especializado (ej. S3/Blob Storage) para eficiencia y costo, referenciados por metadatos en la DB.

2.  **Borde (Edge - Establos):**
    *   **Base de Datos Local:** Cada instancia Edge tiene su propia base de datos ligera (ej. SQLite/Redis) para operar desconectada.
    *   **Sincronización:** Un proceso dedicado sincroniza los eventos críticos con la nube cuando la conexión está disponible.

## Diagrama C4: Nivel Contenedor

El siguiente diagrama muestra los contenedores desplegables y sus interacciones.

```mermaid
graph TB
    %% Estilos
    classDef person fill:#08427B,stroke:#052E56,color:white;
    classDef web fill:#1168BD,stroke:#0B4884,color:white;
    classDef mobile fill:#1168BD,stroke:#0B4884,color:white;
    classDef api fill:#438DD5,stroke:#2E6295,color:white;
    classDef service fill:#438DD5,stroke:#2E6295,color:white;
    classDef db fill:#2F95D6,stroke:#206895,color:white;
    classDef edge fill:#39FF14,stroke:#228B22,color:black;

    %% Actores
    Admin(Administrador):::person
    User(Usuario Final):::person
    Vet(Veterinario):::person

    %% Cloud Boundary
    subgraph Cloud [Stable Experts Cloud]
        %% Frontend Apps
        WebApp["Single-Page App Reat\n(Admin/Web)"]:::web
        
        %% API & Gateway
        APIGateway["API Gateway\nNginx/Traefik"]:::api
        
        %% Microservices
        subgraph Backend [Backend Services]
            AuthService["Auth Service\nJWT/OAuth2"]:::service
            CoreService["Core Management\nLogica de Negocio"]:::service
            IngestionService["Video Ingestion\nStream Processor"]:::service
        end
        
        %% Data Stores
        MainDB[("Main Database\nPostgreSQL")]:::db
        ObjStore[("Video Storage\nS3/Blob")]:::db
    end

    %% Edge Boundary
    subgraph Physical [Establo / Edge Location]
        MobileApp["Mobile App\nFlutter/React Native"]:::mobile
        
        subgraph EdgeDevice [Edge Server Device]
            EdgeController["Edge Controller\nOrquestador Local"]:::edge
            AIModel["AI Service\nInferencia Video"]:::edge
            LocalDB[("Local DB\nSQLite/Cache")]:::db
        end
        
        Camera(Cámaras Térmicas):::edge
    end

    %% Relaciones - Usuarios
    Admin -->|HTTPS| WebApp
    User -->|HTTPS| WebApp
    Vet -->|Usa| MobileApp

    %% Relaciones - Apps a Cloud
    WebApp -->|HTTPS/REST| APIGateway
    MobileApp -->|HTTPS/REST| APIGateway

    %% Relaciones - API Gateway Routing
    APIGateway -->|Auth Req| AuthService
    APIGateway -->|Data Req| CoreService
    APIGateway -->|Video Metadata| IngestionService

    %% Relaciones - Servicios Backend
    CoreService -->|Lee/Escribe| MainDB
    AuthService -->|Lee/Escribe| MainDB
    IngestionService -->|Guarda Video| ObjStore
    IngestionService -->|Guarda Metadatos| MainDB

    %% Relaciones - Edge
    Camera -->|RTSP Stream| EdgeController
    EdgeController -->|Frames| AIModel
    AIModel -->|Eventos| EdgeController
    EdgeController -->|Guarda Temp| LocalDB
    
    %% Relaciones - Edge a Cloud (Sincronización)
    EdgeController -.->|Sync Eventos HTTPS| APIGateway
    EdgeController -.->|Upload Clips HTTPS| IngestionService

```

### Descripción de Componentes

| Contenedor | Tipo | Responsabilidad Principal | Tecnología |
| :--- | :--- | :--- | :--- |
| **Web App** | SPA | Interfaz para usuarios y administración. | React, TypeScript |
| **Mobile App** | Mobile | Interfaz para trabajo de campo y alertas. | Flutter / React Native |
| **API Gateway** | Infra | Punto de entrada único, manejo de tráfico y SSL. | Nginx / Cloud Load Balancer |
| **Auth Service** | Microservicio | Gestión de identidad y tokens. | Node.js / Go |
| **Core Service** | Microservicio | Lógica de negocio principal (caballos, establos). | Node.js / Python |
| **Main DB** | Base de Datos | Fuente de verdad única para datos estructurados. | PostgreSQL |
| **Edge Controller** | Servicio Local | Ingesta de cámaras y gestión offline. | Python / C++ |
| **AI Service** | Servicio Local | Procesamiento de video en tiempo real. | TensorFlow / PyTorch |
