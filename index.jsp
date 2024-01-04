<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.sql.Date"%>
<%@page import="peod.Log"%>
<%@page import="peod.Wish"%>
<%@page autoFlush="true" buffer="1094kb"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<jsp:useBean id="mail" scope="session" class="jMail.Mail" />
<jsp:useBean id="mail1" scope="session" class="jMail.Mail1" />
<jsp:useBean id="mail2" scope="session" class="jMail.Mail2" />
<jsp:useBean id="dbBean" scope="session" class="peod.Procesa" />
<%-- 
    Document   : index
    Created on : Sep 27, 2013
    Author     : Fernando
--%>

<jsp:include page="indexscript.jsp" />
<script language="javascript" type="text/javascript" src="../js/datetimepicker.js">
    //For this script, visit http://www.javascriptkit.com/script/script2/tengcalendar.shtml 
</script>

<c:set var="localhost" scope="session" value="vanondemand.no-ip.biz"/>
<% // same at sendmail.jsp %>

<c:if test="${user == null}">
    <jsp:forward page="login.jsp"/>
</c:if>
<c:if test="${user.padrino == 0}">
    <jsp:forward page="logoff.jsp"/>
</c:if>
<!-- if driver registered in port day, go to self Inspect -->
<c:if test="${user.hack > 0}">
    <sql:query var="selfQuery" dataSource="jdbc/PEODGT">
        SELECT * FROM dailyreg WHERE DATEDIFF(entered,NOW()) = 0 AND hack = ${user.hack} AND inspected IS NULL
    </sql:query>
    <c:if test="${not empty selfQuery.rows[0]}">
        <jsp:forward page="selfInspect.jsp"/>            
    </c:if>
</c:if>

<jsp:include page="../inc/header.jsp" />

<c:if test="${param.submit=='Move'}">
    <sql:query var="oldPierQuery" scope="session" dataSource="jdbc/PEODGT">
        SELECT pier FROM signin WHERE tripNumber = ${param.tripNumber}
    </sql:query>
    <%
        String tripNumber1 = request.getParameter("tripNumber");
        String pier1 = request.getParameter("pier");
        String sqla = "UPDATE signin SET pier = " + pier1 + " WHERE tripNumber = " + tripNumber1 + " AND pier != " + pier1;
        String userId0 = request.getParameter("user_id");
        int affected = dbBean.sendSql(sqla);
        if (affected > 0) {
            sqla = "INSERT INTO triplog (tripNumber,user_id,pier,timed) VALUES (" + tripNumber1 + "," + userId0 + "," + pier1 + ",NOW());";
            dbBean.sendSql(sqla);
            // notify driver at 10 turns later, only if first time pier assigned
    %>
    <c:if test="${oldPierQuery.rows[0].pier == '0'}">
        <sql:query var="notifQuery" dataSource="jdbc/PEODGT">
            SELECT * FROM wish WHERE DATEDIFF(dated,NOW()) = 0 AND info = 'Stop Drivers' AND comments = 'from getting Mobile Notifications today'
        </sql:query>
        <c:if test="${empty notifQuery.rows[0]}">
            <sql:query var="turnQuery" dataSource="jdbc/PEODGT">
                SELECT turn FROM signin WHERE tripNumber = ${param.tripNumber}
            </sql:query>
            <sql:query var="laterQuery" dataSource="jdbc/PEODGT">
                SELECT hack FROM signin WHERE DATEDIFF(dated,NOW()) = 0 AND turn = ${turnQuery.rows[0].turn + 20}
            </sql:query>
            <c:if test="${not empty laterQuery.rows[0]}">
                <sql:query var="phoneQuery" dataSource="jdbc/PEODGT">
                    SELECT email,telefonos,carrier,nombres,apellidos FROM usuario WHERE hack = ${laterQuery.rows[0].hack}
                </sql:query>
                <c:set var="driver" value="${phoneQuery.rows[0]}"/>
                <c:set var="mailto" value="${driver.email}"/>
                <c:if test="${driver.carrier > 0}">
                    <c:set var="number" value="${driver.telefonos}"/>
                    <sql:query var="domainQuery" dataSource="jdbc/PEODGT">
                        SELECT domain FROM carrier WHERE carrier_id = ${driver.carrier}
                    </sql:query>
                    <c:set var="domain" value="${domainQuery.rows[0].domain}"/>
                    <c:if test="${user.user_id == 1}">
                        <c:set var="domain" value="@doylet.org"/>
                    </c:if>
                    <c:set var="mailto" value="${number}${domain}"/>
                </c:if>
                <jsp:setProperty name="mail" property="to" value="${mailto}" />
                <jsp:setProperty name="mail" property="smtpServ" value="smtp.gmail.com" />
                <jsp:setProperty name="mail" property="subject" value="Your turn at Van On Demand will be called soon" />
                <jsp:setProperty name="mail" property="message" value="${driver.nombres} ${driver.apellidos}, you are 20 turns away from dispatch. Be ready at the holding lot. Don't loose your turn and money!" />
                <%
                    mail1.sendMail();
                %>
            </c:if>
        </c:if>
    </c:if>
    <%
        }
    %>
</c:if>
<!-- jsp:include page="indexactions.jsp" -->
<!-- submit = Add Your Van -->
<c:if test="${param.submit=='Add Your Van'}">
    <sql:query var="compQuery" dataSource="jdbc/PEODGT">
        SELECT company_id FROM company WHERE owner_id = "${user.user_id}"
    </sql:query>
    <c:if test="${not empty compQuery.rows[0]}">
        <c:set var="ownedCompany" scope="session" value="${compQuery.rows[0].company_id}"/>
    </c:if>
    <sql:query var="carQuery" dataSource="jdbc/PEODGT">
        SELECT * FROM vehicle WHERE vin = "${param.vin}"
    </sql:query>
    <c:set var="nombres" scope="session" value="${user.nombres}"/>
    <c:set var="apellidos" scope="session" value="${user.apellidos}"/>
    <c:if test="${carQuery.rows[0]!=null}">
        <c:set var="carDetails" value="${carQuery.rows[0]}"/>
        <c:set var="carCompany" scope="session" value="${carQuery.rows[0].company_id}"/>
        <c:if test="${not empty carDetails.owner_id}">
            <table><tr><td>
                        <c:if test="${carDetails.owner_id==user.user_id}">
                            Vin # ${param.vin} is already in your list
                        </c:if>
                        <c:if test="${carDetails.owner_id!=user.user_id}">
                            Vin # ${param.vin} already have an owner
                        </c:if>
                    </td></tr></table>
            <p></p>
        </c:if>
        <c:if test="${empty carDetails.owner_id}">
            <%
                String vinNumber = request.getParameter("vin");
                String owner_id = request.getParameter("user_id");
                String firstnames = session.getAttribute("nombres").toString();
                String lastnames = session.getAttribute("apellidos").toString();
                String sql = "UPDATE vehicle SET owner_id = " + owner_id + ", owner_name = '" + lastnames + ", " + firstnames + "'";
                if (session.getAttribute("ownedCompany") != null) {
                    if (session.getAttribute("carCompany") == null) {
                        sql = sql + ", company_id = " + session.getAttribute("ownedCompany");
                    }
                }
                sql = sql + " WHERE vin = '" + vinNumber + "'";
                dbBean.sendSql(sql);
            %>        
        </c:if>
    </c:if>
    <c:if test="${empty carQuery.rows[0]}">
        <%
            String vinNumber2 = request.getParameter("vin");
            String owner_id2 = request.getParameter("user_id");
            String nombres = session.getAttribute("nombres").toString();
            String apellidos = session.getAttribute("apellidos").toString();
            String sql2 = "INSERT INTO vehicle (vin,owner_id,entered,owner_name) VALUES ('" + vinNumber2 + "'," + owner_id2 + ",NOW(),'" + apellidos + ", " + nombres + "');";
            dbBean.sendSql(sql2);
            if (session.getAttribute("ownedCompany") != null) {
                String sql3 = "UPDATE vehicle SET company_id = " + session.getAttribute("ownedCompany") + " WHERE vin = '" + vinNumber2 + "'";
                dbBean.sendSql(sql3);
            }
        %>
    </c:if>
