<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://types/CommonTypes.xsd"
    xmlns:cf="http://idActs/AOOK.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:aook" />

    </xsl:template>

    <xsl:template match="/cf:aook">


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
                </style>
            </head>
            <title>AOOK</title>
            <!-- Приложение 2 -->
            <body>
                <xsl:for-each select="cf:actInfo">
                    <h2>Объект капитального строительства</h2>
                    <p class="data">
                        <xsl:value-of select="ct:permanentObjectInfo/ct:permanentObjectName" />
                    </p>
                    <p class="under">(наименование проектной документации, почтовый или строительный адрес объекта капитального строительства)</p>
                    <xsl:choose>
                        <xsl:when test="ct:developer">
                            <xsl:apply-templates select="ct:developer" />
                        </xsl:when>
                        <xsl:when test="ct:technicalCustomer">
                            <xsl:apply-templates select="ct:technicalCustomer" />
                        </xsl:when>
                        <xsl:when test="ct:operatingPerson">
                            <xsl:apply-templates select="ct:operatingPerson" />
                        </xsl:when>
                        <xsl:when test="ct:regionalOperator">
                            <xsl:apply-templates select="ct:regionalOperator" />
                        </xsl:when>
                    </xsl:choose>
                    <h2>Лицо, осуществляющее строительство</h2>
                    <xsl:for-each select="ct:buildingContractor/ct:organizationInfo">
                        <xsl:choose>
                            <xsl:when test="ct:individualEntrepreneur">
                                <p class="data">
                                    <xsl:for-each select="ct:individualEntrepreneur">
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
                                <p class="under">фамилия, имя, отчество, адрес места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
                            </xsl:when>
                            <xsl:when test="ct:legalEntity">
                                <p class="data">
                                    <xsl:for-each select="ct:legalEntity">
                                        <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:contactInfo/ct:phone"/>
                                    </xsl:for-each>
                                </p>
                                <p class="under">наименование, ОГРН, ИНН, место нахождения юридического лица, телефон/факс,</p>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select="ct:buildingContractor/ct:organizationInfo">
                        <xsl:choose>
                            <xsl:when test="ct:sro">
                                <p class="data">
                                    <xsl:value-of select="ct:sro/ct:name"/><xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:sro/ct:ogrn"/><xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:sro/ct:inn"/>
                                </p>
                                <p class="under">наименование, ОГРН, ИНН саморегулируемой организации, членом которой является</p>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    <h2>Лицо, осуществляющее подготовку проектной документации</h2>
                    <xsl:for-each select="ct:projectDocumentationContractor/ct:organizationInfo">
                        <xsl:choose>
                            <xsl:when test="ct:individualEntrepreneur">
                                <p class="data">
                                    <xsl:for-each select="ct:individualEntrepreneur">
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
                                <p class="under">фамилия, имя, отчество, адрес места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
                            </xsl:when>
                            <xsl:when test="ct:legalEntity">
                                <p class="data">
                                    <xsl:for-each select="ct:legalEntity">
                                        <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:contactInfo/ct:phone"/>
                                    </xsl:for-each>
                                </p>
                                <p class="under">наименование, ОГРН, ИНН, место нахождения юридического лица, телефон/факс,</p>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select="ct:projectDocumentationContractor/ct:organizationInfo">
                        <xsl:choose>
                            <xsl:when test="ct:sro">
                                <p class="data">
                                    <xsl:value-of select="ct:sro/ct:name"/><xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:sro/ct:ogrn"/><xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:sro/ct:inn"/>
                                </p>
                                <p class="under">наименование, ОГРН, ИНН саморегулируемой организации, членом которой является</p>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                </xsl:for-each>
            </body>

            <!--АКТ освидетельствования ответственных конструкций-->
            <body>
                <xsl:for-each select="cf:actInfo">
                    <h1>АКТ <br>освидетельствования строительных конструкций, устранения недостатков в которых невозможно без разборки или повреждения других строительных конструкций, и участников сетей инженерно-технического обеспесения</br><br>(ответственных конструкций)</br>
                    </h1>
                    <div style="width: 100%; font-size: 10pt; text-align: right">
                        <span style="float: left">
                            № 
                            <xsl:choose>
                                <xsl:when test="ct:documentInfo/ct:structureElementNumber">
                                    <xsl:value-of select="ct:documentInfo/ct:structureElementNumber"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="ct:documentInfo/ct:number" />
                                </xsl:otherwise>
                            </xsl:choose>
                        </span>
                        <xsl:call-template name="formatdate">
                            <xsl:with-param name="DateStr" select="ct:documentInfo/ct:date" />
                        </xsl:call-template>
                    </div>
                    <p class="under" style="text-align: right">(дата составления акта)</p>
                    <!--Представитель застройщика-->
                    <xsl:choose>
                        <xsl:when test="ct:developerRepresentative">
                            <xsl:apply-templates select="ct:developerRepresentative" />
                        </xsl:when>
                        <xsl:when test="ct:technicalCustomerRepresentative">
                            <xsl:apply-templates select="ct:technicalCustomerRepresentative" />
                        </xsl:when>
                        <xsl:when test="ct:operatingPersonRepresentative">
                            <xsl:apply-templates select="ct:operatingPersonRepresentative" />
                        </xsl:when>
                        <xsl:when test="ct:regionalOperatorRepresentative">
                            <xsl:apply-templates select="ct:regionalOperatorRepresentative" />
                        </xsl:when>
                    </xsl:choose>
                
                <!--Представитель лица, осуществляющего строительство-->
                <p class="list">Представитель лица, осуществляющего строительство</p>
                    <xsl:for-each select="ct:buildingContractorRepresentative">
                        <p class="data">
                            <xsl:value-of select="ct:position" /><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:lastName" /><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:firstName" />
                            <xsl:if test="ct:middleName">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="ct:middleName" />
                            </xsl:if>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="ct:administrativeDocument/ct:name" /><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:administrativeDocument/ct:number" /> от 
                            <xsl:call-template name="formatdate">
                                <xsl:with-param name="DateStr" select="ct:administrativeDocument/ct:date" />
                            </xsl:call-template>
                        </p>
                    </xsl:for-each>
                <p class="under">должность, фамилия, инициалы, реквизиты распорядительного документа, подтверждающего полномочия</p>
                <!--Представитель лица, осуществляющего строительство, по вопросам строительного контроля (специалист по организации строительства)-->
                <p class="list">Представитель лица, осуществляющего строительство, по вопросам строительного контроля (специалист по организации строительства)</p>
                    <xsl:for-each select="ct:constructionManagementRepresentative">
                        <p class="data">
                            <xsl:value-of select="ct:position" /><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:lastName" /><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:firstName" />
                            <xsl:if test="ct:middleName">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="ct:middleName" />
                            </xsl:if>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="ct:specialistIdNumber"/>
                        </p>
                        <p class="under">должность, фамилия, инициалы, идентификационный номер в национальном реестре специалистов</p>
                        <p class="data">
                            <xsl:value-of select="ct:administrativeDocument/ct:name" /><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:administrativeDocument/ct:number" /> от 
                            <xsl:call-template name="formatdate">
                                <xsl:with-param name="DateStr" select="ct:administrativeDocument/ct:date" />
                            </xsl:call-template>
                        </p>
                        <p class="under">в области строительства, реквизиты распорядительного документа, подтверждающего полномочия</p>
                    </xsl:for-each>
                    <!--Представитель лица, осуществляющего подготовку проектной документации-->
                    <xsl:if test="ct:projDocContractRepresentative">
                        <p class="list">Представитель лица, осуществляющего подготовку проектной документации</p>
                        <xsl:for-each select="ct:projDocContractRepresentative/ct:representative">
                            <p class="data">
                                <xsl:value-of select="ct:position" /><xsl:text> </xsl:text>
                                <xsl:value-of select="ct:lastName" /><xsl:text> </xsl:text>
                                <xsl:value-of select="ct:firstName" />
                                <xsl:if test="ct:middleName">
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:middleName" />
                                </xsl:if>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="ct:administrativeDocument/ct:name" /><xsl:text> </xsl:text>
                                <xsl:value-of select="ct:administrativeDocument/ct:number" /> от 
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="ct:administrativeDocument/ct:date" />
                                </xsl:call-template>
                            </p>
                        </xsl:for-each>
                        <p class="under">должность, фамилия, инициалы, реквизиты распорядительного документа, подтверждающего полномочия</p>
                        <xsl:for-each select="ct:projDocContractRepresentative/ct:organization/ct:organizationInfo">
                            <xsl:choose>
                                <xsl:when test="ct:individualEntrepreneur">
                                    <p class="data">
                                        <xsl:for-each select="ct:individualEntrepreneur">
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
                                    <p class="under">фамилии, имени, отчества, адреса места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
                                </xsl:when>
                                <xsl:when test="ct:legalEntity">
                                    <p class="data">
                                        <xsl:for-each select="ct:legalEntity">
                                        <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:contactInfo/ct:phone"/>
                                    </xsl:for-each>
                                    </p>
                                    <p class="under">с указанием наименования, ОГРН, ИНН, места нахождения юридического лица</p>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                        <xsl:for-each select="ct:projDocContractRepresentative/ct:organization/ct:organizationInfo">
                            <xsl:choose>
                                <xsl:when test="ct:sro">
                                    <p class="data">
                                        <xsl:value-of select="ct:sro/ct:name"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:sro/ct:ogrn"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:sro/ct:inn"/>
                                    </p>
                                    <p class="under">наименования, ОГРН, ИНН саморегулируемой организации, членом которой является указанное юридическое лицо, индивидуальный предприниматель</p>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:if>
                    <!--Представитель лица, выполнившего конструкции, подлежащие освидетельствованию-->
                    <xsl:if test="ct:workExecutorRepresentative">
                        <p class="list">Представитель лица, выполнившего конструкции, подлежащие освидетельствованию</p>
                        <xsl:for-each select="ct:workExecutorRepresentative/ct:representative">
                            <p class="data">
                                <xsl:value-of select="ct:position" /><xsl:text> </xsl:text>
                                <xsl:value-of select="ct:lastName" /><xsl:text> </xsl:text>
                                <xsl:value-of select="ct:firstName" />
                                <xsl:if test="ct:middleName">
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:middleName" />
                                </xsl:if>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="ct:administrativeDocument/ct:name" /><xsl:text> </xsl:text>
                                <xsl:value-of select="ct:administrativeDocument/ct:number" /> от 
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="ct:administrativeDocument/ct:date" />
                                </xsl:call-template>
                            </p>
                        </xsl:for-each>
                        <p class="under">должность, фамилия, инициалы, реквизиты распорядительного документа, подтверждающего полномочия</p>
                        <xsl:for-each select="ct:workExecutorRepresentative/ct:organization/ct:organizationInfo">
                            <xsl:choose>
                                <xsl:when test="ct:legalEntity">
                                    <p class="data">
                                        <xsl:for-each select="ct:legalEntity">
                                        <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:contactInfo/ct:phone"/>
                                    </xsl:for-each>
                                    </p>
                                    <p class="under">с указанием наименования, ОГРН, ИНН, места нахождения юридического лица</p>
                                </xsl:when>
                                <xsl:when test="ct:individualEntrepreneur">
                                    <p class="data">
                                        <xsl:for-each select="ct:individualEntrepreneur">
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
                                    <p class="under">с указанием фамилии, имени, отчества, адреса места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:if>
                    <!--Представители иных лиц-->
                    <xsl:if test="ct:otherRepresentativesList/ct:otherRepresentativesListItem">
                        <p class="list">а также иные представители лиц, участвующих в освидетельствовании:</p>
                        <xsl:for-each select="ct:otherRepresentativesList/ct:otherRepresentativesListItem">
                            <p class="data">
                                <xsl:value-of select="ct:representative/ct:position" /> в 
                                <xsl:for-each select="ct:organization">
                                    <xsl:choose>
                                        <xsl:when test="ct:fullOrganizationInfo">
                                            <xsl:for-each select="ct:fullOrganizationInfo/ct:organizationInfo">
                                                <xsl:choose>
                                                    <xsl:when test="ct:legalEntity">
                                                        <xsl:for-each select="ct:legalEntity">
                                                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                            ОГРН:<xsl:value-of select="ct:ogrn"/>
                                                            ИНН:<xsl:value-of select="ct:inn"/>
                                                            адрес:<xsl:value-of select="ct:address"/>
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
                                                            ОГРНИП:<xsl:value-of select="ct:ogrnip"/>
                                                            ИНН:<xsl:value-of select="ct:inn"/>
                                                            адрес:<xsl:value-of select="ct:address"/>
                                                        </xsl:for-each>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:when test="ct:shortOrganizationInfo">
                                            <xsl:for-each select="ct:shortOrganizationInfo">
                                                <xsl:choose>
                                                    <xsl:when test="ct:legalEntity">
                                                        <xsl:for-each select="ct:legalEntity">
                                                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                            <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                                            <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                                            <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                                                            <xsl:value-of select="ct:contactInfo/ct:phone"/>
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
                                                            <xsl:text> </xsl:text>
                                                            <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                                                            <xsl:value-of select="ct:ogrnip"/><xsl:text> </xsl:text>
                                                            <xsl:value-of select="ct:inn"/>
                                                        </xsl:for-each>
                                                    </xsl:when>
                                                </xsl:choose>
                                            </xsl:for-each>
                                        </xsl:when>
                                    </xsl:choose>
                                </xsl:for-each>
                            </p>
                            <p class="data">
                                <xsl:value-of select="ct:representative/ct:lastName" /><xsl:text> </xsl:text>
                                <xsl:value-of select="ct:representative/ct:firstName" />
                                <xsl:if test="ct:representative/ct:middleName">
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:representative/ct:middleName" /> 
                                </xsl:if>
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="ct:representative/ct:administrativeDocument/ct:name" /><xsl:text> </xsl:text>
                                <xsl:value-of select="ct:representative/ct:administrativeDocument/ct:number" /> от 
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="ct:representative/ct:administrativeDocument/ct:date" />
                                </xsl:call-template>
                            </p>
                            <p class="under">должность с указанием наименования организации , фамилия, инициалы, реквизиты распорядительного документа, подтверждающего полномочия</p>
                        </xsl:for-each>  
                    </xsl:if>
                    <!--1. К освидетельствованию предъявлены следующие ответственные конструкции:-->
                    <p class="list">1. К освидетельствованию предъявлены следующие ответственные конструкции:</p>
                    <xsl:for-each select="cf:inspectedCriticalConstructionsList/cf:inspectedCriticalConstructionsListItem">
                        <p class="data">
                            <xsl:value-of select="cf:structureElementName"/><xsl:text> - </xsl:text>
                            <xsl:value-of select="cf:structureAmountInfo/cf:amount"/><xsl:text> </xsl:text>
                            <xsl:value-of select="cf:structureAmountInfo/cf:unit"/>;
                        </p>
                    </xsl:for-each>
                    <p class="under">наименование и краткая характеристика конструкций</p>
                    <p class="list">2. Конструкции выполнены по проектной документации</p>
                    <xsl:for-each select="cf:workAndProjectDocumentationsList/cf:workAndProjectDocumentationsListItem">
                        <xsl:for-each select="cf:workAndProjectDocumentation">
                            <xsl:choose>
                                <xsl:when test="ct:obligatoryProjectDocumentation">
                                    <xsl:for-each select="ct:obligatoryProjectDocumentation">
                                        <xsl:for-each select="ct:projectDocumentationSectionsList/ct:projectDocumentationSectionsListItem">
                                            <p class="data">
                                                <xsl:value-of select="ct:projectDocumentationSectionCode" /><xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:projectDocumentationSectionName" />
                                            </p>
                                        </xsl:for-each>
                                        <xsl:if test="ct:workDocumentationSectionsList">
                                            <xsl:for-each select="ct:workDocumentationSectionsList/ct:workDocumentationSectionsListItem">
                                                <p class="data">
                                                    <xsl:value-of select="ct:workDocumentationSectionCode" /><xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:workDocumentationSectionName" />
                                                </p>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="ct:obligatoryWorkDocumentation">
                                    <xsl:for-each select="ct:obligatoryWorkDocumentation">
                                        <xsl:if test="ct:projectDocumentationSectionsList">
                                            <xsl:for-each select="ct:projectDocumentationSectionsList/ct:projectDocumentationSectionsListItem">
                                                <p class="data">
                                                    <xsl:value-of select="ct:projectDocumentationSectionCode" /><xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:projectDocumentationSectionName" />
                                                </p>
                                            </xsl:for-each>
                                        </xsl:if>
                                        <xsl:for-each select="ct:workDocumentationSectionsList/ct:workDocumentationSectionsListItem">
                                            <p class="data">
                                                <xsl:value-of select="ct:workDocumentationSectionCode" /><xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:workDocumentationSectionName" />
                                            </p>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                        <p class="under">наименования и структурные единицы технических регламентов, иных нормативных правовых актов, разделы проектной и/или рабочей документации</p>
                        <xsl:for-each select="cf:organization">
                            <xsl:choose>
                                <xsl:when test="cf:fullOrganizationInfo">
                                    <xsl:for-each select="cf:fullOrganizationInfo/ct:organizationInfo">
                                        <xsl:choose>
                                            <xsl:when test="ct:legalEntity">
                                                <xsl:for-each select="ct:legalEntity">
                                                    <p class="data">
                                                        <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                        ОГРН:<xsl:value-of select="ct:ogrn"/>
                                                        ИНН:<xsl:value-of select="ct:inn"/>
                                                        адрес:<xsl:value-of select="ct:address"/>
                                                    </p>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:when test="ct:individualEntrepreneur">
                                                <p class="data">
                                                    <xsl:for-each select="ct:individualEntrepreneur">
                                                        <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                                        <xsl:value-of select="ct:firstName"/>
                                                        <xsl:if test="ct:middleName">
                                                            <xsl:text> </xsl:text>
                                                            <xsl:value-of select="ct:middleName"/>
                                                        </xsl:if>
                                                        ОГРНИП:<xsl:value-of select="ct:ogrnip"/>
                                                        ИНН:<xsl:value-of select="ct:inn"/>
                                                        адрес:<xsl:value-of select="ct:address"/>
                                                    </xsl:for-each>
                                                </p>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="cf:shortOrganizationInfo">
                                    <xsl:for-each select="cf:shortOrganizationInfo">
                                        <xsl:choose>
                                            <xsl:when test="ct:legalEntity">
                                                <p class="data">
                                                    <xsl:for-each select="ct:legalEntity">
                                                        <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                        <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                                        <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                                        <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                                                        <xsl:value-of select="ct:contactInfo/ct:phone"/>
                                                    </xsl:for-each>
                                                </p>
                                            </xsl:when>
                                            <xsl:when test="ct:individualEntrepreneur">
                                                <p class="data">
                                                    <xsl:for-each select="ct:individualEntrepreneur">
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
                                        </xsl:choose>
                                    </xsl:for-each>
                                </xsl:when>
                            </xsl:choose>
                            <p class="under">сведения о лицах, осуществляющих подготовку раздела проектной документации</p>
                        </xsl:for-each>
                    </xsl:for-each>
                    <p class="list">3. Освидетельствованы скрытые работы, которые оказывают влияние на безопасность конструкций:</p>
                    <xsl:choose>
                        <xsl:when test="cf:inspectedHiddenWorksList">
                            <xsl:for-each select="cf:inspectedHiddenWorksList/cf:inspectedHiddenWorksListItem">
                                <p class="data">
                                    <xsl:value-of select="ct:hiddenWorkInfo/ct:workName"/><xsl:text> </xsl:text>
                                    <xsl:call-template name="formatdate">
                                        <xsl:with-param name="DateStr" select="ct:documentInfo/ct:date"/>
                                    </xsl:call-template><xsl:text> </xsl:text>
                                    <xsl:for-each select="ct:documentInfo">
                                        <xsl:choose>
                                            <xsl:when test="ct:structureElementNumber">
                                                №<xsl:value-of select="ct:structureElementNumber"/>
                                            </xsl:when>
                                            <xsl:when test="ct:number">
                                                №<xsl:value-of select="ct:number"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </p>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <p class="data">Отсутствуют</p>
                        </xsl:otherwise>
                    </xsl:choose>
                    <p class="under">указываются скрытые работы, даты и номера актов их освидетельствования</p>
                    <p class="list">4. При выполнении конструкций применены:</p>
                    <xsl:for-each select="cf:usedMaterialslist/cf:usedMaterialslistItem">
                        <p class="data">
                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                            Сертификаты:
                            <xsl:for-each select="ct:qualityApproveDocuments">
                                <xsl:choose>
                                    <xsl:when test="ct:typedQualityApproveDocuments">
                                        <xsl:for-each select="ct:typedQualityApproveDocuments">
                                            <xsl:choose>
                                                <xsl:when test="ct:materialAmountQualityDocument">
                                                    <xsl:value-of select="ct:materialAmountQualityDocument/ct:name"/><xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:materialAmountQualityDocument/ct:number"/><xsl:text> </xsl:text>
                                                    <xsl:call-template name="formatdate">
                                                        <xsl:with-param name="DateStr">
                                                            <xsl:value-of select="ct:materialAmountQualityDocument/ct:date"/>
                                                        </xsl:with-param>
                                                    </xsl:call-template><xsl:text>; </xsl:text>
                                                </xsl:when>
                                                <xsl:when test="ct:parametersComplianceDocument">
                                                    <xsl:value-of select="ct:parametersComplianceDocument/ct:name"/><xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:parametersComplianceDocument/ct:number"/><xsl:text> </xsl:text>
                                                    <xsl:call-template name="formatdate">
                                                        <xsl:with-param name="DateStr">
                                                            <xsl:value-of select="ct:parametersComplianceDocument/ct:date"/>
                                                        </xsl:with-param>
                                                    </xsl:call-template><xsl:text>; </xsl:text>
                                                </xsl:when>
                                                <xsl:when test="ct:additionalParametersComplianceDocument">
                                                    <xsl:value-of select="ct:additionalParametersComplianceDocument/ct:name"/><xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:additionalParametersComplianceDocument/ct:number"/><xsl:text> </xsl:text>
                                                    <xsl:call-template name="formatdate">
                                                        <xsl:with-param name="DateStr">
                                                            <xsl:value-of select="ct:additionalParametersComplianceDocument/ct:date"/>
                                                        </xsl:with-param>
                                                    </xsl:call-template><xsl:text>; </xsl:text>
                                                </xsl:when>
                                                <xsl:when test="ct:additionalQualityDocument">
                                                    <xsl:value-of select="ct:additionalQualityDocument/ct:name"/><xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:additionalQualityDocument/ct:number"/><xsl:text> </xsl:text>
                                                    <xsl:call-template name="formatdate">
                                                        <xsl:with-param name="DateStr">
                                                            <xsl:value-of select="ct:additionalQualityDocument/ct:date"/>
                                                        </xsl:with-param>
                                                    </xsl:call-template><xsl:text>; </xsl:text>
                                                </xsl:when>
                                            </xsl:choose>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="ct:untypedQualityApproveDocumentsList">
                                        <xsl:for-each select="ct:untypedQualityApproveDocumentsList/ct:untypedQualityApproveDocumentsListItem">
                                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:number"/><xsl:text> </xsl:text>
                                            <xsl:call-template name="formatdate">
                                                <xsl:with-param name="DateStr">
                                                    <xsl:value-of select="ct:date"/>
                                                </xsl:with-param>
                                            </xsl:call-template><xsl:text>; </xsl:text>
                                        </xsl:for-each>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                        </p>
                    </xsl:for-each>
                    <p class="under">наименование строительных материалов (изделий), реквизиты сертификатов и/или других документов, подтверждающих их качество и безопасность</p>
                    <p class="list">5. Предъявлены документы, подтверждающие соответствие конструкций предъявляемым к ним требованиям, в том числе:</p>
                    <xsl:for-each select="cf:examinationDocuments">
                        <xsl:choose>
                            <xsl:when test="ct:obligatoryAsBuiltSchemas">
                                <xsl:for-each select="ct:obligatoryAsBuiltSchemas">
                                    <xsl:for-each select="ct:asBuiltSchemasList/ct:asBuiltSchemasListItem">
                                        <p class="data">
                                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:number"/><xsl:text> от </xsl:text>
                                            <xsl:call-template name="formatdate">
                                                <xsl:with-param name="DateStr" select="ct:date" />
                                            </xsl:call-template>
                                        </p>
                                    </xsl:for-each>
                                    <xsl:if test="ct:examinationResultDocumentsList">
                                        <xsl:for-each select="ct:examinationResultDocumentsList/ct:examinationResultDocumentsListItem">
                                            <p class="data">
                                                <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:number"/><xsl:text> от </xsl:text>
                                                <xsl:call-template name="formatdate">
                                                    <xsl:with-param name="DateStr" select="ct:date" />
                                                </xsl:call-template>
                                            </p>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="ct:obligatoryExpretiseResultDocuments">
                                <xsl:for-each select="ct:obligatoryExpretiseResultDocuments">
                                    <xsl:if test="ct:asBuiltSchemasList">
                                        <xsl:for-each select="ct:asBuiltSchemasList/ct:asBuiltSchemasListItem">
                                            <p class="data">
                                                <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:number"/><xsl:text> от </xsl:text>
                                                <xsl:call-template name="formatdate">
                                                    <xsl:with-param name="DateStr" select="ct:date" />
                                                </xsl:call-template>
                                            </p>
                                        </xsl:for-each>
                                    </xsl:if>
                                    <xsl:for-each select="ct:examinationResultDocumentsList/ct:examinationResultDocumentsListItem">
                                        <p class="data">
                                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:number"/><xsl:text> от </xsl:text>
                                            <xsl:call-template name="formatdate">
                                                <xsl:with-param name="DateStr" select="ct:date" />
                                            </xsl:call-template>
                                        </p>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    <p class="under">исполнительные схемы и чертежи, результаты экспертиз, обследований, лабораторных и иных испытаний выполненных работ, проведенных в процессе строительного контроля</p>
                    <p class="list">6. Проведены необходимые испытания и опробования</p>
                    <xsl:choose>
                        <xsl:when test="cf:trialDocsList">
                            <xsl:for-each select="cf:trialDocsList/cf:trialDoc">
                                <p class="data">
                                    <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:number"/><xsl:text> от </xsl:text>
                                    <xsl:call-template name="formatdate">
                                        <xsl:with-param name="DateStr">
                                            <xsl:value-of select="ct:date"/>
                                        </xsl:with-param>
                                    </xsl:call-template>
                                    (<xsl:value-of select="cf:trialName"/>)
                                </p>
                            </xsl:for-each>
                        </xsl:when>
                        <xsl:otherwise>
                            <p class="data">Не проводились</p>
                        </xsl:otherwise>
                    </xsl:choose>
                    <p class="under">наименование документа, дата, номер, другие реквизиты</p>
                    <p class="list">
                        7. Даты: начала работ - 
                        <span class="data">
                            <xsl:call-template name="formatdate">
                                <xsl:with-param name="DateStr" select="cf:worksDates/ct:beginDate" />
                            </xsl:call-template>
                        </span>
                    </p>
                    <p class="list">              
                        окончания работ - 
                        <span class="data">
                            <xsl:call-template name="formatdate">
                                <xsl:with-param name="DateStr" select="cf:worksDates/ct:endDate" />
                            </xsl:call-template>
                        </span>
                    </p>
                    <p class="list">8. Предъявленные конструкции выполнены в соответствии с техническими регламентами, иными нормативными правовыми актами и проектной документацией</p>
                    <xsl:for-each select="cf:accordantWorkAndProjectDocumentation">
                        <xsl:for-each select="ct:shortWorkAndProjectDocumentation">
                            <xsl:choose>
                                <xsl:when test="ct:obligatoryShortProjectDocumentation">
                                    <xsl:for-each select="ct:obligatoryShortProjectDocumentation">
                                        <xsl:for-each select="ct:shortProjectDocumentationSectionsList/ct:shortProjectDocumentationSectionsListItem">
                                            <p class="data">
                                                <xsl:value-of select="ct:name" />
                                                №
                                                <xsl:value-of select="ct:number" />
                                            </p>
                                        </xsl:for-each>
                                        <xsl:if test="ct:shortWorkDocumentationSectionsList">
                                            <xsl:for-each select="ct:shortWorkDocumentationSectionsList/ct:shortWorkDocumentationSectionsListItem">
                                                <p class="data">
                                                    <xsl:value-of select="ct:name" />
                                                    №
                                                    <xsl:value-of select="ct:number" />
                                                </p>
                                            </xsl:for-each>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:when>
                                <xsl:when test="ct:obligatoryShortWorkDocumentation">
                                    <xsl:for-each select="ct:obligatoryShortWorkDocumentation">
                                        <xsl:if test="ct:shortProjectDocumentationSectionsList">
                                            <xsl:for-each select="ct:shortProjectDocumentationSectionsList/ct:shortProjectDocumentationSectionsListItem">
                                                <p class="data">
                                                    <xsl:value-of select="ct:name" />
                                                    №
                                                    <xsl:value-of select="ct:number" />
                                                </p>
                                            </xsl:for-each>
                                        </xsl:if>
                                        <xsl:for-each select="ct:shortWorkDocumentationSectionsList/ct:shortWorkDocumentationSectionsListItem">
                                            <p class="data">
                                                <xsl:value-of select="ct:name" />
                                                №
                                                <xsl:value-of select="ct:number" />
                                            </p>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                        <xsl:for-each select="ct:technicalRegulationsDocumentation/ct:technicalRegulationDetailsList/ct:technicalRegulationDetailsListItem">
                            <p class="data">
                                <xsl:value-of select="ct:name" />
                                №
                                <xsl:value-of select="ct:number" />
                            </p>
                        </xsl:for-each>
                    </xsl:for-each>
                    <p class="under">наименования и структурные единицы технических регламентов, иных нормативных правовых актов, разделы проектной и/или рабочей документации</p>
                    <p class="list">9. На основании изложенного:</p>
                    <xsl:for-each select="cf:permittedActions">
                        <xsl:choose>
                            <xsl:when test="cf:allowedToUseForPurpose">
                                <p class="data">
                                    <xsl:value-of select="cf:allowedToUseForPurpose"/>
                                </p>
                            </xsl:when>
                            <xsl:when test="cf:allowedToUseWithPartLoad">
                                <p class="data">
                                    Разрешается использование конструкций по назначению с нагружением в размере <xsl:value-of select="cf:allowedToUseWithPartLoad/cf:partLoadPercentage"/>% проектной нагрузки
                                </p>
                            </xsl:when>
                            <xsl:when test="cf:allowedToUseWithFullLoadWithConditions">
                                <p class="data">
                                    Условия, которые необходимо выполнить для обеспечения возможности полного (проектного) нагружения конструкции:
                                    <xsl:for-each select="cf:allowedToUseWithFullLoadWithConditions/cf:conditionsList">
                                        <xsl:value-of select="cf:conditionsListItem"/>
                                    </xsl:for-each>
                                </p>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:choose>
                            <xsl:when test="cf:allowedToPerformFollowingWorks">
                                <p class="data">
                                    Разрешается производство последующих работ:
                                    <xsl:for-each select="cf:allowedToPerformFollowingWorks">
                                        <xsl:choose>
                                            <xsl:when test="cf:worksName">
                                                <xsl:value-of select="cf:worksName"/>
                                            </xsl:when>
                                            <xsl:when test="cf:constructionsName">
                                                <xsl:value-of select="cf:constructionsName"/>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </p>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:if test="ct:additionalInfo">
                        <p class="list">
                            Дополнительные сведения 
                            <span class="data">
                                <xsl:value-of select="ct:additionalInfo" />
                            </span>
                        </p>
                    </xsl:if>
                    <xsl:if test="ct:copiesNumber">
                        <p class="list">Акт составлен в <xsl:value-of select="ct:copiesNumber" /> экземплярах.</p>
                    </xsl:if>
                    
                    <xsl:if test="cf:attachmentslist">
                        <p class="list">Приложения:</p>
                        <xsl:for-each select="cf:attachmentslist/cf:attachmentslistItem">
                            <p class="data">
                                <xsl:choose>
                                    <xsl:when test="ct:asBuiltSchema">
                                        <xsl:for-each select="ct:asBuiltSchema">
                                            <xsl:value-of select="ct:name"/> №
                                            <xsl:value-of select="ct:number"/> 
                                            <xsl:if test="ct:asBuiltSchemaDate">
                                                от 
                                                <xsl:call-template name="formatdate">
                                                    <xsl:with-param name="DateStr" select="ct:asBuiltSchemaDate" />
                                                </xsl:call-template>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:when test="ct:examinationResult">
                                        <xsl:for-each select="ct:examinationResult">
                                            <xsl:value-of select="ct:name"/> №
                                            <xsl:value-of select="ct:number"/> от 
                                            <xsl:call-template name="formatdate">
                                                <xsl:with-param name="DateStr" select="ct:date" />
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:for-each select="ct:document">
                                            <xsl:value-of select="ct:name"/> №
                                            <xsl:value-of select="ct:number"/>
                                        </xsl:for-each>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </p>
                        </xsl:for-each>
                        <br/>
                    </xsl:if>
                    <xsl:choose>
                        <xsl:when test="ct:developerRepresentative">
                            <p class="list">Представитель застройщика по вопросам строительного контроля</p>
                            <xsl:for-each select="ct:developerRepresentative/ct:representative">
                                <p class="data" style="width: 40%">
                                    <xsl:value-of select="ct:lastName" />
                                    <xsl:text> </xsl:text>
                                    <xsl:call-template name="initials">
                                        <xsl:with-param name="NameStr" select="ct:firstName" />
                                    </xsl:call-template>
                                    <xsl:text> </xsl:text>
                                    <xsl:call-template name="initials">
                                        <xsl:with-param name="NameStr" select="ct:middleName" />
                                    </xsl:call-template>
                                </p>
                            </xsl:for-each>
                            <p class="under" style="width: 40%">(фамилия, инициалы, подпись)</p>
                        </xsl:when>
                        <xsl:when test="ct:technicalCustomerRepresentative">
                            <p class="list">Представитель технического заказчика по вопросам строительного контроля</p>
                            <xsl:for-each select="ct:technicalCustomerRepresentative/ct:representative">
                                <p class="data" style="width: 40%">
                                    <xsl:value-of select="ct:lastName" />
                                    <xsl:text> </xsl:text>
                                    <xsl:call-template name="initials">
                                        <xsl:with-param name="NameStr" select="ct:firstName" />
                                    </xsl:call-template>
                                    <xsl:text> </xsl:text>
                                    <xsl:call-template name="initials">
                                        <xsl:with-param name="NameStr" select="ct:middleName" />
                                    </xsl:call-template>
                                </p>
                            </xsl:for-each>
                            <p class="under" style="width: 40%">(фамилия, инициалы, подпись)</p>
                        </xsl:when>
                        <xsl:when test="ct:operatingPersonRepresentative">
                            <p class="list">Представитель эксплуатирующей организации по вопросам строительного контроля</p>
                            <xsl:for-each select="ct:operatingPersonRepresentative/ct:representative">
                                <p class="data" style="width: 40%">
                                    <xsl:value-of select="ct:lastName" />
                                    <xsl:text> </xsl:text>
                                    <xsl:call-template name="initials">
                                        <xsl:with-param name="NameStr" select="ct:firstName" />
                                    </xsl:call-template>
                                    <xsl:text> </xsl:text>
                                    <xsl:call-template name="initials">
                                        <xsl:with-param name="NameStr" select="ct:middleName" />
                                    </xsl:call-template>
                                </p>
                            </xsl:for-each>
                            <p class="under" style="width: 40%">(фамилия, инициалы, подпись)</p>
                        </xsl:when>
                        <xsl:when test="ct:regionalOperatorRepresentative">
                            <p class="list">Представитель регионального оператора по вопросам строительного контроля</p>
                            <xsl:for-each select="ct:regionalOperatorRepresentative/ct:representative">
                                <p class="data" style="width: 40%">
                                    <xsl:value-of select="ct:lastName" />
                                    <xsl:text> </xsl:text>
                                    <xsl:call-template name="initials">
                                        <xsl:with-param name="NameStr" select="ct:firstName" />
                                    </xsl:call-template>
                                    <xsl:text> </xsl:text>
                                    <xsl:call-template name="initials">
                                        <xsl:with-param name="NameStr" select="ct:middleName" />
                                    </xsl:call-template>
                                </p>
                            </xsl:for-each>
                            <p class="under" style="width: 40%">(фамилия, инициалы, подпись)</p>
                        </xsl:when>
                    </xsl:choose>
                    <p class="list">Представитель лица, осуществляющего строительство</p>
                    <p class="data" style="width: 40%">
                        <xsl:for-each select="ct:buildingContractorRepresentative">
                            <xsl:value-of select="ct:lastName" />
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="initials">
                                <xsl:with-param name="NameStr" select="ct:firstName" />
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="initials">
                                <xsl:with-param name="NameStr" select="ct:middleName" />
                            </xsl:call-template>
                        </xsl:for-each>
                    </p>
                    <p class="under" style="width: 40%">(фамилия, инициалы, подпись)</p>
                    <p class="list">Представитель лица, осуществляющего строительство, по вопросам строительного контроля (специалист по организации строительства)</p>
                    <p class="data" style="width: 40%">
                        <xsl:for-each select="ct:constructionManagementRepresentative">
                            <xsl:value-of select="ct:lastName" />
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="initials">
                                <xsl:with-param name="NameStr" select="ct:firstName" />
                            </xsl:call-template>
                            <xsl:text> </xsl:text>
                            <xsl:call-template name="initials">
                                <xsl:with-param name="NameStr" select="ct:middleName" />
                            </xsl:call-template>
                        </xsl:for-each>
                    </p>
                    <p class="under" style="width: 40%">(фамилия, инициалы, подпись)</p>
                    <xsl:if test="ct:projDocContractRepresentative">
                        <p class="list">Представитель лица, осуществляющего подготовку проектной документации</p>
                        <p class="data" style="width: 40%">
                            <xsl:for-each select="ct:projDocContractRepresentative/ct:representative">
                                <xsl:value-of select="ct:lastName" />
                                <xsl:text> </xsl:text>
                                <xsl:call-template name="initials">
                                    <xsl:with-param name="NameStr" select="ct:firstName" />
                                </xsl:call-template>
                                <xsl:text> </xsl:text>
                                <xsl:call-template name="initials">
                                    <xsl:with-param name="NameStr" select="ct:middleName" />
                                </xsl:call-template>
                            </xsl:for-each>
                        </p>
                        <p class="under" style="width: 40%">(фамилия, инициалы, подпись)</p>
                    </xsl:if>
                    <xsl:if test="ct:workExecutorRepresentative">
                        <p class="list">Представитель лица, выполнившего работы, подлежащие освидетельствованию</p>
                        <p class="data" style="width: 40%">
                            <xsl:for-each select="ct:workExecutorRepresentative/ct:representative">
                                <xsl:value-of select="ct:lastName" />
                                <xsl:text> </xsl:text>
                                <xsl:call-template name="initials">
                                    <xsl:with-param name="NameStr" select="ct:firstName" />
                                </xsl:call-template>
                                <xsl:text> </xsl:text>
                                <xsl:call-template name="initials">
                                    <xsl:with-param name="NameStr" select="ct:middleName" />
                                </xsl:call-template>
                            </xsl:for-each>
                        </p>
                        <p class="under" style="width: 40%">(фамилия, инициалы, подпись)</p>
                    </xsl:if>
                    <xsl:if test="ct:otherRepresentativesList">
                        <p class="list">Представители иных лиц</p>
                        <xsl:for-each select="ct:otherRepresentativesList/ct:otherRepresentativesListItem">
                            <p class="data" style="width: 40%">
                                <xsl:value-of select="ct:representative/ct:lastName" /><xsl:text> </xsl:text>
                                <xsl:call-template name="initials">
                                    <xsl:with-param name="NameStr" select="ct:representative/ct:firstName" />
                                </xsl:call-template><xsl:text> </xsl:text>
                                <xsl:call-template name="initials">
                                    <xsl:with-param name="NameStr" select="ct:representative/ct:middleName" />
                                </xsl:call-template>
                            </p>
                            <p class="under" style="width: 40%">(фамилия, инициалы, подпись)</p>
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
    
    <xsl:template name="initials">
        <xsl:param name="NameStr" />
        
        <xsl:if test="$NameStr !=''">
            <xsl:variable name="i">
                <xsl:value-of select="substring($NameStr, 1, 1)" />
            </xsl:variable>
            
            <xsl:value-of select="concat($i, '.')" />
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="ct:developer">
        <h2>Застройщик</h2>
        <xsl:choose>
            <xsl:when test="ct:organization/ct:legalEntity">
                <p class="data">
                    <xsl:value-of select="ct:organization/ct:legalEntity" />
                </p>
                <p class="under">наименование, ОГРН, ИНН, место нахождения юридического лица, телефон/факс,</p>
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
                <p class="under">фамилия, имя, отчество, адрес места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
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
                        <xsl:value-of select="ct:address"/>, 
                        <xsl:if test="ct:phone">
                            <xsl:value-of select="ct:phone"/>
                        </xsl:if>
                    </xsl:for-each>
                </p>
                <p class="under">фамилия, имя, отчество, паспортные данные, адрес места жительства, телефон/факс – для физических лиц, не являющихся индивидуальными предпринимателями</p>
            </xsl:when>
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
    
    <xsl:template match="ct:technicalCustomer">
        <h2>Технический заказчик</h2>
        <xsl:choose>
            <xsl:when test="ct:organizationInfo/ct:legalEntity">
                <p class="data">
                      <xsl:for-each select="ct:organizationInfo/ct:legalEntity">
                        <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                        <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                        <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                        <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                        <xsl:if test="ct:contactInfo">
                            <xsl:for-each select="ct:contactInfo">
                                <xsl:value-of select="ct:phone"/>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:for-each>
                </p>
                <p class="under">наименование, ОГРН, ИНН, место нахождения юридического лица, телефон/факс,</p>
            </xsl:when>
            <xsl:when test="ct:organizationInfo/ct:individualEntrepreneur">
                <p class="data">
                    <xsl:for-each select="ct:organizationInfo/ct:individualEntrepreneur">
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
                <p class="under">фамилия, имя, отчество, адрес места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="ct:operatingPerson">
        <h2>Эксплуатирующая организация</h2>
        <xsl:choose>
            <xsl:when test="ct:organization/ct:legalEntity">
                <p class="data">
                    <xsl:value-of select="ct:organization/ct:legalEntity" />
                </p>
                <p class="under">наименование, ОГРН, ИНН, место нахождения юридического лица, телефон/факс,</p>
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
                <p class="under">фамилия, имя, отчество, адрес места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
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
                        <xsl:value-of select="ct:address"/>, 
                        <xsl:if test="ct:phone">
                            <xsl:value-of select="ct:phone"/>
                        </xsl:if>
                    </xsl:for-each>
                </p>
                <p class="under">фамилия, имя, отчество, паспортные данные, адрес места жительства, телефон/факс – для физических лиц, не являющихся индивидуальными предпринимателями</p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="ct:regionalOperator">
        <h2>Региональный оператор</h2>
        <xsl:choose>
            <xsl:when test="ct:organizationInfo/ct:legalEntity">
                <p class="data">
                    <xsl:for-each select="ct:organizationInfo/ct:legalEntity">
                        <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                        <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                        <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                        <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                        <xsl:if test="ct:contactInfo">
                            <xsl:for-each select="ct:contactInfo">
                                <xsl:value-of select="ct:phone"/>
                            </xsl:for-each>
                        </xsl:if>
                    </xsl:for-each>
                </p>
                <p class="under">наименование, ОГРН, ИНН, место нахождения юридического лица, телефон/факс,</p>
            </xsl:when>
            <xsl:when test="ct:organizationInfo/ct:individualEntrepreneur">
                <p class="data">
                    <xsl:for-each select="ct:organizationInfo/ct:individualEntrepreneur">
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
                <p class="under">фамилия, имя, отчество, адрес места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="ct:developerRepresentative">
        <p class="list">Представитель застройщика по вопросам строительного контроля</p>
        <p class="data">
            <xsl:value-of select="ct:representative/ct:position" /><xsl:text> </xsl:text>
            <xsl:value-of select="ct:representative/ct:lastName" /><xsl:text> </xsl:text>
            <xsl:value-of select="ct:representative/ct:firstName" />
            <xsl:if test="ct:representative/ct:middleName">
                <xsl:text> </xsl:text>
                <xsl:value-of select="ct:representative/ct:middleName" />
            </xsl:if>
            <xsl:text> </xsl:text>
            <xsl:value-of select="ct:representative/ct:specialistIdNumber" />
        </p>
        <p class="under">должность, фамилия, инициалы, идентификационный номер в национальном реестре специалистовв области строительства,</p>
        <p class="data">
            <xsl:value-of select="ct:representative/ct:administrativeDocument/ct:name" /><xsl:text> </xsl:text> 
            <xsl:value-of select="ct:representative/ct:administrativeDocument/ct:number" /> от 
            <xsl:call-template name="formatdate">
                <xsl:with-param name="DateStr" select="ct:representative/ct:administrativeDocument/ct:date" />
            </xsl:call-template>
        </p>
        <p class="under">реквизиты распорядительного документа, подтверждающего полномочия</p>
        <xsl:for-each select="ct:organization/ct:organizationInfo">
            <xsl:choose>
                <xsl:when test="ct:individualEntrepreneur">
                    <p class="data">
                        <xsl:for-each select="ct:individualEntrepreneur">
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
                    <p class="under"> с указанием фамилии, имени, отчества, адреса места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
                </xsl:when>
                <xsl:when test="ct:legalEntity">
                    <p class="data">
                        <xsl:for-each select="ct:legalEntity">
                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:contactInfo/ct:phone"/>
                        </xsl:for-each>
                    </p>
                    <p class="under">с указанием наименования, ОГРН, ИНН, места нахождения юридического лица</p>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="ct:technicalCustomerRepresentative">
        <p class="list">Представитель технического заказчика по вопросам строительного контроля</p>
        <p class="data">
            <xsl:value-of select="ct:representative/ct:position" /><xsl:text> </xsl:text>
            <xsl:value-of select="ct:representative/ct:lastName" /><xsl:text> </xsl:text>
            <xsl:value-of select="ct:representative/ct:firstName" />
            <xsl:if test="ct:representative/ct:middleName">
                <xsl:text> </xsl:text>
                <xsl:value-of select="ct:representative/ct:middleName" />
            </xsl:if>
            <xsl:text> </xsl:text>
            <xsl:value-of select="ct:representative/ct:specialistIdNumber" />
        </p>
        <p class="under">должность, фамилия, инициалы, идентификационный номер в национальном реестре специалистовв области строительства,</p>
        <p class="data">
            <xsl:value-of select="ct:representative/ct:administrativeDocument/ct:name" /><xsl:text> </xsl:text> 
            <xsl:value-of select="ct:representative/ct:administrativeDocument/ct:number" /> от 
            <xsl:call-template name="formatdate">
                <xsl:with-param name="DateStr" select="ct:representative/ct:administrativeDocument/ct:date" />
            </xsl:call-template>
        </p>
        <p class="under">реквизиты распорядительного документа, подтверждающего полномочия</p>
        <xsl:for-each select="ct:organization/ct:organizationInfo">
            <xsl:choose>
                <xsl:when test="ct:individualEntrepreneur">
                    <p class="data">
                        <xsl:for-each select="ct:individualEntrepreneur">
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
                    <p class="under"> с указанием фамилии, имени, отчества, адреса места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
                </xsl:when>
                <xsl:when test="ct:legalEntity">
                    <p class="data">
                        <xsl:for-each select="ct:legalEntity">
                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:contactInfo/ct:phone"/>
                        </xsl:for-each>
                    </p>
                    <p class="under">с указанием наименования, ОГРН, ИНН, места нахождения юридического лица</p>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="ct:operatingPersonRepresentative">
        <p class="list">Представитель эксплуатирующей организации по вопросам строительного контроля</p>
        <p class="data">
            <xsl:value-of select="ct:representative/ct:position" /><xsl:text> </xsl:text>
            <xsl:value-of select="ct:representative/ct:lastName" /><xsl:text> </xsl:text>
            <xsl:value-of select="ct:representative/ct:firstName" />
            <xsl:if test="ct:representative/ct:middleName">
                <xsl:text> </xsl:text>
                <xsl:value-of select="ct:representative/ct:middleName" />
            </xsl:if>
            <xsl:text> </xsl:text>
            <xsl:value-of select="ct:representative/ct:specialistIdNumber" />
        </p>
        <p class="under">должность, фамилия, инициалы, идентификационный номер в национальном реестре специалистовв области строительства,</p>
        <p class="data">
            <xsl:value-of select="ct:representative/ct:administrativeDocument/ct:name" /><xsl:text> </xsl:text> 
            <xsl:value-of select="ct:representative/ct:administrativeDocument/ct:number" /> от 
            <xsl:call-template name="formatdate">
                <xsl:with-param name="DateStr" select="ct:representative/ct:administrativeDocument/ct:date" />
            </xsl:call-template>
        </p>
        <p class="under">реквизиты распорядительного документа, подтверждающего полномочия</p>
        <xsl:for-each select="ct:organization/ct:organizationInfo">
            <xsl:choose>
                <xsl:when test="ct:individualEntrepreneur">
                    <p class="data">
                        <xsl:for-each select="ct:individualEntrepreneur">
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
                    <p class="under"> с указанием фамилии, имени, отчества, адреса места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
                </xsl:when>
                <xsl:when test="ct:legalEntity">
                    <p class="data">
                        <xsl:for-each select="ct:legalEntity">
                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:contactInfo/ct:phone"/>
                        </xsl:for-each>
                    </p>
                    <p class="under">с указанием наименования, ОГРН, ИНН, места нахождения юридического лица</p>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="ct:regionalOperatorRepresentative">
        <p class="list">Представитель регионального оператора по вопросам строительного контроля</p>
        <p class="data">
            <xsl:value-of select="ct:representative/ct:position" /><xsl:text> </xsl:text>
            <xsl:value-of select="ct:representative/ct:lastName" /><xsl:text> </xsl:text>
            <xsl:value-of select="ct:representative/ct:firstName" />
            <xsl:if test="ct:representative/ct:middleName">
                <xsl:text> </xsl:text>
                <xsl:value-of select="ct:representative/ct:middleName" />
            </xsl:if>
            <xsl:text> </xsl:text>
            <xsl:value-of select="ct:representative/ct:specialistIdNumber" />
        </p>
        <p class="under">должность, фамилия, инициалы, идентификационный номер в национальном реестре специалистовв области строительства,</p>
        <p class="data">
            <xsl:value-of select="ct:representative/ct:administrativeDocument/ct:name" /><xsl:text> </xsl:text> 
            <xsl:value-of select="ct:representative/ct:administrativeDocument/ct:number" /> от 
            <xsl:call-template name="formatdate">
                <xsl:with-param name="DateStr" select="ct:representative/ct:administrativeDocument/ct:date" />
            </xsl:call-template>
        </p>
        <p class="under">реквизиты распорядительного документа, подтверждающего полномочия</p>
        <xsl:for-each select="ct:organization/ct:organizationInfo">
            <xsl:choose>
                <xsl:when test="ct:individualEntrepreneur">
                    <p class="data">
                        <xsl:for-each select="ct:individualEntrepreneur">
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
                    <p class="under"> с указанием фамилии, имени, отчества, адреса места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
                </xsl:when>
                <xsl:when test="ct:legalEntity">
                    <p class="data">
                        <xsl:for-each select="ct:legalEntity">
                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:contactInfo/ct:phone"/>
                        </xsl:for-each>
                    </p>
                    <p class="under">с указанием наименования, ОГРН, ИНН, места нахождения юридического лица</p>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>
</xsl:stylesheet>