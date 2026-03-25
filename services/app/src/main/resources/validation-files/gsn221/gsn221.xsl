<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://types/CommonTypes.xsd"
    xmlns:cf="http://gsn/gsn221.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:gsn221" />

    </xsl:template>

    <xsl:template match="/cf:gsn221">

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
                    
                    .border {
                    width: 70%;
                    border: 2px solid #000000;
                    margin: 5px;
                    padding: 5px;
                    }
                    
                    .refusal-table {
                    width: 35%; 
                    border: double #0099ff;
                    }
                    
                    .refusal-th {
                    color: #0099ff; 
                    margin: 10px 0; 
                    padding: 10px;
                    }
                    
                    .controlEventRegistryRecord {
                    margin: 5px;
                    border: 2px solid #000000;
                    border-collapse:collapse;
                    width: 50%
                    }
                    
                    .emailSendingInfo {
                    margin: 5px auto;
                    border: 2px solid #000000;
                    border-collapse:collapse;
                    width: 90%
                    }
                </style>
            </head>
            <title>gsn221</title>
            <body>
                <xsl:for-each select="cf:controlledPersonSignedPart">
                    <xsl:for-each select="cf:actInfo">
                        <xsl:for-each select="cf:actRequisites">
                            <table class="controlEventRegistryRecord">
                                <tr>
                                    <td>
                                        <xsl:for-each select="cf:controlEventRegistryRecord">
                                            <p class="list" style="text-align: center">
                                                Отметка о размещении проверки от 
                                                <span class="data">
                                                    <xsl:call-template name="formatdate">
                                                        <xsl:with-param name="DateStr" select="cf:controlEventDate" />
                                                    </xsl:call-template>
                                                </span>
                                                №
                                                <span class="data">
                                                    <xsl:value-of select="cf:controlEventRegistryNumber"/>
                                                </span>
                                                в едином реестре контрольных (надзорных) мероприятий
                                            </p>
                                        </xsl:for-each>
                                    </td>
                                </tr>
                            </table>
                            <br/>
                            <p class="data">
                                <xsl:for-each select="cf:supervisoryAuthorityInfo">
                                    <xsl:value-of select="ct:name"/>
                                    ОГРН: <xsl:value-of select="ct:ogrn"/>
                                    ИНН: <xsl:value-of select="ct:inn"/>
                                    <xsl:value-of select="ct:address"/>
                                    <xsl:if test="ct:contactInfo">
                                        <xsl:for-each select="ct:contactInfo">
                                            <xsl:value-of select="ct:phone"/><xsl:text> </xsl:text>
                                            <xsl:if test="ct:email">
                                                <xsl:value-of select="ct:email"/><xsl:text> </xsl:text>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:for-each>
                            </p>
                            <p class="under">
                                (указывается наименование контрольного (надзорного) 
                                органа и при необходимости его территориального органа)
                            </p>
                            <p class="list" style="text-align: center">
                                <span class="data">
                                    <xsl:call-template name="formatdate">
                                        <xsl:with-param name="DateStr" select="cf:documentDetails/ct:date" />
                                    </xsl:call-template>
                                </span>
                                <xsl:text> </xsl:text>
                                <span class="data">
                                    <xsl:value-of select="cf:compilationTime/cf:hours"/>
                                </span>
                                час.
                                <span class="data">
                                    <xsl:value-of select="cf:compilationTime/cf:minutes"/>
                                </span>
                                мин.
                                №
                                <span class="data">
                                    <xsl:value-of select="cf:documentDetails/ct:number"/>
                                </span>
                            </p>
                            <p class="under">
                                (дата и время составления акта)
                            </p>
                            <xsl:if test="cf:compilationPlace">
                                <p class="data">
                                    <xsl:value-of select="cf:compilationPlace"/>
                                </p>
                            </xsl:if>
                            <p class="under">
                                (место составления акта)
                            </p>
                        </xsl:for-each>
                        <xsl:for-each select="cf:actContent">
                            <h1>
                                Акт выездной проверки
                                (<span>
                                    <b style=" text-transform: lowercase;">
                                        <xsl:value-of select="../cf:actRequisites/cf:controlEventType"/>
                                    </b>
                                </span>)
                            </h1>
                            <xsl:for-each select="cf:controlEventDecision">
                                <p class="list">
                                    1. Выездная проверка проведена в соответствии с решением
                                </p>
                                <p class="data">
                                    <xsl:value-of select="ct:name"/>
                                    №
                                    <xsl:value-of select="ct:number"/>
                                    от 
                                    <xsl:call-template name="formatdate">
                                        <xsl:with-param name="DateStr" select="ct:date" />
                                    </xsl:call-template>
                                </p>
                                <p class="under">
                                    (указывается ссылка на решение уполномоченного должностного 
                                    лица контрольного (надзорного) органа о проведении выездной 
                                    проверки, номер выездной проверки в едином реестре контрольных 
                                    (надзорных) мероприятий)
                                </p>
                            </xsl:for-each>
                            <p class="list">
                                2. Выездная проверка проведена в рамках
                            </p>
                            <p class="data">
                                <xsl:value-of select="cf:controlType"/>
                            </p>
                            <p class="under">
                                (наименование вида государственного контроля (надзора), 
                                вида муниципального контроля в соответствии с единым 
                                реестром видов федерального государственного контроля (надзора), 
                                регионального государственного контроля (надзора), 
                                муниципального контроля)
                            </p>
                            <xsl:for-each select="cf:authorizedPersonsList">
                                <p class="list">
                                    3. Выездная проверка проведена:
                                </p>
                                <xsl:for-each select="cf:authorizedPersonsListItem">
                                    <p class="data">
                                        <xsl:value-of select="ct:position"/>, 
                                        <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:firstName"/>
                                        <xsl:if test="ct:middleName">
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:middleName"/>
                                        </xsl:if>
                                    </p>
                                </xsl:for-each>
                                <p class="under">
                                    (указываются фамилии, имена, отчества (при наличии), 
                                    должности инспектора (инспекторов, в том числе руководителя 
                                    группы инспекторов), уполномоченного (уполномоченных) на 
                                    проведение выездной проверки. При замене инспектора (инспекторов) 
                                    после принятия решения о проведении выездной проверки такой инспектор 
                                    (инспекторы) указывается (указываются), если его (их) замена была 
                                    проведена после начала выездной проверки)
                                </p>
                            </xsl:for-each>
                            <p class="list">
                                4. К проведению выездной проверки были привлечены:
                            </p>
                            <p class="list">
                                cпециалисты:
                            </p>
                            <xsl:for-each select="cf:involvedSpecialists">
                                <xsl:choose>
                                    <xsl:when test="cf:notInvolved">
                                        <p class="data">
                                            <xsl:value-of select="cf:notInvolved"/>
                                        </p>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="cf:involvedSpecialistList/cf:involvedSpecialistListItem">
                                            <p class="data">
                                                <xsl:value-of select="ct:position"/>, 
                                                <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:firstName"/>
                                                <xsl:if test="ct:middleName">
                                                    <xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:middleName"/>
                                                </xsl:if>
                                            </p>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            <p class="under">
                                (указываются фамилии, имена, отчества 
                                (при наличии), должности специалистов)
                            </p>
                            <p class="list">
                                эксперты (экспертные организации):
                            </p>
                            <xsl:for-each select="cf:expertOrganizationsOrExperts">
                                <xsl:choose>
                                    <xsl:when test="cf:noInvolvedExpertsOrExpertOrganizations">
                                        <p class="data">
                                            <xsl:value-of select="cf:noInvolvedExpertsOrExpertOrganizations"/>
                                        </p>
                                        <p class="under">
                                            (указываются фамилии, имена, отчества (при наличии), 
                                            должности экспертов, с указанием сведений об аттестации 
                                            эксперта в реестре экспертов контрольного (надзорного) 
                                            органа или наименование экспертной организации, с указанием 
                                            реквизитов свидетельства об аккредитации и наименования органа 
                                            по аккредитации, выдавшего свидетельство об аккредитации)
                                        </p>  
                                    </xsl:when>
                                    <xsl:when test="cf:involvedExpertsList">
                                        <xsl:for-each select="cf:involvedExpertsList/cf:involvedExpertsListItem">
                                            <p class="data">
                                                <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:firstName"/>
                                                <xsl:if test="ct:middleName">
                                                    <xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:middleName"/>
                                                </xsl:if>
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:position"/><xsl:text> </xsl:text>
                                                <xsl:value-of select="cf:expertsRegisterInfo"/>
                                            </p>
                                        </xsl:for-each>
                                        <p class="under">
                                            (указываются фамилии, имена, отчества (при наличии), 
                                            должности экспертов, с указанием сведений об аттестации 
                                            эксперта в реестре экспертов контрольного (надзорного) органа)
                                        </p>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="cf:involvedExpertOrganizationsList/cf:involvedExpertOrganizationsListItem">
                                            <p class="data">
                                                <xsl:value-of select="cf:expertOrganizationName"/><xsl:text> </xsl:text>
                                                <xsl:value-of select="cf:expertOrganizationAccreditationName"/><xsl:text> </xsl:text>
                                                <xsl:for-each select="cf:expertOrganizationDocument"><xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:number"/><xsl:text> </xsl:text>
                                                    <xsl:call-template name="formatdate">
                                                        <xsl:with-param name="DateStr" select="ct:date" />
                                                    </xsl:call-template>
                                                </xsl:for-each>
                                            </p>
                                        </xsl:for-each>
                                        <p class="under">
                                            (наименование экспертной организации, с указанием 
                                            реквизитов свидетельства об аккредитации и наименования 
                                            органа по аккредитации, выдавшего свидетельство об аккредитации)
                                        </p>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            <xsl:for-each select="cf:permanentObjectInfo">
                                <p class="list">
                                    5. Выездная проверка проведена в отношении:
                                </p>
                                <p class="data">
                                    <xsl:value-of select="ct:permanentObjectName"/> 
                                </p>
                                <p class="under">
                                    (указывается объект контроля, в отношении 
                                    которого проведена выездная проверка)
                                </p>
                                <p class="list">
                                    6. Выездная проверка была проведена 
                                    по адресу (местоположению):
                                </p>
                                <p class="data">
                                    <xsl:value-of select="ct:permanentObjectAddress"/>
                                </p>
                                <p class="under">
                                    (указываются адреса (местоположение) места осуществления 
                                    контролируемым лицом деятельности или места нахождения 
                                    иных объектов контроля, в отношении которых была проведена 
                                    выездная проверка)
                                </p>
                            </xsl:for-each>
                            <p class="list">
                                7. Контролируемое лицо:
                            </p>
                            <xsl:apply-templates select="cf:controlledPerson" />
                            <xsl:for-each select="cf:controlFactPeriod">
                                <p class="list">
                                    8. Выездная проверка проведена в следующие сроки:
                                </p>
                                <xsl:for-each select="cf:controlPeriod">
                                    <p class="list">
                                        с
                                        <span class="data">
                                            <xsl:call-template name="formatdatetime">
                                                <xsl:with-param name="DateTimeStr" select="ct:beginDate" />
                                            </xsl:call-template>
                                        </span>
                                    </p>
                                    <p class="list">
                                        по
                                        <span class="data">
                                            <xsl:call-template name="formatdatetime">
                                                <xsl:with-param name="DateTimeStr" select="ct:endDate" />
                                            </xsl:call-template>
                                        </span>
                                    </p>
                                </xsl:for-each>
                                <p class="under">
                                    (указываются дата и время фактического начала выездной проверки, 
                                    а также дата и время фактического окончания выездной проверки, 
                                    при необходимости указывается часовой пояс)
                                </p>
                                <xsl:if test="cf:controlPause">
                                    <xsl:for-each select="cf:controlPause">
                                        <p class="list">
                                            Проведение выездной проверки приостанавливалось
                                        </p>
                                        <xsl:for-each select="cf:controlPausePeriod">
                                            <p class="list">
                                                с
                                                <span class="data">
                                                    <xsl:call-template name="formatdatetime">
                                                        <xsl:with-param name="DateTimeStr" select="ct:beginDate" />
                                                    </xsl:call-template>
                                                </span>
                                            </p>
                                            <p class="list">
                                                по
                                                <span class="data">
                                                    <xsl:call-template name="formatdatetime">
                                                        <xsl:with-param name="DateTimeStr" select="ct:endDate" />
                                                    </xsl:call-template>
                                                </span>
                                            </p>
                                        </xsl:for-each>
                                        <p class="data">
                                            в связи с 
                                            <xsl:value-of select="cf:pauseReason"/>
                                        </p>
                                        <p class="under">
                                            (указывается основание для приостановления проведения 
                                            выездной проверки, дата и время начала, а также дата и 
                                            время окончания срока приостановления проведения выездной проверки)
                                        </p>
                                    </xsl:for-each>
                                </xsl:if>
                                <xsl:for-each select="cf:interactionPeriod">
                                    <p class="list">
                                        Срок непосредственного взаимодействия 
                                        с контролируемым лицом составил:
                                    </p>
                                    <xsl:choose>
                                        <xsl:when test="cf:obligatoryDays">
                                            <xsl:for-each select="cf:obligatoryDays">
                                                <p class="data">
                                                    <xsl:value-of select="cf:days"/>
                                                    д.
                                                    <xsl:if test="cf:hours">
                                                        <xsl:value-of select="cf:hours"/>
                                                        ч.
                                                    </xsl:if>
                                                    <xsl:if test="cf:minutes">
                                                        <xsl:value-of select="cf:minutes"/>
                                                        м.
                                                    </xsl:if> 
                                                </p>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:when test="cf:obligatoryHours">
                                            <xsl:for-each select="cf:obligatoryHours">
                                                <p class="data">
                                                    <xsl:if test="cf:days">
                                                        <xsl:value-of select="cf:days"/>
                                                        д.
                                                    </xsl:if>
                                                    <xsl:value-of select="cf:hours"/>
                                                    ч.
                                                    <xsl:if test="cf:minutes">
                                                        <xsl:value-of select="cf:minutes"/>
                                                        м.
                                                    </xsl:if>
                                                </p>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:when test="cf:obligatoryMinutes">
                                            <xsl:for-each select="cf:obligatoryMinutes">
                                                <p class="data">
                                                    <xsl:if test="cf:days">
                                                        <xsl:value-of select="cf:days"/>
                                                        д.
                                                    </xsl:if>
                                                    <xsl:if test="cf:hours">
                                                        <xsl:value-of select="cf:hours"/>
                                                        ч.
                                                    </xsl:if>
                                                    <xsl:value-of select="cf:minutes"/>
                                                    м.
                                                </p>
                                            </xsl:for-each>
                                        </xsl:when>
                                    </xsl:choose>
                                    <p class="under">
                                        (указывается срок (рабочие дни, часы, минуты), 
                                        в пределах которого осуществлялось непосредственное взаимодействие 
                                        с контролируемым лицом по инициативе контролируемого лица)
                                    </p>
                                </xsl:for-each>
                            </xsl:for-each>
                            <xsl:for-each select="cf:controlActionsList">
                                <p class="list">
                                    9. При проведении выездной проверки совершены 
                                    следующие контрольные (надзорные) действия:
                                </p>
                                <xsl:for-each select="cf:controlActionsListItem">
                                    <xsl:for-each select="cf:controlActionInfo">
                                        <p class="data">
                                            <xsl:value-of select="cf:controlActionNumber"/>) 
                                            <xsl:value-of select="cf:controlActionName"/>
                                        </p>
                                        <p class="under">
                                            (указывается первое фактически совершенное контрольное 
                                            надзорное) действие: 1) осмотр; 2) досмотр; 3) опрос; 
                                            4) получение письменных объяснений; 5) истребование документов; 
                                            6) отбор проб (образцов); 7) инструментальное обследование; 
                                            8) испытание; 9) экспертиза; 10) эксперимент)
                                        </p>
                                        <p class="list">
                                            в следующие сроки:
                                        </p>
                                        <xsl:for-each select="cf:controlActionPeriod">
                                            <p class="list">
                                                с
                                                <span class="data">
                                                    <xsl:call-template name="formatdatetime">
                                                        <xsl:with-param name="DateTimeStr" select="ct:beginDate" />
                                                    </xsl:call-template>
                                                </span>
                                            </p>
                                            <p class="list">
                                                по
                                                <span class="data">
                                                    <xsl:call-template name="formatdatetime">
                                                        <xsl:with-param name="DateTimeStr" select="ct:endDate" />
                                                    </xsl:call-template>
                                                </span>
                                            </p>
                                            <p class="list">по месту</p>
                                        </xsl:for-each>
                                        <p class="data">
                                            <xsl:value-of select="cf:controlActionPlace"/>
                                        </p>
                                        <p class="under">
                                            (указываются даты и места фактически 
                                            совершенных контрольных (надзорных) действий)
                                        </p>
                                    </xsl:for-each>
                                        <xsl:for-each select="cf:controlActionDocs">
                                            <p class="list">
                                                по результатам которого составлен:
                                            </p>
                                            <xsl:choose>
                                                <xsl:when test="cf:controlActionDocsList">
                                                    <xsl:for-each select="cf:controlActionDocsList/cf:controlActionDocsListItem">
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
                                                    <p class="data">
                                                        <xsl:value-of select="cf:noDocs"/>
                                                    </p>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                            <p class="under">
                                                указываются даты составления и реквизиты протоколов и 
                                                иных документов (письменные объяснения, экспертное заключение), 
                                                составленных по результатам проведения контрольных (надзорных) 
                                                действий, и прилагаемых к акту)
                                            </p>
                                        </xsl:for-each>
                                </xsl:for-each>
                            </xsl:for-each>
                            <xsl:for-each select="cf:reviewedDocumentsAndAdditionalInfo">
                                <p class="list">
                                    10. При проведении выездной проверки были рассмотрены следующие документы и сведения:
                                </p>
                                <xsl:for-each select="cf:reviewedDocumentsList/cf:reviewedDocumentsListItem">
                                    <p class="data">
                                        <xsl:for-each select="cf:documentRequisites">
                                            <xsl:value-of select="ct:name"/> 
                                            №
                                            <xsl:value-of select="ct:number"/>
                                            от 
                                            <xsl:call-template name="formatdate">
                                                <xsl:with-param name="DateStr" select="ct:date" />
                                            </xsl:call-template>
                                        </xsl:for-each>
                                        <xsl:if test="cf:documentSource">
                                            Источник поступления: 
                                            <xsl:value-of select="cf:documentSource"/>
                                        </xsl:if>
                                        <xsl:if test="cf:docsAdditionalInfo">
                                            Дополнительные сведения: 
                                            <xsl:value-of select="cf:docsAdditionalInfo"/>
                                        </xsl:if>
                                    </p>
                                </xsl:for-each>
                                <p class="under">
                                    (указываются рассмотренные при проведении выездной проверки 
                                    документы, в том числе: 1) находившиеся в распоряжении контрольного 
                                    (надзорного) органа); 2) представленные контролируемым лицом; 
                                    3) полученные посредством межведомственного взаимодействия, 
                                    4) иные (указать источник)
                                </p>
                                <xsl:if test="cf:additionalInfoList">
                                    <xsl:for-each select="cf:additionalInfoList/cf:additionalInfoListItem">
                                        <p class="data">
                                            <xsl:value-of select="."/>
                                        </p>
                                    </xsl:for-each>
                                    <p class="under">
                                        (указываются рассмотренные при проведении выездной проверки 
                                        сведения, в том числе: 1) находившиеся в распоряжении контрольного 
                                        (надзорного) органа); 2) представленные контролируемым лицом; 
                                        3) полученные посредством межведомственного взаимодействия, 
                                        4) иные (указать источник)
                                    </p>
                                </xsl:if>
                            </xsl:for-each>
                            <p class="list">
                                11. По результатам выездной проверки установлено:
                            </p>
                            <xsl:for-each select="cf:controlEventResult">
                                <xsl:choose>
                                    <xsl:when test="cf:identifiedViolationsList">
                                        <xsl:for-each select="cf:identifiedViolationsList/cf:identifiedViolationsListItem">
                                            <p class="data">
                                                <xsl:if test="cf:violationNumber">
                                                    <xsl:value-of select="cf:violationNumber"/><xsl:text>) </xsl:text>
                                                    <xsl:text> </xsl:text>
                                                </xsl:if>
                                                <xsl:for-each select="cf:violationDescription">
                                                    <xsl:value-of select="cf:violationDescriptionText"/><xsl:text> </xsl:text>
                                                    <xsl:value-of select="cf:technicalRegulationsList/cf:technicalRegulationsListItem"/><xsl:text>; </xsl:text>
                                                    <xsl:if test="cf:projectDocSectionsList">
                                                        <xsl:value-of select="cf:projectDocSectionsList/cf:projectDocSectionsListItem"/>;
                                                    </xsl:if>
                                                    <xsl:if test="cf:workingDocSectionsList">
                                                        <xsl:value-of select="cf:workingDocSectionsList/cf:workingDocSectionsListItem"/>;
                                                    </xsl:if>
                                                </xsl:for-each>
                                                <xsl:if test="cf:violationFixInfo">
                                                    <xsl:for-each select="cf:violationFixInfo">
                                                        Устранено
                                                        <xsl:call-template name="formatdate">
                                                            <xsl:with-param name="DateStr" select="cf:violationFixFactDate" />
                                                        </xsl:call-template>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:value-of select="cf:violationFixDescription"/>
                                                    </xsl:for-each>
                                                </xsl:if>
                                            </p>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <p class="data">
                                            <xsl:value-of select="cf:noViolations"/>
                                        </p>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:for-each>
                            <p class="under" style="text-align:justify">
                                (указываются выводы по результатам проведения выездной проверки:
                                <br/><br/>
                                1) вывод об отсутствии нарушений обязательных требований, о соблюдении 
                                (реализации) требований, содержащихся в разрешительных документах, о 
                                соблюдении требований документов, исполнение которых является обязательным 
                                в соответствии с законодательством Российской Федерации, об исполнении 
                                ранее принятого решения контрольного (надзорного) органа, являющихся 
                                предметом выездной проверки;
                                <br/><br/>
                                2) вывод о выявлении нарушений обязательных требований (с указанием 
                                обязательного требования, нормативного правового акта и его структурной 
                                единицы, которым установлено нарушенное обязательное требование, сведений, 
                                являющихся доказательствами нарушения обязательного требования), о 
                                несоблюдении (нереализации) требований, содержащихся в разрешительных документах, 
                                с указанием реквизитов разрешительных документов, о несоблюдении требований 
                                документов, исполнение которых является обязательным в соответствии с законодательством 
                                Российской Федерации, о неисполнении ранее принятого решения контрольного (надзорного) 
                                органа, являющихся предметом выездной проверки;
                                <br/><br/>
                                3) сведения о факте устранения нарушений, указанных в пункте 2, если нарушения 
                                устранены до окончания проведения контрольного надзорного (мероприятия))
                            </p>
                            <xsl:if test="cf:attachedEntitiesList">
                                <p class="list">
                                    12. К настоящему акту прилагаются:
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
                                    (указываются протоколы и иные документы (письменные 
                                    объяснения, экспертное заключение), составленные по результатам 
                                    проведения контрольных (надзорных) действий (даты их составления 
                                    и реквизиты), заполненные проверочные листы (в случае их применения), 
                                    а также документы и иные материалы, являющиеся доказательствами 
                                    нарушения обязательных требований)
                                </p>
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                        <xsl:for-each select="cf:actPersonsInfo">
                            <xsl:for-each select="cf:controlEventActingPersonsList/cf:controlEventActingPersonsListItem">
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
                                        (должность, фамилия, инициалы инспектора (руководителя 
                                        группы инспекторов), проводившего документарную проверку)
                                    </p>
                                </div>
                            </xsl:for-each>
                            <xsl:for-each select="cf:documentAuthor">
                                <div style="max-width: 40%">
                                    <p class="data">
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
                                        <xsl:text>, контактный телефон:</xsl:text>
                                        <xsl:value-of select="cf:contactInfo/cf:phone"/>
                                        <xsl:if test="cf:contactInfo/cf:email">
                                            <xsl:text>, Email:</xsl:text>
                                            <xsl:value-of select="cf:contactInfo/cf:email"/>
                                        </xsl:if>
                                    </p>
                                    <p class="under">
                                        (фамилия, имя, отчество (при наличии) и должность инспектора, 
                                        непосредственно подготовившего акт выездной проверки, 
                                        контактный телефон, электронный адрес (при наличии))
                                    </p>
                                </div>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:if test="cf:emailSendingInfo">
                        <table class="emailSendingInfo">
                            <tr>
                                <td>
                                    <p class="list" style="text-align: center">
                                        Отметка о направлении предписания в электронном виде (на электронный адрес:
                                        <span class="data">
                                            <xsl:value-of select="cf:emailSendingInfo/ct:email"/>
                                        </span>), 
                                        в том числе через личный кабинет на специализированном электронном портале
                                    </p>
                                </td>
                            </tr>
                        </table>
                        <br/>
                    </xsl:if>
                    <xsl:if test="../cf:familiarizationOrRefusal">
                        <xsl:for-each select="../cf:familiarizationOrRefusal">
                            <xsl:choose>
                                <xsl:when test="ct:familiarizationSignature">
                                    <div style="max-width: 40%">
                                        <p class="data">
                                            <xsl:for-each select="../cf:controlledPersonSignedPart/cf:controlledPersonRepresentative">
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
                                            </xsl:for-each>
                                        </p>
                                        <p class="under">
                                            (подпись, ф.и.о контролируемого лица или его представителей)
                                        </p>
                                    </div>
                                </xsl:when>
                                <xsl:when test="ct:refusal">
                                    <div align="center">
                                        <table class="refusal-table">
                                            <tr>
                                                <th class="refusal-th">
                                                    Отказ от подписания и ознакомления
                                                </th>
                                            </tr>
                                        </table>  
                                    </div>
                                    <br/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:if>
                    <p class="list">
                        В случае несогласия с настоящим решением Вы можете обжаловать его в 
                        течение 30 календарных дней со дня получения информации о принятии 
                        обжалуемого решения (статья 40 Федерального закона "О государственном 
                        контроле (надзоре) и муниципальном контроле в Российской Федерации") 
                        с использованием единого портала государственных и муниципальных услуг 
                        (функций), перейдя по ссылке https://knd.gosuslugi.ru/
                    </p>
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
            <xsl:when test="$type ='Строительство'">
                <xsl:value-of select="'строительства'" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="('реконструкции')" />
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
    
    <xsl:template match="cf:controlledPerson">
        <xsl:choose>
            <xsl:when test="ct:organization/ct:legalEntity">
                <p class="data">
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
                </p>
            </xsl:when>
            <xsl:when test="ct:organization/ct:individualEntrepreneur">
                <p class="data">
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
                            <xsl:text> </xsl:text>
                            <xsl:for-each select="ct:contactInfo">
                                <xsl:value-of select="ct:phone"/> 
                                <xsl:if test="ct:email">
                                    <xsl:value-of select="ct:email"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:for-each>
                </p>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="ct:organization/ct:sro">
            <p class="data">
                СРО: 
                <xsl:value-of select="ct:organization/ct:sro"/> 
            </p>
        </xsl:if>
        <p class="under">
            (указываются фамилия, имя, отчество (при наличии) гражданина или 
            наименование организации, их индивидуальные номера налогоплательщика, 
            адрес организации (ее филиалов, представительств, обособленных 
            структурных подразделений), ответственных за соответствие обязательным 
            требованиям объекта контроля, в отношении которого проведена 
            выездная проверка)
        </p>
    </xsl:template>
    
</xsl:stylesheet>
