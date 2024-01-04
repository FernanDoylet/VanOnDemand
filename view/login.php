<?php
include("../model/Dbclass.php");
include("../inc/header.inc");
include("../inc/emailValidation.inc");
include("../control/unProveedor.php");
// var_dump($_SESSION);
// $hostName = gethostname();
?>
<p align=center>
    <?php
    $wrongPass = isset($_SESSION['wrongPass']) ? $_SESSION['wrongPass'] : '';
    $changePass = isset($_SESSION['changePass']) ? $_SESSION['changePass'] : '';
    $wrongEmail = isset($_SESSION['wrongEmail']) ? $_SESSION['wrongEmail'] : '';
    if ($wrongPass || $changePass) {
        ?>
        <font color=white>
        <form action="http://www.doylet.org/mailer/MailVOD.php" method="post" onsubmit="$(this).find(':input[type=submit]').prop('disabled', true);">
        <?php
        if ($wrongPass) {
            echo "<p><b>Wrong Password. Try again please.</b> <p>";
            unset($_SESSION['wrongPass']);
        } else {
            echo "Request Password Change for: " . $changePass;
            unset($_SESSION['changePass']);
        }
        ?>
        <input type="hidden" name="subject" value="Van On Demand. Password Change - <?php echo $_SESSION['byPass']; ?>" />
        <input type="hidden" name="email" value="<?php echo $_SESSION['email']; ?>" />
        <input type="hidden" name="message" value="To change your password in Van On Demand, please visit
               http://<?php echo $_SESSION['servidor']; ?>/control/loginControl.php?byPass=<?php echo $_SESSION['byPass']; ?>
               (Make sure this address appears complete on your browser. Copy and Paste if necessary.)" >
        <br>To receive a link to change your password, click on <input type="Submit" name="submit" value="Send Email" >
        <a href="http://<?php echo $_SESSION['servidor']; ?>/control/loginControl.php?byPass=<?php echo $_SESSION['byPass']; ?>">.</a>
        </form>
        </font>
    <?php
    $email = isset($_SESSION['email']) ? $_SESSION['email'] : '';
} else {
    $email = isset($_REQUEST['email']) ? $_REQUEST['email'] : '';
}
if ($wrongEmail) {
    echo "<div align=left><font color=white>Email not registered: " . $wrongEmail . "<br>Fix the email, or click the 'Register' button above<p></font></div>";
    unset ($_SESSION["wrongEmail"]);
}
$byPassOk = isset($_REQUEST['byPassOk']) ? $_REQUEST['byPassOk'] : '';

    ?>
    <table border=0 align=left>
    <thead><tr><th>Users' Access</th></tr></thead>
    <tbody>
    <tr><td>Enter your email and password:</td></tr>
    <tr><td>
        <form action="..\control\loginControl.php" name="loginForm" onsubmit="return ValidateEmail(document.loginForm.email)" method="post">
             Email: <input type="text" name="email" value='<?php echo $email ?>' size=30 maxlength=50 required /><br>
             Password: <input type="password" name="clave" value="" placeholder="(if you forgot, type anything)" size="25" required />
             <?php if($byPassOk){echo'<font color=red>write your new password</font>';} ?>
             <input type="hidden" name="byPassOk" value='<?php echo $byPassOk ?>' />
             <input type="Submit" class="button" name="submit" value="Enter">
        </form>
            </td></tr></tbody></table>
    </p>
    <?php if (empty($byPass)) { ?>
        <script type="text/javascript" language="javascript">
        <!--
            document.loginForm.clave.value = readCookie("w4spclave");
            if (document.loginForm.clave.value != '') {
                document.loginForm.checker.checked = true;
                document.loginForm.email.value = readCookie("w4spemail");
                // Change the names of the fields at right to match the ones in your form.
            }
            //-->
        </script>
    <?php
    }

$proveedor = new unProveedor();
$proveedores = $proveedor->listAll();
                if (sizeof($proveedores) > 0) {
?>
    <hr>
    <p align=center><font size="5">Proveedores por Pais</font></p>
    <p></p><table align="center"><tr bgcolor="lightgrey"><th>Pais</th><th>Ciudad</th><th>Proveedor</th></tr><?php
        foreach ($proveedores as $prov) {
            $prov_numero = $prov->get_numero();
            $prov_nombre = $prov->get_nombre();
            $prov_ciudad = $prov->get_dir_ciudad();
            $prov_pais = $prov->get_dir_pais();
            ?>
            <tr><td><?php echo $prov_pais; ?></td><td><?php echo $prov_ciudad; ?></td><td><a href="proveedor.php?id=<?php echo $prov_numero; ?>"><?php echo $prov_nombre; ?></a></td></tr>
            <?php
        }
        ?></table><?php
        }
        ?>