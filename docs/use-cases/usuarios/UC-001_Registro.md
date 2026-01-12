# CU-01: Registro de Usuario

### 1. Detalles del Caso de Uso

| Elemento | Descripción |
| :--- | :--- |
| **Nombre del caso de uso** | Registro de Usuario (Email/Password y Redes Sociales). |
| **Actor principal** | Usuario Visitante (No autenticado). |
| **Actores secundarios** | Sistema Stable Experts, Proveedor de Identidad (Google, Facebook, Instagram), Servicio de Correo. |
| **Descripción** | Permite a un nuevo usuario crear una cuenta en la plataforma mediante correo electrónico/contraseña o utilizando sus cuentas de redes sociales existentes. |
| **Precondiciones** | El usuario no debe estar autenticado. El correo no debe estar registrado previamente. |
| **Flujo principal de eventos** | **Opción Correo:**<br>1. El usuario selecciona "Registrarse".<br>2. El usuario ingresa Nombre, Apellido, Correo, Contraseña y Confirmación.<br>3. El sistema valida el formato de los datos y la unicidad del correo.<br>4. El sistema crea la cuenta en estado "Inactivo".<br>5. El sistema envía un correo de activación.<br>6. El sistema informa al usuario que debe verificar su bandeja de entrada.<br><br>**Opción Redes Sociales:**<br>1. El usuario selecciona "Registrarse con [Red Social]".<br>2. El sistema redirige al proveedor de identidad.<br>3. El usuario autoriza el acceso.<br>4. El proveedor retorna el token/datos del usuario.<br>5. El sistema verifica si el correo ya existe. Si no, crea la cuenta (estado "Activo" por defecto al ser validado por un tercero). |
| **Flujo alternativo / excepciones** | **E1: Correo ya registrado:** El sistema muestra un error indicando que la cuenta ya existe.<br>**E2: Fallo en red social:** El proveedor retorna error o el usuario cancela. El sistema retorna al formulario de registro.<br>**E3: Datos inválidos:** El sistema resalta los campos con error (ej. contraseña débil). |
| **Postcondiciones** | Se crea un registro de usuario en la base de datos. Si es por correo, queda pendiente de activación. |
| **Reglas de negocio asociadas** | - La contraseña debe tener mín. 8 caracteres, una mayúscula y un número.<br>- El correo debe ser único.<br>- El registro por redes sociales asume el correo como verificado automáticamente. |

=== "Diagrama de Actividad"
    ```mermaid
    graph TD
    INICIO((Inicio)) --> OPCION{¿Método de Registro?}
    
    OPCION -->|Formulario Web| FORM[Ingresar Datos Personales]
    FORM --> VALIDAR_DATOS{¿Datos Válidos?}
    VALIDAR_DATOS -->|No| ERROR[Mostrar Error] --> FORM
    VALIDAR_DATOS -->|Sí| CREAR_INACTIVO[Crear Usuario Inactivo]
    CREAR_INACTIVO --> ENVIAR_EMAIL[Enviar Correo Activación]
    ENVIAR_EMAIL --> NOTIFICAR[Notificar al Usuario]
    
    OPCION -->|Red Social| RED_SOCIAL[Redirigir a Proveedor]
    RED_SOCIAL --> AUTH_EXT{¿Autorizado?}
    AUTH_EXT -->|No/Cancelado| ERROR_RED[Error de Autenticación] --> INICIO
    AUTH_EXT -->|Sí| OBTENER_DATOS[Obtener Datos del Proveedor]
    OBTENER_DATOS --> EXISTE{¿Usuario Existe?}
    EXISTE -->|Sí| INICIAR_SESION[Iniciar Sesión]
    EXISTE -->|No| CREAR_ACTIVO[Crear Usuario Activo]
    
    NOTIFICAR --> FIN((Fin))
    INICIAR_SESION --> FIN
    CREAR_ACTIVO --> FIN
    ```

=== "Diagrama de Secuencia"
    ```mermaid
    sequenceDiagram
    actor U as Usuario
    participant FE as Frontend
    participant BE as Backend
    participant DB as Base de Datos
    participant IDP as Proveedor Identidad (Google/FB)
    participant MAIL as Servicio Correo

    alt Registro con Correo
        U->>FE: Ingresa Datos de Registro
        FE->>BE: POST /api/register (datos)
        BE->>DB: Verificar Correo Unico
        alt Correo Existe
            DB-->>BE: Error (Duplicado)
            BE-->>FE: Error "Usuario ya existe"
            FE-->>U: Muestra Mensaje de Error
        else Correo Nuevo
            BE->>DB: Crear Usuario (Estado: Inactivo)
            DB-->>BE: Confirmación
            BE->>MAIL: Enviar Email Activación (Token)
            MAIL-->>U: Recibe Correo
            BE-->>FE: Registro Exitoso
            FE-->>U: Muestra "Verifica tu email"
        end
    else Registro con Red Social
        U->>FE: Click "Login con Google"
        FE->>IDP: Redirigir a Auth
        U->>IDP: Autentica y Autoriza
        IDP-->>FE: Redirige con Token/Code
        FE->>BE: POST /api/auth/social (token)
        BE->>IDP: Validar Token y Obtener Datos
        IDP-->>BE: Datos Usuario (Email, Nombre)
        BE->>DB: Buscar Usuario por Email
        alt Usuario Nuevo
            BE->>DB: Crear Usuario (Estado: Activo)
            DB-->>BE: Usuario Creado
        end
        BE-->>FE: Token de Sesión (JWT)
        FE-->>U: Redirige a Dashboard
    end
    ```
