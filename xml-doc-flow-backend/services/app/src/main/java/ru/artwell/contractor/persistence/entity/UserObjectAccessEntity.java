package ru.artwell.contractor.persistence.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "user_object_access")
public class UserObjectAccessEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private UserEntity user;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "construction_object_id", nullable = false)
    private ConstructionObjectEntity constructionObject;

    @Column(name = "access_level", length = 32)
    private String accessLevel;

    public UserObjectAccessEntity(UserEntity user, ConstructionObjectEntity constructionObject, String accessLevel) {
        this.user = user;
        this.constructionObject = constructionObject;
        this.accessLevel = accessLevel;
    }

    protected UserObjectAccessEntity() {
    }

    public Long getId() {
        return id;
    }

    public UserEntity getUser() {
        return user;
    }

    public ConstructionObjectEntity getConstructionObject() {
        return constructionObject;
    }

    public String getAccessLevel() {
        return accessLevel;
    }
}
