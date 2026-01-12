# CU-03: Recuperación de Contraseña

### 1. Detalles del Caso de Uso

| Elemento | Descripción |
| :--- | :--- |
| **Nombre del caso de uso** | Recuperación de Contraseña. |
| **Actor principal** | Usuario (que olvidó credenciales). |
| **Actores secundarios** | Sistema, Servicio de Correo. |
| **Descripción** | Permite a un usuario restablecer su contraseña mediante un enlace seguro enviado a su correo electrónico verificado. |
| **Precondiciones** | El usuario debe estar registrado. |
| **Flujo principal de eventos** | 1. El usuario selecciona "¿Olvidaste tu contraseña?".<br>2. Ingresa su correo electrónico.<br>3. El sistema verifica si el correo existe.<br>4. El sistema genera un token temporal de recuperación y lo envía por correo.<br>5. El usuario hace clic en el enlace del correo.<br>6. El sistema valida el token y muestra el formulario de cambio de contraseña.<br>7. El usuario ingresa la nueva contraseña.<br>8. El sistema actualiza la credencial y revoca el token. |
| **Flujo alternativo / excepciones** | **E1: Correo no existe:** Por seguridad, el sistema puede mostrar un mensaje genérico "Si el correo existe, se enviarán instrucciones" para no revelar usuarios, o indicar error (según política).<br>**E2: Token Expirado/Inválido:** Al hacer clic, el sistema indica que el enlace ya no es válido y solicita iniciar de nuevo. |
| **Postcondiciones** | La contraseña del usuario es actualizada y se invalidan sesiones anteriores (opcionalmente). |
| **Reglas de negocio asociadas** | - El token de recuperación tiene una vigencia corta (ej. 15 minutos).<br>- No se puede reutilizar una contraseña reciente. |

=== "Diagrama de Actividad"
    ```mermaid
    graph TD
    INICIO((Inicio)) --> SOLICITAR[Solicitar Recuperación]
    SOLICITAR --> MAIL[Ingresar Correo]
    MAIL --> BUSCAR{¿Existe Usuario?}
    BUSCAR -->|No| MSG_GEN[Mostrar Mensaje Genérico] --> FIN((Fin))
    BUSCAR -->|Sí| GEN_TOKEN[Generar Token Recuperación]
    GEN_TOKEN --> ENVIAR[Enviar Email con Link]
    ENVIAR --> MSG_OK[Mostrar Mensaje Confirmación]
    
    MSG_OK --> WAIT[Usuario abre correo]
    WAIT --> CLICK[Clic en Enlace]
    CLICK --> VAL_TOKEN{¿Token Válido?}
    VAL_TOKEN -->|No / Expirado| ERR_LINK[Mostrar Error de Enlace] --> INICIO
    VAL_TOKEN -->|Sí| FORM[Mostrar Formulario Nueva Contraseña]
    
    FORM --> INPUT_NEW[Ingresar Nueva Clave]
    INPUT_NEW --> UPDATE[Actualizar Contraseña]
    UPDATE --> NOTIF[Confirmar Cambio]
    NOTIF --> REDIR[Redirigir a Login] --> FIN
    ```

=== "Diagrama de Secuencia"
    ```mermaid
    sequenceDiagram
    actor U as Usuario
    participant FE as Frontend
    participant BE as Backend
    participant DB as Base de Datos
    participant MAIL as Servicio Correo

    U->>FE: Click "¿Olvidaste contraseña?"
    FE->>U: Muestra Input Email
    U->>FE: Ingresa Email y Envia
    FE->>BE: POST /api/auth/forgot-password
    
    BE->>DB: Buscar Usuario
    alt Usuario Existe
        BE->>DB: Guardar Token Recuperación (con expiración)
        BE->>MAIL: Enviar Email (Link + Token)
        MAIL-->>U: Recibe Correo instrucciones
    end
    BE-->>FE: 200 OK (Mensaje genérico enviado)
    
    U->>FE: Click en Link (frontend/reset-password?token=XYZ)
    FE->>BE: GET /api/auth/validate-reset-token (XYZ)
    alt Token Valido
        BE-->>FE: Token OK
        FE->>U: Muestra Formulario Nueva Clave
        U->>FE: Ingresa Nueva Clave
        FE->>BE: POST /api/auth/reset-password
        BE->>DB: Actualizar Password & Borrar Token
        BE-->>FE: Exito
        FE-->>U: "Contraseña cambiada, inicia sesión"
    else Token Invalido
        BE-->>FE: Error (Expirado/Inválido)
        FE-->>U: Muestra Error
    end
    ```