</c:if>
<!-- param.delVan -->
<c:if test="${not empty param.delVan}">
    <%
        String car_id = request.getParameter("delVan");
        String sql3 = "DELETE FROM vehicle WHERE vehicle_id = " + car_id;
        System.out.println(sql3);
        dbBean.sendSql(sql3);
    %>
</c:if>
<!-- submit = AddLog -->
<c:if test="${param.submit=='AddLog'}">
    <%
        Log log = new Log();
        log.dated = Date.valueOf(request.getParameter("dated"));
        log.info = request.getParameter("info");
        log.comments = request.getParameter("comments");
        String sqlb = "INSERT INTO log (dated,info,comments) VALUES ('" + log.dated + "','" + log.info + "','" + log.comments + "')";
        dbBean.sendSql(sqlb);
    %>
</c:if>
<!-- param.delLog -->
<c:if test="${param.delLog!=null}">
    <%
        String sql4 = "DELETE FROM log WHERE log_id = " + request.getParameter("delLog");
        dbBean.sendSql(sql4);
    %>
</c:if>
<!-- submit = AddWish -->
<c:if test="${param.submit=='AddWish'}">
    <%
        Wish wish = new Wish();
        wish.dated = Date.valueOf(request.getParameter("dated"));
        wish.info = request.getParameter("info");
        wish.comments = request.getParameter("comments");
        String sql5 = "INSERT INTO wish (dated,info,comments) VALUES ('" + wish.dated + "','" + wish.info + "','" + wish.comments + "')";
        dbBean.sendSql(sql5);
    %>
</c:if>
<!-- param.delWish -->
<c:if test="${param.delWish!=null}">
    <%
        String sql6 = "DELETE FROM wish WHERE wish_id = " + request.getParameter("delWish");
        dbBean.sendSql(sql6);
    %>
</c:if>
<!--  param.hack & submit = Move (Move) -->                                
<c:if test="${not empty param.hack}">
    <c:if test="${param.submit=='Move'}">
        <sql:query var="inspectQuery" scope="session" dataSource="jdbc/PEODGT">
            SELECT tag FROM dailyreg WHERE hack = ${param.hack} AND DATEDIFF(entered,NOW()) = 0 
        </sql:query>
        <c:if test="${empty inspectQuery.rows[0].tag}">
            <jsp:forward page="dailyInspect.jsp?hack=${param.hack}"/>
        </c:if>
    </c:if>
</c:if>

<!--  -->
<c:if test="${not empty user.hack}">
    <sql:query var="driverQuery" dataSource="jdbc/PEODGT">
        SELECT * FROM driver WHERE user_id = "${user.user_id}"
    </sql:query>
    <c:set var="drivDetails" scope="session" value="${driverQuery.rows[0]}"/>
</c:if>
<!-- Show Turn & Tickets -->
<sql:query var="ticketQuery" dataSource="jdbc/PEODGT">
    SELECT * FROM ticket WHERE user_id = "${user.user_id}" AND closed = '0' AND where_at = false ORDER BY dated DESC;
</sql:query>

