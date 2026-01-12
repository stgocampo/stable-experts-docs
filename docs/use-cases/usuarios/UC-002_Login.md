# CU-02: Inicio de Sesión

### 1. Detalles del Caso de Uso

| Elemento | Descripción |
| :--- | :--- |
| **Nombre del caso de uso** | Inicio de Sesión (Credenciales, Social, 2FA, Biometría). |
| **Actor principal** | Usuario Registrado. |
| **Actores secundarios** | Sistema Stable Experts, Proveedor de Identidad. |
| **Descripción** | Permite a un usuario acceder a su cuenta. Soporta credenciales tradicionales, redes sociales y verificación biométrica (si el dispositivo lo soporta). Puede requerir 2FA si está configurado. |
| **Precondiciones** | El usuario debe estar registrado. Si es registro por email, la cuenta debe estar activada. |
| **Flujo principal de eventos** | 1. El usuario ingresa credenciales o selecciona red social / biometría.<br>2. El sistema valida las credenciales primarias.<br>3. El sistema verifica el estado de la cuenta (Debe estar "Activo").<br>4. El sistema verifica si tiene 2FA activado.<br>    - Si SÍ: Solicita código OTP.<br>    - Si NO: Procede.<br>5. El sistema genera un token de sesión.<br>6. El usuario accede al Dashboard. |
| **Flujo alternativo / excepciones** | **E1: Cuenta Inactiva:** El sistema solicita activar la cuenta vía email primero.<br>**E2: Credenciales Inválidas:** Muestra error y permite reintentar.<br>**E3: 2FA Fallido:** Código incorrecto, permite reintentar o reenviar.<br>**E4: Biometría Fallida:** Solicita uso de contraseña / PIN como respaldo. |
| **Postcondiciones** | El usuario obtiene acceso a las funcionalidades privadas (Token de sesión activo). |
| **Reglas de negocio asociadas** | - Bloqueo temporal de cuenta tras 5 intentos fallidos.<br>- La sesión expira tras X tiempo de inactividad. |

=== "Diagrama de Actividad"
    ```mermaid
    graph TD
    INICIO((Inicio)) --> METODO{Método Login}
    
    METODO -->|Biometría| BIO[Validar FaceID/TouchID]
    BIO --> BIO_OK{¿Valido?}
    BIO_OK -->|No| ERROR_BIO[Error Biometría] --> METODO
    BIO_OK -->|Sí| CHECK_ACTIVO
    
    METODO -->|Usuario/Pass| CRED[Ingresar Credenciales]
    CRED --> VALIDAR[Validar Credenciales]
    VALIDAR --> VAL_OK{¿Correcto?}
    VAL_OK -->|No| ERROR_CRED[Error Credenciales] --> PIDE_REINTENTO{¿Reintentar?}
    PIDE_REINTENTO -->|Sí| CRED
    PIDE_REINTENTO -->|No| FIN_FAIL((Fin))
    VAL_OK -->|Sí| CHECK_ACTIVO
    
    CHECK_ACTIVO{¿Cuenta Activa?}
    CHECK_ACTIVO -->|No| MSG_ACT[Mostrar: Activa tu cuenta] --> FIN_FAIL
    CHECK_ACTIVO -->|Sí| CHECK_2FA{¿Tiene 2FA?}
    
    CHECK_2FA -->|No| GEN_TOKEN[Generar Token Sesión]
    CHECK_2FA -->|Sí| PIDE_OTP[Solicitar Código 2FA]
    PIDE_OTP --> VAL_OTP{¿Código Válido?}
    VAL_OTP -->|No| ERROR_OTP[Código Incorrecto] --> PIDE_OTP
    VAL_OTP -->|Sí| GEN_TOKEN
    
    GEN_TOKEN --> ACCESO[Acceso al Dashboard] --> FIN_OK((Fin))
    ```

=== "Diagrama de Secuencia"
    ```mermaid
    sequenceDiagram
    actor U as Usuario
    participant DEV as Dispositivo (Biometría)
    participant FE as Frontend
    participant BE as Backend
    participant DB as Base de Datos

    alt Login Biométrico
        U->>DEV: Usa FaceID / TouchID
        DEV-->>FE: Credencial WebAuthn firmada
        FE->>BE: POST /api/auth/biometric (credential)
        BE->>BE: Validar Firma WebAuthn
    else Login Tradicional
        U->>FE: Ingresa Email/Password
        FE->>BE: POST /api/auth/login
    end

    BE->>DB: Buscar Usuario y Verificar Pass/Firma
    alt Credenciales Invalidas
        BE-->>FE: Error 401
    else Valido
        BE->>DB: Verificar Estado y Config 2FA
        
        alt Cuenta Inactiva
            BE-->>FE: Error "Cuenta no activada"
        else Requiere 2FA
            BE-->>FE: 200 OK (Require2FA: true)
            FE->>U: Pedir Código OTP
            U->>FE: Ingresa Código
            FE->>BE: POST /api/auth/2fa-verify
            BE->>BE: Validar OTP
            alt OTP Valido
                 BE-->>FE: Token JWT + Datos Usuario
            else OTP Invalido
                 BE-->>FE: Error Codigo
            end
        else Login Directo (Sin 2FA)
            BE-->>FE: Token JWT + Datos Usuario
        end
    end
    ```
