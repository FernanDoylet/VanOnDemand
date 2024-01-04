<?php
include("../model/Dbclass.php");
include("unUsuario.php");
if (isset($_REQUEST['email'])) {
    $email = ($_REQUEST['email']);
    $userd = new unUsuario();
    $user = $userd->find($email);
    if ($user == '') {
        $_SESSION['emailReg'] = $email;
        echo '<META HTTP-EQUIV="REFRESH" CONTENT="0; URL=..\view\registro.php">';
        exit;
    }
    $_SESSION['email'] = $email;
    echo '<META HTTP-EQUIV="REFRESH" CONTENT="0; URL=..\view\preRegistro.php">';
}
?>