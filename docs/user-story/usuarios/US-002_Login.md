# HU-002: Inicio de Sesión

## 1. Ficha historia de usuario

| Campo | Detalles |
| :--- | :--- |
| **Proyecto** | Stable Experts |
| **Sistema** | Plataforma Web / Móvil |
| **Módulo** | Gestión de Usuarios |
| **Épica** | Autenticación y Seguridad |
| **ID HU** | HU-002 |
| **Nombre HU** | Autenticación de Usuario (Login) |
| **Tipo** | Funcional |
| **Responsable** | Equipo de Desarrollo |
| **Fecha documento** | 2026-01-12 |
| **Prioridad** | Crítica |
| **Observaciones** | Soporte para biometría y doble factor de autenticación (2FA) |

## 2. Descripción HU
Como usuario registrado, quiero iniciar sesión en la plataforma utilizando mis credenciales, biometría o redes sociales, para acceder a mi información y herramientas de gestión de manera segura.

## 3. Roles como
- **Actor Principal:** Usuario Registrado.
- **Actores Secundarios:** Sistema de Autenticación, Dispositivo Biométrico.

## 4. Característica / Funcionalidad
- Validación de credenciales (Usuario/Contraseña).
- Soporte para autenticación biométrica (FaceID/TouchID en dispositivos compatibles).
- Verificación de segundo factor (2FA) si está habilitado por el usuario.
- Bloqueo de cuenta temporal tras intentos fallidos.

## 5. Razón / Resultado
**Resultado Esperado:** El usuario accede al sistema (Dashboard) de forma segura. Se garantiza que solo el propietario de la cuenta pueda ingresar, protegiendo la información sensible del establo y los animales.

## 6. Criterios de aceptación

| ID | Criterio | Dado que | Cuando | Entonces |
| :--- | :--- | :--- | :--- | :--- |
| **CA-01** | **Login Correcto** | El usuario tiene cuenta activa y credenciales válidas | Ingresa su correo y contraseña correctos | El sistema genera un token de sesión y redirige al usuario al Dashboard. |
| **CA-02** | **Cuenta Inactiva** | El usuario se registró por correo pero no ha activado su cuenta | Intenta iniciar sesión | El sistema impide el acceso y muestra un mensaje solicitando la activación vía correo. |
| **CA-03** | **Login con 2FA** | El usuario tiene 2FA habilitado | Ingresa sus credenciales correctas | El sistema solicita un código OTP adicional antes de dar acceso. |
| **CA-04** | **Datos Incorrectos** | El usuario ingresa una contraseña errónea | Intenta iniciar sesión | El sistema muestra error de credenciales inválidas y registra el intento fallido. |
| **CA-05** | **Bloqueo de Seguridad** | Se han realizado 5 intentos fallidos consecutivos | El usuario intenta ingresar de nuevo | El sistema bloquea temporalmente la cuenta (ej. 15 minutos) y notifica al usuario. |
