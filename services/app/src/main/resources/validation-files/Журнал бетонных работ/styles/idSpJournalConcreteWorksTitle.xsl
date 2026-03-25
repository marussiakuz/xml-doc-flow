<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://v_17_0/types/CommonTypes.xsd"
    xmlns:cf="http://v_17_0/idJournals/idSpJournalConcreteWorksTitle.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />
    <xsl:param name="version" select="1.0"/>

    <xsl:template match="/">
        <xsl:apply-templates select="/cf:idSpJournalConcreteWorksTitle" />
    </xsl:template>
    
    <xsl:template match="/cf:idSpJournalConcreteWorksTitle">      
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
                        font-size: 12pt;
                    }
                    .pagebreak {
                        page-break-before: always;
                    }
                    .str {
                        display: flex;
                        flex-wrap: wrap; 
                    }    
                </style>
            </head>
            <title>Журнал бетонных работ</title>
            <body>
                <xsl:for-each select="cf:customerControlSignedPart">
                    <xsl:for-each select="cf:buildingContractorSignedPart">
                        <h1>
                            Журнал бетонных работ 
                            <xsl:if test="cf:journalRequisites/ct:number">
                                № <xsl:value-of select="cf:journalRequisites/ct:number"/>
                            </xsl:if> 
                        </h1>
                        <xsl:for-each select="cf:participantBuildingContractor/ct:organizationInfo">
                            <div class="str">
                                <p class="list"><b>Организация </b></p>
                                <p class="data">
                                    <xsl:choose>
                                        <xsl:when test="ct:legalEntity">
                                            <xsl:for-each select="ct:legalEntity">
                                                <xsl:value-of select="ct:name"/>
                                                <xsl:text> ИНН: </xsl:text><xsl:value-of select="ct:inn"/>
                                                <xsl:text> ОГРН: </xsl:text><xsl:value-of select="ct:ogrn"/>
                                            </xsl:for-each>
                                        </xsl:when>
                                        <xsl:when test="ct:individualEntrepreneur">
                                            <xsl:for-each select="ct:individualEntrepreneur">
                                                <xsl:call-template name="nameTempl">
                                                    <xsl:with-param name="Person" select="." />
                                                </xsl:call-template>
                                                <xsl:text> ИНН: </xsl:text><xsl:value-of select="ct:inn"/>
                                                <xsl:text> ОГРНИП: </xsl:text><xsl:value-of select="ct:ogrnip"/>
                                            </xsl:for-each>
                                        </xsl:when>
                                    </xsl:choose>
                                </p>
                            </div>
                        </xsl:for-each>
                        <xsl:for-each select="cf:permanentObjectInfo">
                            <div class="str">
                                <p class="list"><b>Наименование объекта </b></p>
                                <p class="data">
                                    <xsl:value-of select="ct:permanentObjectName"/>
                                </p>
                            </div>
                            <div class="str">
                                <p class="list">Адрес </p>
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
                        </xsl:for-each><br/><br/>
                        <xsl:for-each select="cf:projectInfo">
                            <h2>Проектные данные:</h2>
                            <p class="list">1. Класс бетона по прочности на сжатие конструктивных элементов</p>
                            <xsl:for-each select="cf:concreteStrengthGradeList/cf:concreteStrengthGrade">
                                <p class="data">   
                                    <xsl:value-of select="cf:structuralElement"/><xsl:text> </xsl:text>
                                    <xsl:value-of select="cf:concreteClass"/>
                                </p>
                            </xsl:for-each><br/>
                            <div class="str">
                                <p class="list">2. Объем бетона общий </p>
                                <p class="data">
                                    <xsl:for-each select="cf:concreteVolume">
                                        <xsl:value-of select="ct:value"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:unit"/>
                                    </xsl:for-each>
                                </p>
                            </div>
                            <div class="str">
                                <p class="list">Объем бетона неармированного </p>
                                <p class="data">
                                    <xsl:for-each select="cf:unreinforcedConcreteVolume">
                                        <xsl:value-of select="ct:value"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:unit"/>
                                    </xsl:for-each>
                                </p>
                            </div>
                            <div class="str">
                                <p class="list">Объем бетона армированного </p>
                                <p class="data">
                                    <xsl:for-each select="cf:reinforcedConcreteVolume">
                                        <xsl:value-of select="ct:value"/>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:unit"/>
                                    </xsl:for-each>
                                </p>
                            </div>
                        </xsl:for-each>                                                
                        <xsl:for-each select="cf:representativeBuildingContractor">
                            <div class="str">
                                <p class="list">Производитель работ </p>
                                <p class="data">
                                    <xsl:call-template name="nameTempl">
                                        <xsl:with-param name="Person" select="." />
                                    </xsl:call-template>
                                </p>
                            </div>
                        </xsl:for-each>
                        <div class="str">
                            <p class="list">Ведение журнала: начало </p>
                            <p class="data">
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="cf:journalLogStartDate" />
                                </xsl:call-template>
                            </p>
                        </div>
                        <br/>
                        <xsl:if test="../cf:representativeBuildingContractorSignature">
                            <xsl:for-each select="cf:representativeBuildingContractor">
                                <div style="display: flex; justify-content: space-between; align-items:baseline ; width: 100%; gap:3em">
                                    <div style="flex: 3;">
                                        <p class="data">
                                            <xsl:value-of select="ct:position"/></p>
                                        <p class="under">(должность уполномоченного представителя лица, осуществляющего строительство)</p>
                                    </div>
                                    <div style="flex: 1;">
                                        <p class="data"><br/></p>
                                        <p class="under" >(подпись)</p> 
                                    </div>
                                    <div style="flex: 2;">
                                        <p class="data">
                                            <xsl:call-template name="nameTempl">
                                                <xsl:with-param name="Person" select="." />
                                            </xsl:call-template>
                                        </p>
                                        <p class="under" >(расшифровка подписи)</p> 
                                    </div>
                                </div>
                            </xsl:for-each>
                        </xsl:if>
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
    
    <xsl:template name="contactInfo">
        <xsl:value-of select="ct:phone"/>
        <xsl:text> </xsl:text>
        <xsl:value-of select="ct:email"/>
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