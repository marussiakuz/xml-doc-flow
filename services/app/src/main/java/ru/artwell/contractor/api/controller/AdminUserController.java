package ru.artwell.contractor.api.controller;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import ru.artwell.contractor.dto.admin.CreateUserRequest;
import ru.artwell.contractor.dto.admin.UpdateUserRequest;
import ru.artwell.contractor.dto.admin.UserAdminResponse;
import ru.artwell.contractor.security.SecurityUser;
import ru.artwell.contractor.service.AdminUserService;

@Tag(name = "03. Администрирование пользователей", description = "Управление пользователями (только ADMIN)")
@RestController
@RequestMapping("/api/admin/users")
@PreAuthorize("hasRole('ADMIN')")
public class AdminUserController {

    private final AdminUserService adminUserService;

    public AdminUserController(AdminUserService adminUserService) {
        this.adminUserService = adminUserService;
    }

    @Operation(summary = "Получить список пользователей с пагинацией и фильтрацией по роли")
    @GetMapping
    public ResponseEntity<Page<UserAdminResponse>> listUsers(
            @RequestParam(required = false) String role,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size
    ) {
        Page<UserAdminResponse> users = adminUserService.listUsers(
                role,
                PageRequest.of(page, size, Sort.by("id").descending())
        );
        return ResponseEntity.ok(users);
    }

    @Operation(summary = "Получить пользователя по ID")
    @GetMapping("/{id}")
    public ResponseEntity<UserAdminResponse> getUser(@PathVariable Long id) {
        return ResponseEntity.ok(adminUserService.getUser(id));
    }

    @Operation(summary = "Создать нового пользователя")
    @PostMapping
    public ResponseEntity<UserAdminResponse> createUser(
            @Valid @RequestBody CreateUserRequest request,
            @AuthenticationPrincipal SecurityUser admin
    ) {
        UserAdminResponse created = adminUserService.createUser(request, admin.getUser());
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }

    @Operation(summary = "Обновить пользователя")
    @PutMapping("/{id}")
    public ResponseEntity<UserAdminResponse> updateUser(
            @PathVariable Long id,
            @Valid @RequestBody UpdateUserRequest request,
            @AuthenticationPrincipal SecurityUser admin
    ) {
        UserAdminResponse updated = adminUserService.updateUser(id, request, admin.getUser());
        return ResponseEntity.ok(updated);
    }

    @Operation(summary = "Удалить пользователя (мягкое удаление)")
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteUser(
            @PathVariable Long id,
            @AuthenticationPrincipal SecurityUser admin
    ) {
        adminUserService.deleteUser(id, admin.getUser());
        return ResponseEntity.noContent().build();
    }

    @Operation(summary = "Сбросить пароль пользователя")
    @PostMapping("/{id}/reset-password")
    public ResponseEntity<Void> resetPassword(
            @PathVariable Long id,
            @RequestBody ResetPasswordRequest request,
            @AuthenticationPrincipal SecurityUser admin
    ) {
        adminUserService.resetPassword(id, request.password(), admin.getUser());
        return ResponseEntity.ok().build();
    }

    record ResetPasswordRequest(String password) {
    }
}

