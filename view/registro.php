<?php
include("../model/Dbclass.php");
include("../inc/header.inc");
include("../inc/userValidation.inc");
include("../control/unUsuario.php");
$id = isset($_REQUEST['id']) ? $_REQUEST['id'] : '';
if ($id != '') {
    $email = isset($_REQUEST['email']) ? $_REQUEST['email'] : '';
    $titulo = "Perfil de Usuario";
    $enviar = "Actualizar";
    $usuario = new unUsuario();
    $user = $usuario->load($id);
    $nombres = $user->get_nombres();
    $apellidos = $user->get_apellidos();
    $email = $user->get_email();
    $clave = $user->get_clave();
    $dir_linea_1 = $user->get_dir_linea_1();
    $dir_linea_2 = $user->get_dir_linea_2();
    $dir_ciudad = $user->get_dir_ciudad();
    $dir_provincia = $user->get_dir_provincia();
    $dir_pais = $user->get_dir_pais();
    $dir_codigo = $user->get_dir_codigo();
    $nacimiento = $user->get_nacimiento();
    $ano = substr($nacimiento, 0, 4);
    if ($ano == '0000')
        $ano = '';
    $mes = substr($nacimiento, 6, 7);
    $dia = substr($nacimiento, 8, 9);
    if ($dia == '00')
        $dia = '';
    $sexo = $user->get_sexo();
    $telefono = $user->get_telefono();
}
if ($id == '') {
    $email = isset($_SESSION['emailReg']) ? $_SESSION['emailReg'] : ''; // unset ($_SESSION["emailReg"]);
    $titulo = "Forma de Registro";
    $enviar = "Registrar";
    $nombres = '';
    $apellidos = '';
    $sexo = '';
    $clave = '';
    $nivel = '';
    $nacimiento = ''; $mes = ''; $dia = ''; $ano = '';
    $direccion = ''; 
    $dir_linea_1 = ''; 
    $dir_linea_2 = ''; 
    $dir_ciudad = ''; 
    $dir_provincia = ''; 
    $dir_ciudad = ''; 
    $dir_codigo = ''; 
    $dir_pais = '';
    $provincia = '';
    $pais = '';
    $sexo = '';
    $telefono = '';
}
?>
<table width=100%><tr><td align=center>
            <p>&nbsp;</p><div id="header"><?php echo $titulo ?></div>
        </td></tr></table>
<form action="../control/registroCtrl.php" name="forma" method="post" onsubmit="return ValidateUser()" autocomplete="off">
    <table align=center border=0>
        <tr><td align=right><b>Nombres: </b></td><td><input type="text" name="nombres" value="<?php echo $nombres; ?>" maxlength="45" autofocus required /><input type="hidden" name="id" value="<?php echo $id; ?>"></td></tr>
        <tr><td align=right><b>Apellidos: </b></td><td><input type="text" name="apellidos" value="<?php echo $apellidos; ?>" maxlength="45" required /></td></tr>
        <tr><td align=right><b>Email: </b></td><td><input type="hidden" name="email" value="<?php echo $email; ?>" /><?php echo $email; ?>
                <?php if ($id == '') { ?>
                    <button onclick="window.location.href = 'preRegistro.php?corregir=1';">Cambiar</button>
<?php } ?>
            </td></tr>

        <tr><td align=right><b>Clave: </b></td><td><input type="password" name="clave" value="<?php echo $clave; ?>" maxlength="15" required /></td></tr>
        <tr><td align=right>Repita su Clave: </td><td><input type="password" name="clave2" value="<?php echo $clave; ?>" maxlength="15" required /></td></tr>
        <tr><td align="right" valign="top">Direccion: </td><td><input type="text" name="dir_linea_1" value="<?php echo $dir_linea_1; ?>" maxlength="45"><br>
                <input type="text" name="dir_linea_2" value="<?php echo $dir_linea_2; ?>" maxlength="45"></td></tr>
        <tr><td align="right">Ciudad: </td><td><input type="text" name="dir_ciudad" value="<?php echo $dir_ciudad; ?>" maxlength="45" required /></td></tr>
        <tr><td align="right">Provincia: </td><td><input type="text" name="dir_provincia" value="<?php echo $dir_provincia; ?>" maxlength="45"></td></tr>
        <tr><td align="right">Pais: </td><td><input type="text" name="dir_pais" value="<?php echo $dir_pais; ?>" maxlength="45" required /></td></tr>
        <tr><td align="right">Codigo Postal: </td><td><input type="text" name="dir_codigo" value="<?php echo $dir_codigo; ?>" maxlength="15"></td></tr>
        <tr><td align=right>Fecha de Nacimiento: </td><td>
                <input type="text" name="dia" value="<?php echo $dia; ?>" placeholder="dia" size="2" /> 
                <select name="mes">
                    <option value="">mes
                    <option value="1" <?php if ($mes == 1) echo'selected'; ?> >Enero
                    <option value="2" <?php if ($mes == 2) echo'selected'; ?> >Febrero
                    <option value="3" <?php if ($mes == 3) echo'selected'; ?> >Marzo
                    <option value="4" <?php if ($mes == 4) echo'selected'; ?> >Abril
                    <option value="5" <?php if ($mes == 5) echo'selected'; ?> >Mayo
                    <option value="6" <?php if ($mes == 6) echo'selected'; ?> >Junio
                    <option value="7" <?php if ($mes == 7) echo'selected'; ?> >Julio
                    <option value="8" <?php if ($mes == 8) echo'selected'; ?> >Agosto
                    <option value="9" <?php if ($mes == 9) echo'selected'; ?> >Septiembre
                    <option value="10" <?php if ($mes == 10) echo'selected'; ?> >Octubre
                    <option value="11" <?php if ($mes == 11) echo'selected'; ?> >Noviembre
                    <option value="12" <?php if ($mes == 12) echo'selected'; ?> >Diciembre
                </select>
                <input type="text" name="ano" value="<?php echo $ano; ?>" placeholder="año" size="4" /> 
            </td></tr>
        <tr><td align=right>Sexo: </td><td nowrap>
                <input type="radio" name="sexo" value='M' <?php if ($sexo == 1) echo 'checked'; ?> required > Masculino &nbsp; &nbsp; &nbsp;
                <input type="radio" name="sexo" value='F' <?php if ($sexo == 0) echo 'checked'; ?> > Femenino
            </td></tr>
        <tr><td align="right">Telefono: </td><td><input type="text" name="telefono" value="<?php echo $telefono; ?>" maxlength="30" />
            <input type="hidden" name="numero" value="<?php echo $id; ?>" /></td></tr>
        <tr><td colspan=2 align=right><input type="Submit" name="submit" value="<?php echo $enviar ?>"></td></tr>
    </table>
</form>
