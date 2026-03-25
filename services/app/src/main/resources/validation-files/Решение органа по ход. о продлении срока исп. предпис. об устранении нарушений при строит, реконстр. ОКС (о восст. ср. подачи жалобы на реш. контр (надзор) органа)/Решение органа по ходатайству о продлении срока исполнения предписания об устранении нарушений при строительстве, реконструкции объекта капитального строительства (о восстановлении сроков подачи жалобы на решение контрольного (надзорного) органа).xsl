<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://types/CommonTypes.xsd"
    xmlns:cf="http://gsn/gsnDecisionPrescriptExecutionDateChange.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:gsnDecisionPrescriptExecutionDateChange" />

    </xsl:template>

    <xsl:template match="/cf:gsnDecisionPrescriptExecutionDateChange">

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
                    font-size:8.0pt;
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
                    
                    .addressee {
                    width: 50%;
                    margin: 10px;
                    margin: 0 0 0 50%;
                    align: right;
                    }
                    
                    .margin {
                    margin: 0;
                    }
                    
                    .controlEventRegistryRecord {
                    margin: 5px;
                    border: 2px solid #000000;
                    border-collapse:collapse;
                    width: 50%
                    }
                </style>
            </head>
            <title>gsnDecisionPrescriptExecutionDateChange</title>
            <body>
                <xsl:for-each select="cf:controlledOrganizationRepresentativeSignedPart">
                    <xsl:for-each select="cf:supervisoryAuthorityRepresentativeSignedPart">
                        <xsl:for-each select="cf:decisionRequisites">
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
                            <xsl:for-each select="cf:supervisoryAuthorityInfo">
                                <p class="list" style="text-align: center">
                                    Наименование организации:
                                    <span class="data">
                                        <xsl:value-of select="ct:name"/>
                                    </span>
                                </p>
                                <p class="list" style="text-align: center">
                                    Почтовый адрес:
                                    <span class="data">
                                        <xsl:value-of select="ct:address"/>
                                    </span>
                                </p>
                                <p class="list" style="text-align: center">
                                    ИНН:
                                    <span class="data">
                                        <xsl:value-of select="ct:inn"/>
                                    </span>
                                </p>
                                <p class="list" style="text-align: center">
                                    ОГРН:
                                    <span class="data">
                                        <xsl:value-of select="ct:ogrn"/>
                                    </span>
                                </p>
                                <xsl:if test="ct:contactInfo">
                                    <xsl:for-each select="ct:contactInfo">
                                        <p class="list" style="text-align: center">
                                            Телефон, адрес электронной почты:
                                            <span class="data">
                                                <xsl:value-of select="ct:phone"/><xsl:text> </xsl:text>
                                                <xsl:if test="ct:email">
                                                    <xsl:value-of select="ct:email"/><xsl:text> </xsl:text>
                                                </xsl:if>
                                            </span>
                                        </p>
                                    </xsl:for-each>
                                </xsl:if>
                            </xsl:for-each>
                            <hr/>
                            <h1>
                                РЕШЕНИЕ
                                <br/>
                                по результатам рассмотрения ходатайства
                            </h1>
                            <xsl:for-each select="cf:documentDetails">
                                <p class="list" style="text-align: center">
                                    от 
                                    <span class="data">
                                        <xsl:call-template name="formatdate">
                                            <xsl:with-param name="DateStr" select="ct:date" />
                                        </xsl:call-template>
                                    </span>
                                    № 
                                    <span class="data">
                                        <xsl:value-of select="ct:number"/>
                                    </span>
                                </p>
                            </xsl:for-each>
                        </xsl:for-each>
                        <br/>
                        <xsl:for-each select="cf:decisionInfo">
                            <p class="list">На основании ходатайства контролируемого лица (или представления инспектора)</p>
                            <xsl:for-each select="cf:gsnPetitionPrescriptExecutionDateChange">
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
                            <p class="under">(указывается дата и номер ходатайства или представления)</p>
                            <p class="list">от</p>
                            <xsl:choose>
                                <xsl:when test="cf:controlledOrganization">
                                    <xsl:for-each select="cf:controlledOrganization">
                                        <xsl:choose>
                                            <xsl:when test="ct:organization/ct:legalEntity">
                                                <xsl:for-each select="ct:organization/ct:legalEntity">
                                                    <p class="data">
                                                        <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                        ОГРН: 
                                                        <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                                        ИНН: 
                                                        <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                                        <xsl:value-of select="ct:address"/>
                                                        <xsl:if test="ct:contactInfo">
                                                            <xsl:for-each select="ct:contactInfo">
                                                                <xsl:value-of select="ct:phone"/> 
                                                                <xsl:if test="ct:email">
                                                                    <xsl:value-of select="ct:email"/>
                                                                </xsl:if>
                                                            </xsl:for-each>
                                                        </xsl:if>
                                                    </p>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:when test="ct:organization/ct:individualEntrepreneur">
                                                <xsl:for-each select="ct:organization/ct:individualEntrepreneur">
                                                    <p class="data">
                                                        <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                                        <xsl:value-of select="ct:firstName"/>
                                                        <xsl:if test="ct:middleName">
                                                            <xsl:text> </xsl:text>
                                                            <xsl:value-of select="ct:middleName"/>
                                                        </xsl:if>
                                                        ОГРНИП: 
                                                        <xsl:value-of select="ct:ogrnip"/><xsl:text> </xsl:text>
                                                        ИНН: 
                                                        <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
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
                                                    </p>
                                                </xsl:for-each>
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
                                    </xsl:for-each>
                                    <p class="under">
                                        (указывается контролируемое лицо (организационно-правовая форма, 
                                        ИНН/ОГРН))
                                    </p>
                                </xsl:when>
                                <xsl:when test="cf:inspectionAuthority">
                                    <xsl:for-each select="cf:inspectionAuthority">
                                        <p class="data">
                                            <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:firstName"/>
                                            <xsl:if test="ct:middleName">
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:middleName"/>
                                            </xsl:if>
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:position"/>
                                        </p>
                                    </xsl:for-each>
                                    <p class="under">
                                        (указывается инспектор направивший представление)
                                    </p>
                                </xsl:when>
                            </xsl:choose>
                            
                            <p class="list">По вопросу</p>
                            <p class="data">
                                <xsl:value-of select="cf:decisionSubjectDescription"/>
                            </p>
                            <p class="under">
                                указывается вопрос в ходатайстве или представлении 
                                (разъяснение способа и порядка исполнения решения; 
                                об отсрочке исполнения решения; 
                                о приостановлении исполнения решения, возобновлении ранее приостановленного исполнения решения; 
                                о прекращении исполнения решения)
                            </p>
                            <p class="list">В связи с решением</p>
                            <p class="data">
                                <xsl:for-each select="cf:decisionRequisites">
                                    <xsl:value-of select="ct:name"/>
                                    №
                                    <xsl:value-of select="ct:number"/>
                                    от
                                    <xsl:call-template name="formatdate">
                                        <xsl:with-param name="DateStr" select="ct:date" />
                                    </xsl:call-template>
                                </xsl:for-each> 
                            </p>
                            <p class="under">(указывается дата, наименование, номер решения)</p>
                            <p class="list">в отношении</p>
                            <xsl:for-each select="cf:permanentObjectInfo">
                                <p class="data">
                                    <xsl:value-of select="ct:permanentObjectName"/><xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:permanentObjectAddress"/>  
                                </p>
                            </xsl:for-each>
                            <p class="under">(указывается наименование, адрес объекта)</p>
                            <p class="list">в присутствии</p>
                            <xsl:if test="cf:inspectionAuthority">
                                <xsl:for-each select="cf:inspectionAuthority">
                                    <p class="data">
                                        <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:firstName"/>
                                        <xsl:if test="ct:middleName">
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:middleName"/>
                                        </xsl:if>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:position"/>
                                    </p>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:if test="../../cf:controlledOrganizationRepresentative">
                                <xsl:for-each select="../../cf:controlledOrganizationRepresentative">
                                    <p class="data">
                                        <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:firstName"/>
                                        <xsl:if test="ct:middleName">
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:middleName"/>
                                        </xsl:if>
                                        реквизиты доверенности:
                                        <xsl:for-each select="ct:administrativeDocument">
                                            <xsl:value-of select="ct:name"/>
                                            №
                                            <xsl:value-of select="ct:number"/>
                                            от
                                            <xsl:call-template name="formatdate">
                                                <xsl:with-param name="DateStr" select="ct:date" />
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </p>
                                </xsl:for-each>
                            </xsl:if>
                            <xsl:for-each select="../cf:supervisoryAuthorityRepresentative">
                                <p class="data">
                                    <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:firstName"/>
                                    <xsl:if test="ct:middleName">
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:middleName"/>
                                    </xsl:if>
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:position"/>
                                </p>
                            </xsl:for-each>
                            <xsl:if test="cf:presentRepresentativesList">
                                <xsl:for-each select="cf:presentRepresentativesList/cf:presentRepresentative">
                                    <p class="data">
                                        <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:firstName"/>
                                        <xsl:if test="ct:middleName">
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:middleName"/>
                                        </xsl:if>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:position"/> от
                                        <xsl:for-each select="cf:organization/ct:organizationInfo">
                                            <xsl:choose>
                                                <xsl:when test="ct:legalEntity">
                                                    <xsl:for-each select="ct:legalEntity">
                                                        <xsl:value-of select="ct:name"/>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:when test="ct:individualEntrepreneur">
                                                    <xsl:for-each select="ct:individualEntrepreneur">
                                                        <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                                        <xsl:value-of select="ct:firstName"/>
                                                        <xsl:if test="ct:middleName">
                                                            <xsl:text> </xsl:text>
                                                            <xsl:value-of select="ct:middleName"/>
                                                        </xsl:if>
                                                    </xsl:for-each>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </p>
                                </xsl:for-each>
                            </xsl:if>
                            <p class="under">
                                (указывается контролируемое (или представитель лица по доверенности с реквизитами доверенности)
                                лицо либо инспектор, а также иные лица, присутствующие при рассмотрении)</p>
                            <p class="list">Учитывая следующее:</p>
                            <p class="data">
                                <xsl:value-of select="cf:comment"/>
                            </p>
                            <br/>
                            <p class="list">
                                и руководствуясь 
                                <span class="data">
                                    <xsl:for-each select="cf:regulationDocumentsList/ct:regulationDocument">
                                        <span class="data">
                                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:number"/><xsl:text> </xsl:text>
                                            <xsl:if test="ct:sectionsList">
                                                <xsl:for-each select="ct:sectionsList/ct:section">
                                                    <xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:number"/><xsl:text> </xsl:text>
                                                </xsl:for-each>
                                            </xsl:if>
                                        </span>
                                    </xsl:for-each>
                                </span>
                            </p>
                            <br/>
                            <p class="list">Решение:
                                <span class="data">
                                    <xsl:for-each select="cf:decisionResultInfo">
                                        <xsl:value-of select="cf:decisionResult"/><xsl:text> </xsl:text>
                                        <xsl:choose>
                                            <xsl:when test="cf:startDate">
                                                c
                                                <xsl:call-template name="formatdate">
                                                    <xsl:with-param name="DateStr" select="cf:startDate" />
                                                </xsl:call-template>
                                            </xsl:when>
                                            <xsl:when test="cf:endDate">
                                                до
                                                <xsl:call-template name="formatdate">
                                                    <xsl:with-param name="DateStr" select="cf:endDate" />
                                                </xsl:call-template>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </span>
                            </p>
                            <br/>
                        </xsl:for-each>
                        <p class="list">Решение принято</p>
                        <xsl:for-each select="cf:supervisoryAuthorityRepresentative">
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
                                <span style="text-align:left; float:left; width:50mm">
                                    (указывается наименование должности должностного лица КНО)
                                </span>
                                расшифровка подписи
                            </p>
                        </xsl:for-each>
                    </xsl:for-each>
                    <br/>
                </xsl:for-each>
                <xsl:choose>
                    <xsl:when test="cf:controlledOrganizationRepresentativeSignature">
                        <xsl:for-each select="cf:controlledOrganizationRepresentativeSignedPart/cf:controlledOrganizationRepresentative">
                            <p class="list">Решение получил</p>
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
                                <span style="text-align:left; float:left; width:50mm">
                                    (должность представителя контролируемого лица)
                                </span>
                                расшифровка подписи
                            </p>
                        </xsl:for-each>
                    </xsl:when>
                    <xsl:when test="cf:inspectionAuthoritySignature">
                        <xsl:for-each select="cf:controlledOrganizationRepresentativeSignedPart/cf:supervisoryAuthorityRepresentativeSignedPart/cf:decisionInfo/cf:inspectionAuthority">
                            <p class="list">Решение получил</p>
                            <p style="text-align:left">
                                <span class="data">
                                    <xsl:value-of select="ct:position"/><xsl:text> </xsl:text>
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
                                <span style="text-align:left; float:left; width:50mm">
                                    (должность инспектора)
                                </span>
                                расшифровка подписи
                            </p>
                        </xsl:for-each>
                    </xsl:when>
                </xsl:choose>
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
    
</xsl:stylesheet>
