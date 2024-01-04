<?php
 include("./inc/header.inc");
?>
<html>
    <head>
        <title>Bienvenido!</title>
    </head>
    <body>
        <p>Welcome!</p>
        One moment please...
    </body>
</html>
<?php
// detect javascript or no javascript
//if (!isset($_SESSION['jsOk'])) {
    if (isset($_GET['js'])) {
        if ($_GET['js'] == 0)
            echo "<b><font color='red'>Por favor activar JavaScript para continuar.</font></b>";
        if ($_GET['js'] == 1)
            $_SESSION['jsOk'] = '1';
            echo '<META HTTP-EQUIV="REFRESH" CONTENT="1; URL=./view/index.php">';
            exit;
    } else {
        ?>
        <script>location.href = 'index.php?js=1';</script>
        <meta http-equiv="refresh" content="0; index.php?js=0">
        <?php
    }
//}
?>