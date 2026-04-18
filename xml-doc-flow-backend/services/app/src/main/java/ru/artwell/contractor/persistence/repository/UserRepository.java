package ru.artwell.contractor.persistence.repository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ru.artwell.contractor.persistence.entity.UserEntity;

import java.util.Optional;

public interface UserRepository extends JpaRepository<UserEntity, Long> {

    Optional<UserEntity> findByUsername(String username);

    boolean existsByUsername(String username);

    @Query("SELECT u FROM UserEntity u WHERE u.active = true")
    Page<UserEntity> findAllActive(Pageable pageable);

    @Query("SELECT u FROM UserEntity u WHERE u.role = :role")
    Page<UserEntity> findByRole(@Param("role") String role, Pageable pageable);
}