<table><tr><td nowrap>
            Welcome ${user.nombres} ${user.apellidos}!
            <c:if test="${not empty user.hack}">
                <sql:query var="turnQuery" dataSource="jdbc/PEODGT">
                    SELECT turn,signin_id,tripNumber,paid,fare,pier FROM signin WHERE DATEDIFF(NOW(),dated) = 0 AND passengers IS NULL AND hack = ${user.hack}
                </sql:query>
                <c:set var="suTurno" value="${turnQuery.rows[0].turn}"/>
                <c:set var="suTrip" value="${turnQuery.rows[0].tripNumber}"/>
                <c:set var="suId" value="${turnQuery.rows[0].signin_id}"/>
                <c:set var="suPago" value="${turnQuery.rows[0].paid}"/>
                <c:set var="suCobro" value="${turnQuery.rows[0].fare}"/>
                <c:set var="suPier" scope="session" value="${turnQuery.rows[0].pier}"/>
                <sql:query var="nowQuery" dataSource="jdbc/PEODGT">
                    SELECT MAX(turn) AS turn FROM signin WHERE DATEDIFF(NOW(),dated) = 0 AND tripNumber > 0
                </sql:query>
                <c:set var="nowTurno" value="${nowQuery.rows[0].turn}"/>
                <c:if test="${not empty suPier}">
                    <sql:query var="pQuery" dataSource="jdbc/PEODGT">
                        SELECT tipo FROM notify WHERE numero = ${suPier} AND tipo LIKE 'replaceWith:%';
                    </sql:query>
                    <c:set var="p" value="${pQuery.rows[0].tipo}"/>
                </c:if>
                <c:if test="${not empty suTurno}">
                    <p>Your Turn # ${suTurno}
                        <c:if test="${suTurno <= nowTurno}">
                            <button type="button" onClick="JavaScript:window.location = '/PEODGT/jsp/tripBill.jsp?id=${suId}&ok=1';">Trip Sheet ${suTrip}</button>
                            <c:if test="${suCobro != null}">
                                <c:if test="${empty p}">
                                    Pier ${suPier}    
                                </c:if>
                                <c:if test="${not empty p}">
                                    ${fn:substring(p,12,p.length())}
                                </c:if>
                            </c:if>
                        </c:if>
                        <c:if test="${empty nowTurno || suTurno > nowTurno}">
                            <c:if test="${empty suPago}">
                                <sql:query var="paidone" dataSource="jdbc/PEODGT">
                                    SELECT * FROM signin WHERE tripNumber is null AND paid = true AND DATEDIFF(NOW(),dated) > 0 AND hack = ${user.hack}
                                </sql:query>
                                &nbsp; 
                                <c:if test="${not empty paidone.rows[0]}">
                                    <button type="button" onClick="JavaScript:window.location = '/PEODGT/jsp/payCredit.jsp?hack=${user.hack}&turn=${suTurno}';">Pay with Credit</button>
                                </c:if>    
                                <c:if test="${empty paidone.rows[0]}">
                                    <sql:query var="payadvanceQuery" dataSource="jdbc/PEODGT">
                                        SELECT * FROM payadvance WHERE fecha IS NULL AND hack = ${user.hack}
                                    </sql:query>
                                    <c:if test="${not empty payadvanceQuery.rows[0]}">
                                        <button type="button" onClick="JavaScript:window.location = '/PEODGT/jsp/payAdvance.jsp?hack=${user.hack}&turn=${suTurno}';">Pay with Balance (${payadvanceQuery.rowCount})</button>
                                    </c:if>
                                    <c:if test="${empty payadvanceQuery.rows[0]}">
                                        <font color="red">Please Pay</font>                     
                                    </c:if>    
                                </c:if>    
                            </c:if>
                            <c:if test="${not empty suPago}">
                                &nbsp; <font color="green">Paid</font>

                                <sql:query var="verify2Query" dataSource="jdbc/PEODGT">
                                   SELECT * FROM payadvance WHERE DATEDIFF(dated,NOW()) = 0 AND turno = ${suTurno} AND hack = ${user.hack}
                                </sql:query>

                                <sql:query var="tenQuery" dataSource="jdbc/PEODGT">
                                    SELECT * FROM advanced WHERE used IS NULL AND hack = ${user.hack} AND turnos > 9
                                </sql:query>

                                <c:if test="${usuarioId == 3 || usuarioId == 87 || usuarioId == 140 || usuarioId == 6 || not empty verify2Query.rows[0]}">
                                    &nbsp; <button type="button" onClick="JavaScript:window.location = '/PEODGT/jsp/cancelTurn.jsp?hack=${user.hack}&turn=${suTurno}';">Remove Payment</button>
                                </c:if>

                            </c:if>
                            <c:if test="${not empty nowTurno}">
                                &nbsp; &nbsp; &nbsp; Now Serving # ${nowTurno}
                            </c:if>
                        </c:if>
                        <br>
                    </c:if>

                    <c:if test="${empty suTurno}">
                        <sql:query var="doneQuery" dataSource="jdbc/PEODGT">
                            SELECT turn,signin_id,tripNumber,paid,fare,pier FROM signin WHERE DATEDIFF(NOW(),dated) = 0 AND passengers > 0 AND hack = ${user.hack}
                        </sql:query>
                        <c:if test="${not empty doneQuery.rows[0]}">
                            <br>Your Trips: 
                            <c:forEach var="row" items="${doneQuery.rows}">
                                <a href="tripBill.jsp?id=${row.signin_id}">${row.tripNumber}</a> - 
                            </c:forEach>
                        </c:if>
                        <sql:query var="gtQuery" dataSource="jdbc/PEODGT">
                            SELECT * FROM notify WHERE tipo = "driversNewTurns" AND DATEDIFF(NOW(),fecha) = 0
                        </sql:query>
                        <c:if test="${not empty gtQuery.rows[0]}">
                            <sql:query var="premiumQuery" dataSource="jdbc/PEODGT">
                                SELECT * FROM driver WHERE user_id = ${user.user_id} AND premium = true
                            </sql:query>
                            <c:if test="${not empty premiumQuery.rows[0]}">
                                <sql:query var="tripNowQuery" dataSource="jdbc/PEODGT">
                                    SELECT * FROM signin WHERE DATEDIFF(NOW(),dated) = 0 AND hack = ${user.hack} AND passengers IS NULL
                                </sql:query>
                                <c:if test="${empty tripNowQuery.rows[0]}">
                                    <sql:query var="outsQuery" dataSource="jdbc/PEODGT">
                                        SELECT COUNT(*) AS count FROM signin WHERE DATEDIFF(NOW(),dated) = 0 AND paid IS NULL AND hack = ${user.hack}
                                    </sql:query>
                                    <c:if test="${outsQuery.rows[0].count < 3}">
                                        <sql:query var="lastTripQuery" dataSource="jdbc/PEODGT">
                                            SELECT MAX(turn) AS ultimo FROM signin WHERE DATEDIFF(NOW(),dated) = 0 AND passengers IS NOT NULL AND hack = ${user.hack}
                                        </sql:query>
                                        <c:if test="${not empty lastTripQuery.rows[0]}">
                                            <c:set var="lastTrip" value="${lastTripQuery.rows[0].ultimo}" />
                                            <c:if test="${not empty lastTrip}">
                                                <sql:query var="pasadoQuery" dataSource="jdbc/PEODGT">
                                                    SELECT MAX(turn) AS pasado FROM signin WHERE DATEDIFF(NOW(),dated) = 0 AND hack = ${user.hack}
                                                </sql:query>
                                                <c:set var="pasadoTrip" value="${pasadoQuery.rows[0].pasado}" />
                                                <c:if test="${pasadoTrip == lastTrip}">
                                                    <button type="button" onClick="JavaScript:window.location = '/PEODGT/jsp/getTurn.jsp?hack=${user.hack}';">Get Turn</button>
                                                </c:if> <%-- IF LAST CLOSED TRIP IS LATEST TRIP --%>
                                            </c:if> <%-- IF LAST CLOSED TRIP NOT EMPTY --%>
                                        </c:if> <%-- IF DRIVER HAS OR HAD A CLOSED TRIP --%>
                                    </c:if> <%-- IF DRIVER HAS < 3 OUTS --%>
                                </c:if> <%-- IF DRIVER IS NOT IN A TRIP NOW --%>
                                <c:if test="${user.padrino != null }">
                                    <sql:query var="firstTripQuery" dataSource="jdbc/PEODGT">
                                        SELECT MAX(turn) FROM signin WHERE DATEDIFF(NOW(),dated) = 0 AND hack = ${user.hack}
                                    </sql:query>
                                    <c:if test="${empty firstTripQuery.rows[0]}"> 
                                        <sql:query var="anyTripQuery" dataSource="jdbc/PEODGT">
                                            SELECT MAX(turn) FROM signin WHERE DATEDIFF(NOW(),dated) = 0 AND passengers IS NOT NULL
                                        </sql:query>
                                        <c:if test="${not empty anyTripQuery.rows[0]}">
                                            <button type="button" onClick="JavaScript:window.location = '/PEODGT/jsp/getTurn.jsp?hack=${user.hack}';">Get Turn</button>
                                        </c:if> <%-- IF SOMEONE HAD A TRIP OR OUT TODAY --%>
                                    </c:if> <%-- IF DRIVER HAD NO TURN TODAY --%>
                                </c:if> <%-- IF DRIVER IS ACTIVE --%>
                            </c:if> <%-- IF DRIVER IS PREMIUM --%>
                        </c:if> <%-- IF DRIVERS CAN GET NEW TURNS --%>
                    </c:if> <%-- IF NO TURN --%>
                </c:if> <%-- IF DRIVER --%>
                <c:if test="${not empty ticketQuery}">
                    <c:forEach var="row" items="${ticketQuery.rows}">
                        <br>See the [<a href='ticketReply.jsp?id=${row.ticket_id}'>reply</a>] <a title='${row.dated}'><font color='blue'>${fn:substring(row.dated,5,10)}</font></a> ${row.subject}
                        </c:forEach>
                    </c:if>
        </td></tr></table>
