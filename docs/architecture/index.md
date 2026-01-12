# Arquitectura del Sistema

**Stable Experts** está construido bajo una arquitectura modular de microservicios, diseñada para operar en un entorno híbrido (**Cloud + Edge**). Esta estructura garantiza alta disponibilidad, escalabilidad y una respuesta inmediata ante eventos críticos en los establos.

## Visión General
El sistema integra dispositivos IoT in-situ con una plataforma en la nube robusta. El procesamiento pesado de video e inteligencia artificial se descentraliza hacia servidores locales (Edge) para reducir la latencia, mientras que la gestión administrativa y el acceso global se centralizan en la nube.

### Diagrama de Contexto
A continuación se muestra cómo interactúan los usuarios y el entorno físico con la solución.

```mermaid
graph TD
    classDef person fill:#00241B,stroke:#333,stroke-width:2px,color:white;
    classDef system fill:#00F5FF,stroke:#333,stroke-width:2px,color:black;
    classDef edge fill:#39FF14,stroke:#333,stroke-width:2px,color:black;
    classDef external fill:#8E8E8E,stroke:#333,stroke-width:2px,color:white;

    User(Usuario / Admin):::person
    Horse(Caballo / Entorno):::external
    
    subgraph Location[Establo Físico]
        Camera(Cámara Térmica):::external
        Edge[Servidor Edge Local]:::edge
    end

    subgraph Cloud[Nube Stable Experts]
        Core[Sistema Core & API]:::system
        DB[(Base de Datos)]:::system
        Storage[Almacenamiento Multimedia]:::system
    end

    Horse -->|Calor/Movimiento| Camera
    Camera -->|Stream RTSP| Edge
    Edge -->|Eventos & Clips| Core
    Edge -->|Respaldo Video| Storage
    
    User -->|HTTPS| Core
    Core -->|Datos & Alertas| User

    linkStyle default stroke-width:2px,fill:none,stroke:gray;
```

## Principios de Diseño
- **Latencia Mínima:** Procesamiento en el borde para alertas en tiempo real.
- **Microservicios:** Desacoplamiento de funciones (Auth, Gestión, Ingesta) para facilitar el mantenimiento.
- **Offline-First:** Capacidad de operar localmente si falla la conexión a internet.
