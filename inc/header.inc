<?php
//set_include_path("inc");
if (!isset($_SESSION)) {
    include("sessionStart.inc");
    include("dbAccess.inc");
}
$parts = Explode('/', $_SERVER["PHP_SELF"]);
$thisPage = $parts[count($parts) - 1];
?>
<script language="javascript" type="text/javascript">
    function showForm() {
        document.getElementById("sinForma").style.display = "none";
        document.getElementById("conForma").style.display = "";
    }
    function hideForm() {
        document.getElementById("conForma").style.display = "none";
        document.getElementById("sinForma").style.display = "";
    }
</script>
<!DOCTYPE html>
<html lang="es-US"><head>
        <title>Van On Demand</title>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=1">
        <style><?php include("../style/style.css"); ?></style>
    </head><body style="background-image:url('../pics/back4.jpg');background-repeat:no-repeat;">
        <p>&nbsp;<p>&nbsp;<p>&nbsp;<p>&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; <font color='white'>See what is new at </font><a href="https://vanondemand.wordpress.com"><font color='white'>VanOnDemand.wordpress.com</font></a><p>&nbsp;<p>  
        <table width=100%><tr><td align=center nowrap>
                    <?php
                    $currentFile = $_SERVER["PHP_SELF"];
                    $parts = Explode('/', $currentFile);
                    $thisPage = $parts[count($parts) - 1];
                    $username = isset($_SESSION['username']) ? $_SESSION['username'] : '';
                    $usertype = isset($_SESSION['usertype']) ? $_SESSION['usertype'] : '';
                    $servidor = isset($_SESSION['servidor']) ? $_SESSION['servidor'] : '';
                    $dbhost = ($servidor == '/PROVEE') ? '/PROVEE' : '';
                    if ($username != '') {
                        if ($thisPage != 'index.php') {
                            ?><button type="button" onClick="location.href = '<?php echo $dbhost; ?>../view/index.php'" style="width:100px" >Main</button><?php
                            }
                            if ($thisPage != 'profile.php') {
                                ?>
                            <button type="button" onClick="location.href = '<?php echo $dbhost; ?>../view/profile.php?id=<?php echo $_SESSION['userId']; ?>'" style="width:100px" >Profile</button><?php } ?>
                        <button type="button" onClick="location.href = '<?php echo $dbhost; ?>../view/index.php?logoff=1'" style="width:100px" >Exit</button>
                        <p><?php
                            if ($usertype == 'A') {

                            }
                        }

                        if ($username == '') {
                            if ($thisPage != 'login.php') {
                                ?><button type="button" onClick="location.href = '<?php echo $dbhost; ?>../view/login.php'">Login</button><?php
                            }
                            if ($thisPage != 'preRegistro.php' && $thisPage != 'registro.php') {
                                ?><button type="button" onClick="location.href = '<?php echo $dbhost; ?>../view/preRegistro.php?corregir=1'">Register</button><?php
                            }
                            if ($thisPage != 'getPass.php') {
                                ?><button type = "button" onClick = "location.href = '<?php echo $dbhost; ?>../view/getPass.php'">Forgot Password</button><?php
                            }
                            if ($thisPage != 'userList.php') {
                                ?><button type = "button" onClick = "location.href = '<?php echo $dbhost; ?>../view/userList.php'">DB test</button><?php
                            }
                            if ($thisPage != 'logs.php') {
                                ?><button type = "button" onClick = "location.href = '<?php echo $dbhost; ?>../view/logs.php'">Logs</button><?php
                            }
                        }
                        ?>
                </td></tr></table>