<p></p>

<c:if test="${user.padrino == null }">
    <c:if test="${not empty user.hack || not empty user.ssn}">
        <table><tr><td nowrap>
                    <p>
                        Your information will be reviewed shortly. Thank You!
                    <p>
                </td></tr></table>
            </c:if>
        </c:if>

<c:if test="${user.padrino != null }">
    <c:if test="${user.nivel != 'M'}">
        <c:if test="${empty user.signDCinitials}">
            <jsp:forward page="dresscode.jsp?id=${user.user_id}"/>
        </c:if>
    </c:if>
    <c:if test="${user.nivel == 'A'}">
        <table><tr><td nowrap>

                    <c:if test="${empty pendingCount}">
                        <sql:query var="countQuery" dataSource="jdbc/PEODGT">
                            SELECT COUNT(*) AS counter FROM usuario WHERE padrino is null AND signDCinitials is not null AND nombres is not null
                        </sql:query>
                        <c:set var="pendingCount" scope="session" value="${countQuery.rows[0].counter}"/>
                    </c:if>       
                    <c:if test="${empty pendingCount2}">
                        <sql:query var="countQuery2" dataSource="jdbc/PEODGT">
                            SELECT COUNT(*) AS counter FROM vehicle WHERE padrino IS NOT null
                        </sql:query>
                        <c:set var="pendingCount2" scope="session" value="${countQuery2.rows[0].counter}"/>
                    </c:if>       
                    <c:if test="${empty pendingCount3}">
                        <sql:query var="countQuery3" dataSource="jdbc/PEODGT">
                            SELECT COUNT(*) AS counter FROM company WHERE padrino IS NOT null
                        </sql:query>
                        <c:set var="pendingCount3" scope="session" value="${countQuery3.rows[0].counter}"/>
                    </c:if>       
                    <c:if test="${pendingCount > 0}">
                        <button type="button" style="background-color:yellow" onClick="JavaScript:window.location = 'inactive.jsp';">${pendingCount} inactive user(s)</button>
                    </c:if>       
                    <c:if test="${pendingCount2 > 0}">
                        <button type="button" style="background-color:yellow" onClick="JavaScript:window.location = 'inactiveCars.jsp';">${pendingCount2} inactive vehicle(s)</button>
                    </c:if> 
                    <c:if test="${pendingCount3 > 0}">
                        <button type="button" style="background-color:yellow" onClick="JavaScript:window.location = 'inactiveComp.jsp';">${pendingCount3} inactive companies</button>
                    </c:if> 
                    <p>
                        <button type="button" onClick="JavaScript:window.location = 'userList.jsp';" title="${usuariosCount}" >Users</button>
                        <button type="button" onClick="JavaScript:window.location = 'compList.jsp';" title="${companiasCount}" >Companies</button>
                        <button type="button" onClick="JavaScript:window.location = 'drivList.jsp';" title="${driversCount}" >Drivers</button>
                        <button type="button" onClick="JavaScript:window.location = 'carList.jsp';" title="${carsCount}" >Vehicles</button>
                        <button type="button" onClick="JavaScript:window.location = 'disList.jsp';" title="${dispatchersCount}" >Dispatchers</button>
                </td></tr><tr><td>

                    <button type="button" onClick="JavaScript:window.location = 'updates.jsp';">Updates</button>
                    <button type="button" onClick="JavaScript:window.location = 'reportIssues.jsp';">Issues</button>
                    <button type="button" onClick="JavaScript:window.location = 'invite.jsp';">Invite</button>

                    <c:if test="${empty onePass}">
                        <c:set var="onePass" scope="session" value="loaded"/>
                    </c:if>

                    <c:if test="${empty openTickets}">
                        <sql:query var="pendingTickets" dataSource="jdbc/PEODGT">
                            SELECT COUNT(*) AS tickets FROM ticket WHERE where_at = '1' AND closed = '0'
                        </sql:query>
                        <c:set var="openTickets" value="${pendingTickets.rows[0].tickets}"/>
                    </c:if>
                    <c:if test="${openTickets > 0}">
                        <button type="button" style="background-color:yellow" onClick="JavaScript:window.location = 'ticketList.jsp';">${openTickets} Open Tickets</button>
                    </c:if>
                    <c:if test="${openTickets == 0}">
                        <sql:query var="allTickets" dataSource="jdbc/PEODGT">
                            SELECT * FROM ticket
                        </sql:query>
                        <c:set var="firstTicket" value="${allTickets.rows[0]}"/>
                        <c:if test="${not empty firstTicket}">
                            <button type="button" onClick="JavaScript:window.location = 'ticketList.jsp';">Support Tickets</button>
                        </c:if>
                    </c:if>
                    <button type="button" onClick="JavaScript:window.location = 'status.jsp';">Status</button>
                </td></tr></table>
            </c:if>

    <c:if test="${user.nivel == 'M'}"> <% // was M %>
        <p></p>
        <table><tr><td nowrap>
                    <button type="button" onClick="JavaScript:window.location = 'compList.jsp';" title="${companiasCount}" >Companies</button>
                    <button type="button" onClick="JavaScript:window.location = 'drivList.jsp';" title="${driversCount}" >Drivers</button>
                    <button type="button" onClick="JavaScript:window.location = 'carList.jsp';" title="${carsCount}" >Vehicles</button>
                    <button type="button" onClick="JavaScript:window.location = 'insList.jsp';" title="${inspectorsCount}" >Monitors</button>
                </td></tr></table>
            </c:if>

    <c:if test="${not empty user.hack && suCobro != null && suPier > 0}">
        <p></p>
        <table><tr><td>
                    <b>Receiving at 
                        <c:if test="${empty p}">
                            berth ${suPier}    
                        </c:if>
                        <c:if test="${not empty p}">
                            ${fn:substring(p,12,p.length())}
                        </c:if>
                    </b>
                    <p>
                        <jsp:include page="../inc/expecting.jsp" >
                            <jsp:param name="thePier" value="${suPier}" />
                        </jsp:include>
                </td></tr></table>
            </c:if>
            <c:if test="${not empty portDay}">
                <c:if test="${not empty user.ssn}">
            <p></p>
            <c:if test="${user.supervisor == null}">
                <table><tr><td>
                            [Dispatcher Access Pending]
                        </td></tr></table>
                    </c:if>
            <table><tr><td>
                        <c:if test="${user.supervisor > -1 && user.supervisor < 90}">
                            <button type="button" onClick="JavaScript:window.location = 'receiving.jsp';">Receive Vans at Pier ${user.supervisor}</button>
                        </c:if>
                        <c:if test="${ user.supervisor == 0 || user.supervisor > 90 || (user.supervisor > 0 && empty busy) }"> <% // DISPATCHER IN LOT added all others %>
                            <c:if test="${empty superDispatcher}">
                                <sql:query var="superQuery" dataSource="jdbc/PEODGT">
                                    SELECT supervisor FROM usuario WHERE user_id = 1 AND supervisor = ${user.user_id}
                                </sql:query>
                                <c:set var="superDispatcher" scope="session" value="${superQuery.rows[0].supervisor}"/> 
                            </c:if>
                            <c:if test="${user.user_id == superDispatcher}">
                                <button type="button" onClick="JavaScript:window.location = 'reportIssues.jsp';">Issues</button>
                            </c:if>
                            <button type="button" onClick="JavaScript:window.location = 'dailyReg.jsp';">Daily Registration</button>
                            <sql:query var="regs" dataSource="jdbc/PEODGT">
                                SELECT * FROM dailyreg WHERE DATEDIFF(NOW(),entered) = 0 LIMIT 1
                            </sql:query>
                            <c:if test="${not empty regs.rows[0]}">                            
                                <button type="button" onClick="JavaScript:window.location = 'dailyInspect.jsp';">Inspection</button>
                                <c:if test="${user.user_id == superDispatcher}">
                                    <button type="button" onClick="JavaScript:window.location = 'dailyRaffle.jsp';">Lotto</button>
                                    <button type="button" onClick="JavaScript:window.location = 'tripAdd.jsp';">Trip Sheet Generator</button>
                                </c:if>
                            </c:if>
                        </c:if>

                        <c:if test="${user.supervisor == 98}"> <% // CASHIER %>
                            <button type="button" onClick="JavaScript:window.location = '/PEODGT/jsp/paying.jsp';">Get Payments</button>
                            <p>
                            </c:if>

                            <c:if test="${user.supervisor == 99}"> <% // CLERK %>
                                <b>Terminal Assignments</b>
                            <p>
                                <sql:query var="tripQuery" scope="session" dataSource="jdbc/PEODGT">
                                    SELECT * FROM signin WHERE tripNumber > 0 AND destination IS NULL AND passengers IS NULL AND DATEDIFF(dated,NOW()) = 0 order by tripNumber
                                </sql:query>
                                <sql:query var="arrivalQuery" scope="session" dataSource="jdbc/PEODGT">
                                    SELECT * FROM arrival WHERE DATEDIFF(entry,NOW()) = 0 ORDER BY berth
                                </sql:query>
                            <form action="index.jsp" name="formAssign" method="post" onSubmit="return formAssCheck();" >
                                Assign  
                                <select name="tripNumber" size="1"> <% //${tripQuery.rowCount} %>
                                    <option value=""></option>
                                    <c:forEach var="row1" items="${tripQuery.rows}">
                                        <sql:query var="inspectQuery" scope="session" dataSource="jdbc/PEODGT">
                                            SELECT tag FROM dailyreg WHERE hack = ${row1.hack} AND DATEDIFF(entered,NOW()) = 0 
                                        </sql:query>
                                        <option value="${row1.tripNumber}" >Hack # ${row1.hack} &nbsp; &nbsp; &nbsp; Trip # ${row1.tripNumber} &nbsp; &nbsp; &nbsp; Pier # ${row1.pier} <c:if test="${empty inspectQuery.rows[0].tag}">&nbsp; &nbsp; &nbsp; Not Inspected</c:if></option>
                                    </c:forEach>
                                </select><br>
                                To Terminal #
                                <select name="pier" required >
                                    <option value=""></option>
                                    <c:forEach var="row2" items="${arrivalQuery.rows}">
                                        <option value="${row2.berth}" <c:if test="${todayCount > 0 && lastPier == row2.berth}">selected</c:if> >${row2.berth}</option>
                                    </c:forEach>        
                                </select>
                                <input type="hidden" name="user_id" value="${user.user_id}">
                                <input type="submit" id="formAssignMove" value="Move" name="submit" />
                                <input type="hidden" id="formAssignMove2" value="Please Wait" name="submit" />
                            </form>
                            <p> &nbsp; <p align="right">
                            </c:if>

                    </td></tr></table>
                </c:if>
            </c:if>
        </c:if>

