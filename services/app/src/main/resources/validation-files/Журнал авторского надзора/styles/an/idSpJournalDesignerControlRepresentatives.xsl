<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://v_17_0/types/CommonTypes.xsd"
    xmlns:cf="http://v_17_0/an/idSpJournalDesignerControlRepresentatives.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />
    <xsl:param name="version" select="'1.1'"/>

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:idSpJournalDesignerControlRepresentatives" />

    </xsl:template>

    <xsl:template match="/cf:idSpJournalDesignerControlRepresentatives">


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
            <title>idSpJournalDesignerControlRepresentatives</title>
            <body>
                <h1>
                    СПИСОК РАБОТНИКОВ ЛИЦА, ОСУЩЕСТВЛЯЮЩЕГО АВТОРСКИЙ НАДЗОР 
                </h1>
               <br/>
                <table border="1">
                    <tr>
                        <th> Фамилия, имя, отчество </th>
                        <th> Работник лица, осуществляющего авторский надзор, должность, номер телефона </th>
                        <th> Вид работ при осуществлении авторского надзора </th>
                        <th> Дата и номер документа о полномочиях по проведению авторского надзора </th>
                    </tr>
                    <tr>
                        <th> 1 </th>
                        <th> 2 </th>
                        <th> 3 </th>
                        <th> 4 </th>
                    </tr>
                    <xsl:for-each select="cf:participantDesignerControlWithRepresentatives">
                        <xsl:for-each select="cf:representativeDesignerControlList/cf:representativeDesignerControl">
                            <xsl:for-each select="cf:representativeSignedPart">
                                <tr>
                                    <td class="data">
                                        <xsl:value-of select="cf:representative/ct:lastName"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="cf:representative/ct:firstName"/>
                                        <xsl:if test="cf:representative/ct:middleName">
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="cf:representative/ct:middleName"/>
                                        </xsl:if>
                                    </td>
                                    <td class="data">
                                        <xsl:value-of select="cf:representative/ct:position"/><xsl:text>, </xsl:text>
                                        <xsl:value-of select="cf:phone"/>
                                    </td>
                                    <td class="data">
                                        <xsl:for-each select="cf:workTypeList/cf:workType">
                                            <xsl:value-of select="."/><br/>
                                        </xsl:for-each>
                                    </td>
                                    <td class="data">
                                        <xsl:for-each select="cf:representative/ct:administrativeDocument">
                                            <xsl:call-template name="docDetailsTempl">
                                                <xsl:with-param name="Doc" select="." />
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </td>
                                </tr>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:for-each>
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
    
   <!--Реквизиты документов: name № number от «ДД.» ММ.ГГГГ г.-->
    <xsl:template name="docDetailsTempl">
        <xsl:param name="Doc"/>
        <xsl:value-of select="$Doc/ct:name"/> №
        <xsl:value-of select="$Doc/ct:number"/> 
        от 
        <xsl:call-template name="formatdate">
            <xsl:with-param name="DateStr" select="$Doc/ct:date" />
        </xsl:call-template>
    </xsl:template>
</xsl:stylesheet>