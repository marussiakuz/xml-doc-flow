package ru.artwell.contractor.dto;

import java.math.BigDecimal;

public record WorkVolumeDto(String workType, BigDecimal quantity) {
}