<c:if test="${not empty user.hack || (user.padrino!=null && not empty user.ssn)}">
    <sql:query var="premiumQuery" dataSource="jdbc/PEODGT">
        SELECT * FROM driver WHERE user_id = ${user.user_id} AND premium = true
    </sql:query>
    <c:if test="${not empty premiumQuery.rows[0] || (user.padrino!=null && not empty user.ssn)}">
        <sql:query var="ctrlQuery" dataSource="jdbc/PEODGT">
            SELECT * FROM rosterctrl WHERE DATEDIFF(NOW(),dated) <= 0 AND maxtemps > 0 AND opened = 'Y'
        </sql:query>
        <c:if test="${not empty ctrlQuery.rows[0]}">
            <p></p>
            <table><tr><td>
                        <button type="button" onClick="JavaScript:window.location = 'rosterdays.jsp';">Future Port Days</button>
                    </td></tr></table>
                </c:if>            
            </c:if>            
        </c:if>

<c:if test="${not empty user.hack}">
    <p></p>
    <table><tr><td>
                <c:if test="${empty drivDetails.user_id}">
                    <jsp:forward page="userChange.jsp?id=${user.user_id}"/>
                </c:if>
                <c:if test="${empty drivDetails.company_id}">
                    <p>Thank you for registering as a driver.<br>In order to participate in the lotto with your hack license, you are required to be working for a company that has registered with the program van on demand. <font color="red">Please instruct the company owner to include you within their company profile, prior to showing for Port operations.</font>
                    </c:if>
                <p><button type="button" onClick="JavaScript:window.location = 'driver.jsp?id=${drivDetails.driver_id}';" title="${user.email}">Your Driver Profile</button>
                    <sql:query var="hacksQuery" dataSource="jdbc/PEODGT">
                        SELECT hackExpire FROM driver WHERE user_id = ${user.user_id} AND DATEDIFF(hackExpire,NOW()) < 7
                    </sql:query>
                    <c:if test="${not empty hacksQuery.rows[0]}">
                        <font color="red"> <-- Hack expiring</font>
                    </c:if>
                    <c:if test="${empty hacksQuery.rows[0]}">
                        <c:if test="${not empty drivDetails.portIdExpire}">
                            <sql:query var="pidQuery" dataSource="jdbc/PEODGT">
                                SELECT nombres FROM driver WHERE driver_id = ${drivDetails.driver_id} AND DATEDIFF(portIdExpire,NOW()) < 7
                            </sql:query>
                            <c:if test="${not empty pidQuery.rows[0]}">
                                <font color="red"> <-- Port ID expiring</font>
                            </c:if>
                        </c:if>
                    </c:if>
                    <sql:query var="cars" dataSource="jdbc/PEODGT">
                        SELECT * FROM vehicle WHERE owner_id = ${user.user_id} OR (owner_id = 0 AND company_id IN (SELECT company_id FROM company WHERE owner_id = ${user.user_id} OR manager_id = ${user.user_id}))
                    </sql:query>
                    <c:if test="${cars.rows[0]!=null}">
                    <p>Your Van(s):<br>
                        <c:forEach var="row" items="${cars.rows}">
                            <c:if test="${row.make!=null}">
                                <button type="button" onClick="JavaScript:window.location = 'car.jsp?id=${row.vehicle_id}';" title="${row.vin}">${row.yearMade} ${row.make}, ${row.tag}</button>
                                <c:if test="${empty row.company_id}">
                                    <font color="red"><-- not working for a company yet. This van can not participate.</font>
                                </c:if>
                                <c:if test="${not empty row.company_id}">
                                    <sql:query var="insQuery" dataSource="jdbc/PEODGT">
                                        SELECT insExpire FROM vehicle WHERE vehicle_id = ${row.vehicle_id} AND DATEDIFF(insExpire,NOW()) < 7
                                    </sql:query>
                                    <c:if test="${not empty insQuery.rows[0]}">
                                        <font color="red"><-- Insurance expiring</font>
                                    </c:if>
                                    <c:if test="${empty insQuery.rows[0]}">
                                        <sql:query var="miaIdQuery" dataSource="jdbc/PEODGT">
                                            SELECT miaIdExpire FROM vehicle WHERE vehicle_id = ${row.vehicle_id} AND DATEDIFF(miaIdExpire,NOW()) < 7
                                        </sql:query>
                                        <c:if test="${not empty miaIdQuery.rows[0]}">
                                            <font color="red"><-- MIA Port Permit expiring</font>
                                        </c:if>
                                        <c:if test="${empty miaIdQuery.rows[0]}">
                                            <sql:query var="LLVuntilQuery" dataSource="jdbc/PEODGT">
                                                SELECT numero FROM notify WHERE tipo = 'LLVuntil'
                                            </sql:query>
                                            <c:set var="LLVuntil" value="${LLVuntilQuery.rows[0].numero}"/>                                            
                                            <sql:query var="llvQuery" dataSource="jdbc/PEODGT">
                                                SELECT gtp FROM vehicle WHERE vehicle_id = ${row.vehicle_id} AND gtp NOT LIKE '${LLVuntil}%'
                                            </sql:query>
                                            <c:if test="${not empty llvQuery.rows[0]}">
                                                <font color="red"> <-- BC GTP LL/V # expired</font>
                                            </c:if>
                                            <c:if test="${empty llvQuery.rows[0]}">
                                                <c:if test="${not empty row.padrino}">
                                                    <font color="red"> <-- Inactive</font>
                                                </c:if>    
                                            </c:if>
                                        </c:if>
                                    </c:if>
                                </c:if>
                            </c:if>
                            <c:if test="${row.make==null}">
                                <a href="carChange.jsp?id=${row.vehicle_id}">${row.vin}</a> <font color="red"><-- click to complete</font> or <a href="index.jsp?id=${param.id}&delVan=${row.vehicle_id}">delete</a>
                            </c:if>                   
                            <br>
                        </c:forEach>
                    </c:if>
                    <c:if test="${user.user_id!='3'}">
                    <p>
                        <c:if test="${user.padrino==null}"><font color="blue"></c:if>
                        <font color="blue">Do you own a<c:if test='${cars.rows[0]!=null}'>nother</c:if> Van with BC GTP LL/V permit?</font><br>
                        <c:if test="${user.padrino==null}"></font></c:if>
                            <input type="radio" name="newvan" id="newvan_Y" value="Y" onChange="showForm();" />Yes -  
                            <input type="radio" name="newvan" id="newvan_N" value="N" checked onChange="hideForm();" />No
                        <div id="showform" style="display:none">
                            <form action="index.jsp" name="forma" method="post" onSubmit="return formCheck();" >
                                Vin #: <input type="text" name="vin" value="" size="17" maxlength="17" />
                                <input type="hidden" name="user_id" value="${user.user_id}">
                            <input type="hidden" name="id" value="${param.id}">
                            <input type="submit" value="Add Your Van" name="submit" />
                        </form>
                    </div>
                </c:if>

            </td></tr></table>

    <c:if test="${empty compDetails}">
        <% System.out.println("compDetails");%>
        <sql:query var="compQuery" dataSource="jdbc/PEODGT">
            SELECT * FROM company WHERE owner_id = '${user.user_id}' OR manager_id = '${user.user_id}'
        </sql:query>
        <c:set var="compDetails" scope="session" value="${compQuery.rows[0]}"/>
        <c:set var="companyId" scope="session" value="${compDetails.company_id}"/>
        <c:set var="companyName" scope="session" value="${compDetails.named}"/>
    </c:if>
    <c:if test="${not empty compDetails}">
        <p></p>
        <table><tr><td>
                    Your Company: 
                    <c:if test="${compDetails.named!=null}">
                        <button type="button" onClick="JavaScript:window.location = 'compania.jsp?id=${compDetails.company_id}';" >${compDetails.named}</button>
                        <c:if test="${compDetails.padrino!=null}">
                            <b><font color="red"> <-- Inactive</font></b>
                            </c:if>                        
                            <c:if test="${compDetails.padrino == null}">
                                <sql:query var="comp2Query" dataSource="jdbc/PEODGT">
                                SELECT COUNT(*) AS count FROM vehicle WHERE company_id = ${compDetails.company_id}
                            </sql:query>
                            <c:if test="${comp2Query.rows[0].count == 0}">
                                <b><font color="red"> <-- Need to add Van(s)</font></b>
                                </c:if>                        
                            </c:if>
                        </c:if>
                        <c:if test="${compDetails.named==null}">
                            <jsp:forward page="compChange.jsp?id=${compDetails.company_id}"/>
                        <button type="button" onClick="JavaScript:window.location = 'compChange.jsp?id=${compDetails.company_id}';" ><font color="red">Enter Company Information</font></button>
                        </c:if>
                </td></tr></table>
            </c:if>

