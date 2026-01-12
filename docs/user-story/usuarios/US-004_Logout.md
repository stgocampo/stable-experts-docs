# HU-004: Cierre de Sesión

## 1. Ficha historia de usuario

| Campo | Detalles |
| :--- | :--- |
| **Proyecto** | Stable Experts |
| **Sistema** | Plataforma Web / Móvil |
| **Módulo** | Gestión de Usuarios |
| **Épica** | Autenticación y Seguridad |
| **ID HU** | HU-004 |
| **Nombre HU** | Cierre de Sesión (Logout) |
| **Tipo** | Funcional |
| **Responsable** | Equipo de Desarrollo |
| **Fecha documento** | 2026-01-12 |
| **Prioridad** | Media |
| **Observaciones** | Debe asegurar que el token de sesión quede inutilizable en el cliente. |

## 2. Descripción HU
Como usuario autenticado, quiero poder cerrar mi sesión explícitamente, para asegurar que nadie más pueda acceder a mi cuenta desde el dispositivo que estoy utilizando.

## 3. Roles como
- **Actor Principal:** Usuario Autenticado.
- **Actores Secundarios:** Sistema.

## 4. Característica / Funcionalidad
- Botón visible de "Cerrar Sesión" en el menú principal.
- Confirmación de acción (opcional).
- Limpieza de almacenamiento local (Tokens, Cache de usuario).

## 5. Razón / Resultado
**Resultado Esperado:** La sesión finaliza y el usuario es redirigido a la pantalla de login pública. Se previenen accesos no autorizados en equipos compartidos.

## 6. Criterios de aceptación

| ID | Criterio | Dado que | Cuando | Entonces |
| :--- | :--- | :--- | :--- | :--- |
| **CA-01** | **Logout Voluntario** | El usuario ha iniciado sesión | Hace clic en "Cerrar Sesión" | El sistema elimina el token de acceso del dispositivo y redirige al Login. |
| **CA-02** | **Logout por Expiración** | El usuario ha dejado la sesión inactiva por X tiempo | Intenta realizar una acción | El sistema detecta el token expirado, cierra la sesión automáticamente y solicita login nuevamente. |
