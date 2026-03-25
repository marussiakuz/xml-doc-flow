<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://v_17_0/types/CommonTypes.xsd"
    xmlns:cf="http://v_17_0/idJournals/idSpJournalDesignerControl.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />
    <xsl:param name="version" select="'1.1'"/>

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:idSpJournalDesignerControl" />

    </xsl:template>

    <xsl:template match="/cf:idSpJournalDesignerControl">


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
                    display: block;
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

                    flex-grow: 1; 
                    align-content: end;
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
                    width: 90%;
                    border: 1px solid #000000;
                    margin: 5px auto;
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
                    .str {
                    display: flex;
                    flex-wrap: wrap;
                    gap: 10pt;
                    }
                </style>
            </head>
            <title>idSpJournalDesignerControl</title>
            <body>
                <h1>
                    ПЕРЕЧЕНЬ ПОДРЯДНЫХ ОРГАНИЗАЦИЙ, ОСУЩЕСТВЛЯЮЩИХ СТРОИТЕЛЬНЫЕ И МОНТАЖНЫЕ РАБОТЫ
                </h1>
                <br/>
                <xsl:for-each select="cf:designerControlSignedPart">
                    <xsl:for-each select="cf:participantBuildingContractor">
                        <p class="list">Исполнитель работ (лицо, осуществляющее строительство)</p>
                        <p class="data">
                            <xsl:call-template name="orgTempl">
                                <xsl:with-param name="Org" select="cf:participantBuildingContractor" />
                            </xsl:call-template>
                        </p>
                    </xsl:for-each>
                    <br/>
                    <xsl:for-each select="cf:participantWorkExecutorAndWorksList">
                        <p class="list">Исполнители отдельных видов работ (подрядчики):</p>
                        <xsl:choose>
                            <xsl:when test="count(cf:participantWorkExecutorAndWorks)&#62;1">
                                <xsl:for-each select="cf:participantWorkExecutorAndWorks">
                                    <div class="str">
                                        <p class="list"><xsl:value-of select="position()"/></p>
                                        <p class="data">
                                            <xsl:for-each select="cf:workDescriptionList/cf:workDescription">
                                                <xsl:value-of select="."/>
                                                <xsl:choose>
                                                    <xsl:when test="position() != last()">
                                                        <xsl:text>, </xsl:text>
                                                    </xsl:when>
                                                    <xsl:otherwise>
                                                        <xsl:text> &#8212; </xsl:text>
                                                    </xsl:otherwise>
                                                </xsl:choose>                                                                                          
                                            </xsl:for-each>
                                            <xsl:for-each select="cf:participantWorkExecutor">
                                                <xsl:call-template name="orgTempl">
                                                    <xsl:with-param name="Org" select="cf:participantWorkExecutor" />
                                                </xsl:call-template>
                                            </xsl:for-each>
                                        </p>
                                    </div>
                                    <xsl:if test="position() = 1">
                                        <p class="under">(наименования работ и организации)</p>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:when>
                            <xsl:when test="count(cf:participantWorkExecutorAndWorks) = 1">
                                <xsl:for-each select="cf:participantWorkExecutorAndWorks">
                                    <p class="data">
                                        <xsl:for-each select="cf:workDescriptionList/cf:workDescription">
                                            <xsl:value-of select="."/>
                                            <xsl:choose>
                                                <xsl:when test="position() != last()">
                                                    <xsl:text>, </xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text> &#8212; </xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>                                                                                          
                                        </xsl:for-each>
                                        <xsl:for-each select="cf:participantWorkExecutor">
                                            <xsl:call-template name="orgTempl">
                                                    <xsl:with-param name="Org" select="cf:participantWorkExecutor" />
                                                </xsl:call-template>  
                                        </xsl:for-each>
                                    </p>
                                    <p class="under">(наименования работ и организации)</p>
                                </xsl:for-each>
                            </xsl:when> 
                        </xsl:choose>
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
                                <xsl:text> ОГРНИП: </xsl:text><xsl:value-of select="ct:ogrnip"/>
                                <xsl:text> </xsl:text>
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
                </xsl:for-each>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>