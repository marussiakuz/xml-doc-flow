<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://types/CommonTypes.xsd"
    xmlns:cf="http://gsn/gsnProtocolInspection.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:gsnProtocolInspection" />

    </xsl:template>

    <xsl:template match="/cf:gsnProtocolInspection">

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
                </style>
            </head>
            <title>gsnProtocolInspection</title>
            <body>
                <xsl:for-each select="cf:controlledPersonSignedPart/cf:supervisoryAuthorityRepresentativesSignedPart/cf:protocolRequisites">
                    <div style="width: 60%; margin: 0 auto;">
                        <xsl:for-each select="cf:supervisoryAuthorityInfo">
                            <p style="text-transform: uppercase; text-align: center;">
                                <strong>
                                    <xsl:value-of select="ct:name"/>
                                </strong>
                            </p>
                            <p class="list" style="text-align: center;">
                                <xsl:value-of select="ct:address"/>
                                <xsl:if test="ct:contactInfo">
                                    <xsl:for-each select="ct:contactInfo">
                                        <xsl:value-of select="ct:phone"/><xsl:text> </xsl:text>
                                        <xsl:if test="ct:email">
                                            <xsl:value-of select="ct:email"/><xsl:text> </xsl:text>
                                        </xsl:if>
                                    </xsl:for-each>
                                </xsl:if>
                                ОГРН: <xsl:value-of select="ct:ogrn"/>
                                ИНН: <xsl:value-of select="ct:inn"/>
                            </p>
                        </xsl:for-each>
                    </div>
                    <hr/>
                    <h1>
                        ПРОТОКОЛ ОСМОТРА<br/>
                        <span style="font-weight: normal;">
                            ТЕРРИТОРИЙ, ПОМЕЩЕНИЙ (ОТСЕКОВ), ПРОИЗВОДСТВЕННЫХ И ИНЫХ
                            <br/>ОБЪЕКТОВ, ПРОДУКЦИИ (ТОВАРОВ) И ИНЫХ ПРЕДМЕТОВ
                        </span>
                    </h1>
                    <br/>
                    <div>
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
                    </div>
                    <br/>
                    <div class="list" style="margin: 0 0 0 70%">
                        <xsl:for-each select="cf:controlEventPeriod">
                            <p class="list">
                                Осмотр начат 
                                <span class="data">
                                    <xsl:call-template name="formatdatetime">
                                        <xsl:with-param name="DateTimeStr" select="ct:beginDate" />
                                    </xsl:call-template>
                                </span>
                            </p>
                            <p class="list">
                                Осмотр окончен 
                                <span class="data">
                                    <xsl:call-template name="formatdatetime">
                                        <xsl:with-param name="DateTimeStr" select="ct:endDate" />
                                    </xsl:call-template>
                                </span>
                            </p>
                        </xsl:for-each>
                    </div>
                </xsl:for-each>
                <p class="list" style="text-indent: 20px">
                    Мною (нами):
                </p>
                <xsl:for-each select="cf:controlledPersonSignedPart/cf:supervisoryAuthorityRepresentativesSignedPart/cf:supervisoryAuthorityRepresentativesList/cf:supervisoryAuthorityRepresentativesListItem">
                    <p class="data">
                        <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                        <xsl:value-of select="ct:firstName"/>
                        <xsl:if test="ct:middleName">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="ct:middleName"/>
                        </xsl:if>;
                    </p>
                </xsl:for-each>
                <p class="under">
                    (указываются фамилии, имена, отчества должностных лиц, 
                    уполномоченных на проведение мероприятия по контролю (надзору), 
                    проводивших контрольное (надзорное) действие)
                </p>
                <p class="list">
                    в присутствии:
                </p>
                <p class="data">
                    <xsl:for-each select="cf:controlledPersonSignedPart/cf:controlledPersonRepresentative">
                        <xsl:value-of select="ct:position"/><xsl:text>, </xsl:text>
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
                    (должность, ф.и.о представителя проверяемого лица)
                </p>
                <xsl:for-each select="cf:controlledPersonSignedPart/cf:supervisoryAuthorityRepresentativesSignedPart/cf:protocolInfo">
                    <p class="list">
                        в рамках контрольного (надзорного) мероприятия 
                        в соответствии с решением (заданием) от 
                        <span class="data">
                            <xsl:call-template name="formatdate">
                                <xsl:with-param name="DateStr" select="cf:controlEventDecisionRequisites/ct:date" />
                            </xsl:call-template>
                        </span>
                        <span class="list">
                            № 
                            <span class="data">
                                <xsl:value-of select="cf:controlEventDecisionRequisites/ct:number"/>
                            </span>
                            произведен осмотр:
                        </span>
                    </p>
                    <p class="data">
                        <xsl:value-of select="cf:controlEventInfo"/>
                    </p>
                    <p class="under">
                        (дата, время, место и перечень территорий, помещений, 
                        конструкций, производственных объектов, продукции)
                    </p>
                </xsl:for-each>
                <div>
                    <p class="list" style="text-indent: 20px">
                        Осмотр проводился с применением:
                    </p>
                    <p class="data">
                        <xsl:value-of select="cf:controlledPersonSignedPart/cf:supervisoryAuthorityRepresentativesSignedPart/cf:protocolInfo/cf:recordingMethodsInfo"/>
                    </p>
                    <p class="under">
                        (указать фотосъемку, видео-, аудио запись ииные способы фиксации)
                    </p>
                </div>
                <xsl:if test="cf:familiarizationOrRefusal">
                    <xsl:for-each select="cf:familiarizationOrRefusal">
                        <xsl:choose>
                            <xsl:when test="ct:familiarizationSignature">
                                <p class="list" style="text-indent: 20px">
                                    С протоколом ознакомлен, копия протокола вручена (не вручена)
                                </p>
                                <div style="max-width: 40%">
                                    <p class="data">
                                        <xsl:for-each select="../cf:controlledPersonSignedPart/cf:controlledPersonRepresentative">
                                            <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:firstName"/>
                                            <xsl:if test="ct:middleName">
                                                <xsl:text> </xsl:text>
                                                <xsl:value-of select="ct:middleName"/>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </p>
                                    <p class="under">
                                        (подпись, ф.и.о представителя заказчика (застройщика))
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
                <xsl:if test="cf:controlledPersonSignedPart/cf:protocolComments">
                    <p class="list" style="text-indent: 20px">
                        Замечания к протоколу
                    </p>
                    <p class="data">
                        <xsl:for-each select="cf:controlledPersonSignedPart/cf:protocolComments">
                            <xsl:choose>
                                <xsl:when test="cf:commentsAbsence">
                                    <xsl:value-of select="cf:commentsAbsence"/>
                                </xsl:when>
                                <xsl:when test="cf:commentsText">
                                    <xsl:value-of select="cf:commentsText"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:for-each>
                    </p>
                    <p class="under">
                        (содержание замечаний либо 
                        указание на их отсутствие)
                    </p>
                </xsl:if>
                <div style="max-width: 40%">
                    <ol style="list-style: none; padding: 0; margin: 0;">
                        <xsl:for-each select="cf:controlledPersonSignedPart/cf:supervisoryAuthorityRepresentativesSignedPart/cf:supervisoryAuthorityRepresentativesList/cf:supervisoryAuthorityRepresentativesListItem">
                            <li style="list-style: none; padding: 0; margin: 0;">
                                <p class="data">
                                    <xsl:value-of select="ct:position"/><xsl:text> </xsl:text>
                                    <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                    <xsl:call-template name="initials">
                                        <xsl:with-param name="NameStr" select="ct:firstName" />
                                    </xsl:call-template>
                                    <xsl:if test="ct:middleName">
                                        <xsl:call-template name="initials">
                                            <xsl:with-param name="NameStr" select="ct:middleName" />
                                        </xsl:call-template>
                                    </xsl:if> 
                                    <p class="under">
                                        (должность, фамилия, инициалы ответственного 
                                        представителя госстройнадзора, проводившего осмотр)
                                    </p>
                                </p>
                            </li>
                        </xsl:for-each>
                    </ol>
                </div>
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
    
</xsl:stylesheet>
