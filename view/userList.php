<?php
include("../model/Dbclass.php");
include("../inc/header.inc");
include("../control/unUsuario.php");
//var_dump($_SESSION);
?>
<table width=100%><tr><td align=center>
<p>&nbsp;<p>
            <div id="header">Registered Users</div>
        </td></tr></table>
<p align=center>
<table border=1 width=250 align=left cellpadding=10>
    <tr><th>ID</th><th nowrap>Name</th><th>Last Name</th><th>Email</th></tr>
    <?php
    $temp = new unUsuario();
    $lista = $temp->listAll();
    if (sizeof($lista) > 0) {
        foreach ($lista as $row) {
            $id = $row->get_user_id();
            $nombres = $row->get_nombres();
            $apellidos = $row->get_apellidos();
            $email = $row->get_email();
            ?>
    <tr><td align="center"><?php echo $id; ?></td><td nowrap><?php echo $nombres; ?></td><td nowrap><?php echo $apellidos; ?></td><td nowrap><?php echo $email; ?></td></tr>
            <?php
        }
    }
    ?>
</table>
