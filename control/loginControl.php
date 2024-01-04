<?php

include("../model/Dbclass.php");
include("../control/unUsuario.php");
include("../control/unCambio.php");
$submit = isset($_REQUEST['submit']) ? $_REQUEST['submit'] : '';
$email = isset($_REQUEST['email']) ? $_REQUEST['email'] : '';
$claveIn = isset($_REQUEST['clave']) ? $_REQUEST['clave'] : '';
$byPass = isset($_REQUEST['byPass']) ? $_REQUEST['byPass'] : '';
$byPassOk = isset($_REQUEST['byPassOk']) ? $_REQUEST['byPassOk'] : '';
$numero = isset($_REQUEST['numero']) ? $_REQUEST['numero'] : '0';
if ($email != '') {
    $user = new unUsuario();
    $user = $user->find($email);
    if ($user == '') {
        $_SESSION['wrongEmail'] = $email;
        echo '<META HTTP-EQUIV="REFRESH" CONTENT="1; URL=../view/login.php">';
        exit;
    }
    $nombres = $user->get_nombres();
// print "nombres:"; print $nombres; print "<<<<p>"; exit;
    $numero = $user->get_user_id();
// print "numero:"; print $numero; print "<<<<p>"; exit;
    $apellidos = $user->get_apellidos();
    $clave = $user->get_pass();
    $username = $nombres . ' ' . $apellidos;
// print "username:"; print $username; print "<<<<p>"; exit;
    if ($byPassOk != '') { //si byPass coincide (obtuvo byPassOk) cambiar la clave
        $_SESSION['username'] = $username;
        $_SESSION['userId'] = $numero;
        $_SESSION['user'] = $user;
        $cambio = new unCambio();
        $response = $cambio->delBypass($byPassOk);
        if ($response >= 0) {
            $user2 = new unUsuario();
            $user2->updatePass($numero, $claveIn);
            echo ' &nbsp; &nbsp; &nbsp; Clave Actualizada ' . $username . '!';
            echo '<META HTTP-EQUIV="REFRESH" CONTENT="1; URL=..\view\index.php">';
            exit;
        }
    }
    if (($claveIn != '') && ($claveIn == $clave)) {
        $_SESSION['username'] = $username;
        $_SESSION['userId'] = $numero;
        $_SESSION['user'] = $user;
        if ($numero==1) $_SESSION['usertype'] = 'A';
        echo ' &nbsp; &nbsp; &nbsp; Bienvenid@ ' . $username . '!';
        echo '<META HTTP-EQUIV="REFRESH" CONTENT="1; URL=..\view\index.php">';
        exit;
    } else {
        $cambio2 = new unCambio();
// print "username2:"; print $username; print "<<<<p>"; exit;
        $secNum = $cambio2->getSecNum($numero);
// print "username3:"; print $username; print "<<<<p>"; exit; NO EXISTE TABLA CAMBIO
        if ($secNum == null || $secNum == '' || strlen($secNum) < 9) {
            $cambio3 = new unCambio();
            $cambio3->set_tabla("usuario");
            $cambio3->set_causa("byPass");
            $cambio3->set_usuario($numero);
            $result = $cambio3->insert();
// print "Result:"; print $result; print "<<<<p>"; exit;
            date_default_timezone_set('UTC');
            $secNum = $cambio3->getSecNum($numero);
        }
        date_default_timezone_set('UTC');
        $date = strtotime($secNum);
        $_SESSION['byPass'] = $date;
        $_SESSION['email'] = $email;
        if ($claveIn)
            $_SESSION['wrongPass'] = $username;
        else
            $_SESSION['changePass'] = $username;
        echo '<META HTTP-EQUIV="REFRESH" CONTENT="1; URL=..\view\login.php">';
        exit;
    }
} else {
    if ($byPass != '') {
        if ($byPass == 'true') {
            $username = isset($_REQUEST['username']) ? $_REQUEST['username'] : '';
            echo " &nbsp; &nbsp; &nbsp; <b>Usuario Registrado: $username<br> &nbsp; &nbsp; &nbsp; recibira [via email] un enlace especial para cambiar su clave.</b>";
        } else {
// echo "byPass:".$byPass."<<<<"; exit;
            $cambio = new unCambio();
            date_default_timezone_set('UTC');
            $date = date('Y-m-d H:i:s', $byPass);
            $cambio = $cambio->loadBypass($date); // makes sure byPass coincides
            if ($cambio == '') {
                echo " &nbsp; &nbsp; &nbsp; El enlace que esta usado esta obsoleto.<p>"
                . " &nbsp; &nbsp; &nbsp; Obtenga uno nuevo por favor.";
                exit;
            }
            $numero = $cambio->get_usuario();
            $usuario = new unUsuario();
            $usuario = $usuario->load($numero);
            $email = $usuario->get_email();
            if ($numero) {
                echo '<META HTTP-EQUIV="REFRESH" CONTENT="1; URL=../view/login.php?email=' . $email . '&byPassOk=' . $numero . '">';
                exit;
            }
        }
    }
}
?>