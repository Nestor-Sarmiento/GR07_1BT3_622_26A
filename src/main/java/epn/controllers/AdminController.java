package epn.controllers;

import epn.schemas.Admin;
import epn.services.UserService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.server.ResponseStatusException;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admins")
@Tag(name = "Administradores", description = "Endpoints para gestión de administradores")
@SecurityRequirement(name = "Bearer JWT")
public class AdminController {

    private final UserService userService;

    public AdminController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/me")
    @Operation(
            summary = "Obtener mis datos",
            description = "Obtiene los datos del administrador autenticado (nombre, apellido, email)"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Datos del usuario obtenidos"),
            @ApiResponse(responseCode = "404", description = "Administrador no encontrado"),
            @ApiResponse(responseCode = "401", description = "No autenticado - Token inválido o expirado")
    })
    public ResponseEntity<?> obtenerMisDatos() {
        // Obtener email del JWT desde el contexto de seguridad
        String email = SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString();
        return ResponseEntity.ok(userService.obtenerMisDatos(email));
    }

    @GetMapping
    @Operation(
            summary = "Listar administradores",
            description = "Obtiene la lista completa de administradores registrados"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Lista de administradores obtenida"),
            @ApiResponse(responseCode = "401", description = "No autenticado - Token inválido o expirado")
    })
    public List<Admin> listar() {
        return userService.listarAdmins();
    }

    @GetMapping("/{id}")
    @Operation(
            summary = "Obtener administrador por ID",
            description = "Trae los detalles de un administrador específico por su ID"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Administrador encontrado"),
            @ApiResponse(responseCode = "404", description = "Administrador no encontrado"),
            @ApiResponse(responseCode = "401", description = "No autenticado")
    })
    public Admin obtenerPorId(@PathVariable String id) {
        return userService.obtenerAdminPorId(id);
    }

    @PostMapping
    @Operation(
            summary = "Crear nuevo administrador",
            description = "Crea un nuevo administrador con email, nombre y apellido. La contraseña se genera automáticamente y se envía por email. El admin debe cambiarla en el primer login."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "201", description = "Administrador creado exitosamente - Contraseña temporal enviada por email"),
            @ApiResponse(responseCode = "400", description = "Datos inválidos - ID debe ser null"),
            @ApiResponse(responseCode = "409", description = "Conflicto - Email ya está en uso"),
            @ApiResponse(responseCode = "401", description = "No autenticado")
    })
    public ResponseEntity<?> crear(@RequestBody Admin admin) {
        if (admin.getId_usuario() != null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error: Datos involucrados son incorrectos");
        }
        try {
            Admin creado = userService.crearAdmin(admin);
            return ResponseEntity.status(HttpStatus.CREATED).body(Map.of(
                    "message", "Administrador creado exitosamente",
                    "admin", creado,
                    "note", "Contraseña temporal enviada al email " + creado.getEmail()
            ));
        } catch (ResponseStatusException e) {
            return ResponseEntity.status(e.getStatusCode()).body(Map.of("error", e.getReason()));
        }

    }

    @PatchMapping
    @Operation(
            summary = "Actualizar mis datos",
            description = "Actualiza los datos del administrador autenticado. Solo se pueden actualizar nombre y/o apellido."
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "Datos actualizados exitosamente"),
            @ApiResponse(responseCode = "404", description = "Administrador no encontrado"),
            @ApiResponse(responseCode = "401", description = "No autenticado")
    })
    public Admin actualizarMisDatos(@RequestBody Admin admin) {
        // Obtener email del JWT desde el contexto de seguridad
        String email = SecurityContextHolder.getContext().getAuthentication().getPrincipal().toString();
        return userService.actualizarMisDatos(email, admin);
    }

    @DeleteMapping("/{id}")
    @Operation(
            summary = "Eliminar administrador",
            description = "Marca administrativamente como INACTIVO el administrador (borrado lógico)"
    )
    @ApiResponses(value = {
            @ApiResponse(responseCode = "204", description = "Administrador eliminado (marcado como INACTIVO)"),
            @ApiResponse(responseCode = "404", description = "Administrador no encontrado"),
            @ApiResponse(responseCode = "401", description = "No autenticado")
    })
    public ResponseEntity<Void> eliminar(@PathVariable String id) {
        userService.eliminarAdmin(id);
        return ResponseEntity.noContent().build();
    }

    @GetMapping("/")
    public String healthCheck() {
        return "API is running";
    }
}
