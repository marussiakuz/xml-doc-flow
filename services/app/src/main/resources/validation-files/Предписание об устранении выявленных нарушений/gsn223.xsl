<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://types/CommonTypes.xsd"
    xmlns:cf="http://gsn/gsn223.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:gsn223" />

    </xsl:template>

    <xsl:template match="/cf:gsn223">

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
                    
                    .refusal-table {
                    width: 35%; 
                    border: double #0099ff;
                    }
                    
                    .refusal-th {
                    color: #0099ff; 
                    margin: 10px 0; 
                    padding: 10px;
                    }
                    
                    .emailSendingInfo {
                    margin: 5px auto;
                    border: 2px solid #000000;
                    border-collapse:collapse;
                    width: 90%
                    }
                </style>
            </head>
            <title>gsn223</title>
            <body>
                <xsl:for-each select="cf:controlledPersonSignedPart/cf:gsnInfo">
                    <xsl:for-each select="cf:orderRequisites">
                        <h1>
                            ПРЕДПИСАНИЕ №
                            <span>
                                <i>
                                    <xsl:value-of select="cf:documentDetails/ct:number"/>
                                </i>
                            </span><br/>
                            ОБ УСТРАНЕНИИ ВЫЯВЛЕННЫХ НАРУШЕНИЙ ОБЯЗАТЕЛЬНЫХ <br/>
                            ТРЕБОВАНИЙ ПРИ СТРОИТЕЛЬСТВЕ,<br/>
                            РЕКОНСТРУКЦИИ ОБЪЕКТА КАПИТАЛЬНОГО СТРОИТЕЛЬСТВА
                        </h1>
                        <div style="width: 100%; font-size: 10pt; text-align: right">
                            <i>
                                <u>
                                    <xsl:if test="cf:compilationPlace">
                                        <span style="float: left">
                                            <u>
                                                <xsl:value-of select="cf:compilationPlace"/>
                                            </u>
                                        </span>
                                    </xsl:if>
                                    <xsl:call-template name="formatdate">
                                        <xsl:with-param name="DateStr" select="cf:documentDetails/ct:date" />
                                    </xsl:call-template>  
                                </u>
                            </i>
                        </div>
                        <br/>
                    </xsl:for-each>
                    <xsl:for-each select="cf:orderInfo">
                        <p class="list">
                            Выдано
                        </p>
                        <xsl:apply-templates select="cf:controlledPerson" />
                        <p class="list">
                            в отношении 
                            <xsl:call-template name="activityType">
                                <xsl:with-param name="type" select="cf:activityType" />
                            </xsl:call-template>
                            объекта капитального строительства
                        </p>
                        <xsl:for-each select="cf:permanentObjectInfoWithDesignParameters">
                            <p class="data">
                                <xsl:value-of select="ct:permanentObjectName"/><xsl:text> </xsl:text>
                            </p>
                            <xsl:apply-templates select="cf:designParameters" />
                            <p class="under">
                                (наименование объекта капитального строительства 
                                в соответствии с разрешением
                                на строительство, краткие проектные характеристики
                                описание этапа строительства, реконструкции, если 
                                разрешение выдано на этап строительства, реконструкции)
                            </p>
                            <p class="list">
                                расположенного по адресу
                            </p>
                            <p class="data">
                                <xsl:value-of select="ct:permanentObjectAddress"/>
                            </p>
                        </xsl:for-each>
                        <br/>
                        <p class="list">
                            по результатам проведения контрольного (надзорного) 
                            мероприятия на основании решения от
                            <span class="data">
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="cf:controlEventDecision/ct:date" />
                                </xsl:call-template> 
                            </span>
                            №
                            <span class="data">
                                <xsl:value-of select="cf:controlEventDecision/ct:number"/>
                            </span>
                            составлен акт контрольного (надзорного) мероприятия от
                            <span class="data">
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="cf:controlEventAct/ct:date" />
                                </xsl:call-template>
                            </span>
                            №
                            <span class="data">
                                <xsl:value-of select="cf:controlEventAct/ct:number"/>
                            </span>
                            установлено, что индивидуальным предпринимателем, юридическим лицом
                        </p>
                        <xsl:for-each select="cf:controlledPersonName">
                            <p class="data">
                                <xsl:choose>
                                    <xsl:when test="cf:fullPersonName">
                                        <xsl:for-each select="cf:fullPersonName">
                                            <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:firstName"/>
                                            <xsl:if test="ct:middleName">
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:middleName"/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="cf:organizationName"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </p>
                        </xsl:for-each>
                        <p class="under">
                            (наименование застройщика, технического заказчика, 
                            лица, осуществляющего строительство (в зависимости 
                            от того, кто допустил нарушения)
                        </p>
                        <p class="list">
                            допущены и предписываются к 
                            устранению следующие нарушения:
                        </p>
                        <br/>
                        <table border="1" style="border-collapse:collapse">
                            <tr>
                                <td valign="top" align="center"> № п/п </td>
                                <td valign="top" align="center"> Описание и характер выявленных нарушений обязательных требований</td>
                                <td valign="top" align="center"> Ссылки на статьи (пункты, части статей) нормативных правовых актов, 
                                    листы (страницы) проектной документации, содержащие обязательные требования, которые нарушены</td>
                                <td valign="top" align="center"> Срок устранения выявленного нарушения </td>
                            </tr>
                            <xsl:for-each select="cf:detectedViolationsList/cf:detectedViolationsListItem">
                                <tr>
                                    <td class="data" style="width: 7%">
                                        <xsl:value-of select="cf:violationNumber"/>
                                    </td>
                                    <td class="data" style="width: 25%">
                                        <xsl:value-of select="cf:violationDescription/cf:violationDescriptionText"/>
                                    </td>
                                    <td class="data" style="width: 50%">
                                        <xsl:for-each select="cf:violationDescription/cf:technicalRegulationsList/cf:technicalRegulationsListItem">
                                            <table>
                                                <tr>
                                                    <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:number"/><xsl:text>; </xsl:text>
                                                    <xsl:if test="cf:technicalRegulationsSectionsList/cf:technicalRegulationsSectionsListItem">
                                                        <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                        <xsl:value-of select="ct:number"/><xsl:text>; </xsl:text>
                                                    </xsl:if>
                                                </tr>
                                            </table>
                                        </xsl:for-each>
                                        <xsl:for-each select="cf:violationDescription/cf:projectDocSectionsList/cf:projectDocSectionsListItem">
                                            <table>
                                                <tr>
                                                    <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:number"/><xsl:text>; </xsl:text>
                                                </tr>
                                            </table>
                                        </xsl:for-each>
                                        <xsl:for-each select="cf:violationDescription/cf:workingDocSectionsList/cf:workingDocSectionsListItem">
                                            <table>
                                                <tr>
                                                    <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                    <xsl:value-of select="ct:number"/><xsl:text>; </xsl:text>
                                                    <xsl:if test="cf:sheetsNumbersList/cf:sheetsNumbersListItem">
                                                        <xsl:value-of select="cf:sheetsNumbersList/cf:sheetsNumbersListItem"/><xsl:text>; </xsl:text>
                                                    </xsl:if>
                                                </tr>
                                            </table>
                                        </xsl:for-each>
                                    </td>
                                    <td class="data">
                                        <xsl:call-template name="formatdate">
                                            <xsl:with-param name="DateStr" select="cf:violationPlanFixDate" />
                                        </xsl:call-template>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </table>
                        <br/>
                        <p class="list" style="text-indent: 20px;">
                            За неисполнение или ненадлежащее исполнение в срок настоящего
                            предписания застройщик или технический заказчик либо лицо, осуществляющее
                            строительство на основании договора с застройщиком или техническим заказчиком,
                            несет административную ответственность, предусмотренную Кодексом Российской
                            Федерации об административных правонарушениях (Собрание законодательства
                            Российской Федерации, 2002, № 1, ст.1; 2022, № 16, ст. 2605).
                        </p>
                        <p class="list" style="text-indent: 20px;">
                            В соответствии с частью 6 статьи 52 Градостроительного кодекса Российской
                            Федерации (Собрание законодательства Российской Федерации, 2005, № 1, ст.16;
                            2019, № 26, ст. 3317) лицо, осуществляющее строительство (застройщик или
                            технический заказчик либо лицо, осуществляющее строительство на основании
                            договора), обязано обеспечить устранение выявленных нарушений и не приступать
                            к продолжению работ до устранения выявленных недостатков.
                        </p>
                        <xsl:for-each select="cf:orderComplianceNotification">
                            <br/>
                            <p class="list" style="text-indent: 20px;">
                                О выполнении настоящего предписания в срок до
                                <span class="data">
                                    <xsl:call-template name="formatdate">
                                        <xsl:with-param name="DateStr" select="cf:notificationDate" />
                                    </xsl:call-template>
                                </span>
                                уведомить
                            </p>
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
                                (наименование, адрес органа государственного строительного надзора)
                            </p>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:for-each select="cf:orderIssuedPerson">
                        <p class="list">
                            Лицо, выдавшее предписание:
                        </p>
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
                                (должность, ФИО)
                            </p>
                        </div>
                        <br/>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:if test="cf:familiarizationOrRefusal">
                    <xsl:for-each select="cf:familiarizationOrRefusal">
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
                <xsl:if test="cf:controlledPersonSignedPart/cf:emailSendingInfo">
                    <table class="emailSendingInfo">
                        <tr>
                            <td>
                                <p class="list" style="text-align: center">
                                    Отметка о направлении предписания в электронном виде (на электронный адрес:
                                    <span class="data">
                                        <xsl:value-of select="cf:controlledPersonSignedPart/cf:emailSendingInfo/ct:email"/>
                                    </span>), 
                                    в том числе через личный кабинет на специализированном электронном портале
                                </p>
                            </td>
                        </tr>
                    </table>
                    <br/>
                </xsl:if>
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
                    <xsl:value-of select="concat('«', $dd, '» ', 'июля ', $yyyy, ' г.' )" />
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
                    <xsl:value-of select="concat('«', $dd, '» ', 'июля ', $yyyy, ' г. ', $hh, ' час. ', $m,  ' мин.' )" />
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
    
    <xsl:template match="cf:designParameters">
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
                        <xsl:if test="ct:buildingArea">
                            Площадь застройки:
                            <xsl:value-of select="ct:buildingArea"/>
                        </xsl:if>
                        <xsl:if test="ct:permanentObjectPartBuildingArea">
                            Площадь застройки части объекта капитального строительства:
                            <xsl:value-of select="ct:permanentObjectPartBuildingArea"/>
                        </xsl:if>
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
                                        <xsl:for-each select="ct:otherParametersList/ct:otherParametersListItem">
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
                                        <xsl:for-each select="ct:otherParametersList/ct:otherParametersListItem">
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
                                        <xsl:for-each select="ct:otherParametersList/ct:otherParametersListItem">
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
                                        <xsl:for-each select="ct:otherParametersList/ct:otherParametersListItem">
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
                                        <xsl:for-each select="ct:otherParametersList/ct:otherParametersListItem">
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
                                        <xsl:for-each select="ct:otherParametersList/ct:otherParametersListItem">
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
