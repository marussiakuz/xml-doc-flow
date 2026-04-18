package ru.artwell.contractor.persistence.spec;

import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;
import org.springframework.data.jpa.domain.Specification;
import ru.artwell.contractor.persistence.entity.DocumentEntity;
import ru.artwell.contractor.persistence.entity.DocumentVersionEntity;
import ru.artwell.contractor.persistence.entity.VersionValidationStatus;

import java.time.LocalDate;
import java.time.LocalDateTime;

public final class DocumentSpecifications {

    private DocumentSpecifications() {
    }

    /**
     * Подгружает связи для списка (не для count-запроса).
     */
    public static Specification<DocumentEntity> withListFetches() {
        return (root, query, cb) -> {
            if (query.getResultType() != Long.class && query.getResultType() != long.class) {
                root.fetch("documentType", JoinType.INNER);
                root.fetch("constructionObject", JoinType.INNER);
                root.fetch("uploadedBy", JoinType.INNER);
            }
            return cb.conjunction();
        };
    }

    public static Specification<DocumentEntity> byDocumentType(String typeCode) {
        return (root, query, cb) -> {
            if (typeCode == null || typeCode.isBlank()) {
                return cb.conjunction();
            }
            return cb.equal(root.get("documentType").get("typeCode"), typeCode.trim());
        };
    }

    public static Specification<DocumentEntity> byDocumentNumberLike(String documentNumber) {
        return (root, query, cb) -> {
            if (documentNumber == null || documentNumber.isBlank()) {
                return cb.conjunction();
            }
            String term = "%" + documentNumber.trim().toLowerCase() + "%";
            return cb.like(cb.lower(root.get("documentNumber")), term);
        };
    }

    public static Specification<DocumentEntity> byConstructionObject(Long objectId, String objectCode) {
        return (root, query, cb) -> {
            if (objectId != null) {
                return cb.equal(root.get("constructionObject").get("id"), objectId);
            }
            if (objectCode != null && !objectCode.isBlank()) {
                return cb.equal(root.get("constructionObject").get("objectCode"), objectCode.trim());
            }
            return cb.conjunction();
        };
    }

    public static Specification<DocumentEntity> byDocumentDateRange(LocalDate from, LocalDate to) {
        return (root, query, cb) -> {
            if (from == null && to == null) {
                return cb.conjunction();
            }
            if (from != null && to != null) {
                return cb.between(root.get("documentDate"), from, to);
            }
            if (from != null) {
                return cb.greaterThanOrEqualTo(root.get("documentDate"), from);
            }
            return cb.lessThanOrEqualTo(root.get("documentDate"), to);
        };
    }

    public static Specification<DocumentEntity> byUploadDateRange(LocalDateTime from, LocalDateTime to) {
        return (root, query, cb) -> {
            if (from == null && to == null) {
                return cb.conjunction();
            }
            if (from != null && to != null) {
                return cb.between(root.get("uploadedAt"), from, to);
            }
            if (from != null) {
                return cb.greaterThanOrEqualTo(root.get("uploadedAt"), from);
            }
            return cb.lessThanOrEqualTo(root.get("uploadedAt"), to);
        };
    }

    public static Specification<DocumentEntity> byStatus(String status) {
        return (root, query, cb) -> {
            if (status == null || status.isBlank()) {
                return cb.conjunction();
            }
            return cb.equal(root.get("status"), status.trim());
        };
    }

    public static Specification<DocumentEntity> byLatestOnly(boolean latestOnly) {
        return (root, query, cb) -> {
            if (latestOnly) {
                return cb.isTrue(root.get("latestVersion"));
            }
            return cb.conjunction();
        };
    }

    public static Specification<DocumentEntity> byValidationStatusForCurrentVersion(String validationStatus) {
        return (root, query, cb) -> {
            if (validationStatus == null || validationStatus.isBlank()) {
                return cb.conjunction();
            }
            VersionValidationStatus vs;
            try {
                vs = VersionValidationStatus.valueOf(validationStatus.trim().toUpperCase());
            } catch (IllegalArgumentException e) {
                return cb.disjunction();
            }
            Join<DocumentEntity, DocumentVersionEntity> versions = root.join("versions", JoinType.INNER);
            query.distinct(true);
            return cb.and(
                    cb.equal(versions.get("versionNumber"), root.get("currentVersion")),
                    cb.equal(versions.get("validationStatus"), vs)
            );
        };
    }
}
