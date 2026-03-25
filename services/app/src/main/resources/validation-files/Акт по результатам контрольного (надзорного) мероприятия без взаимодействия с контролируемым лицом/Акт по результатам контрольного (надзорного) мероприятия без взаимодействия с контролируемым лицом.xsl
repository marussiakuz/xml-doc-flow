<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://types/CommonTypes.xsd"
    xmlns:cf="http://gsn/gsnActControlEventResult.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:gsnActControlEventResult" />

    </xsl:template>

    <xsl:template match="/cf:gsnActControlEventResult">


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
                    font-weight: bold;
                    width: 100%;
                    margin-top: 0px;
                    }
                    h3 {
                    font-family: Times New Roman;
                    font-size: 12pt;
                    text-align:center;
                    font-weight: bold;
                    width: 100%;
                    margin-top: 0px;
                    }
                    {
                    font-family: Times New Roman;
                    font-size: 14pt;
                    text-align:center;
                    width: 100%;
                    margin-top: 0px;
                    }
                    p {
                    font-family: Times New Roman;
                    font-size: 14pt;
                    margin-bottom: 5px;
                    text-indent: 0px;
                    margin-top: 0;
                    text-align: justify;
                    }
                    
                    body {
                    font-family: Times New Roman;
                    font-size: 14pt;
                    margin: 0 auto;
                    max-width:1200
                    }
                    .attachment{
                    margin:0cm;
                    margin-bottom:.0001pt;
                    font-size:10.0pt;
                    font-family:"Times New Roman",serif;
                    margin-left:290.6pt;
                    text-align:right;
                    }
                    .title {
                    font-size: 12pt;
                    text-align:center
                    }
                    
                    .under {
                    line-height: 0.9em;
                    margin:0cm;
                    margin-bottom:.0001pt;
                    text-autospace:none;
                    font-size:10.0pt;
                    font-family:"Times New Roman",serif;
                    margin-bottom:12.0pt;
                    text-align:center;
                    border:none;
                    }
                    .data {
                    margin-bottom:1.0pt;
                    font-family: Times New Roman;
                    font-style: italic;
                    border-bottom: 1px solid;
                    font-size: 10pt;
                    text-align: center;
                    }
                    .list {
                    font-size: 12pt;
                    }
                    .pagebreak {
                    page-break-before: always;
                    }
                    .qr-code {
                    max-width: 200px;
                    margin: 10px;
                    }
                </style>
            </head>
            <title>gsnActControlEventResult</title>
            <body>
                <xsl:for-each select="cf:signedPart">
                    <xsl:for-each select="cf:actRequisites">
                        <xsl:for-each select="cf:supervisoryAuthorityInfo">
                            <p class="data">
                                <xsl:value-of select="ct:name"/>
                            </p>
                            <p class="under">(наименование органа регионального государственного строительного надзора)</p>
                        </xsl:for-each>
                        <h1>
                            АКТ
                        </h1>
                        <h1 style="text-align:left">
                            по результатам
                            <span class="data">
                                <xsl:value-of select="cf:controlEventType"/>
                            </span> 
                        </h1>
                        <p class="under">(вид контрольного (надзорного) мероприятия без взаимодействия с контролируемым лицом)</p>
                        <xsl:for-each select="cf:documentDetails">
                            <span class="data">
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="ct:date" />
                                </xsl:call-template>
                            </span>
                            <span style="float: right">
                                <span class="list">№ </span>
                                <span class="data">
                                    <xsl:value-of select="ct:number"/>
                                </span>
                            </span>
                        </xsl:for-each>
                    </xsl:for-each>
                    <br/>
                    <br/>
                    <xsl:for-each select="cf:actInfo">
                        <p class="list">
                            1. Контрольное (надзорное) мероприятие без взаимодействия
                            с контролируемым лицом проведено в соответствии с заданием
                        </p>
                        <xsl:for-each select="cf:gsnAssignmentControlEvent">
                            <p class="data">
                                <xsl:value-of select="ct:name"/>
                                №
                                <xsl:value-of select="ct:number"/>
                                от
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="ct:date" />
                                </xsl:call-template>
                            </p>
                        </xsl:for-each>
                        <p class="under">
                            (дата выдачи задания и номер задания)
                        </p>
                        <p class="list">
                            2. Контрольное (надзорное) мероприятие без взаимодействия
                            с контролируемым лицом проведено:
                        </p>
                        <xsl:for-each select="cf:supervisoryAuthorityRepresentativesList/cf:supervisoryAuthorityRepresentative">
                            <p class="data">
                                <xsl:value-of select="ct:position"/><xsl:text> </xsl:text>
                                <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                <xsl:value-of select="ct:firstName"/>
                                <xsl:if test="ct:middleName">
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:middleName"/>
                                </xsl:if>
                            </p>
                        </xsl:for-each>
                        <p class="under">
                            (должность, фамилия, имя, отчество (при наличии) должностного лица, проводившего контрольное
                            (надзорное) мероприятие без взаимодействия с контролируемым лицом)
                        </p>
                        <p class="list">
                            3. Контрольное (надзорное) мероприятие без взаимодействия
                            с контролируемым лицом проведено в отношении
                        </p>
                        <xsl:choose>
                            <xsl:when test="cf:variantRequiredControlledOrganization">
                                <xsl:for-each select="cf:variantRequiredControlledOrganization">
                                    <xsl:apply-templates select="cf:controlledOrganization" />
                                    <xsl:if test="cf:permanentObjectInfo">
                                        <xsl:for-each select="cf:permanentObjectInfo">
                                            <p class="data">
                                                <xsl:value-of select="ct:permanentObjectName"/><xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:permanentObjectAddress"/>
                                            </p>
                                        </xsl:for-each>
                                    </xsl:if>
                                    <p class="under">
                                        (наименование контролируемого лица, адрес регистрации по месту жительства (пребывания) гражданина,
                                        индивидуального предпринимателя или адрес юридического лица в пределах места нахождения
                                        юридического лица, ИНН и (или) ОГРН индивидуального предпринимателя, ИНН и (или) ОГРН
                                        юридического лица либо наименование, место нахождения, кадастровый номер (последнее - при наличии)
                                        объекта государственного контроля)
                                    </p>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="cf:variantRequiredPermanentObjectInfo">
                                <xsl:for-each select="cf:variantRequiredPermanentObjectInfo">
                                    <xsl:for-each select="cf:permanentObjectInfo">
                                        <p class="data">
                                            <xsl:value-of select="ct:permanentObjectName"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:permanentObjectAddress"/>
                                        </p>
                                        <p class="under">
                                            (место нахождения, кадастровый номер (последнее - при наличии)
                                            объекта государственного контроля)
                                        </p>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                        <p class="list">
                            4. Контрольное (надзорное) мероприятие без взаимодействия
                            с контролируемым лицом проведено
                        </p>
                        <xsl:for-each select="cf:controlEventPeriod">
                            <p class="data">
                                c 
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="cf:beginDate" />
                                </xsl:call-template>
                                по
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="cf:endDate" />
                                </xsl:call-template>
                            </p>
                        </xsl:for-each>
                        <p class="under">
                            (дата или период времени проведения контрольного (надзорного) мероприятия без взаимодействия с
                            контролируемым лицом)
                        </p>
                        <p class="list">
                            5. По результатам контрольного (надзорного) мероприятия без
                            взаимодействия с контролируемым лицом установлено
                        </p>
                        <xsl:for-each select="cf:controlEventResult">
                            <xsl:choose>
                                <xsl:when test="cf:identifiedViolationsList">
                                    <xsl:for-each select="cf:identifiedViolationsList/cf:identifiedViolation">
                                        <p class="data">
                                            <xsl:if test="ct:sequenceNumber">
                                                <xsl:value-of select="ct:sequenceNumber"/><xsl:text>. </xsl:text>
                                                <xsl:text> </xsl:text>
                                            </xsl:if>
                                            <xsl:for-each select="ct:violationDescription">
                                                <xsl:value-of select="ct:violationDescriptionText"/><xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:technicalRegulationsList/ct:technicalRegulationsListItem"/><xsl:text>; </xsl:text>
                                                <xsl:if test="ct:projectDocSectionsList">
                                                    <xsl:value-of select="ct:projectDocSectionsList/cf:projectDocSectionsListItem"/>;
                                                </xsl:if>
                                                <xsl:if test="ct:workingDocSectionsList">
                                                    <xsl:value-of select="ct:workingDocSectionsList/cf:workingDocSectionsListItem"/>;
                                                </xsl:if>
                                            </xsl:for-each>
                                            <xsl:if test="ct:violationFixInfo">
                                                <xsl:for-each select="ct:violationFixInfo">
                                                    Устранено
                                                    <xsl:call-template name="formatdate">
                                                        <xsl:with-param name="DateStr" select="ct:violationFixFactDate" />
                                                    </xsl:call-template>
                                                    <xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:violationFixDescription"/>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </p>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="cf:noViolations">
                                    <p class="data">Нарушения не обнаружены</p>
                                </xsl:when>
                            </xsl:choose>   
                        </xsl:for-each>
                        <p class="under">
                            (сведения о результатах мероприятий по контролю без взаимодействия с контролируемым лицом, в том числе
                            информация о выявленных нарушениях либо признаках нарушений обязательных требований (при наличии)
                        </p>
                        <p class="list">
                            6. К настоящему акту прилагаются
                        </p>
                        <xsl:for-each select="cf:attachedEntitiesList/ct:attachedEntitiesListItem">
                            <p class="data">
                                <xsl:if test="ct:attachedEntityNumber">
                                    <xsl:value-of select="ct:attachedEntityNumber"/>.<xsl:text> </xsl:text>
                                </xsl:if>
                                <xsl:choose>
                                    <xsl:when test="ct:attachedEntityDoc">
                                        <xsl:for-each select="ct:attachedEntityDoc">
                                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:number"/> от
                                            <xsl:call-template name="formatdate">
                                                <xsl:with-param name="DateStr" select="ct:date" />
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="ct:attachedDocumentsList/ct:attachedDocuments">
                                            <xsl:choose>
                                                <xsl:when test="ct:variantRequiredFileWithInternalSignature">
                                                    <xsl:for-each select="ct:variantRequiredFileWithInternalSignature">
                                                        <xsl:value-of select="ct:fileWithInternalSignature/ct:file/ct:name"/> <xsl:text> </xsl:text>
                                                        <xsl:if test="ct:fileWithDisattachSignature">
                                                            <xsl:value-of select="ct:fileWithDisattachSignature/ct:file/ct:name"/> <xsl:text> </xsl:text>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:for-each select="ct:variantRequiredFileWithDisattachSignature">
                                                        <xsl:value-of select="ct:fileWithDisattachSignature/ct:file/ct:name"/> <xsl:text> </xsl:text>
                                                    </xsl:for-each>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </p>
                        </xsl:for-each>
                        <p class="under">
                            (документы, иные материалы, подтверждающие выявленные нарушения либо признаки нарушений обязательных
                            требований)
                        </p>
                    </xsl:for-each>
                    <xsl:for-each select="cf:actAuthor">
                        <p class="list">Лицо, составившее акт:</p>
                        <p style="text-align:left">
                            <span class="data">
                                <xsl:value-of select="ct:position"/>
                            </span>
                            <span class="data" style="text-align:right; float:right">
                                <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                <xsl:call-template name="initials">
                                    <xsl:with-param name="NameStr" select="ct:firstName" />
                                </xsl:call-template>
                                <xsl:if test="ct:middleName">
                                    <xsl:call-template name="initials">
                                        <xsl:with-param name="NameStr" select="ct:middleName" />
                                    </xsl:call-template>
                                </xsl:if>
                            </span>
                        </p>
                        <p class="under" style="text-align:right">
                            <span style="text-align:left; float:left; width:50mm">(должность)</span>
                            (расшифровка подписи)
                        </p>
                    </xsl:for-each>
                </xsl:for-each>
            </body>
        </html>

    </xsl:template>

    <!-- Вывод даты в формате ДД.ММ.ГГГГ-->
    <xsl:template name="formatdate">
        <xsl:param name="DateStr" />
        
        <xsl:if test="$DateStr != ''">
            <xsl:variable name="dd">
                <xsl:value-of select="substring($DateStr, 9, 2)" />
            </xsl:variable>
            
            <xsl:variable name="mm">
                <xsl:value-of select="substring($DateStr, 6, 2)" />
            </xsl:variable>
            
            <xsl:variable name="yyyy">
                <xsl:value-of select="substring($DateStr, 1, 4)" />
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
            
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="initials">
        <xsl:param name="NameStr" />
        
        <xsl:if test="$NameStr !=''">
            <xsl:variable name="i">
                <xsl:value-of select="substring($NameStr, 1, 1)" />
            </xsl:variable>
            
            <xsl:value-of select="concat($i, '.')" />
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
    
    <xsl:template match="cf:controlledOrganization">
        <xsl:choose>
            <xsl:when test="ct:organization/ct:legalEntity">
                <p class="data">
                    <xsl:value-of select="ct:organization/ct:legalEntity" />
                </p>
            </xsl:when>
            <xsl:when test="ct:organization/ct:individualEntrepreneur">
                <p class="data">
                    <xsl:for-each select="ct:organization/ct:individualEntrepreneur">
                        <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                        <xsl:value-of select="ct:firstName"/>
                        <xsl:if test="ct:middleName">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="ct:middleName"/>
                        </xsl:if>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                        <xsl:value-of select="ct:ogrnip"/><xsl:text> </xsl:text>
                        <xsl:value-of select="ct:inn"/>
                    </xsl:for-each>
                </p>
            </xsl:when>
            <xsl:when test="ct:individual">
                <p class="data">
                    <xsl:for-each select="ct:individual">
                        <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                        <xsl:value-of select="ct:firstName"/>
                        <xsl:if test="ct:middleName">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="ct:middleName"/>
                        </xsl:if>,
                        <xsl:apply-templates select="ct:passportDetails" />, 
                        <xsl:value-of select="ct:address"/> 
                        <xsl:if test="ct:contactInfo">
                            <xsl:value-of select="ct:contactInfo"/>
                        </xsl:if>
                    </xsl:for-each>
                </p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>