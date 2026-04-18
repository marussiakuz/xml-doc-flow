package ru.artwell.contractor.dto;

import java.math.BigDecimal;

public record WorkVolumeInfo(Long id, String workType, BigDecimal quantity) {
}
