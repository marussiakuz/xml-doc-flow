package ru.artwell.contractor.persistence.repository;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import ru.artwell.contractor.persistence.entity.UserObjectAccessEntity;

import java.util.List;
import java.util.Set;

public interface UserObjectAccessRepository extends JpaRepository<UserObjectAccessEntity, Long> {

    List<UserObjectAccessEntity> findByUser_Id(Long userId);

    @Query("SELECT uoa.constructionObject.id FROM UserObjectAccessEntity uoa WHERE uoa.user.id = :userId")
    Set<Long> findConstructionObjectIdsByUserId(@Param("userId") Long userId);

    boolean existsByUser_IdAndConstructionObject_Id(Long userId, Long constructionObjectId);
}
