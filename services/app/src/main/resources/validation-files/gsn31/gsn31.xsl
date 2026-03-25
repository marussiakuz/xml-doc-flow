<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://types/CommonTypes.xsd"
    xmlns:cf="http://gsn/gsn31.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:gsn31" />

    </xsl:template>

    <xsl:template match="/cf:gsn31">

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
                    max-width: 1200px;
                    }
                    
                    .attachmеnt{
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
            <title>gsn31</title>
            <body>
                <xsl:for-each select="cf:signedPart">
                    <xsl:for-each select="cf:gsnInfo">
                        <xsl:for-each select="cf:notificationRequisites">
                            <h1>
                                ИЗВЕЩЕНИЕ № 
                                <span>
                                    <i>
                                        <xsl:value-of select="cf:documentDetails/ct:number"/>
                                    </i>
                                </span><br/>
                                об устранении нарушений при строительстве,<br/>
                                реконструкции объекта капитального строительства<br/>
                            </h1>
                            <xsl:if test="cf:supervisoryCaseDetails">
                                <div style="width: 50%; margin: auto">
                                    <p class="data">
                                        № 
                                        <xsl:value-of select="cf:supervisoryCaseDetails/ct:number"/>
                                    </p>
                                    <p class="under">
                                        (номер дела, присвоенный органом государственного строительного надзора)
                                    </p>
                                </div>
                            </xsl:if>
                            <div>
                                <xsl:for-each select="cf:documentDetails">
                                    <span class="data">
                                        <xsl:if test="../cf:compilationPlace">
                                            <xsl:value-of select="../cf:compilationPlace"/>
                                        </xsl:if>
                                    </span>
                                    <span class="data" style="float: right">
                                        <xsl:call-template name="formatdate">
                                            <xsl:with-param name="DateStr" select="ct:date" />
                                        </xsl:call-template>
                                    </span>
                                </xsl:for-each>
                            </div>
                            <br/>
                        </xsl:for-each>
                        <xsl:for-each select="cf:notificationInfo">
                            <div>
                                <p class="list">
                                    1.	Контролируемое лицо
                                </p>
                                <xsl:for-each select="cf:participant">
                                    <p class="data">
                                        <xsl:choose>
                                            <xsl:when test="ct:organization/ct:legalEntity">
                                                <xsl:value-of select="ct:organization/ct:legalEntity/ct:name"/><xsl:text> </xsl:text>
                                                ОГРН: 
                                                <xsl:value-of select="ct:organization/ct:legalEntity/ct:ogrn"/><xsl:text> </xsl:text>
                                                ИНН: 
                                                <xsl:value-of select="ct:organization/ct:legalEntity/ct:inn"/><xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:organization/ct:legalEntity/ct:address"/>
                                                <xsl:if test="ct:organization/ct:legalEntity/ct:contactInfo">
                                                    <xsl:for-each select="ct:organization/ct:legalEntity/ct:contactInfo">
                                                        <xsl:value-of select="ct:phone"/> 
                                                        <xsl:if test="ct:email">
                                                            <xsl:value-of select="ct:email"/>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:when test="ct:organization/ct:individualEntrepreneur">
                                                <xsl:value-of select="ct:organization/ct:individualEntrepreneur/ct:lastName"/><xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:organization/ct:individualEntrepreneur/ct:firstName"/>
                                                <xsl:if test="ct:organization/ct:individualEntrepreneur/ct:middleName">
                                                    <xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:organization/ct:individualEntrepreneur/ct:middleName"/>
                                                </xsl:if>
                                                ОГРНИП: 
                                                <xsl:value-of select="ct:organization/ct:individualEntrepreneur/ct:ogrnip"/><xsl:text> </xsl:text>
                                                ИНН: 
                                                <xsl:value-of select="ct:organization/ct:individualEntrepreneur/ct:inn"/><xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:organization/ct:individualEntrepreneur/ct:address"/>
                                                <xsl:if test="ct:organization/ct:individualEntrepreneur/ct:contactInfo">
                                                    <xsl:text> </xsl:text>
                                                    <xsl:for-each select="ct:organization/ct:individualEntrepreneur/ct:contactInfo">
                                                        <xsl:value-of select="ct:phone"/> 
                                                        <xsl:if test="ct:email">
                                                            <xsl:value-of select="ct:email"/>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </xsl:if>
                                            </xsl:when>
                                            <xsl:when test="ct:individual">
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
                                                        <xsl:text> </xsl:text>
                                                        <xsl:for-each select="ct:contactInfo">
                                                            <xsl:value-of select="ct:phone"/> 
                                                            <xsl:if test="ct:email">
                                                                <xsl:value-of select="ct:email"/>
                                                            </xsl:if>
                                                        </xsl:for-each>
                                                    </xsl:if>
                                                </xsl:for-each>
                                            </xsl:when>
                                        </xsl:choose>
                                    </p>
                                    <xsl:if test="ct:organization/ct:sro">
                                        <p class="data">
                                            СРО: 
                                            <xsl:value-of select="ct:organization/ct:sro"/> 
                                        </p>
                                    </xsl:if>
                                </xsl:for-each>
                                <p class="under">
                                    (застройщик (технический заказчик) или лицо осуществляющее строительство; 
                                    фамилия, имя, отчество, адрес места жительства, ОГРНИП, ИНН индивидуального предпринимателя,
                                    наименование, ОГРН, ИНН, место нахождения юридического лица, телефон/факс,
                                    наименование, ОГРН, ИНН саморегулируемой организации, членом которой является, 
                                    - для индивидуальных предпринимателей и юридических лиц;
                                    фамилия, имя, отчество, паспортные данные, адрес места жительства, 
                                    телефон/факс - для физических лиц, не являющихся индивидуальными предпринимателями)
                                </p>
                            </div>
                            <div>
                                <p class="list">
                                    2. Объект капитального строительства
                                </p>
                                <xsl:for-each select="cf:permanentObjectInfoWithWorkTypeAndDesignParameters">
                                    <p class="data">
                                        <xsl:value-of select="ct:permanentObjectName"/><xsl:text> </xsl:text>
                                        <xsl:apply-templates select="ct:designParameters"/>
                                    </p>
                                </xsl:for-each>
                                <p class="under">
                                    (наименование объекта капитального строительства в соответствии с разрешением
                                    на строительство, краткие проектные характеристики
                                    описание этапа строительства, реконструкции, если разрешение 
                                    выдано на этап строительства, реконструкции)
                                </p>
                            </div>
                            <div>
                                <xsl:for-each select="cf:permanentObjectInfoWithWorkTypeAndDesignParameters">
                                    <p class="list">
                                        3. Адрес (местоположение) объекта капитального строительства
                                    </p>
                                    <p class="data">
                                        <xsl:value-of select="ct:permanentObjectAddress"/> 
                                    </p>
                                    <p class="under">
                                        (почтовый или строительный адрес объекта капитального строительства)
                                    </p>
                                </xsl:for-each>
                            </div>
                            <div>
                                <p class="list">
                                    4. Разрешение на строительство объекта капитального строительства
                                </p>
                                <xsl:for-each select="cf:permissionToConstructionRoot">
                                    <p class="data">
                                        №
                                        <xsl:value-of select="ct:docDetails/ct:number"/> от
                                        <xsl:call-template name="formatdate">
                                            <xsl:with-param name="DateStr" select="ct:docDetails/ct:date" />
                                        </xsl:call-template> выдан
                                        "<xsl:value-of select="ct:executiveAuthorityName"/>" 
                                        <xsl:choose>
                                            <xsl:when test="ct:docDetails/ct:expirationDate">
                                                до <xsl:call-template name="formatdate">
                                                    <xsl:with-param name="DateStr" select="ct:docDetails/ct:expirationDate" />
                                                </xsl:call-template>
                                            </xsl:when>
                                        </xsl:choose>
                                    </p>
                                </xsl:for-each>
                                <p class="under">
                                    (номер и дата выдачи, орган или организация, его выдавшие, срок действия)
                                </p>
                            </div>
                            <div>
                                <p class="list">
                                    5.	Положительное заключение экспертизы проектной документации
                                </p>
                                <xsl:for-each select="cf:projectDocumentationExpertisePositiveConclusion/ct:projectDocumentationExpertisesList/ct:projectDocumentationExpertisesListItem">
                                    <p class="data">
                                        № 
                                        <xsl:value-of select="ct:expertiseResultDoc/ct:number"/> от
                                        <xsl:call-template name="formatdate">
                                            <xsl:with-param name="DateStr" select="ct:expertiseResultDoc/ct:date" />
                                        </xsl:call-template> утверждено
                                        "<xsl:value-of select="ct:executiveAuthorityName"/>" 
                                    </p>
                                </xsl:for-each>
                                <p class="under">
                                    (номер заключения и дата его выдачи, орган или организация, 
                                    его утвердившие; заключение главного инженера проекта)
                                </p>
                            </div>
                            <div>
                                <p class="list">
                                    6.	Положительное заключение государственной экологической экспертизы 
                                    проектной документации, если проектная документация объекта капитального 
                                    строительства подлежит государственной экологической экспертизе
                                </p>
                                <xsl:choose>
                                    <xsl:when test="not(cf:stateEnvironmentalExpertisesList)">
                                        <p class="data">
                                            -
                                        </p>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="cf:stateEnvironmentalExpertisesList/cf:stateEnvironmentalExpertisesListItem">
                                            <p class="data">
                                                № 
                                                <xsl:value-of select="ct:expertiseResultDoc/ct:number"/> от
                                                <xsl:call-template name="formatdate">
                                                    <xsl:with-param name="DateStr" select="ct:expertiseResultDoc/ct:date" />
                                                </xsl:call-template>
                                            </p>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                                <p class="under">
                                    (номер и дата выдачи, орган исполнительной 
                                    власти, его утвердивший, срок действия)
                                </p>
                            </div>
                            <div>
                                <p class="list">
                                    7.	Вид нарушения
                                </p>
                                <xsl:for-each select="cf:detectedViolations">
                                    <xsl:for-each select="cf:issuedOrdersList/cf:issuedOrdersListItem">
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
                                    <xsl:for-each select="cf:violationsInfoList/cf:violationsInfoListItem">
                                        <p class="data">
                                            <xsl:value-of select="cf:violationNumber"/><xsl:text>) </xsl:text>
                                            описание выявленного нарушения: 
                                            <xsl:if test="cf:subjectDescription">
                                                <xsl:for-each select="cf:subjectDescription/ct:structuralElement">
                                                    <xsl:value-of select="cf:subjectDescription/ct:structuralElement/ct:structuralElementName"/>
                                                </xsl:for-each>
                                                <xsl:text>, </xsl:text>
                                                <xsl:value-of select="cf:subjectDescription/ct:worksResultsLocation"/>
                                            </xsl:if>
                                            <xsl:value-of select="cf:violationDescription/cf:violationDescriptionText"/>
                                        </p>
                                    </xsl:for-each>
                                </xsl:for-each>
                                <p class="under">
                                    (описание нарушения, номер и дата 
                                    предписания об устранении нарушения)
                                </p>
                            </div>
                            <div>
                                <p class="list">
                                    8.	Дата устранения нарушения в соответствии с предписанием
                                </p>
                                <p class="data">
                                    <xsl:for-each select="cf:detectedViolations">
                                        <xsl:for-each select="cf:violationsInfoList/cf:violationsInfoListItem">
                                            <p class="data">
                                                <xsl:value-of select="cf:violationNumber"/><xsl:text>) </xsl:text>
                                                <xsl:call-template name="formatdate">
                                                    <xsl:with-param name="DateStr" select="cf:violationFixPlanDate"/> 
                                                </xsl:call-template>
                                            </p>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </p>
                                <p class="under">
                                    (дата)
                                </p>
                            </div>
                            <div>
                                <p class="list">
                                    9. Фактическая дата устранения нарушения
                                </p>
                                <p class="data">
                                    <xsl:for-each select="cf:detectedViolations">
                                        <xsl:for-each select="cf:violationsInfoList/cf:violationsInfoListItem">
                                            <p class="data">
                                                <xsl:value-of select="cf:violationNumber"/><xsl:text>) </xsl:text>
                                                <xsl:call-template name="formatdate">
                                                    <xsl:with-param name="DateStr" select="cf:violationFixFactDate"/> 
                                                </xsl:call-template>
                                            </p>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </p>
                                <p class="under">
                                    (дата)
                                </p>
                            </div>
                            <xsl:if test="cf:attachedEntitiesList">
                                <p class="list">
                                    Приложение
                                </p>
                                <xsl:for-each select="cf:attachedEntitiesList/ct:attachedEntitiesListItem">
                                    <xsl:choose>
                                        <xsl:when test="ct:attachedEntityDoc">
                                            <xsl:for-each select="ct:attachedEntityDoc">
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
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:for-each select="ct:attachedDocumentsList/ct:attachedDocuments">
                                                <xsl:choose>
                                                    <xsl:when test="ct:fileWithInternalSignature">
                                                        <p class="data">
                                                            Документ с внутренней подписью: 
                                                            <xsl:value-of select="ct:fileWithInternalSignature/ct:file/ct:name"/> <xsl:text> </xsl:text>
                                                        </p>
                                                        <xsl:if test="ct:fileWithDisattachSignature">
                                                            <p class="data">
                                                                <xsl:value-of select="ct:fileWithDisattachSignature/ct:file/ct:name"/> <xsl:text> </xsl:text>
                                                            </p>
                                                        </xsl:if>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <p class="data">
                                                            <xsl:value-of select="ct:fileWithDisattachSignature/ct:file/ct:name"/> <xsl:text> </xsl:text>
                                                        </p>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:for-each>
                                <p class="under">
                                    (перечень документов, подтверждающих устранение нарушения,
                                    прилагаемых к настоящему извещению)
                                </p>
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="cf:controlledPersonRepresentative">
                            <div style="max-width: 40%">
                                <p class="data" >
                                    <xsl:value-of select="ct:position"/>, 
                                    <xsl:value-of select="ct:lastName"/> <xsl:text> </xsl:text>
                                    <xsl:call-template name="initials">
                                        <xsl:with-param name="NameStr" select="ct:firstName" />
                                    </xsl:call-template> 
                                    <xsl:if test="ct:middleName">
                                        <xsl:call-template name="initials">
                                            <xsl:with-param name="NameStr" select="ct:middleName" />
                                        </xsl:call-template>
                                    </xsl:if>
                                </p>
                                <p class="under">
                                    (представитель контролируемого лица)
                                </p>
                            </div>
                        </xsl:for-each>
                    </xsl:for-each>
                    <br/>
                    <xsl:if test="cf:participantRepresentative">
                        <xsl:for-each select="cf:participantRepresentative">
                            <div style="max-width: 40%">
                                <p class="data" >
                                    <xsl:value-of select="ct:position"/>, 
                                    <xsl:value-of select="ct:lastName"/> <xsl:text> </xsl:text>
                                    <xsl:call-template name="initials">
                                        <xsl:with-param name="NameStr" select="ct:firstName" />
                                    </xsl:call-template> 
                                    <xsl:if test="ct:middleName">
                                        <xsl:call-template name="initials">
                                            <xsl:with-param name="NameStr" select="ct:middleName" />
                                        </xsl:call-template>
                                    </xsl:if>
                                </p>
                                <p class="under">
                                    (представитель застройщика, технического заказчика)
                                </p>
                            </div>
                        </xsl:for-each>
                    </xsl:if>
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
    
    <!-- Вывод даты в формате ДД.ММ.ГГГГ чч:мм-->
    
    <xsl:template name="formatdatetime">
        <xsl:param name="DateTimeStr" />
        
        <xsl:if test="$DateTimeStr != ''">
            <xsl:variable name="dd">
                <xsl:value-of select="substring($DateTimeStr, 9, 2)" />
            </xsl:variable>
            
            <xsl:variable name="mm">
                <xsl:value-of select="substring($DateTimeStr, 6, 2)" />
            </xsl:variable>
            
            <xsl:variable name="yyyy">
                <xsl:value-of select="substring($DateTimeStr, 1, 4)" />
            </xsl:variable>
            
            <xsl:variable name="hh">
                <xsl:value-of select="substring($DateTimeStr, 12, 2)" />
            </xsl:variable>
            
            <xsl:variable name="m">
                <xsl:value-of select="substring($DateTimeStr, 15, 2)" />
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
    
    <xsl:template name="activityType">
        <xsl:param name="type" />
        <xsl:choose>
            <xsl:when test="$type ='строительство'">
                <xsl:value-of select="'осуществляющее строительство'" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="('обеспечивающее реконструкцию')" />
            </xsl:otherwise>
        </xsl:choose>
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
    
    <xsl:template match="ct:designParameters">
        <xsl:choose>
            <xsl:when test="ct:permanentObjectsDesignParametersList">
                <xsl:for-each select="ct:permanentObjectsDesignParametersList/ct:permanentObjectsDesignParametersListItem">
                    <p class="data">
                        <xsl:value-of select="ct:sequenceNumber"/>)
                        <xsl:for-each select="ct:permanentObjectTypeInfo">
                            <xsl:choose>
                                <xsl:when test="ct:building">
                                    <xsl:for-each select="ct:building">
                                        <xsl:if test="ct:permanentObjectName">
                                            <xsl:value-of select="ct:permanentObjectName"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                        вид: 
                                        <xsl:value-of select="ct:permanentObjectType"/>
                                        назначение:
                                        <xsl:value-of select="ct:permanentObjectAssignment"/>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="ct:structure">
                                        <xsl:if test="ct:permanentObjectName">
                                            <xsl:value-of select="ct:permanentObjectName"/>
                                            <xsl:text> </xsl:text>
                                        </xsl:if>
                                        вид: 
                                        <xsl:value-of select="ct:permanentObjectType"/>
                                        назначение:
                                        <xsl:value-of select="ct:permanentObjectAssignment"/>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </p>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="ct:linearTypeFacilityDesignParametersList/ct:linearTypeFacilityDesignParametersListItem">
                    <p class="data">
                        <xsl:value-of select="ct:sequenceNumber"/>)
                        <xsl:choose>
                            <xsl:when test="ct:linearTypeFacilityParametersWithObligatoryCadastralNumber">
                                <xsl:for-each select="ct:linearTypeFacilityParametersWithObligatoryCadastralNumber">
                                    <xsl:if test="ct:cadastralNumber">
                                        Кадастровый номер:
                                        <xsl:value-of select="ct:cadastralNumber"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:length">
                                        <xsl:for-each select="ct:length">
                                            Протяженность:
                                            <xsl:value-of select="ct:value"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:unit"/>
                                        </xsl:for-each>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:category">
                                        Категория:
                                        <xsl:value-of select="ct:category"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:power">
                                        Мощность:
                                        <xsl:value-of select="ct:power"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:electricalTransmissionLineTypeAndPower">
                                        Тип и уровень напряжения линий электропередачи:
                                        <xsl:value-of select="ct:electricalTransmissionLineTypeAndPower"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:otherParametersList">
                                        <xsl:for-each select="ct:otherParametersListItem">
                                            <xsl:value-of select="ct:parameterName"/><xsl:text>: </xsl:text>
                                            <xsl:value-of select="ct:value"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:unit"/><xsl:text> </xsl:text>
                                        </xsl:for-each>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="ct:linearTypeFacilityParametersWithObligatoryLength">
                                <xsl:for-each select="ct:linearTypeFacilityParametersWithObligatoryLength">
                                    <xsl:if test="ct:cadastralNumber">
                                        Кадастровый номер:
                                        <xsl:value-of select="ct:cadastralNumber"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:length">
                                        <xsl:for-each select="ct:length">
                                            Протяженность:
                                            <xsl:value-of select="ct:value"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:unit"/>
                                        </xsl:for-each>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:category">
                                        Категория:
                                        <xsl:value-of select="ct:category"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:power">
                                        Мощность:
                                        <xsl:value-of select="ct:power"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:electricalTransmissionLineTypeAndPower">
                                        Тип и уровень напряжения линий электропередачи:
                                        <xsl:value-of select="ct:electricalTransmissionLineTypeAndPower"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:otherParametersList">
                                        <xsl:for-each select="ct:otherParametersListItem">
                                            <xsl:value-of select="ct:parameterName"/><xsl:text>: </xsl:text>
                                            <xsl:value-of select="ct:value"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:unit"/><xsl:text> </xsl:text>
                                        </xsl:for-each>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="ct:linearTypeFacilityParametersWithObligatoryCategory">
                                <xsl:for-each select="ct:linearTypeFacilityParametersWithObligatoryCategory">
                                    <xsl:if test="ct:cadastralNumber">
                                        Кадастровый номер:
                                        <xsl:value-of select="ct:cadastralNumber"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:length">
                                        <xsl:for-each select="ct:length">
                                            Протяженность:
                                            <xsl:value-of select="ct:value"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:unit"/>
                                        </xsl:for-each>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:category">
                                        Категория:
                                        <xsl:value-of select="ct:category"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:power">
                                        Мощность:
                                        <xsl:value-of select="ct:power"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:electricalTransmissionLineTypeAndPower">
                                        Тип и уровень напряжения линий электропередачи:
                                        <xsl:value-of select="ct:electricalTransmissionLineTypeAndPower"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:otherParametersList">
                                        <xsl:for-each select="ct:otherParametersListItem">
                                            <xsl:value-of select="ct:parameterName"/><xsl:text>: </xsl:text>
                                            <xsl:value-of select="ct:value"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:unit"/><xsl:text> </xsl:text>
                                        </xsl:for-each>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="ct:linearTypeFacilityParametersWithObligatoryPower">
                                <xsl:for-each select="ct:linearTypeFacilityParametersWithObligatoryPower">
                                    <xsl:if test="ct:cadastralNumber">
                                        Кадастровый номер:
                                        <xsl:value-of select="ct:cadastralNumber"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:length">
                                        <xsl:for-each select="ct:length">
                                            Протяженность:
                                            <xsl:value-of select="ct:value"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:unit"/>
                                        </xsl:for-each>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:category">
                                        Категория:
                                        <xsl:value-of select="ct:category"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:power">
                                        Мощность:
                                        <xsl:value-of select="ct:power"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:electricalTransmissionLineTypeAndPower">
                                        Тип и уровень напряжения линий электропередачи:
                                        <xsl:value-of select="ct:electricalTransmissionLineTypeAndPower"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:otherParametersList">
                                        <xsl:for-each select="ct:otherParametersListItem">
                                            <xsl:value-of select="ct:parameterName"/><xsl:text>: </xsl:text>
                                            <xsl:value-of select="ct:value"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:unit"/><xsl:text> </xsl:text>
                                        </xsl:for-each>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="ct:linearTypeFacilityParametersWithObligatoryElectricalTransmissionLineTypeAndPower">
                                <xsl:for-each select="ct:linearTypeFacilityParametersWithObligatoryElectricalTransmissionLineTypeAndPower">
                                    <xsl:if test="ct:cadastralNumber">
                                        Кадастровый номер:
                                        <xsl:value-of select="ct:cadastralNumber"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:length">
                                        <xsl:for-each select="ct:length">
                                            Протяженность:
                                            <xsl:value-of select="ct:value"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:unit"/>
                                        </xsl:for-each>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:category">
                                        Категория:
                                        <xsl:value-of select="ct:category"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:power">
                                        Мощность:
                                        <xsl:value-of select="ct:power"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:electricalTransmissionLineTypeAndPower">
                                        Тип и уровень напряжения линий электропередачи:
                                        <xsl:value-of select="ct:electricalTransmissionLineTypeAndPower"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:otherParametersList">
                                        <xsl:for-each select="ct:otherParametersListItem">
                                            <xsl:value-of select="ct:parameterName"/><xsl:text>: </xsl:text>
                                            <xsl:value-of select="ct:value"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:unit"/><xsl:text> </xsl:text>
                                        </xsl:for-each>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="ct:linearTypeFacilityParametersWithObligatoryOtherParameters">
                                <xsl:for-each select="ct:linearTypeFacilityParametersWithObligatoryOtherParameters">
                                    <xsl:if test="ct:cadastralNumber">
                                        Кадастровый номер:
                                        <xsl:value-of select="ct:cadastralNumber"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:length">
                                        <xsl:for-each select="ct:length">
                                            Протяженность:
                                            <xsl:value-of select="ct:value"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:unit"/>
                                        </xsl:for-each>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:category">
                                        Категория:
                                        <xsl:value-of select="ct:category"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:power">
                                        Мощность:
                                        <xsl:value-of select="ct:power"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:electricalTransmissionLineTypeAndPower">
                                        Тип и уровень напряжения линий электропередачи:
                                        <xsl:value-of select="ct:electricalTransmissionLineTypeAndPower"/>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                    <xsl:if test="ct:otherParametersList">
                                        <xsl:for-each select="ct:otherParametersListItem">
                                            <xsl:value-of select="ct:parameterName"/><xsl:text>: </xsl:text>
                                            <xsl:value-of select="ct:value"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:unit"/><xsl:text> </xsl:text>
                                        </xsl:for-each>
                                        <xsl:text> </xsl:text>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                    </p>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
