<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://v_17_0/types/CommonTypes.xsd"
    xmlns:cf="http://v_17_0/idJournals/idSpJournalConcreteWorksRecord.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />
    <xsl:param name="version" select="1.0"/>
    
    <xsl:template match="/">
        <xsl:apply-templates select="/cf:idSpJournalConcreteWorksRecord" />
    </xsl:template>
    
    <xsl:template match="/cf:idSpJournalConcreteWorksRecord">
        <!-- Начало основного шаблона -->
        <html>
            <head>
                <style type="text/css">
                    h1 {
                        font-family: Times New Roman;
                        font-size: 14pt;
                        text-align:center;
                        font-weight: bold;
                        width: 100%;
                        margin-top: 0px;
                    }
                    h2 {
                        font-family: Times New Roman;
                        font-size: 12pt;
                        text-align:center;
                        font-weight: bold;
                        width: 100%;
                        margin-top: 0px;
                    }
                    p {
                        font-family: Times New Roman;
                        font-size: 14pt;
                        margin-bottom: 5px;
                        text-indent: 0px;
                        margin-top: 1.5em;
                        text-align: justify;
                        
                    }
                    body {
                        font-family: Times New Roman;
                        font-size: 14pt;
                        padding: 20px;
                        margin: 0 auto;
                        max-width:1600
                    }
                    .attachment{
                        margin:0cm;
                        margin-bottom:.0001pt;
                        font-size:10.0pt;
                        font-family:Times New Roman;
                        margin-left:290.6pt;
                        text-align:right;
                    }
                    .title {
                        font-size: 12pt;
                        text-align:center
                    }
                    .mso {
                        font-size: 12pt;
                        text-align:center
                    }
                    .under {
                        text-align:center;
                        font-size:9.0pt;
                        line-height:150%;
                        font-family:Times New Roman;
                    }
                    .data {
                        margin-bottom:1.0pt;
                        font-family: Times New Roman;
                        font-style: italic;
                        border-bottom: 1px solid;
                        font-size: 10pt;
                        text-align: center;
                        flex-grow: 1; 
                        align-content: end;
                    }
                    .list {
                        font-size: 9pt;
                    }
                    .pagebreak {
                        page-break-before: always;
                    }
                    .str {
                        display: flex;
                        flex-wrap: wrap;
                    }
                    table {
                        table-layout: fixed;
                        width: 100%;
                        border-collapse: collapse;
                        word-wrap: break-word;
                    }
                    th.list {
                        height:100pt;
                    }
                    td, th {
                        border: 1pt solid #000000;
                        padding: 2pt;
                        font-weight: normal;
                    }
                    td .data {
                        border-bottom: 0 solid;
                    }
                </style>
            </head>
            <title>Сведения о производстве бетонных работ (запись журнала бетонных работ (ЖБР))</title>
            <body>
                <xsl:for-each select="cf:recordCancelSignedPart">
                    <xsl:for-each select="cf:buildingContractorSignedPart">
                            <table border="1">
                                <tr>
                                    <th class="list" rowspan="2">Статус записи</th>
                                    <th class="list" rowspan="2">Дата и время укладки бетона</th>
                                    <th class="list" rowspan="2">Наименование бетонируемой конструкции и ее расположение (оси, отметка)</th>
                                    <th class="list" rowspan="2">Изготовитель (поставщик) бетонной смеси</th>
                                    <th class="list" rowspan="2">Условное обозначение бетонной смеси и номер документа о качестве по ГОСТ7473</th>
                                    <th class="list" rowspan="2"><p class="list" style="transform: rotate(180deg); writing-mode: vertical-rl">Объем партии бетонной смеси, уложенной в конструкцию, м<sup>3</sup></p></th>
                                    <th class="list" rowspan="2"><p class="list" style="transform: rotate(180deg); writing-mode: vertical-rl">Температура наружного воздуха, &#176;С</p></th>
                                    <th class="list" rowspan="2"><p class="list" style="transform: rotate(180deg); writing-mode: vertical-rl">Способ и режим твердения бетона</p></th>
                                    <th class="list" rowspan="2">Проектный класс прочности бетона В (В<sub>норм</sub>)</th>
                                    <th class="list" rowspan="2">Нормируемая прочность бетона в промежуточном возрасте при распалубке или нагружении конструкций (%В<sub>норм</sub>)</th>
                                    <th class="list" rowspan="2"><p class="list" style="transform: rotate(180deg); writing-mode: vertical-rl">Должность, ФИО и подпись ответственного исполнителя работ по бетонированию</p></th>                                   
                                    <th class="list" rowspan="2">Фактический класс прочности бетона (В<sub>ф</sub>) в проектном возрасте в контролируемой партии конструкций по результатам сплошного 
                                    неразрушающего контроля прочности по ГОСТ 18105</th>
                                    <th class="list" rowspan="2">Фактическая прочность бетона в контролируемой партии конструкций по результатам сплошного неразрушающего контроля прочности по ГОСТ18105</th>
                                    <th class="list" colspan="2" >Средняя прочность серий контрольных образцов бетона (МПа) по результатам входного контроля прочности
                                    бетонной смеси по пункту 5.4 ГОСТ 18105 или по примечанию к пункту 4.3 ГОСТ 18105</th>
                                    <th class="list" rowspan="2"><p class="list" style="transform: rotate(180deg); writing-mode: vertical-rl">Должность, ФИО и подпись ответственного за проведение контроля и оценку прочности бетона</p></th>
                                </tr>
                                <tr>
                                    <th class="list">В промежуточном возрасте</th>
                                    <th class="list">В проектном возрасте</th>
                                </tr>
                                <tr class="list">
                                    <th>1</th>
                                    <th>2</th>
                                    <th>3</th>
                                    <th>4</th>
                                    <th>5</th>
                                    <th>6</th>
                                    <th>7</th>
                                    <th>8</th>
                                    <th>9</th>
                                    <th>10</th>
                                    <th>11</th>
                                    <th>12</th>
                                    <th>13</th>
                                    <th>14</th>
                                    <th>15</th>
                                    <th>16</th>
                                </tr>
                                <!-- запись -->
                                <tr>
                                    <!-- Статус записи -->
                                    <td>
                                        <p class="data">
                                            <xsl:for-each select="../../cf:recordStatus">  
                                                <xsl:choose>
                                                    <xsl:when test=".='On_revision'">
                                                        <xsl:text>На доработке, частично подписанный</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test=".='Signed'">
                                                        <xsl:text>Подписан</xsl:text>
                                                    </xsl:when>
                                                    <xsl:when test=".='Canceled'">
                                                        <xsl:text>Аннулирован</xsl:text>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:for-each>
                                            <xsl:if test="../../cf:representativeCancelSignature">
                                                <br/>
                                                <xsl:for-each select="../cf:recordCancelInfo">
                                                    <xsl:call-template name="formatdatetime">
                                                        <xsl:with-param name="DateTimeStr" select="ct:recordCancelDateTime"/>
                                                    </xsl:call-template>
                                                    <br/>
                                                    <xsl:call-template name="nameTempl">
                                                        <xsl:with-param name="Person" select="ct:representativeCancel"/>
                                                    </xsl:call-template>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </p>
                                    </td>
                                    <xsl:for-each select="cf:recordSignedPart">
                                        <!-- !Дата и время укладки бетона -->
                                        <td>
                                            <xsl:for-each select="cf:concreteWorkDateTime">
                                                <p class="data">с 
                                                    <xsl:call-template name="formatdatetime">
                                                        <xsl:with-param name="DateTimeStr" select="ct:beginDate" />
                                                    </xsl:call-template> до 
                                                    <xsl:call-template name="formatdatetime">
                                                        <xsl:with-param name="DateTimeStr" select="ct:endDate" />
                                                    </xsl:call-template>
                                                </p>
                                            </xsl:for-each>
                                        </td>
                                        <!-- !Наименование бетонируемой конструкции и ее расположение -->
                                        <td>
                                            <xsl:for-each select="cf:constructionInfo">
                                                <p class="data">
                                                    <xsl:value-of select="cf:permanentObjectStructureElement/ct:structureElementName"/>
                                                    <xsl:for-each select="ct:location">
                                                        <xsl:choose>
                                                            <xsl:when test="ct:obligatoryAxes">
                                                                <xsl:for-each select="ct:obligatoryAxes">
                                                                    <xsl:call-template name="location" />
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:when test="ct:obligatoryRanks">
                                                                <xsl:for-each select="ct:obligatoryRanks">
                                                                    <xsl:call-template name="location" />
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:when test="ct:obligatoryMarks">
                                                                <xsl:for-each select="ct:obligatoryMarks">
                                                                    <xsl:call-template name="location" />
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:when test="ct:obligatoryFloors">
                                                                <xsl:for-each select="ct:obligatoryFloors">
                                                                    <xsl:call-template name="location" />
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:when test="ct:obligatoryTiers">
                                                                <xsl:for-each select="ct:obligatoryTiers">
                                                                    <xsl:call-template name="location" />
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:when test="ct:obligatorySections">
                                                                <xsl:for-each select="ct:obligatorySections">
                                                                    <xsl:call-template name="location" />
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:when test="ct:obligatoryPremises">
                                                                <xsl:for-each select="ct:obligatoryPremises">
                                                                    <xsl:call-template name="location" />
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:when test="ct:place">
                                                                <xsl:value-of select="ct:place"/>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                    </xsl:for-each>
                                                </p>
                                            </xsl:for-each>
                                        </td>
                                        <xsl:for-each select="cf:concreteInfo">
                                            <!-- Изготовитель (поставщик) бетонной смеси -->
                                            <td>
                                                <p class="data">
                                                    <!-- Изготовитель -->
                                                    <xsl:text>Изготовитель: </xsl:text>
                                                    <xsl:for-each select="cf:concreteManufacturerList/cf:concreteManufacturer">  
                                                        <xsl:choose>
                                                            <xsl:when test="cf:manufacturerInfo/ct:individualEntrepreneur">
                                                                <xsl:for-each select="cf:manufacturerInfo/ct:individualEntrepreneur">
                                                                    <xsl:call-template name="nameTempl">
                                                                        <xsl:with-param name="Person" select="." />
                                                                    </xsl:call-template>
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:when test="cf:manufacturerInfo/ct:legalEntity">
                                                                <xsl:for-each select="cf:manufacturerInfo/ct:legalEntity">
                                                                    <xsl:value-of select="."/>
                                                                </xsl:for-each> 
                                                            </xsl:when>
                                                        </xsl:choose>
                                                        <xsl:if test="following-sibling:: cf:concreteManufacturer">
                                                            <xsl:text>; </xsl:text>
                                                        </xsl:if>
                                                    </xsl:for-each><br/>
                                                    <!-- Поставщик -->
                                                    <xsl:if test="cf:concreteSupplierList">
                                                        <br/><xsl:text>Поставщик: </xsl:text>
                                                    </xsl:if>
                                                    <xsl:for-each select="cf:concreteSupplierList/cf:concreteSupplier">  
                                                        <xsl:choose>
                                                            <xsl:when test="cf:supplierInfo/ct:individualEntrepreneur">
                                                                <xsl:for-each select="cf:supplierInfo/ct:individualEntrepreneur">
                                                                    <xsl:call-template name="nameTempl">
                                                                        <xsl:with-param name="Person" select="." />
                                                                    </xsl:call-template>
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:when test="cf:supplierInfo/ct:legalEntity">
                                                                <xsl:for-each select="cf:supplierInfo/ct:legalEntity">
                                                                    <xsl:value-of select="."/>
                                                                </xsl:for-each> 
                                                            </xsl:when>
                                                        </xsl:choose>
                                                        <xsl:if test="following-sibling:: cf:concreteSupplier">
                                                            <xsl:text>; </xsl:text>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </p>
                                            </td>
                                            <!-- !Условное обозначение бетонной смеси и номер документа о качестве по ГОСТ7473 -->
                                            <td>
                                                <p class="data">
                                                    <xsl:value-of select="cf:concreteLabel"/><xsl:text> (</xsl:text>
                                                    <xsl:for-each select="cf:materialList/cf:material">
                                                        <xsl:for-each select="cf:qualityApproveDocuments">
                                                            <xsl:choose>
                                                                <xsl:when test="cf:untypedQualityApproveDocumentList/cf:untypedQualityApproveDocument">
                                                                    <xsl:for-each select="cf:untypedQualityApproveDocumentList/cf:untypedQualityApproveDocument">
                                                                        <xsl:text> № </xsl:text><xsl:value-of select="ct:number"/>
                                                                        <xsl:if test="following-sibling:: cf:parametersComplianceDocument">
                                                                            <xsl:text>, </xsl:text>
                                                                        </xsl:if>
                                                                    </xsl:for-each>
                                                                </xsl:when>
                                                                <xsl:when test="cf:typedQualityApproveDocuments/cf:parametersComplianceDocument">
                                                                    <xsl:for-each select="cf:typedQualityApproveDocuments/cf:parametersComplianceDocument">
                                                                        <xsl:text> № </xsl:text><xsl:value-of select="ct:number"/>
                                                                        <xsl:if test="following-sibling:: cf:parametersComplianceDocument">
                                                                            <xsl:text>, </xsl:text>
                                                                        </xsl:if>
                                                                    </xsl:for-each>
                                                                </xsl:when>
                                                            </xsl:choose>
                                                        </xsl:for-each>
                                                        <xsl:if test="following-sibling:: cf:material">
                                                            <xsl:text>, </xsl:text>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                    <xsl:text>)</xsl:text>
                                                </p>
                                            </td>
                                        </xsl:for-each>    
                                        <!-- !Объем партии бетонной смеси, уложенной в конструкцию, м3 -->
                                        <td>
                                            <p class="data">
                                                <xsl:value-of select="cf:concreteVolume"/>  
                                            </p>
                                        </td>
                                        <!-- !Температура наружного воздуха, 0С -->
                                        <td>
                                            <p class="data">
                                                <xsl:value-of select="cf:openAirTemperature"/>
                                            </p>
                                        </td>
                                        <!-- !Способ и режим твердения бетона -->
                                        <td>
                                            <xsl:for-each select="cf:concreteHardeningInfo">
                                                <p class="data">
                                                    <xsl:choose>
                                                        <xsl:when test="cf:variantRequiredConcreteHardeningMethod">
                                                            <xsl:for-each select="cf:variantRequiredConcreteHardeningMethod">
                                                                <xsl:value-of select="cf:concreteHardeningMethod"/><br/>
                                                                <xsl:value-of select="cf:concreteHardeningMode"/>
                                                            </xsl:for-each>
                                                        </xsl:when>
                                                        <xsl:when test="cf:variantRequiredConcreteHardeningMode">
                                                            <xsl:for-each select="cf:variantRequiredConcreteHardeningMode">
                                                                <xsl:value-of select="cf:concreteHardeningMode"/>
                                                            </xsl:for-each>
                                                        </xsl:when>
                                                    </xsl:choose>
                                                </p>
                                            </xsl:for-each>
                                        </td>  
                                        <!-- !Проектный класс прочности бетона В -->
                                        <td>
                                            <xsl:for-each select="cf:concreteStrengthProjectNormativeGrade">
                                                <p class="data">
                                                    <xsl:value-of select="."/>
                                                </p>
                                            </xsl:for-each>
                                        </td>
                                        <!-- !Нормируемая прочность бетона в промежуточном возрасте при распалубке или нагружении конструкций -->
                                        <td>
                                            <xsl:for-each select="cf:concreteMiddleAgedNormativeStrength">
                                                <p class="data">
                                                    <xsl:value-of select="."/>  
                                                </p>
                                            </xsl:for-each>
                                        </td>
                                        <!-- !Подпись ответственных исполнителей работ по бетонированию и контролю качества -->
                                        <td>
                                            <p class="data">
                                                <xsl:choose>
                                                    <xsl:when test="cf:representativeBuildingContractor/ct:representative">
                                                        <xsl:for-each select="cf:representativeBuildingContractor/ct:representative">
                                                            <xsl:value-of select="ct:position"/><br/>
                                                            <xsl:call-template name="nameTempl">
                                                                <xsl:with-param name="Person" select="." />
                                                            </xsl:call-template>
                                                        </xsl:for-each>
                                                    </xsl:when>
                                                    <xsl:when test="cf:representativeWorkExecutor/ct:representative">
                                                        <xsl:for-each select="cf:representativeWorkExecutor/ct:representative">
                                                            <xsl:value-of select="ct:position"/><br/>
                                                            <xsl:call-template name="nameTempl">
                                                                <xsl:with-param name="Person" select="." />
                                                            </xsl:call-template>
                                                        </xsl:for-each>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </p>
                                        </td>
                                    </xsl:for-each>
                                    <!-- !Фактический (Вф) в проектном возрасте в контролируемой партии конструкций по результатам сплошного неразрушающего контроля прочности по ГОСТ 18105 -->
                                    <td>
                                        <xsl:for-each select="cf:concreteStrengthFactGrade">
                                            <p class="data">
                                                <xsl:value-of select="."/>
                                            </p>
                                        </xsl:for-each>
                                    </td>
                                    <!-- !Фактическая в контролируемой партии конструкций по результатам сплошного неразрушающего контроля прочности по ГОСТ18105 -->
                                    <td>
                                        <xsl:for-each select="cf:factStrength">
                                            <p class="data">
                                                <xsl:value-of select="."/>
                                            </p>
                                        </xsl:for-each>
                                    </td>
                                    <!-- !Средняя прочность серий контрольных образцов бетона по результатам входного контроля прочности бетонной смеси в промежуточном возрасте  -->
                                    <td>
                                        <xsl:for-each select="cf:concreteMiddleAgedAverageStrength">
                                            <p class="data">
                                                <xsl:value-of select="."/>
                                            </p>
                                        </xsl:for-each>
                                    </td>
                                    <!-- !Средняя прочность серий контрольных образцов бетона по результатам входного контроля прочности бетонной смеси в проектном возрасте -->
                                    <td>
                                        <xsl:for-each select="cf:concreteProjectAgedAverageStrength">
                                            <p class="data">
                                                <xsl:value-of select="."/>
                                            </p>
                                        </xsl:for-each>
                                    </td>
                                    <!-- !Лицо, ответственное за проведение контроля и оценку прочности бетона -->
                                    <td>
                                        <xsl:for-each select="cf:representativeBuildingContractor/ct:representative">
                                            <p class="data">
                                                <xsl:value-of select="ct:position"/><br/>
                                                <xsl:call-template name="nameTempl">
                                                    <xsl:with-param name="Person" select="." />
                                                </xsl:call-template>
                                            </p>
                                        </xsl:for-each>
                                    </td>
                                </tr>
                            </table>
                    </xsl:for-each>
                </xsl:for-each>
            </body>
        </html>           
    </xsl:template>

    <!-- Вывод даты в формате ДД.ММ.ГГГГ-->
    <xsl:template name="formatdate">
        <xsl:param name="DateStr" />
        <xsl:variable name="dd">
            <xsl:value-of select="substring(string($DateStr), 9, 2)" />
        </xsl:variable>
        
        <xsl:variable name="mm">
            <xsl:value-of select="substring(string($DateStr), 6, 2)" />
        </xsl:variable>
        
        <xsl:variable name="yyyy">
            <xsl:value-of select="substring(string($DateStr), 1, 4)" />
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$mm = 01">
                <xsl:value-of select="concat('«', $dd, '» ', 'января ', $yyyy, ' г.' )" />
            </xsl:when>
            <xsl:when test="$mm = 02">
                <xsl:value-of select="concat('«', $dd, '» ', 'февраля ', $yyyy, ' г.' )" />
            </xsl:when>
            <xsl:when test="$mm = 03">
                <xsl:value-of select="concat('«', $dd, '» ', 'марта ', $yyyy, ' г.' )" />
            </xsl:when>
            <xsl:when test="$mm = 04">
                <xsl:value-of select="concat('«', $dd, '» ', 'апреля ', $yyyy, ' г.' )" />
            </xsl:when>
            <xsl:when test="$mm = 05">
                <xsl:value-of select="concat('«', $dd, '» ', 'мая ', $yyyy, ' г.' )" />
            </xsl:when>
            <xsl:when test="$mm = 06">
                <xsl:value-of select="concat('«', $dd, '» ', 'июня ', $yyyy, ' г.' )" />
            </xsl:when>
            <xsl:when test="$mm = 07">
                <xsl:value-of select="concat('«', $dd, '» ', 'июля', $yyyy, ' г.' )" />
            </xsl:when>
            <xsl:when test="$mm = 08">
                <xsl:value-of select="concat('«', $dd, '» ', 'августа ', $yyyy, ' г.' )" />
            </xsl:when>
            <xsl:when test="$mm = 09">
                <xsl:value-of select="concat('«', $dd, '» ', 'сентября ', $yyyy, ' г.' )" />
            </xsl:when>
            <xsl:when test="$mm = 10">
                <xsl:value-of select="concat('«', $dd, '» ', 'октября ', $yyyy, ' г.' )" />
            </xsl:when>
            <xsl:when test="$mm = 11">
                <xsl:value-of select="concat('«', $dd, '» ', 'ноября ', $yyyy, ' г.' )" />
            </xsl:when>
            <xsl:when test="$mm = 12">
                <xsl:value-of select="concat('«', $dd, '» ', 'декабря ', $yyyy, ' г.' )" />
            </xsl:when>
        </xsl:choose>
        
    </xsl:template>
    
    <!-- Вывод даты в формате ДД.ММ.ГГГГ чч:мм-->  
    <xsl:template name="formatdatetime">
        <xsl:param name="DateTimeStr" />
        
        <xsl:variable name="dd">
            <xsl:value-of select="substring(string($DateTimeStr), 9, 2)" />
        </xsl:variable>
        
        <xsl:variable name="mm">
            <xsl:value-of select="substring(string($DateTimeStr), 6, 2)" />
        </xsl:variable>
        
        <xsl:variable name="yyyy">
            <xsl:value-of select="substring(string($DateTimeStr), 1, 4)" />
        </xsl:variable>
        
        <xsl:variable name="hh">
            <xsl:value-of select="substring(string($DateTimeStr), 12, 2)" />
        </xsl:variable>
        
        <xsl:variable name="m">
            <xsl:value-of select="substring(string($DateTimeStr), 15, 2)" />
        </xsl:variable>
        
        <xsl:choose>
            <xsl:when test="$mm = 01">
                <xsl:value-of select="concat('«', $dd, '» ', 'января ', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
            </xsl:when>
            <xsl:when test="$mm = 02">
                <xsl:value-of select="concat('«', $dd, '» ', 'февраля ', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
            </xsl:when>
            <xsl:when test="$mm = 03">
                <xsl:value-of select="concat('«', $dd, '» ', 'марта ', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
            </xsl:when>
            <xsl:when test="$mm = 04">
                <xsl:value-of select="concat('«', $dd, '» ', 'апреля ', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
            </xsl:when>
            <xsl:when test="$mm = 05">
                <xsl:value-of select="concat('«', $dd, '» ', 'мая ', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
            </xsl:when>
            <xsl:when test="$mm = 06">
                <xsl:value-of select="concat('«', $dd, '» ', 'июня ', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
            </xsl:when>
            <xsl:when test="$mm = 07">
                <xsl:value-of select="concat('«', $dd, '» ', 'июля', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
            </xsl:when>
            <xsl:when test="$mm = 08">
                <xsl:value-of select="concat('«', $dd, '» ', 'августа ', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
            </xsl:when>
            <xsl:when test="$mm = 09">
                <xsl:value-of select="concat('«', $dd, '» ', 'сентября ', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
            </xsl:when>
            <xsl:when test="$mm = 10">
                <xsl:value-of select="concat('«', $dd, '» ', 'октября ', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
            </xsl:when>
            <xsl:when test="$mm = 11">
                <xsl:value-of select="concat('«', $dd, '» ', 'ноября ', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
            </xsl:when>
            <xsl:when test="$mm = 12">
                <xsl:value-of select="concat('«', $dd, '» ', 'декабря ', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <!-- Инициалы -->
    <xsl:template name="initials">
        <xsl:param name="NameStr" />
        
        <xsl:if test="$NameStr !=''">
            <xsl:variable name="i">
                <xsl:value-of select="substring($NameStr, 1, 1)" />
            </xsl:variable>
            
            <xsl:value-of select="concat($i, '.')" />
        </xsl:if>
    </xsl:template>

    <!-- Фамилия И.О. -->
    <xsl:template name="nameTempl">
        <xsl:param name="Person"/>
        <xsl:value-of select="$Person/ct:lastName"/><xsl:text> </xsl:text>
        <xsl:call-template name="initials">
            <xsl:with-param name="NameStr" select="$Person/ct:firstName" />
        </xsl:call-template>
        <xsl:if test="$Person/ct:middleName">
            <xsl:call-template name="initials">
                <xsl:with-param name="NameStr" select="$Person/ct:middleName" />
            </xsl:call-template>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="ct:passportDetails">
        <xsl:choose>
            <xsl:when test="ct:documentDetailsForeignCitizen">
                <xsl:for-each select="ct:documentDetailsForeignCitizen">
                    <xsl:value-of select="ct:docName"/><xsl:text> </xsl:text>
                    <xsl:if test="ct:series">
                        Серия:
                        <xsl:value-of select="ct:series"/>
                        <xsl:text> </xsl:text>
                    </xsl:if>
                    №<xsl:value-of select="ct:number"/> дата выдачи:
                    <xsl:call-template name="formatdate">
                        <xsl:with-param name="DateStr" select="ct:dateIssue" />
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="ct:passportDetailsRussianFederation">
                <xsl:for-each select="ct:passportDetailsRussianFederation">
                    серия:<xsl:value-of select="ct:series"/>
                    №<xsl:value-of select="ct:number"/> дата выдачи:
                    <xsl:call-template name="formatdate">
                        <xsl:with-param name="DateStr" select="ct:dateIssue" />
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <!--Реквизиты документов: name № number от «ДД.» ММ.ГГГГ г.-->
    <xsl:template name="docDetailsTempl">
        <xsl:param name="Doc"/>
        <xsl:value-of select="$Doc/ct:name"/> №
        <xsl:value-of select="$Doc/ct:number"/> 
        от 
        <xsl:call-template name="formatdate">
            <xsl:with-param name="DateStr" select="$Doc/ct:date" />
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="postalAddress">
        <xsl:choose>
            <xsl:when test="ct:stringAddress">
                <xsl:value-of select="ct:stringAddress"/>
            </xsl:when>
            <xsl:when test="ct:detalizedAddress">
                <xsl:for-each select="ct:detalizedAddress">
                    <xsl:value-of select="ct:country"/><xsl:text> </xsl:text>
                    <xsl:value-of select="ct:entityOfFederation"/><xsl:text> </xsl:text>
                    <xsl:value-of select="ct:districtOrRegionCode"/><xsl:text> </xsl:text>
                    <xsl:if test="ct:settlement">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="ct:settlement"/>
                    </xsl:if>
                    <xsl:if test="ct:locality">
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="ct:locality">
                            <xsl:value-of select="ct:localityType"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:localityName"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="ct:planningStructure">
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="ct:planningStructure">
                            <xsl:value-of select="ct:planningStructureElement"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:planningStructureObject"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="ct:roadNetwork">
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="ct:roadNetwork">
                            <xsl:value-of select="ct:roadNetworkElement"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:roadNetworkObject"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="ct:addressingObjectType">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="ct:addressingObjectType"/>
                    </xsl:if>
                    <xsl:if test="ct:plotNumber">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="ct:plotNumber"/>
                    </xsl:if>
                    <xsl:if test="ct:building">
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="ct:building">
                            <xsl:value-of select="ct:buildingType"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:buildingNumber"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="ct:room">
                        <xsl:text> </xsl:text>
                        <xsl:for-each select="ct:room">
                            <xsl:value-of select="ct:roomType"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:roomNumber"/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:if test="ct:parkingSpaceNumber">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="ct:parkingSpaceNumber"/>
                    </xsl:if>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="ct:stringAddressFIAS">
                <xsl:for-each select="ct:stringAddressFIAS">
                    <xsl:value-of select="ct:stringAddress"/>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="constructionSiteAddress">
        <xsl:value-of select="ct:country"/><xsl:text> </xsl:text>
        <xsl:for-each select="ct:entitysOfFederationList">
            <xsl:value-of select="ct:entitysOfFederationListItem"/><xsl:text> </xsl:text>
        </xsl:for-each>
        <xsl:for-each select="ct:districtOrRegionCodeList">
            <xsl:value-of select="ct:districtOrRegionCodeListItem"/><xsl:text> </xsl:text>
        </xsl:for-each>
        <xsl:if test="ct:settlement">
            <xsl:text> </xsl:text>
            <xsl:value-of select="ct:settlement"/>
        </xsl:if>
        <xsl:if test="ct:locality">
            <xsl:text> </xsl:text>
            <xsl:for-each select="ct:locality">
                <xsl:value-of select="ct:localityType"/><xsl:text> </xsl:text>
                <xsl:value-of select="ct:localityName"/>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="ct:planningStructure">
            <xsl:text> </xsl:text>
            <xsl:for-each select="ct:planningStructure">
                <xsl:value-of select="ct:planningStructureElement"/><xsl:text> </xsl:text>
                <xsl:value-of select="ct:planningStructureObject"/>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="ct:roadNetwork">
            <xsl:text> </xsl:text>
            <xsl:for-each select="ct:roadNetwork">
                <xsl:value-of select="ct:roadNetworkElement"/><xsl:text> </xsl:text>
                <xsl:value-of select="ct:roadNetworkObject"/>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="ct:addressingObjectType">
            <xsl:text> </xsl:text>
            <xsl:value-of select="ct:addressingObjectType"/>
        </xsl:if>
        <xsl:if test="ct:plotNumber">
            <xsl:text> </xsl:text>
            <xsl:value-of select="ct:plotNumber"/>
        </xsl:if>
        <xsl:if test="ct:building">
            <xsl:text> </xsl:text>
            <xsl:for-each select="ct:building">
                <xsl:value-of select="ct:buildingType"/><xsl:text> </xsl:text>
                <xsl:value-of select="ct:buildingNumber"/>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="ct:room">
            <xsl:text> </xsl:text>
            <xsl:for-each select="ct:room">
                <xsl:value-of select="ct:roomType"/><xsl:text> </xsl:text>
                <xsl:value-of select="ct:roomNumber"/>
            </xsl:for-each>
        </xsl:if>
        <xsl:if test="ct:parkingSpaceNumber">
            <xsl:text> </xsl:text>
            <xsl:value-of select="ct:parkingSpaceNumber"/>
        </xsl:if>
        <xsl:if test="ct:arbitraryAddress">
            <xsl:text> </xsl:text>
            <xsl:value-of select="ct:arbitraryAddress"/>
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="location">
        <xsl:if test="ct:axes">
            Ось:<xsl:value-of select="ct:axes"/>
        </xsl:if>
        <xsl:if test="ct:ranks">
            Ряд:<xsl:value-of select="ct:ranks"/>
        </xsl:if>
        <xsl:if test="ct:marks">
            Отметка:<xsl:value-of select="ct:marks"/>
        </xsl:if>
        <xsl:if test="ct:floors">
            Этаж:<xsl:value-of select="ct:floors"/>
        </xsl:if>
        <xsl:if test="ct:tiers">
            Ярус:<xsl:value-of select="ct:tiers"/>
        </xsl:if>
        <xsl:if test="ct:sections">
            Секция:<xsl:value-of select="ct:sections"/>
        </xsl:if>
        <xsl:if test="ct:premises">
            Помещение:<xsl:value-of select="ct:premises"/>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>