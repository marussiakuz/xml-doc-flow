<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="3.0"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ct="http://types/CommonTypes.xsd"
    xmlns:cf="http://gsn/gsn39.xsd">
    <xsl:output method="html" omit-xml-declaration="yes" />

    <xsl:template match="/">

        <xsl:apply-templates select="/cf:gsn39" />

    </xsl:template>

    <xsl:template match="/cf:gsn39">


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
            <title>gsn39</title>
            <body>
                <xsl:for-each select="cf:controlledPersonSignedPart/cf:gsnInfo/cf:supervisoryAuthorityRepresentativesInfo/cf:controlEventDecisionAuthor">
                    <p class="data">
                        <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                        <xsl:value-of select="ct:firstName"/>
                        <xsl:if test="ct:middleName">
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="ct:middleName"/>
                        </xsl:if>
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="ct:position"/>, 
                        <xsl:if test="cf:contactInfo">
                            <xsl:value-of select="cf:contactInfo/cf:phone"/>
                            <xsl:if test="cf:contactInfo/cf:email">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="cf:contactInfo/cf:email"/>
                            </xsl:if>
                        </xsl:if>
                    </p>
                    <p class="under">(фамилия, имя, отчество (при наличии) и должность должностного лица, непосредственно подготовившего проект решения, контактный телефон, электронный адрес (при наличии)</p>
                </xsl:for-each>
                <xsl:for-each select="cf:controlledPersonSignedPart">
                    <table border="2" style="border-collapse:collapse; width: 70%">
                        <tr>
                            <td>
                                <xsl:for-each select="cf:gsnInfo/cf:controlEventDecisionRequisites/cf:controlEventRegistryRecord">
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
                    <xsl:if test="cf:gsnInfo/cf:controlEventDecisionRequisites/cf:controlEventProsecutorApproval">
                        <xsl:for-each select="cf:gsnInfo/cf:controlEventDecisionRequisites/cf:controlEventProsecutorApproval">
                            <p class="list">
                                Проверка от 
                                <span class="data">
                                    <xsl:call-template name="formatdate">
                                        <xsl:with-param name="DateStr" select="cf:prosecutorApprovalDocument/ct:date" />
                                    </xsl:call-template>
                                </span>
                                №
                                <span class="data">
                                    <xsl:value-of select="cf:prosecutorApprovalDocument/ct:number"/>
                                </span>
                                <xsl:text> </xsl:text>
                                <xsl:call-template name="controlEventProsecutorApproval">
                                    <xsl:with-param name="approval" select="cf:approval" />
                                </xsl:call-template>
                                с прокуратурой
                            </p>
                            <br/>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:for-each select="cf:gsnInfo/cf:controlEventDecisionRequisites/cf:supervisoryAuthorityInfo">
                        <p class="data">
                            <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:address"/>
                        </p>
                        <p class="under">(указывается наименование контрольного (надзорного) органа) и при необходимости его территориального органа)</p>
                    </xsl:for-each>
                    <br/>
                </xsl:for-each>
                <h1>Решение о проведении выездной проверки</h1>
                <xsl:for-each select="cf:controlledPersonSignedPart/cf:gsnInfo/cf:controlEventDecisionInfo">
                    <xsl:for-each select="cf:documentDetails">
                        <p class="list" style="text-align: center">
                            от
                            <span class="data">
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="ct:date" />
                                </xsl:call-template>,
                            </span>
                            <xsl:text> </xsl:text>
                            <span class="data">
                                <xsl:value-of select="cf:compilationTime/cf:hours"/>
                            </span>
                            час.
                            <span class="data">
                                <xsl:value-of select="cf:compilationTime/cf:minutes"/>
                            </span>
                            мин. №
                            <span class="data">
                                <xsl:value-of select="ct:number"/>
                            </span>
                        </p>
                    </xsl:for-each>
                    <xsl:for-each select="cf:controlEventDecisionResponsiblePerson">
                        <p class="list">1. Решение принято</p>
                        <p class="data">
                            <xsl:value-of select="ct:position"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:firstName"/>
                            <xsl:if test="ct:middleName">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="ct:middleName"/>
                            </xsl:if>
                        </p>
                        <p class="under">(указывается наименование должности, фамилия, имя, отчество (при наличии) руководителя
                            (заместителя руководителя) контрольного (надзорного) органа или иного должностного лица контрольного
                            (надзорного) органа, уполномоченного в соответствии с положением о виде государственного контроля
                            (надзора), муниципального контроля, положением о лицензировании вида деятельности (далее - положение
                            о виде контроля) на принятие решений о проведении контрольных (надзорных) мероприятий)</p>
                    </xsl:for-each>
                    <xsl:for-each select="cf:controlEventDecisionBasis">
                        <p class="list">2. Решение принято на основании</p>
                        <p class="data">
                            <xsl:value-of select="cf:basis"/>
                        </p>
                        <p class="under">(указывается пункт части 1 или часть 3 статьи 57 Федерального закона "О государственном контроле
                            (надзоре) и муниципальном контроле в Российской Федерации")</p>
                        <p class="list">в связи с</p>
                        <xsl:for-each select="cf:basisExplanations">
                            <p class="data">
                                <xsl:value-of select="cf:basisDocument/ct:name"/><xsl:text> </xsl:text>
                                <xsl:value-of select="cf:basisDocument/ct:number"/><xsl:text> </xsl:text>
                                <xsl:call-template name="formatdate">
                                    <xsl:with-param name="DateStr" select="cf:basisDocument/ct:date" />
                                </xsl:call-template><xsl:text> </xsl:text>
                                <xsl:value-of select="cf:basisDocument/cf:compiler"/><xsl:text> </xsl:text>
                                <xsl:value-of select="cf:explanations"/>
                            </p>
                        </xsl:for-each>
                        <p class="under" style="text-align: left">
                            (указываются:
                            <br/><br/>
                            1) для пункта 1 части 1 статьи 57 Федерального закона "О государственном контроле (надзоре) и
                            муниципальном контроле в Российской Федерации":
                            <br/><br/>
                            1.1) сведения о причинении вреда (ущерба) охраняемым законом ценностям (источник сведений,
                            изложение сведений, охраняемые законом ценности);
                            <br/><br/>
                            1.2) сведения об угрозе причинения вреда (ущерба) охраняемым законом ценностям (источник сведений,
                            изложение сведений, обоснование наличия угрозы причинения вреда (ущерба), охраняемые законом
                            ценности);
                            <br/><br/>
                            1.3) соответствие объекта контроля параметрам, утвержденным индикаторами риска нарушения
                            обязательных требований, или отклонение объекта контроля от таких параметров (источник сведений,
                            изложение сведений, ссылка на утвержденные индикаторы риска нарушения обязательных требований);
                            <br/><br/>
                            (при изложении источников сведений персональные данные граждан, направивших обращения
                            (заявления) в контрольный (надзорный) орган, не приводятся);
                            <br/><br/>
                            2) для пункта 2 части 1 статьи 57 Федерального закона "О государственном контроле (надзоре) и
                            муниципальном контроле в Российской Федерации":
                            <br/><br/>
                            ссылка на утвержденный ежегодный план проведения плановых контрольных (надзорных) мероприятий,
                            содержащиеся в нем сведения о выездной проверке;
                            <br/><br/>
                            3) для пункта 3 части 1 статьи 57 Федерального закона "О государственном контроле (надзоре) и
                            муниципальном контроле в Российской Федерации":
                            <br/><br/>
                            3.1) ссылка на поручение Президента Российской Федерации о проведении контрольных (надзорных)
                            мероприятий, приказ (распоряжение) контрольного (надзорного) органа об организации выполнения
                            поручения Президента Российской Федерации (при наличии);
                            <br/><br/>
                            3.2) ссылка на поручение Председателя Правительства Российской Федерации о проведении
                            контрольных (надзорных) мероприятий, приказ (распоряжение) контрольного (надзорного) органа об
                            организации выполнения поручения Председателя Правительства Российской Федерации (при наличии);
                            <br/><br/>
                            3.3) ссылка на поручение Заместителя Председателя Правительства Российской Федерации о
                            проведении контрольных (надзорных) мероприятий в отношении конкретного контролируемого лица, приказ
                            (распоряжение) контрольного (надзорного) органа об организации выполнения поручения Заместителя
                            Председателя Правительства Российской Федерации (при наличии);
                            <br/><br/>
                            4) для пункта 4 части 1 статьи 57 Федерального закона "О государственном контроле (надзоре) и
                            муниципальном контроле в Российской Федерации":
                            <br/><br/>
                            ссылка на требование прокурора о проведении выездной проверки в рамках надзора за исполнением
                            законов, соблюдением прав и свобод человека и гражданина по поступившим в органы прокуратуры
                            материалам и обращениям;
                            <br/><br/>
                            5) для пункта 5 части 1 статьи 57 Федерального закона "О государственном контроле (надзоре) и
                            муниципальном контроле в Российской Федерации":
                            <br/><br/>
                            ссылка на решение контрольного (надзорного) органа об устранении выявленных нарушений
                            обязательных требований, ссылка на наступление срока его исполнения;
                            6) для пункта 6 части 1 статьи 57 Федерального закона "О государственном контроле (надзоре) и
                            муниципальном контроле в Российской Федерации":
                            <br/><br/>
                            ссылка на утвержденную программу проверок и указанное в ней событие, наступление которого влечет
                            проведение выездной проверки);
                            <br/><br/>
                            7) для части 3 статьи 57 Федерального закона "О государственном контроле (надзоре) и муниципальном
                            контроле в Российской Федерации":
                            <br/><br/>
                            поступившая от контролируемого лица информация об устранении нарушений обязательных требований,
                            выявленных в рамках процедур периодического подтверждения соответствия (компетентности),
                            осуществляемых в рамках разрешительных режимов, предусматривающих бессрочный характер действия
                            соответствующих разрешений
                            <br/>
                        </p>
                    </xsl:for-each>
                    <p class="list">3. Выездная проверка проводится в рамках</p>
                    <p class="data">
                        <xsl:value-of select="cf:controlType"/>
                    </p>
                    <p class="under">(наименование вида государственного контроля (надзора), вида муниципального контроля в
                        соответствии с единым реестром видов федерального государственного контроля (надзора), регионального
                        государственного контроля (надзора), муниципального контроля)</p>
                    <p class="list">4. Для проведения выездной проверки уполномочены:</p>
                    <xsl:for-each select="cf:authorizedPersonsList/cf:authorizedPersonsListItem">
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
                    <p class="under">указываются фамилии, имена, отчества (при наличии), должности инспектора (инспекторов, в том числе
                        руководителя группы инспекторов), уполномоченного (уполномоченных) на проведение выездной проверки)</p>
                    <p class="list">5. К проведению выездной проверки привлекаются:</p>
                    <p class="list">специалисты:</p>
                    <xsl:for-each select="cf:involvedSpecialists">
                        <xsl:choose>
                            <xsl:when test="cf:involvedSpecialistList">
                                <xsl:for-each select="cf:involvedSpecialistList/cf:involvedSpecialistListItem">
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
                            </xsl:when>
                            <xsl:otherwise>
                                <p class="data">
                                    <xsl:value-of select="cf:notInvolved" />
                                </p>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <p class="under">(указываются фамилии, имена, отчества (при наличии), должности специалистов);</p>
                    <p class="list">эксперты (экспертные организации):</p>
                    <xsl:for-each select="cf:expertOrganizationsOrExperts">
                        <xsl:choose>
                            <xsl:when test="cf:noInvolvedExpertsOrExpertOrganizations">
                                <p class="data">
                                    <xsl:value-of select="cf:noInvolvedExpertsOrExpertOrganizations"/>
                                </p>
                                <p class="under">(указываются фамилии, имена, отчества (при наличии), должности экспертов с указанием сведений о
                                    статусе эксперта в реестре экспертов контрольного (надзорного) органа или наименование экспертной
                                    организации, с указанием реквизитов свидетельства об аккредитации и наименования органа об
                                    аккредитации, выдавшего свидетельство об аккредитации)</p>
                            </xsl:when>
                            <xsl:when test="cf:involvedExpertOrganizationsList">
                                <xsl:for-each select="cf:involvedExpertOrganizationsList/cf:involvedExpertOrganizationsListItem">
                                    <p class="data">
                                        <xsl:value-of select="cf:expertOrganizationName"/><xsl:text> </xsl:text>
                                        свидетельство об аккредитации:
                                        <xsl:value-of select="cf:expertOrganizationDocument/ct:name"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="cf:expertOrganizationDocument/ct:number"/><xsl:text> от </xsl:text>
                                        <xsl:call-template name="formatdate">
                                            <xsl:with-param name="DateStr" select="cf:expertOrganizationDocument/ct:date" />
                                        </xsl:call-template>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="cf:expertOrganizationAccreditationName"/>
                                    </p>
                                </xsl:for-each>
                                <p class="under">(наименование экспертной организации, с указанием реквизитов свидетельства об аккредитации и наименования органа об аккредитации, выдавшего свидетельство об аккредитации)</p>
                            </xsl:when>
                            <xsl:when test="cf:involvedExpertsList">
                                <xsl:for-each select="cf:involvedExpertsList/cf:involvedExpertsListItem">
                                    <p class="data">
                                        <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:firstName"/>
                                        <xsl:if test="ct:middleName">
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="ct:middleName"/>
                                        </xsl:if>
                                        <xsl:text> </xsl:text>
                                        <xsl:value-of select="ct:position"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="cf:expertsRegisterInfo"/>
                                    </p>
                                </xsl:for-each>
                                <p class="under">(указываются фамилии, имена, отчества (при наличии), должности экспертов с указанием сведений о статусе эксперта в реестре экспертов контрольного (надзорного) органа)</p>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:for-each select="cf:controlObject">
                        <p class="list">6. Выездная проверка проводится в отношении:</p>
                        <p class="data">
                            <xsl:value-of select="cf:description"/>
                        </p>
                        <p class="under">(указывается объект контроля в соответствии с положением о виде контроля):</p>
                        <p class="under" style="text-align:left">
                            1) деятельность, действия (бездействие) граждан и организаций, в рамках которых должны
                            соблюдаться обязательные требования, в том числе предъявляемые к гражданам и организациям,
                            осуществляющим деятельность, действия (бездействие);
                            <br/><br/>
                            2) результаты деятельности граждан и организаций, в том числе продукция (товары), работы и услуги, к
                            которым предъявляются обязательные требования;
                            <br/><br/>
                            3) здания, помещения, сооружения, линейные объекты, территории, включая водные, земельные и
                            лесные участки, оборудование, устройства, предметы, материалы, транспортные средства, компоненты
                            природной среды, природные и природно-антропогенные объекты, другие объекты, которыми граждане и
                            организации владеют и (или) пользуются, компоненты природной среды, природные и природно-антропогенные объекты, не находящиеся во владении (и) или пользовании граждан или организаций, к
                            которым предъявляются обязательные требования (производственные объекты)
                        </p>
                    </xsl:for-each>
                    <p class="list">7. Выездная проверка проводится по адресу (местоположению):</p>
                    <p class="data">
                        <xsl:value-of select="cf:controlObjectAddress"/>
                    </p>
                    <p class="under">
                        (указываются адрес (местоположение) места осуществления контролируемым лицом деятельности или
                        адрес (местоположение) нахождения иных объектов контроля, в отношении которых проводится выездная
                        проверка)
                    </p>
                    <xsl:apply-templates select="cf:controlledPerson" />
                    <p class="list">9. При проведении выездной проверки совершаются следующие контрольные (надзорные) действия:</p>
                    <xsl:for-each select="cf:controlActionsList/cf:controlActionsListItem">
                        <p class="data">
                            <xsl:value-of select="cf:controlActionNumber"/>) 
                            <xsl:value-of select="cf:controlActionName"/>
                        </p>
                    </xsl:for-each>
                    <p class="under">(указываются контрольные (надзорные) действия: 1) осмотр; 2) досмотр; 3) опрос; 4) получение
                        письменных объяснений; 5) истребование документов; 6) отбор проб (образцов); 7) инструментальное
                        обследование; 8) испытание; 9) экспертиза; 10) эксперимент).</p>
                    <p class="list">10. Предметом выездной проверки является:</p>
                    <xsl:for-each select="cf:controlSubject">
                        <p class="data">
                            <xsl:value-of select="cf:controlSubjectDescription"/>
                        </p>
                        <xsl:for-each select="cf:technicalRegulationsList/cf:technicalRegulationsListItem">
                            <p class="data">
                                <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                <xsl:value-of select="ct:number"/><xsl:text> </xsl:text>
                                <xsl:value-of select="cf:controlSubjectComment"/>;
                            </p>
                        </xsl:for-each>
                        <xsl:for-each select="cf:projectDocSectionsList/cf:projectDocSectionsListItem">
                            <p class="data">
                                <xsl:value-of select="ct:name"/><xsl:text> </xsl:text>
                                <xsl:value-of select="ct:number"/><xsl:text> </xsl:text>
                                <xsl:value-of select="cf:controlSubjectComment"/>;
                            </p>
                        </xsl:for-each>
                    </xsl:for-each>
                    <p class="under">(указываются: соблюдение обязательных требований/соблюдение требований/исполнение решений)</p>
                    <p class="list">11. При проведении выездной проверки применяются следующие проверочные листы:</p>
                    <xsl:for-each select="cf:testSheets">
                        <xsl:choose>
                            <xsl:when test="cf:testSheetsAreNotApplied">
                                <p class="data">
                                    Проверочные листы не применяются
                                </p>
                            </xsl:when>
                            <xsl:when test="cf:appliedTestSheetsList">
                                <xsl:for-each select="cf:appliedTestSheetsList/cf:appliedTestSheetsListItem">
                                    <p class="data">
                                        <xsl:value-of select="cf:sequenceNumber"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="cf:testSheetName"/>
                                        <xsl:if test="cf:structuralUnits">
                                            <xsl:text> </xsl:text>
                                            <xsl:value-of select="cf:structuralUnits"/>
                                        </xsl:if>
                                        <xsl:text> </xsl:text>
                                        реквизиты акта:
                                        <xsl:value-of select="cf:checklistApprovingAct/ct:name"/><xsl:text> </xsl:text>
                                        <xsl:value-of select="cf:checklistApprovingAct/ct:number"/><xsl:text> от </xsl:text>
                                        <xsl:call-template name="formatdate">
                                            <xsl:with-param name="DateStr" select="cf:checklistApprovingAct/ct:date" />
                                        </xsl:call-template>
                                    </p>
                                </xsl:for-each>
                            </xsl:when>
                        </xsl:choose>
                    </xsl:for-each>
                    <p class="under">(указываются проверочные листы, их структурные единицы (если проверочный лист применяется не в
                        полном объеме), с реквизитами актов, их утверждающих, либо указывается, что проверочные листы не
                        применяются)
                    </p>
                    <xsl:for-each select="cf:controlPeriodInfo/cf:controlPeriod">
                        <p class="list">12. Выездная проверка проводится в следующие сроки:</p>
                        <p class="data">
                            c
                            <xsl:call-template name="formatdatetime">
                                <xsl:with-param name="DateTimeStr" select="ct:beginDate"></xsl:with-param>
                            </xsl:call-template>
                            по
                            <xsl:call-template name="formatdatetime">
                                <xsl:with-param name="DateTimeStr" select="ct:endDate"></xsl:with-param>
                            </xsl:call-template>
                        </p>
                        <p class="under">указываются дата и время (при необходимости указывается также часовой пояс) начала выездной
                            проверки, ранее наступления которых проверка не может быть начата, а также дата и время (при
                            необходимости указывается также часовой пояс), до наступления которых выездная проверка должна быть
                            закончена, если не будет принято решение о приостановлении проведения выездной проверки)
                        </p>
                    </xsl:for-each>
                    <xsl:for-each select="cf:controlPeriodInfo/cf:interactionPeriod">
                        <p class="list">Срок непосредственного взаимодействия с контролируемым лицом составляет не более:</p>
                        <p class="data">
                            <xsl:value-of select="cf:hours"/> ч. 
                            <xsl:value-of select="cf:minutes"/> мин.
                        </p>
                        <p class="under">(указывается срок (часы, минуты), в пределах которого осуществляется непосредственное взаимодействие с контролируемым лицом)</p>
                    </xsl:for-each>
                    <p class="list">13. В целях проведения выездной проверки контролируемому лицу необходимо представить следующие документы:</p>
                    <p class="data">
                        <xsl:choose>
                            <xsl:when test="cf:controlledPerson/ct:organization/ct:legalEntity">
                                <xsl:value-of select="cf:controlledPerson/ct:organization/ct:legalEntity/ct:name" />
                            </xsl:when>
                            <xsl:when test="cf:controlledPerson/ct:organization/ct:individualEntrepreneur">
                                <xsl:value-of select="cf:controlledPerson/ct:organization/ct:individualEntrepreneur/ct:lastName" /><xsl:text> </xsl:text>
                                <xsl:value-of select="cf:controlledPerson/ct:organization/ct:individualEntrepreneur/ct:firstName" />
                                <xsl:if test="cf:controlledPerson/ct:organization/ct:individualEntrepreneur/ct:middleName">
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="cf:controlledPerson/ct:organization/ct:individualEntrepreneur/ct:middleName" />
                                </xsl:if>
                                <xsl:text> </xsl:text>
                            </xsl:when>
                            <xsl:when test="cf:controlledPerson/ct:individual">
                                <xsl:value-of select="cf:controlledPerson/ct:individual/ct:lastName"/><xsl:text> </xsl:text>
                                <xsl:value-of select="cf:controlledPerson/ct:individual/ct:firstName"/>
                                <xsl:if test="cf:controlledPerson/ct:individual/ct:middleName">
                                    <xsl:text> </xsl:text>
                                    <xsl:value-of select="cf:controlledPerson/ct:individual/ct:middleName"/>
                                </xsl:if>
                            </xsl:when>
                        </xsl:choose>
                        <xsl:value-of select="cf:providedDocsInfo/cf:providedDocsList"/>
                    </p>
                    <p class="under">(указывается контролируемое лицо (гражданин, организация) и перечень документов, представление которых необходимо для проведения выездной проверки)</p>
                    <p class="list">14. Указание иных сведений</p>
                    <p class="data">
                        <xsl:value-of select="cf:providedDocsInfo/cf:additionalInfo"/>
                    </p>
                    <p class="under">(указываются иные сведения, предусмотренные положением о виде контроля)</p>
                </xsl:for-each>
                <xsl:for-each select="cf:controlledPersonSignedPart/cf:gsnInfo/cf:supervisoryAuthorityRepresentativesInfo">
                    <xsl:for-each select="cf:controlDecisionResponsiblePerson">
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
                        </p>
                        <p class="under">(должность, фамилия, инициалы руководителя, заместителя
                            руководителя органа государственного контроля (надзора),
                            органа муниципального контроля, иного должностного лица,
                            принявшего решение о проведении выездной проверки)</p>
                    </xsl:for-each>
                    <xsl:for-each select="cf:controlEventDecisionAuthor">
                        <p class="data">
                            <xsl:value-of select="ct:lastName"/><xsl:text> </xsl:text>
                            <xsl:value-of select="ct:firstName"/>
                            <xsl:if test="ct:middleName">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="ct:middleName"/>
                            </xsl:if>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="ct:position"/>
                            <xsl:text> </xsl:text>
                            <xsl:value-of select="cf:contactInfo/cf:phone"/>
                            <xsl:if test="cf:contactInfo/cf:email">
                                <xsl:text> </xsl:text>
                                <xsl:value-of select="cf:contactInfo/cf:email"/>
                            </xsl:if>
                        </p>
                        <p class="under">(фамилия, имя, отчество (при наличии) и должность должностного лица, непосредственно подготовившего проект решения, контактный телефон, электронный адрес (при наличии)</p>
                    </xsl:for-each>
                </xsl:for-each>
                <xsl:for-each select="cf:controlledPersonSignedPart">
                    <xsl:if test="cf:emailSendingInfo">
                        <table border="2" style="border-collapse:collapse; width: 100%">
                            <tr>
                                <td>
                                    <p class="list" style="text-align: center">
                                        Отметка о направлении решения в электронном виде (на электронный адрес:
                                        <span class="data">
                                            <xsl:value-of select="cf:emailSendingInfo/ct:email"/>
                                        </span>), 
                                        в том числе через личный кабинет на специализированном электронном портале
                                    </p>
                                </td>
                            </tr>
                        </table>
                        <br/>
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
    
    <xsl:template
        name="initials">
        <xsl:param name="NameStr" />
        
        <xsl:if test="$NameStr !=''">
            <xsl:variable name="i">
                <xsl:value-of select="substring($NameStr, 1, 1)" />
            </xsl:variable>
            
            <xsl:value-of select="concat($i, '.')" />
        </xsl:if>
    </xsl:template>
    
    <xsl:template name="controlEventProsecutorApproval">
        <xsl:param name="approval" />
        <xsl:choose>
            <xsl:when test="$approval ='Согласовано'">
                <xsl:value-of select="'согласована'" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'не согласована'" />
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
    
    <xsl:template match="cf:developer">
        <xsl:choose>
            <xsl:when test="ct:organization/ct:legalEntity">
                <p class="data">
                    <xsl:value-of select="ct:organization/ct:legalEntity" />
                </p>
                <p class="under">указываются наименование, ОГРН, ИНН,
                    место нахождения, телефон/факс юридического лица ответственного за соответствие обязательным требованиям объекта контроля, в отношении которого планируется выездная проверка</p>
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
                <p class="under">указываются фамилия, имя, отчество, адрес места жительства, ОГРНИП, ИНН индивидуального предпринимателя ответственного за соответствие обязательным требованиям объекта контроля, в отношении которого планируется выездная проверка</p>
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
                <p class="under">указываются фамилия, имя, отчество, паспортные данные,
                    адрес места жительства, телефон/факс гражданина, ответственного за соответствие обязательным требованиям объекта контроля, в отношении которого планируется выездная проверка</p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="cf:controlledPerson">
        <p class="list">8. Контролируемое лицо:</p>
        <xsl:choose>
            <xsl:when test="ct:organization/ct:legalEntity">
                <p class="data">
                    <xsl:value-of select="ct:organization/ct:legalEntity" />
                </p>
                <p class="under">наименование, ОГРН, ИНН,
                    место нахождения юридического лица, телефон/факс,</p>
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
                <p class="under">фамилия, имя,
                    отчество, адрес места жительства, ОГРНИП, ИНН индивидуального предпринимателя</p>
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
                <p class="under">фамилия, имя, отчество, паспортные данные,
                    адрес места жительства, телефон/факс</p>
            </xsl:when>
        </xsl:choose>
        <xsl:if test="ct:organization/ct:sro">
            <p class="data">
                <xsl:value-of select="ct:organization/ct:sro"/>
            </p>
            <p class="under">наименование, ОГРН, ИНН саморегулируемой организации</p>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
