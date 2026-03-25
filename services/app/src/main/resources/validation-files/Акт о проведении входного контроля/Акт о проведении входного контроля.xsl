<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://types/CommonTypes.xsd"
    xmlns:cf="http://idActs/APVK.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:apvk" />

    </xsl:template>

    <xsl:template match="/cf:apvk">


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
                    {
                    font-family: Times New Roman;
                    font-size: 14pt;
                    text-align:center;
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
                    .qr-code {
                    max-width: 200px;
                    margin: 10px;
                    }
                </style>
            </head>
            <title>APVK</title>
           <body>
               <h1>
                   АКТ
                   <br/>
                   о проведении входного контроля
               </h1>
               <xsl:for-each select="cf:actInfo">
                   <xsl:for-each select="cf:documentDetails">
                       <span class="data">
                           <xsl:call-template name="formatdate">
                               <xsl:with-param name="DateStr" select="ct:date" />
                           </xsl:call-template>
                       </span>
                       <span style="float: right">
                           <span class="list">№ </span>
                           <span class="data">
                               <xsl:choose>
                                   <xsl:when test="ct:structureElementNumber">
                                       <xsl:value-of select="ct:structureElementNumber"/>
                                   </xsl:when>
                                   <xsl:otherwise>
                                       <xsl:value-of select="ct:number" />
                                   </xsl:otherwise>
                               </xsl:choose>
                           </span>
                       </span>
                   </xsl:for-each>
                   <br/><br/>
                   <xsl:for-each select="cf:permanentObjectInfo">
                       <p class="data">
                           <xsl:value-of select="ct:permanentObjectName"/>
                       </p>
                       <p class="under">(наименование объекта строительства)</p>
                       <p class="data">
                           <xsl:value-of select="ct:permanentObjectAddress"/>
                       </p>
                       <p class="under">(местонахождение объекта строительства)</p>
                   </xsl:for-each>
                   <p class="list">Комиссия в составе:</p>
                   <xsl:choose>
                       <xsl:when test="cf:developer">
                           <p class="list">Застройщик</p>
                           <xsl:for-each select="cf:developer">
                               <xsl:choose>
                                   <xsl:when test="ct:organization/ct:legalEntity">
                                       <p class="data">
                                           <xsl:for-each select="ct:organization/ct:legalEntity">
                                               <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:address"/>
                                           </xsl:for-each>
                                       </p>
                                       <p class="under">(наименование, ОГРН, ИНН, место нахождения юридического лица)</p>
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
                                               <xsl:value-of select="ct:ogrnip"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:address"/>
                                           </xsl:for-each>
                                       </p>
                                       <p class="under">(фамилия, имя, отчество, ОГРНИП, ИНН, адрес места жительства индивидуального предпринимателя)</p>
                                   </xsl:when>
                                   <xsl:when test="ct:individual">
                                       <p class="data">
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
                                               <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                                           </xsl:for-each>
                                       </p>
                                       <p class="under">(фамилия, имя, отчество, паспортные данные, адрес места жительства физического лица, не являющегося индивидуальными предпринимателями</p>
                                   </xsl:when>
                               </xsl:choose>
                           </xsl:for-each>
                       </xsl:when>
                       <xsl:when test="cf:technicalCustomer">
                           <p class="list">Технический заказчик</p>
                           <xsl:for-each select="cf:technicalCustomer">
                               <xsl:choose>
                                   <xsl:when test="ct:organizationInfo/ct:legalEntity">
                                       <p class="data">
                                           <xsl:for-each select="ct:organizationInfo/ct:legalEntity">
                                               <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:address"/>
                                           </xsl:for-each>
                                       </p>
                                       <p class="under">(наименование, ОГРН, ИНН, место нахождения юридического лица)</p>
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
                                               <xsl:value-of select="ct:ogrnip"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:address"/>
                                           </xsl:for-each>
                                       </p>
                                       <p class="under">(фамилия, имя, отчество, ОГРНИП, ИНН, адрес места жительства индивидуального предпринимателя)</p>
                                   </xsl:when>
                               </xsl:choose>
                           </xsl:for-each>
                       </xsl:when>
                       <xsl:when test="cf:operatingPerson">
                           <p class="list">Лицо, ответственное за эксплуатацию здания, сооружения</p>
                           <xsl:for-each select="cf:operatingPerson">
                               <xsl:choose>
                                   <xsl:when test="ct:organization/ct:legalEntity">
                                       <p class="data">
                                           <xsl:for-each select="ct:organization/ct:legalEntity">
                                               <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:address"/>
                                           </xsl:for-each>
                                       </p>
                                       <p class="under">(наименование, ОГРН, ИНН, место нахождения юридического лица)</p>
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
                                               <xsl:value-of select="ct:ogrnip"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:address"/>
                                           </xsl:for-each>
                                       </p>
                                       <p class="under">(фамилия, имя, отчество, ОГРНИП, ИНН, адрес места жительства индивидуального предпринимателя)</p>
                                   </xsl:when>
                                   <xsl:when test="ct:individual">
                                       <p class="data">
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
                                               <xsl:value-of select="ct:address"/><xsl:text> </xsl:text>
                                           </xsl:for-each>
                                       </p>
                                       <p class="under">(фамилия, имя, отчество, паспортные данные, адрес места жительства физического лица, не являющегося индивидуальными предпринимателями</p>
                                   </xsl:when>
                               </xsl:choose>
                           </xsl:for-each>
                       </xsl:when>
                       <xsl:when test="cf:regionalOperator">
                           <p class="list">Региональный оператор</p>
                           <xsl:for-each select="cf:regionalOperator">
                               <xsl:choose>
                                   <xsl:when test="ct:organizationInfo/ct:legalEntity">
                                       <p class="data">
                                           <xsl:for-each select="ct:organizationInfo/ct:legalEntity">
                                               <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:address"/>
                                           </xsl:for-each>
                                       </p>
                                       <p class="under">(наименование, ОГРН, ИНН, место нахождения юридического лица)</p>
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
                                               <xsl:value-of select="ct:ogrnip"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                               <xsl:value-of select="ct:address"/>
                                           </xsl:for-each>
                                       </p>
                                       <p class="under">(фамилия, имя, отчество, ОГРНИП, ИНН, адрес места жительства индивидуального предпринимателя)</p>
                                   </xsl:when>
                               </xsl:choose>
                           </xsl:for-each>
                       </xsl:when>
                   </xsl:choose>
                   <xsl:if test="cf:participantControlRepresentative">
                       <xsl:choose>
                           <xsl:when test="cf:developer">
                               <p class="list">Представитель застройщика по вопросам строительного контроля</p>
                           </xsl:when>
                           <xsl:when test="cf:technicalCustomer">
                               <p class="list">Представитель технического заказчика по вопросам строительного контроля</p>
                           </xsl:when>
                           <xsl:when test="cf:operatingPerson">
                               <p class="list">Представитель лица, ответственного за эксплуатацию здания, сооружения по вопросам строительного контроля</p>
                           </xsl:when>
                           <xsl:when test="cf:regionalOperator">
                               <p class="list">Представитель регионального оператора по вопросам строительного контроля</p>
                           </xsl:when>
                       </xsl:choose>
                       <xsl:for-each select="cf:participantControlRepresentative">
                           <xsl:if test="ct:organization">
                               <xsl:for-each select="ct:organization">
                                   <xsl:choose>
                                       <xsl:when test="ct:organizationInfo/ct:legalEntity">
                                           <p class="data">
                                               <xsl:for-each select="ct:organizationInfo/ct:legalEntity">
                                                   <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                   <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                                   <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                                   <xsl:value-of select="ct:address"/>
                                               </xsl:for-each>
                                           </p>
                                           <p class="under">(наименование, ОГРН, ИНН, место нахождения юридического лица)</p>
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
                                                   <xsl:value-of select="ct:ogrnip"/><xsl:text> </xsl:text>
                                                   <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                                   <xsl:value-of select="ct:address"/>
                                               </xsl:for-each>
                                           </p>
                                           <p class="under">(фамилия, имя, отчество, ОГРНИП, ИНН, адрес места жительства индивидуального предпринимателя)</p>
                                       </xsl:when>
                                   </xsl:choose>
                               </xsl:for-each>
                           </xsl:if>
                           <p class="data">
                               <xsl:value-of select="ct:position"/><xsl:text> </xsl:text>
                               <xsl:value-of select="ct:lastName" />
                               <xsl:text> </xsl:text>
                               <xsl:call-template name="initials">
                                   <xsl:with-param name="NameStr" select="ct:firstName" />
                               </xsl:call-template>
                               <xsl:text> </xsl:text>
                               <xsl:call-template name="initials">
                                   <xsl:with-param name="NameStr" select="ct:middleName" />
                               </xsl:call-template>
                               <xsl:text> </xsl:text>
                               <xsl:for-each select="ct:administrativeDocument">
                                   <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                   №
                                   <xsl:value-of select="ct:number"/>
                                   от
                                   <xsl:call-template name="formatdate">
                                       <xsl:with-param name="DateStr" select="ct:date" />
                                   </xsl:call-template>
                                   <xsl:if test="ct:expirationDate">
                                       до
                                       <xsl:call-template name="formatdate">
                                           <xsl:with-param name="DateStr" select="ct:expirationDate" />
                                       </xsl:call-template>
                                   </xsl:if>
                               </xsl:for-each>
                           </p>
                           <p class="under">(должность, фамилия, инициалы, реквизиты документа о представительстве)</p> 
                       </xsl:for-each>
                   </xsl:if>
                   <p class="list">Лицо, осуществляющее строительство:</p>
                   <xsl:for-each select="cf:buildingContractor">
                       <xsl:choose>
                           <xsl:when test="ct:organizationInfo/ct:legalEntity">
                               <p class="data">
                                   <xsl:for-each select="ct:organizationInfo/ct:legalEntity">
                                       <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                       <xsl:value-of select="ct:ogrn"/><xsl:text> </xsl:text>
                                       <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                       <xsl:value-of select="ct:address"/>
                                   </xsl:for-each>
                               </p>
                               <p class="under">(наименование, ОГРН, ИНН, место нахождения юридического лица)</p>
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
                                       <xsl:value-of select="ct:ogrnip"/><xsl:text> </xsl:text>
                                       <xsl:value-of select="ct:inn"/><xsl:text> </xsl:text>
                                       <xsl:value-of select="ct:address"/>
                                   </xsl:for-each>
                               </p>
                               <p class="under">(фамилия, имя, отчество, ОГРНИП, ИНН, адрес места жительства индивидуального предпринимателя)</p>
                           </xsl:when>
                       </xsl:choose>
                   </xsl:for-each>
                   <xsl:for-each select="cf:buildingContractorRepresentative">
                       <p class="data">
                           <xsl:value-of select="ct:position"/><xsl:text> </xsl:text>
                           <xsl:value-of select="ct:lastName" />
                           <xsl:text> </xsl:text>
                           <xsl:call-template name="initials">
                               <xsl:with-param name="NameStr" select="ct:firstName" />
                           </xsl:call-template>
                           <xsl:text> </xsl:text>
                           <xsl:call-template name="initials">
                               <xsl:with-param name="NameStr" select="ct:middleName" />
                           </xsl:call-template>
                           <xsl:text> </xsl:text>
                           <xsl:for-each select="ct:administrativeDocument">
                               <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                               №
                               <xsl:value-of select="ct:number"/>
                               от
                               <xsl:call-template name="formatdate">
                                   <xsl:with-param name="DateStr" select="ct:date" />
                               </xsl:call-template>
                               <xsl:if test="ct:expirationDate">
                                   до
                                   <xsl:call-template name="formatdate">
                                       <xsl:with-param name="DateStr" select="ct:expirationDate" />
                                   </xsl:call-template>
                               </xsl:if>
                           </xsl:for-each>
                       </p>
                       <p class="under">(должность, фамилия, инициалы, реквизиты документа о представительстве)</p>
                   </xsl:for-each>
                   <xsl:for-each select="cf:buildingContractorControlRepresentative">
                       <p class="list">
                           Представитель лица, осуществляющего строительство по вопросам строительного контроля  
                       </p>
                       <p class="data">
                           <xsl:value-of select="ct:position"/><xsl:text> </xsl:text>
                           <xsl:value-of select="ct:lastName" />
                           <xsl:text> </xsl:text>
                           <xsl:call-template name="initials">
                               <xsl:with-param name="NameStr" select="ct:firstName" />
                           </xsl:call-template>
                           <xsl:text> </xsl:text>
                           <xsl:call-template name="initials">
                               <xsl:with-param name="NameStr" select="ct:middleName" />
                           </xsl:call-template>
                           <xsl:text> </xsl:text>
                           <xsl:for-each select="ct:administrativeDocument">
                               <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                               №
                               <xsl:value-of select="ct:number"/>
                               от
                               <xsl:call-template name="formatdate">
                                   <xsl:with-param name="DateStr" select="ct:date" />
                               </xsl:call-template>
                               <xsl:if test="ct:expirationDate">
                                   до
                                   <xsl:call-template name="formatdate">
                                       <xsl:with-param name="DateStr" select="ct:expirationDate" />
                                   </xsl:call-template>
                               </xsl:if>
                           </xsl:for-each>
                       </p>
                       <p class="under">(должность, фамилия, инициалы, реквизиты документа о представительстве)</p>
                   </xsl:for-each>
                   <xsl:if test="cf:otherRepresentativesList">
                       <p class="list">а также лица, дополнительно участвующие в освидетельствовании:</p>
                       <xsl:for-each select="cf:otherRepresentativesList/ct:otherRepresentative">
                           <p class="data">
                               <xsl:for-each select="ct:organization">
                                   <xsl:choose>
                                       <xsl:when test="ct:fullOrganizationInfo">
                                           <xsl:for-each select="ct:fullOrganizationInfo/ct:organizationInfo">
                                               <xsl:choose>
                                                   <xsl:when test="ct:legalEntity">
                                                       <xsl:value-of select="ct:legalEntity/ct:name"/>
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
                                                       </xsl:for-each>
                                                   </xsl:when>
                                               </xsl:choose>
                                           </xsl:for-each>
                                       </xsl:when>
                                       <xsl:when test="ct:shortOrganizationInfo">
                                           <xsl:for-each select="ct:shortOrganizationInfo">
                                               <xsl:choose>
                                                   <xsl:when test="ct:individualEntrepreneur">
                                                       <xsl:value-of select="ct:individualEntrepreneur"/>
                                                       <xsl:text> </xsl:text>
                                                   </xsl:when>
                                                   <xsl:when test="ct:legalEntity">
                                                       <xsl:value-of select="ct:legalEntity"/>
                                                       <xsl:text> </xsl:text>
                                                   </xsl:when>
                                               </xsl:choose>
                                           </xsl:for-each>
                                       </xsl:when>
                                   </xsl:choose>
                               </xsl:for-each>
                               <xsl:text> </xsl:text>
                               <xsl:for-each select="ct:representative">
                                   <xsl:value-of select="ct:position"/><xsl:text> </xsl:text>
                                   <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                   <xsl:value-of select="ct:firstName"/>
                                   <xsl:if test="ct:middleName">
                                       <xsl:text> </xsl:text>
                                       <xsl:value-of select="ct:middleName"/>
                                   </xsl:if>
                               </xsl:for-each>
                           </p>
                           <p class="under">(наименование организации, должность, фамилия, и.о.)</p>
                       </xsl:for-each>
                   </xsl:if>
                   <p class="list">Составила настоящий акт о том, что технические средства/материалы</p>
                   <br>
                       <table border="1" style="border-collapse:collapse; width:100%">
                           <tr>
                               <th valign="top"> Наименование </th>
                               <th valign="top"> Тип </th>
                               <th valign="top"> Марка </th>
                               <th valign="top"> Заводской номер </th>
                               <th valign="top"> Предприятие-изготовитель/поставщик </th>
                               <th valign="top"> Дата изготовления </th>
                               <th valign="top"> Дата поступления </th>
                               <th valign="top"> Сопроводительные документы </th>
                               <th valign="top"> Количество </th>
                           </tr>
                           <xsl:for-each select="cf:incomingControlInfoList/cf:incomingControlInfo">
                               <tr>
                                   <td class="data">
                                       <xsl:value-of select="cf:name"/>
                                   </td>
                                   <td class="data">
                                       <xsl:value-of select="cf:type"/>
                                   </td>
                                   <td class="data">
                                       <xsl:value-of select="cf:mark"/>
                                   </td>
                                   <td class="data">
                                       <xsl:value-of select="cf:serialNumber"/>
                                   </td>
                                   <td class="data">
                                       <xsl:for-each select="cf:supplier">
                                           <xsl:choose>
                                               <xsl:when test="cf:individualEntrepreneur">
                                                   <xsl:value-of select="cf:individualEntrepreneur"/>
                                               </xsl:when>
                                               <xsl:when test="cf:legalEntity">
                                                   <xsl:value-of select="cf:legalEntity"/>
                                               </xsl:when>
                                           </xsl:choose>
                                       </xsl:for-each>
                                   </td>
                                   <td class="data">
                                       <xsl:call-template name="formatdate">
                                           <xsl:with-param name="DateStr" select="cf:manufacturingDate"/>
                                       </xsl:call-template>
                                   </td>
                                   <td class="data">
                                       <xsl:call-template name="formatdate">
                                           <xsl:with-param name="DateStr" select="cf:deliveryDate"/>
                                       </xsl:call-template>
                                   </td>
                                   <td class="data">
                                       <xsl:for-each select="cf:qualityApproveDocuments">
                                           <xsl:choose>
                                               <xsl:when test="cf:untypedQualityApproveDocumentsList">
                                                   <xsl:for-each select="cf:untypedQualityApproveDocumentsList/cf:untypedQualityApproveDocument">
                                                       <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                       <xsl:value-of select="ct:number"/><xsl:text> </xsl:text>
                                                       <xsl:call-template name="formatdate">
                                                           <xsl:with-param name="DateStr" select="ct:date"/>
                                                       </xsl:call-template>
                                                       <br/>
                                                   </xsl:for-each>
                                               </xsl:when>
                                               <xsl:when test="cf:typedQualityApproveDocuments">
                                                   <xsl:for-each select="cf:typedQualityApproveDocuments">
                                                       <xsl:for-each select="cf:materialAmountQualityDocument">
                                                           <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                           <xsl:value-of select="ct:number"/><xsl:text> </xsl:text>
                                                           <xsl:call-template name="formatdate">
                                                               <xsl:with-param name="DateStr" select="ct:date"/>
                                                           </xsl:call-template>
                                                           <br/>
                                                       </xsl:for-each>
                                                       <xsl:for-each select="cf:parametersComplianceDocument">
                                                           <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                           <xsl:value-of select="ct:number"/><xsl:text> </xsl:text>
                                                           <xsl:call-template name="formatdate">
                                                               <xsl:with-param name="DateStr" select="ct:date"/>
                                                           </xsl:call-template>
                                                           <br/>
                                                       </xsl:for-each>
                                                       <xsl:for-each select="cf:additionalParametersComplianceDocument">
                                                           <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                           <xsl:value-of select="ct:number"/><xsl:text> </xsl:text>
                                                           <xsl:call-template name="formatdate">
                                                               <xsl:with-param name="DateStr" select="ct:date"/>
                                                           </xsl:call-template>
                                                           <br/>
                                                       </xsl:for-each>
                                                       <xsl:for-each select="cf:additionalQualityDocument">
                                                           <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                                           <xsl:value-of select="ct:number"/><xsl:text> </xsl:text>
                                                           <xsl:call-template name="formatdate">
                                                               <xsl:with-param name="DateStr" select="ct:date"/>
                                                           </xsl:call-template>
                                                           <br/>
                                                       </xsl:for-each>
                                                   </xsl:for-each>
                                               </xsl:when>
                                           </xsl:choose>
                                       </xsl:for-each>
                                   </td>
                                   <td class="data">
                                       <xsl:value-of select="cf:materialOrItemAdditionalInfo/cf:count"/>
                                   </td>
                               </tr>
                           </xsl:for-each>
                       </table>
                   </br>
                   <br/>
                   <p class="list">прошедшие входной контроль, соответствуют технической документации предприятий-изготовителей и проектной (рабочей) документации:</p>
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
                   <p class="under">(наименования и структурные единицы технических регламентов, иных нормативных правовых актов, разделы проектной и/или рабочей документации)</p> 
               </xsl:for-each>
               <br/>
               <p class="list">Подписи:</p>
               <xsl:if test="cf:participantControlRepresentativeSignature">
                   <xsl:choose>
                       <xsl:when test="cf:actInfo/cf:developer">
                           <p class="list">Представитель застройщика по вопросам строительного контроля</p>
                       </xsl:when>
                       <xsl:when test="cf:actInfo/cf:technicalCustomer">
                           <p class="list">Представитель технического заказчика по вопросам строительного контроля</p>
                       </xsl:when>
                       <xsl:when test="cf:actInfo/cf:operator">
                           <p class="list">Представитель лица, ответственного за эксплуатацию здания, сооружения по вопросам строительного контроля</p>
                       </xsl:when>
                       <xsl:when test="cf:actInfo/cf:regionalOperator">
                           <p class="list">Представитель регионального оператора по вопросам строительного контроля</p>
                       </xsl:when>
                   </xsl:choose>
                   <xsl:for-each select="cf:actInfo/cf:participantControlRepresentative">
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
                               (должность)
                           </span>
                           (расшифровка подписи)
                       </p> 
                   </xsl:for-each>
               </xsl:if>
               <xsl:if test="cf:buildingContractorRepresentativeSignature">
                   <p class="list">Представитель лица, осуществляющего строительство</p>
                   <xsl:for-each select="cf:actInfo/cf:buildingContractorRepresentative">
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
                               (должность)
                           </span>
                           (расшифровка подписи)
                       </p> 
                   </xsl:for-each>
               </xsl:if>
               <xsl:if test="cf:buildingContractorControlRepresentativeSignature">
                   <p class="list">Представитель лица, осуществляющего строительство по вопросам строительного контроля</p>
                   <xsl:for-each select="cf:actInfo/cf:buildingContractorControlRepresentative">
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
                               (должность)
                           </span>
                           (расшифровка подписи)
                       </p>
                   </xsl:for-each>
               </xsl:if>
               <xsl:if test="cf:workExecutorRepresentativeSignature">
                   <p class="list">Представитель электромонтажной организации</p>
                   <xsl:for-each select="cf:actInfo/cf:workExecutorRepresentative">
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
                               (должность)
                           </span>
                           (расшифровка подписи)
                       </p>
                   </xsl:for-each>
               </xsl:if>
               <xsl:if test="cf:otherRepresentativesSignaturesList">
                   <p class="list">Иные лица, участвующие в освидетельствовании</p>
                   <xsl:for-each select="cf:actInfo/cf:otherRepresentativesList/ct:otherRepresentative/ct:representative">
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
                               (должность)
                           </span>
                           (расшифровка подписи)
                       </p> 
                   </xsl:for-each>
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
   
</xsl:stylesheet>