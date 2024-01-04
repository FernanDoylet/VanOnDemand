<?php
    session_start();
    if (gethostname() == "DESKTOP-813I5KF") { $dbhost = "127.0.0.1"; $dbuser = "root"; $dbpass = "xscuby"; $dbname = "provee"; $servidor = "localhost:8000"; }
    elseif (gethostname() == "IsisHP") { $dbhost = "localhost:3307"; $dbuser = "admin"; $dbpass = "xscuby"; $dbname = "provee"; $servidor = "localhost:8000"; }
    elseif (gethostname() == "Isisgema-PC") { $dbhost = "127.0.0.1:3308"; $dbuser = "root"; $dbpass = "xscuby"; $dbname = "provee"; $servidor = "/PROVEE"; }
    else { $dbhost = "a2plcpnl0542.prod.iad2.secureserver.net"; $dbuser = "peodgt"; $dbpass = "xscuby"; $dbname = "peodgt"; $servidor = "/VOD2"; }
    $_SESSION['dbhost'] = $dbhost;
    $_SESSION['dbuser'] = $dbuser;
    $_SESSION['dbpass'] = $dbpass;
    $_SESSION['dbname'] = $dbname;
    $_SESSION['servidor'] = "doylet.org".$servidor;
?>