<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://v_17_0/types/CommonTypes.xsd"
    xmlns:cf="http://v_17_0/an/idSpJournalDesignerControlResultRecord.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />
    <xsl:param name="version" select="'1.1'"/>

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:idSpJournalDesignerControlResultRecord" />

    </xsl:template>

    <xsl:template match="/cf:idSpJournalDesignerControlResultRecord">


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
                    padding: 4;
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
                    table {
                    border-collapse:collapse; 
                    width:100%;
                    word-wrap: break-word;
                    }
                    th {
                    vertical-align: top;
                    padding: 4; 
                    }
                </style>
            </head>
            <title>idSpJournalDesignerControlResultRecord</title>
            <body>
               
                <h1>
                    УЧЕТНЫЙ ЛИСТ №2
                </h1>
               <br/>
                <table border="1" style="border-collapse:collapse; width:100%">
                    <tr>
                        <th> Дата </th>
                        <th> Результат участия в освидетельствовании работ (наличие/отсутствие нарушений требований проектной документации) </th>
                        <th> Выявление несоответствия рабочей документации проектной документации  </th>
                        <th> Согласованная с застройщиком (техническим заказчиком) дата устранения нарушений проектной документации </th>
                    </tr>
                    <tr>
                        <th> 1 </th>
                        <th> 2 </th>
                        <th> 3 </th>
                        <th> 4 </th>
                    </tr>
                    <tr>
                        <xsl:choose>
                            <!-- Нарушение требования -->
                            <xsl:when test="cf:violationInfo">
                                <xsl:for-each select="cf:violationInfo">
                                    <xsl:for-each select="cf:recordCancelSignedPart">
                                        <xsl:for-each select="cf:customerSignedPart">
                                            <xsl:for-each select="cf:designerControlSignedPart">
                                                <!-- !Дата внесения записи о нарушении -->
                                                <td class="data">
                                                    <xsl:call-template name="formatdate">
                                                        <xsl:with-param name="DateStr" select="cf:violationDate"/>
                                                    </xsl:call-template> 
                                                </td>
                                                <!-- !Нарушение требования проектной документации -->
                                                <xsl:for-each select="cf:violationDetails">
                                                    <td class="data">
                                                        <xsl:value-of select="cf:violationDescription"/>
                                                        <xsl:choose>
                                                            <xsl:when test="cf:variantRequiredProjDocSectionList">
                                                                <xsl:for-each select="cf:variantRequiredProjDocSectionList">
                                                                    <xsl:for-each select="cf:projDocSectionList/ct:projDocSection">
                                                                        <br/>
                                                                        <xsl:value-of select="ct:documentationName"/><xsl:text> </xsl:text>
                                                                        <xsl:value-of select="ct:documentationCode"/>
                                                                    </xsl:for-each>
                                                                    <xsl:for-each select="cf:regulationDocumentsList/ct:regulationDocument">
                                                                        <br/>
                                                                        <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                                        <xsl:value-of select="ct:number"/>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                            <xsl:when test="cf:variantRequiredRegulationDocumentsList">
                                                                <xsl:for-each select="cf:variantRequiredRegulationDocumentsList">
                                                                    <xsl:for-each select="cf:regulationDocumentsList/ct:regulationDocument">
                                                                        <br/>
                                                                        <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                                        <xsl:value-of select="ct:number"/>
                                                                    </xsl:for-each>
                                                                </xsl:for-each>
                                                            </xsl:when>
                                                        </xsl:choose>
                                                    </td>
                                                    <!-- !Выявление несоответствия рабочей документации проектной документации -->
                                                    <td class="data">
                                                        <xsl:if test="cf:workDocSectionList">
                                                            <xsl:for-each select="cf:workDocSectionList/ct:workDocSection">
                                                                <xsl:value-of select="ct:documentationName"/><xsl:text> </xsl:text>
                                                                <xsl:value-of select="ct:documentationCode"/>
                                                                <br/>
                                                            </xsl:for-each>
                                                        </xsl:if>
                                                    </td>
                                                </xsl:for-each>
                                            </xsl:for-each>
                                            <!-- !Дата устранения выявленного нарушения -->
                                            <td class="data">
                                                <xsl:if test="cf:violationFixCustomerPlanDate">
                                                    <xsl:call-template name="formatdate">
                                                        <xsl:with-param name="DateStr" select="cf:violationFixCustomerPlanDate"/>
                                                    </xsl:call-template>
                                                </xsl:if>
                                                <!-- !Аннулирование записи -->
                                                <xsl:if test="../../cf:representativeCancelSignature">
                                                    <br/>
                                                    <b>Запись аннулирована
                                                    <br/>
                                                    <xsl:for-each select="../cf:recordCancelInfo">
                                                        <xsl:call-template name="nameTempl">
                                                            <xsl:with-param name="Person" select="ct:representativeCancel"/>
                                                        </xsl:call-template>
                                                        <xsl:text> </xsl:text>
                                                        <xsl:value-of select="ct:position"/>
                                                        <br/>
                                                        <xsl:call-template name="formatdatetime">
                                                            <xsl:with-param name="DateTimeStr" select="ct:recordCancelDateTime"/>
                                                        </xsl:call-template>
                                                    </xsl:for-each>
                                                    </b>
                                                </xsl:if>
                                            </td>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:when>
                            <!-- Отсутствие нарушений  -->
                            <xsl:when test="cf:noViolationInfo">
                                <xsl:for-each select="cf:noViolationInfo">
                                    <xsl:for-each select="cf:recordCancelSignedPart">
                                        <xsl:for-each select="cf:designerControlSignedPart">
                                            <!-- Дата внесения записи об отсутствии нарушений -->
                                            <td class="data">
                                                <xsl:call-template name="formatdate">
                                                    <xsl:with-param name="DateStr" select="cf:noViolationDate"/>
                                                </xsl:call-template>
                                            </td>
                                            <!-- !Нарушения отсутствуют -->
                                            <td class="data">
                                                <xsl:value-of select="cf:noViolation"/>
                                            </td>
                                            <td class="data"/>
                                        </xsl:for-each>
                                        <!-- !Аннулирование записи -->
                                        <td class="data">
                                            <xsl:if test="../cf:representativeCancelSignature">
                                                <b>Запись аннулирована
                                                <br/>
                                                <xsl:for-each select="cf:recordCancelInfo">
                                                    <xsl:call-template name="nameTempl">
                                                        <xsl:with-param name="Person" select="ct:representativeCancel"/>
                                                    </xsl:call-template>
                                                    <xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:position"/>
                                                    <br/>
                                                    <xsl:call-template name="formatdatetime">
                                                        <xsl:with-param name="DateTimeStr" select="ct:recordCancelDateTime"/>
                                                    </xsl:call-template>
                                                </xsl:for-each>
                                                </b>
                                            </xsl:if>
                                        </td>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                    </tr>
                </table>
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
   
</xsl:stylesheet>