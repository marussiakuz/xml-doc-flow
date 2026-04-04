package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import ru.artwell.contractor.persistence.entity.UserEntity;

import java.util.Optional;

public interface UserRepository extends JpaRepository<UserEntity, Long> {

    Optional<UserEntity> findByUsername(String username);
}
