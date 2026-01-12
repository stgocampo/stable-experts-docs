# HU-001: Registro de Usuario

## 1. Ficha historia de usuario

| Campo | Detalles |
| :--- | :--- |
| **Proyecto** | Stable Experts |
| **Sistema** | Plataforma Web / Móvil |
| **Módulo** | Gestión de Usuarios |
| **Épica** | Autenticación y Seguridad |
| **ID HU** | HU-001 |
| **Nombre HU** | Registro de Nuevo Usuario |
| **Tipo** | Funcional |
| **Responsable** | Equipo de Desarrollo |
| **Fecha documento** | 2026-01-12 |
| **Prioridad** | Alta |
| **Observaciones** | Incluye registro tradicional (email) y OAuth (Google, etc.) |

## 2. Descripción HU
Como visitante no registrado, quiero poder crear una cuenta en la plataforma Stable Experts proporcionando mis datos básicos o utilizando mis redes sociales, para poder acceder a los servicios de gestión equina.

## 3. Roles como
- **Actor Principal:** Visitante (Usuario no autenticado).
- **Actores Secundarios:** Sistema de Correo, Proveedor de Identidad (Google/Meta).

## 4. Característica / Funcionalidad
- Formulario de registro con validación de campos (Email único, complejidad de contraseña).
- Integración con botones de "Login Social".
- Flujo de activación de cuenta vía correo electrónico (para registro tradicional).

## 5. Razón / Resultado
**Resultado Esperado:** El usuario obtiene una cuenta creada en el sistema. Si es por correo, recibe un enlace de activación. Si es social, accede directamente. Esto permite captar nuevos usuarios y asegurar sus identidades.

## 6. Criterios de aceptación

| ID | Criterio | Dado que | Cuando | Entonces |
| :--- | :--- | :--- | :--- | :--- |
| **CA-01** | **Registro Exitoso (Email)** | El usuario está en la página de registro y no tiene cuenta previa | Ingresa nombre, apellido, correo válido y contraseña segura, y da clic en "Registrar" | El sistema crea la cuenta en estado "Inactivo", envía un correo con link de activación y muestra un mensaje de éxito. |
| **CA-02** | **Correo Duplicado** | El correo ingresado ya existe en la base de datos | El usuario intenta registrarse con ese correo | El sistema muestra un error indicando que el usuario ya existe. |
| **CA-03** | **Contraseña Débil** | El usuario ingresa una contraseña simple (menos de 8 chars, sin números) | El usuario intenta enviar el formulario | El sistema bloquea el envío y muestra los requisitos de seguridad de la contraseña. |
| **CA-04** | **Registro Social Exitoso** | El usuario elige registrarse con Google | Autoriza la aplicación en la ventana emergente de Google | El sistema crea la cuenta automáticamente en estado "Activo" (tomando datos de Google) y lo redirige al Dashboard. |