</c:if>

<c:if test="${empty user.signDCinitials}">
    <jsp:forward page="dresscode.jsp?id=${user.user_id}"/>
</c:if>
<c:if test="${user.user_id == 1}">
    <c:if test="${empty param.feda}">
        <button type="button" onClick="JavaScript:window.location = 'index.jsp?feda=1';" ><font color="navy">Find Payadvance Discrepancies</font></button>
        </c:if>
        <c:if test="${not empty param.feda}">
            <sql:query var="discrepaQuery" dataSource="jdbc/PEODGT">
            select payadvance.id,signin.signin_id,signin.paid,signin.dated,signin.turn from payadvance,signin where datediff(payadvance.fecha,signin.dated) = 0 and payadvance.turno = signin.turn and (payadvance.hack <> signin.hack or signin.paid is null) order by dated desc
        </sql:query>
        <c:if test="${not empty discrepaQuery.rows[0]}">
            <p></p><table><tr><td align="center">
                        Discrepancies found on payadvance record(s)
                        <table><th>Signin.dated</th><th>Turn</th><th>Singin_id</th><th>Payadvance.id</th><th>Paid</th></tr>
                        <c:forEach var="row" items="${discrepaQuery.rows}">
                            <tr><td>${row.dated}</td><td>${row.turn}</td><td>${row.signin_id}</td><td>${row.id}</td><td>${row.paid}</td></tr> 
                        </c:forEach>
                        </table>
                    </td></tr></table>
                </c:if>
            </c:if>
        </c:if>

