<?php
include("../inc/header.inc");
if ($username == '') {
    echo '<META HTTP-EQUIV="REFRESH" CONTENT="1; URL=./login.php">';
    exit;
}
$logoff = isset($_REQUEST['logoff']) ? $_REQUEST['logoff'] : '';
if ($logoff) {
    session_destroy();
    echo '<META HTTP-EQUIV="REFRESH" CONTENT="1; URL=../index.php">';
    exit;
}
?>
<table width=100% height=50% border=0><tr><td align=center valign=middle>
            <table><tr><td align=center>
                        <?php echo "<font size=4>Bienvenido " . $username . "!</font>"; ?>
                    </td></tr></table>
        </td></tr></table>