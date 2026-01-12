# HU-003: Recuperación de Contraseña

## 1. Ficha historia de usuario

| Campo | Detalles |
| :--- | :--- |
| **Proyecto** | Stable Experts |
| **Sistema** | Plataforma Web / Móvil |
| **Módulo** | Gestión de Usuarios |
| **Épica** | Autenticación y Seguridad |
| **ID HU** | HU-003 |
| **Nombre HU** | Restablecimiento de Contraseña |
| **Tipo** | Funcional |
| **Responsable** | Equipo de Desarrollo |
| **Fecha documento** | 2026-01-12 |
| **Prioridad** | Alta |
| **Observaciones** | Utiliza tokens temporales enviados por correo para garantizar seguridad. |

## 2. Descripción HU
Como usuario que ha olvidado sus credenciales, quiero poder restablecer mi contraseña a través de mi correo electrónico verificado, para recuperar el acceso a mi cuenta de manera autónoma y segura.

## 3. Roles como
- **Actor Principal:** Usuario (sin acceso).
- **Actores Secundarios:** Sistema de Correo.

## 4. Característica / Funcionalidad
- Formulario de solicitud de recuperación por email.
- Generación y envío de token seguro (tiempo de vida limitado).
- Validación de token y formulario de cambio de contraseña.
- Invalidación de sesiones activas tras el cambio.

## 5. Razón / Resultado
**Resultado Esperado:** El usuario logra cambiar su contraseña y recuperar el acceso. Se previene el robo de cuentas mediante la verificación por correo.

## 6. Criterios de aceptación

| ID | Criterio | Dado que | Cuando | Entonces |
| :--- | :--- | :--- | :--- | :--- |
| **CA-01** | **Solicitud Válida** | El usuario existe en el sistema | Ingresa su correo en "Olvidé mi contraseña" | El sistema envía un correo con un enlace único y temporal para restablecer la clave. |
| **CA-02** | **Correo Desconocido** | El correo ingresado no está registrado | El usuario solicita recuperación | El sistema muestra un mensaje genérico ("Si existe, se enviarán instrucciones") para no revelar qué correos están registrados. |
| **CA-03** | **Token Inválido/Expirado** | El usuario intenta usar un enlace viejo (más de 15 min) | Hace clic en el enlace del correo | El sistema muestra un error indicando que el enlace ha expirado y debe solicitar uno nuevo. |
| **CA-04** | **Cambio Exitoso** | El usuario accede con un token válido | Ingresa y confirma su nueva contraseña | El sistema actualiza la contraseña, invalida el token usado y redirige al Login. |