<jsp:include page="../inc/footer.jsp" />

<button type="button" onClick="JavaScript:window.location = '../overflowRules.pdf';" ><font color="navy">VOD RULES</font></button>

<!-- LOGS -->
<c:if test="${user.nivel != 'A'}">
    <p></p>
    <div id="notutors" style="display:'';">
        <button type="button" onClick="JavaScript:showTutors();">Show Video Tutorial</button>
    </div>
    <div id="situtors" style="display:none;">
        <button type="button" onClick="JavaScript:hideTutors();">Hide Video Tutorial</button>
        <p></p>
        <table><tr><td align="center" nowrap>
                    <button type="button" onClick="showEp2();" >Fix Expired Permit</button><br>
                    <p>
                        <button type="button" onClick="showUd2();" >Upload Documents</button><br>
                </td><td>
                    <div id="ud2" style="display:none;">
                        <iframe width="560" height="315" src="https://www.youtube.com/embed/qvIwqFClbp0" frameborder="0" allowfullscreen></iframe>
                    </div><!-- _IdNou7bwi8 -->
                    <div id="ep2" style="display:none;">
                        <iframe width="560" height="315" src="https://www.youtube.com/embed/QBECPyiS2P8" frameborder="0" allowfullscreen></iframe>
                    </div><!-- l3fskhJWlJ0 -->
                </td></tr></table>
    </div>
