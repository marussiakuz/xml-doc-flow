<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://v_17_0/types/CommonTypes.xsd"
    xmlns:cf="http://v_17_0/an/idSpJournalDesignerControlTitle.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />
    <xsl:param name="version" select="'1.1'"/>

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:idSpJournalDesignerControlTitle" />

    </xsl:template>

    <xsl:template match="/cf:idSpJournalDesignerControlTitle">


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
                        margin-top: 1.5em;
                        text-align: justify;
                        
                    }
                    body {
                        font-family: Times New Roman;
                        font-size: 14pt;
                        padding: 20px;
                        margin: 0 auto;
                        max-width:1200
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
                    
                    .under {
                    line-height: 0.9em;
                    margin:0cm;
                    margin-bottom:.0001pt;
                    text-autospace:none;
                    font-size:10.0pt;
                    font-family:"Times New Roman",serif;
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

                        flex-grow: 1; 
                        align-content: end;
                    }
                    .list {
                        font-size: 12pt;
                    }
                    .pagebreak {
                        page-break-before: always;
                    }
                    .str {
                        display: flex;
                        flex-wrap: wrap;
                    }
                    .signs {
                        display: flex; 
                        width: 100%; 
                        justify-content: space-between; 
                        align-items: basline; 
                        gap: 2em;
                    }
                    @media (max-width: 843px) {
                        .signs {
                            align-items: end; 
                        }
                    }

                </style>
            </head>
            <title>idSpJournalDesignerControlTitle</title>
            <body>
                <xsl:for-each select="cf:customerSignedPart">
                    <xsl:for-each select="cf:designerControlSignedPart">
                        <h1>
                            ЖУРНАЛ АВТОРСКОГО НАДЗОРА 
                            <xsl:if test="cf:journalRequisites/ct:number">
                                № <xsl:value-of select="cf:journalRequisites/ct:number"/>
                            </xsl:if>
                        </h1>
                        <xsl:for-each select="cf:permanentObjectInfo">
                            <div class="str">
                                <p class="list">Наименование объекта капитального строительства </p>
                                <p class="data">
                                    <xsl:value-of select="ct:permanentObjectName"/>
                                </p>
                            </div>
                            <div class="str">
                                <p class="list">Адрес строительства</p>
                                <p class="data">
                                    <xsl:for-each select="ct:permanentObjectAddress">
                                        <xsl:choose>
                                            <xsl:when test="ct:postalAddress">
                                                <xsl:for-each select="ct:postalAddress">
                                                    <xsl:call-template name="postalAddress"/>
                                                </xsl:for-each>
                                            </xsl:when>
                                            <xsl:when test="ct:constructionSiteAddress">
                                                <xsl:for-each select="ct:constructionSiteAddress">
                                                    <xsl:call-template name="constructionSiteAddress"/>
                                                </xsl:for-each>
                                            </xsl:when>
                                        </xsl:choose>
                                    </xsl:for-each>
                                </p>
                            </div>
                        </xsl:for-each>
                        <br/>
                        <xsl:choose>
                            <!-- Застройщик -->
                            <xsl:when test="cf:participantDeveloper">
                                <div class="str">
                                    <p class="list">Застройщик </p>
                                    <xsl:for-each select="cf:participantDeveloper">
                                        <p class="data">
                                            <xsl:call-template name="orgTempl">
                                                <xsl:with-param name="Org" select="cf:participantDeveloper" />
                                            </xsl:call-template>
                                        </p>
                                    </xsl:for-each>
                                </div>
                                <p class="under">(наименование, адрес)</p>
                            </xsl:when>
                            <!-- Технический заказчик -->
                            <xsl:when test="cf:participantTechnicalCustomer">
                                <div class="str">
                                    <p class="list">Технический заказчик </p>
                                    <xsl:for-each select="cf:participantTechnicalCustomer">
                                        <p class="data">
                                            <xsl:call-template name="orgTempl">
                                                <xsl:with-param name="Org" select="cf:participantTechnicalCustomer" />
                                            </xsl:call-template>
                                        </p>
                                    </xsl:for-each>
                                </div>
                                <p class="under">(наименование, адрес)</p>
                            </xsl:when>
                            <!-- Лицо, ответственное за эксплуатацию здания, сооружения -->
                            <xsl:when test="cf:participantBuildingOperator">
                                <div class="str">
                                    <p class="list">Лицо, ответственное за эксплуатацию здания, сооружения </p>
                                    <xsl:for-each select="cf:participantBuildingOperator">
                                        <p class="data">
                                            <xsl:call-template name="orgTempl">
                                                <xsl:with-param name="Org" select="cf:participantBuildingOperator" />
                                            </xsl:call-template>
                                        </p>
                                    </xsl:for-each>
                                </div>
                                <p class="under">(наименование, адрес)</p>
                            </xsl:when>
                            <!-- Региональный оператор -->
                            <xsl:when test="cf:participantRegionalBuildingOperator">
                                <div class="str">
                                    <p class="list">Региональный оператор </p>
                                    <xsl:for-each select="cf:participantRegionalBuildingOperator">
                                        <p class="data">
                                            <xsl:call-template name="orgTempl">
                                                <xsl:with-param name="Org" select="cf:participantRegionalBuildingOperator" />
                                            </xsl:call-template>
                                        </p>
                                    </xsl:for-each>
                                </div>
                                <p class="under">(наименование, адрес)</p>
                            </xsl:when>
                        </xsl:choose>
                        <!-- Лицо, осуществляющее авторский надзор -->
                        <xsl:for-each select="cf:participantDesignerControl">
                            <p class="list">Лицо, осуществляющее авторский надзор </p>
                            <p class="data">
                                <xsl:call-template name="orgTempl">
                                    <xsl:with-param name="Org" select="cf:participantDesignerControl" />
                                </xsl:call-template>
                            </p>
                            <p class="under">(наименование организации, Ф.И.О. индивидуального предпринимателя, адрес)</p>
                        </xsl:for-each>
                        <!-- Журнал начат -->
                        <div class="str" style="width: 50%">
                            <p class="list">Журнал начат </p>
                            <p class="data">
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="cf:journalLogStartDate" />
                                </xsl:call-template>
                            </p>
                        </div>
                        <br/>
                    </xsl:for-each>
                    <!-- Лицо, осуществляющее авторский надзор -->
                    <xsl:if test="cf:representativeDesignerControlSignature">
                        <div class="signs">
                            <p class="list" style='flex:2; margin-bottom: 13px;'>Лицо, осуществляющее авторский надзор</p>
                            <div style=" flex: 1;">
                                <p class="data" >
                                    <xsl:for-each select="cf:designerControlSignedPart/cf:representativeDesignerControl">
                                        <xsl:call-template name="nameTempl">
                                            <xsl:with-param name="Person" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </p>
                                <p class="under">(подпись)</p>
                            </div>
                        </div><br/><br/>
                    </xsl:if>
                    
                </xsl:for-each>
                <!-- Руководитель застройщика -->
                <xsl:if test="cf:representativeDeveloperSignature or cf:representativeTechnicalCustomerSignature or cf:representativeBuildingOperatorSignature or cf:representativeBuildingOperatorSignature">
                    <div class="signs">
                        <xsl:if test="cf:representativeDeveloperSignature">
                            <p class="list" style='flex:2; margin-bottom: 13px;'>Руководитель застройщика</p>
                            <div style=" flex: 1;">
                                <p class="data" >
                                    <xsl:for-each select="cf:customerSignedPart/cf:representativeDeveloper">
                                        <xsl:call-template name="nameTempl">
                                            <xsl:with-param name="Person" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </p>
                                <p class="under">(подпись)</p>
                            </div>
                        </xsl:if>
                        <!-- Руководитель технического заказчика -->
                        <xsl:if test="cf:representativeTechnicalCustomerSignature">
                            <p class="list" style='flex:2; margin-bottom: 13px;'>Руководитель технического заказчика</p>
                            <div style=" flex: 1;">
                                <p class="data">
                                    <xsl:for-each select="cf:customerSignedPart/cf:representativeTechnicalCustomer">
                                        <xsl:call-template name="nameTempl">
                                            <xsl:with-param name="Person" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </p>
                                <p class="under">(подпись)</p>
                            </div>
                        </xsl:if>
                        <!-- Руководитель лица, ответственного за эксплуатацию здания, сооружения -->
                        <xsl:if test="cf:representativeBuildingOperatorSignature">
                            <p class="list" style='flex:2; margin-bottom: 13px;'>Руководитель лица, ответственного за эксплуатацию здания, сооружения</p>
                            <div style=" flex: 1;">
                                <p class="data" >
                                    <xsl:for-each select="cf:customerSignedPart/cf:representativeBuildingOperator">
                                        <xsl:call-template name="nameTempl">
                                            <xsl:with-param name="Person" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </p>
                                <p class="under">(подпись)</p>
                            </div>
                        </xsl:if>
                        <!-- Руководитель регионального оператора -->
                        <xsl:if test="cf:representativeRegionalBuildingOperatorSignature">
                            <p class="list" style='flex:2; margin-bottom: 13px;'>Руководитель регионального оператора</p>
                            <div style=" flex: 1;">
                                <p class="data" >
                                    <xsl:for-each select="cf:customerSignedPart/cf:representativeRegionalBuildingOperator">
                                        <xsl:call-template name="nameTempl">
                                            <xsl:with-param name="Person" select="." />
                                        </xsl:call-template>
                                    </xsl:for-each>
                                </p>
                                <p class="under">(подпись)</p>
                            </div>
                        </xsl:if>
                    </div>
                </xsl:if>
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
    <xsl:template name="orgTempl">
        <xsl:param name="Org"/>
        <xsl:choose>
            <xsl:when test="ct:organization">
                <xsl:for-each select="ct:organization">
                    <xsl:choose>
                        <xsl:when test="ct:legalEntity">
                            <xsl:for-each select="ct:legalEntity">
                                <xsl:value-of select="ct:name"/>
                                <xsl:text> ИНН: </xsl:text><xsl:value-of select="ct:inn"/>
                                <xsl:text> ОГРН: </xsl:text><xsl:value-of select="ct:ogrn"/>
                                <xsl:text> </xsl:text>
                                <xsl:for-each select="ct:address">
                                    <xsl:call-template name="postalAddress"/>
                                </xsl:for-each>
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
                                <xsl:text> ИНН: </xsl:text><xsl:value-of select="ct:inn"/>
                                <xsl:text> ОГРНИП: </xsl:text><xsl:value-of select="ct:ogrnip"/><xsl:text> </xsl:text>
                                <xsl:for-each select="ct:address">
                                    <xsl:call-template name="postalAddress"/>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="ct:organizationInfo">
                <xsl:for-each select="ct:organizationInfo">
                    <xsl:choose>
                        <xsl:when test="ct:legalEntity">
                            <xsl:for-each select="ct:legalEntity">
                                <xsl:value-of select="ct:name"/>
                                <xsl:text> ИНН: </xsl:text><xsl:value-of select="ct:inn"/>
                                <xsl:text> ОГРН: </xsl:text><xsl:value-of select="ct:ogrn"/>
                                <xsl:for-each select="ct:address">
                                    <xsl:call-template name="postalAddress"/>
                                </xsl:for-each>
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
                                <xsl:text> ИНН: </xsl:text><xsl:value-of select="ct:inn"/>
                                <xsl:text> ОГРНИП: </xsl:text><xsl:value-of select="ct:ogrnip"/><xsl:text> </xsl:text>
                                <xsl:for-each select="ct:address">
                                    <xsl:call-template name="postalAddress"/>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:when>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:when>
            <xsl:when test="ct:individual">
                <xsl:for-each select="ct:individual">
                    <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                    <xsl:value-of select="ct:firstName"/>
                    <xsl:if test="ct:middleName">
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="ct:middleName"/>
                    </xsl:if>
                    <xsl:text> </xsl:text>
                    <xsl:apply-templates select="ct:passportDetails" />
                    <xsl:text> </xsl:text>
                    <xsl:for-each select="ct:address">
                        <xsl:call-template name="postalAddress"/>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
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
        <xsl:for-each select="ct:entitysOfFederationList/ct:entitysOfFederationListItem">
            <xsl:value-of select="."/><xsl:text> </xsl:text>
        </xsl:for-each>
        <xsl:for-each select="ct:districtOrRegionCodeList/ct:districtOrRegionCodeListItem">
            <xsl:value-of select="."/><xsl:text> </xsl:text>
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
</xsl:stylesheet>