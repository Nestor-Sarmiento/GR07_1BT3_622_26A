package epn.controllers;

import epn.schemas.Admin;
import epn.services.UserService;

import org.springframework.context.annotation.Description;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/admins")
public class AdminController {

    private final UserService userService;

    public AdminController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping
    public List<Admin> listar() {
        return userService.listarAdmins();
    }

    @Description("Usuario especifico de admin")
    @GetMapping("/{id}")
    public Admin obtenerPorId(@PathVariable String id) {
        return userService.obtenerAdminPorId(id);
    }


    /*
    TODO: Agregar JWT
    */
    @PostMapping
    public ResponseEntity<?> crear(@RequestBody Admin admin) {
        if (admin.getId_usuario() != null) {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Error: Datos involucrados son incorrectos");
        }
        Admin creado = userService.crearAdmin(admin);
        return ResponseEntity.status(HttpStatus.CREATED).body(creado);
    }

    // TODO: Patch Nombre, apellido, contraseña. Por ultimo email 
    @PutMapping("/{id}")
    public Admin actualizar(@PathVariable String id, @RequestBody Admin admin) {
        return userService.actualizarAdmin(id, admin);
    }

    // TODO: Borrado logico
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> eliminar(@PathVariable String id) {
        userService.eliminarAdmin(id);
        return ResponseEntity.noContent().build();
    }
}