</c:if>
<c:if test="${user.nivel == 'A'}">
    <p>
    <div id="nologs" style="display:'';">
        <button type="button" onClick="JavaScript:showLogs();">Show Logs</button>
    </div>
    <div id="silogs" style="display:none;">
        <sql:query var="logQuery" dataSource="jdbc/PEODGT">
            SELECT * FROM log WHERE log_id < 1 ORDER BY dated DESC
        </sql:query>
        <button type="button" onClick="JavaScript:hideLogs();">Hide Logs</button>
        <table><tr><td>
                    <c:forEach var="row" items="${logQuery.rows}">
                        ${row.log_id} :<c:if test="${user.user_id == '1'}"><a href="index.jsp?delLog=${row.log_id}">del</a>:</c:if> ${row.dated} : ${row.info} : ${row.comments}
                            <p>
                        </c:forEach>
                        <jsp:include page="../htm/logs.html" />
                    <p>
                        <c:if test="${user.user_id == '1'}">
                        <form action="index.jsp" name="forma" method="post" >
                            New Log: <br>
                            Date: <input type="text" name="dated" id="dated" value="" size="10" readonly="readonly" /> 
                            <a href="javascript:NewCal('dated','yyyymmdd')"><img src="../pics/cal.gif" width="16" height="16" border="0" alt="Select a Date"></a>
                            <br>
                            Info: <input type="text" name="info" value="" size="40" /> <br>
                            Comments: <input type="text" name="comments" value="" size="40" />  
                            <input type="submit" value="AddLog" name="submit" />
                        </form>
                    </c:if>
                </td></tr></table>
    </div>
    <p>
    <div id="notutors" style="display:'';">
        <button type="button" onClick="JavaScript:showTutors();">Show Video Tutorials</button>
    </div>
    <div id="situtors" style="display:none;">
        <button type="button" onClick="JavaScript:hideTutors();">Hide Video Tutorials</button>
        <p></p>
        <table><tr><td align="center" nowrap>
                    <button type="button" onClick="showSs();" >Starting the Server</button><br>
                    <p>
                        <button type="button" onClick="showRc();" >Register Company Owner</button><br>
                    <p>
                        <button type="button" onClick="showRd();" >Register Driver</button><br>
                    <p>
                        <button type="button" onClick="showRi();" >Register Dispatcher</button><br>
                    <p>
                        <button type="button" onClick="showAu();" >Administering Users</button><br>
                    <p>
                        <button type="button" onClick="showAd();" >Administering Drivers</button><br>
                    <p>
                        <button type="button" onClick="showAi();" >Administering Dispatchers</button><br>
                    <p>
                        <button type="button" onClick="showAc();" >Administering Companies</button><br>
                    <p>
                        <button type="button" onClick="showRr();" >Restore a Driver</button><br>
                    <p>
                        <button type="button" onClick="showEp();" >Fix Expired Permit</button><br>
                    <p>
                        <button type="button" onClick="showUd();" >Upload Documents</button><br>
                    <p>
                        <button type="button" onClick="showPa();" >Payments In Advance</button><br>
                </td><td>
                    <div id="ss" style="display:none;">
                        <iframe width="560" height="315" src="http://www.youtube.com/embed/TIIle9lUG18" frameborder="0" allowfullscreen></iframe>
                    </div>
                    <div id="rc" style="display:none;">
                        <iframe width="560" height="315" src="http://www.youtube.com/embed/8mMz0C5EOn8" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                    </div>
                    <div id="rd" style="display:none;">
                        <iframe width="560" height="315" src="http://www.youtube.com/embed/6UOMjXOWHKQ" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                    </div>
                    <div id="ro" style="display:none;">
                        <iframe width="560" height="315" src="http://www.youtube.com/embed/v1CZh2K3k9c"  title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                    </div>
                    <div id="ri" style="display:none;">
                        <iframe width="560" height="315" src="http://www.youtube.com/embed/wpxsqbOcdDY"  title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                    </div>
                    <div id="au" style="display:none;">
                        <iframe width="560" height="315" src="http://www.youtube.com/embed/9_ohp7WtcfM" frameborder="0" allowfullscreen></iframe>
                    </div>
                    <div id="ad" style="display:none;">
                        <iframe width="560" height="315" src="http://www.youtube.com/embed/8KGoDiZnm4U" frameborder="0" allowfullscreen></iframe>
                    </div>
                    <div id="ai" style="display:none;">
                        <iframe width="560" height="315" src="http://www.youtube.com/embed/YNw8qGyAitc" frameborder="0" allowfullscreen></iframe>
                    </div>
                    <div id="ac" style="display:none;">
                        <iframe width="560" height="315" src="http://www.youtube.com/embed/E-w1gNU0L68" frameborder="0" allowfullscreen></iframe>
                    </div>
                    <div id="rr" style="display:none;">
                        <iframe width="560" height="315" src="http://www.youtube.com/embed/N45JirBzcTw" frameborder="0" allowfullscreen></iframe>
                    </div>
                    <div id="ud" style="display:none;">
                        <iframe width="560" height="315" src="https://www.youtube.com/embed/qvIwqFClbp0" frameborder="0" allowfullscreen></iframe>
                    </div><!-- _IdNou7bwi8 -->
                    <div id="ep" style="display:none;">
                        <iframe width="560" height="315" src="https://www.youtube.com/embed/QBECPyiS2P8" frameborder="0" allowfullscreen></iframe>
                    </div><!-- l3fskhJWlJ0 -->
                    <div id="pa" style="display:none;">
                        <iframe width="560" height="315" src="http://www.youtube.com/embed/MndoO9Oa8lM" frameborder="0" allowfullscreen></iframe>
                    </div><!-- OZKtCpMyd34 -->
                </td></tr></table>
    </div>
    <p>
    <div id="nowishes" style="display:'';">
        <button type="button" onClick="JavaScript:showWishes();">Show Wish List</button>
    </div>
    <div id="siwishes" style="display:none;">
        <sql:query var="wishesQuery" dataSource="jdbc/PEODGT">
            SELECT * FROM wish ORDER BY dated
        </sql:query>
        <button type="button" onClick="JavaScript:hideWishes();">Hide Wish List</button>
        <table><tr><td>
                    <c:forEach var="row" items="${wishesQuery.rows}">
                        ${row.wish_id} :<c:if test="${user.nivel == 'A'}"><a href="index.jsp?delWish=${row.wish_id}">del</a>:</c:if> ${row.dated} : ${row.info} : ${row.comments}
                            <p>
                        </c:forEach>
                    <p>
                        <c:if test="${user.nivel == 'A'}">
                        <form action="index.jsp" name="forma" method="post" >
                            New Wish: <br>
                            Date: <input type="text" name="dated" id="dated2" value="" size="10" readonly="readonly" /> 
                            <a href="javascript:NewCal('dated2','yyyymmdd')"><img src="../pics/cal.gif" width="16" height="16" border="0" alt="Select a Date"></a>
                            <br>
                            Info: <input type="text" name="info" value="" size="40" /> <br>
                            Comments: <input type="text" name="comments" value="" size="40" /> 
                            <input type="submit" value="AddWish" name="submit" />
                        </form>
                    </c:if>
                </td></tr></table>
    </div>
</c:if>
<p></p>
<c:if test="${empty user.ssn}">
    <sql:query var="queued" dataSource="jdbc/PEODGT">
        SELECT * FROM signin WHERE DATEDIFF(NOW(),dated) = 0 AND tripNumber IS NOT NULL AND pier < 1
    </sql:query>
    <sql:query var="raffled" dataSource="jdbc/PEODGT">
        SELECT * FROM signin WHERE DATEDIFF(NOW(),dated) = 0 AND tripNumber IS NULL ORDER BY turn
    </sql:query>
    <c:if test="${not empty raffled.rows[0]}">
        <table>
            <tr><td colspan="2" align="center"><b>Turns Pending for Trips</b></td></tr>
            <tr bgcolor="lightgrey"><td align="center">Turn</td><td>Driver</td><td align="right"><i>(${queued.rowCount} in Queue)</i></td></tr>
            <c:forEach var="row" items="${raffled.rows}">
                <sql:query var="nameQuery" dataSource="jdbc/PEODGT">
                    SELECT nombres,apellidos FROM usuario WHERE hack = ${row.hack}
                </sql:query>
                <tr><td align="center">${row.turn}</td><td>${nameQuery.rows[0].apellidos}, ${nameQuery.rows[0].nombres}</td><td><c:if test="${row.paid}">.</c:if></td></tr>
                    </c:forEach>
            <tr bgcolor="lightgrey"><td colspan="3" align="center">Raffle Closed!</td></tr>
        </table>
    </c:if>
</c:if>
<p>
    <%
        Calendar cal = Calendar.getInstance();
        int iMonth = cal.get(Calendar.MONTH) + 1;
        int iDate = cal.get(Calendar.DAY_OF_MONTH);
        session.setAttribute("monthNow", iMonth);
        session.setAttribute("dayNow", iDate);
    %>
    <sql:query var="birthdayQuery" dataSource="jdbc/PEODGT">
        SELECT nombres,apellidos FROM usuario WHERE birthmonth = ${monthNow} AND birthday = ${dayNow}
    </sql:query>
    <c:if test="${not empty birthdayQuery.rows[0]}">
    <table><tr><td>Happy Birthday to
                <c:forEach var="row" items="${birthdayQuery.rows}">
                    : ${row.nombres} ${row.apellidos}
                </c:forEach>
            </td></tr></table>
</c:if>