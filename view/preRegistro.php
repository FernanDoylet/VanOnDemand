<?php
  include("../inc/header.inc");
  include("../inc/emailValidation.inc");
?>
<script language="javascript" src="calendar/calendar.js"></script>
<p>&nbsp;
<table width=100%><tr><td align=center>
<div id="header">Pre-Registration Form</div>
</td></tr></table>
<?php

if (isset($_REQUEST['corregir'])) { unset($_SESSION['emailReg']); unset($_SESSION['email']); }

if(isset($_SESSION['emailReg']))
{
   echo '<META HTTP-EQUIV="REFRESH" CONTENT="0; URL=registro.php">';
   exit;
}
$email = isset($_SESSION['email']) ? $_SESSION['email'] : ''; unset ($_SESSION["email"]);
if($email){
          echo "<br><font color=white> &nbsp; &nbsp; &nbsp; Email $email already registered.<br> &nbsp; &nbsp; &nbsp; Use the [Login] button above, please.</font>";
}
?>
<p align=center>
  <form name="forma" action="..\control\preRegCtrl.php" onsubmit="return ValidateEmail(document.forma.email)" method="post">
<table border=1 width=250 align=left cellpadding=10><tr><td nowrap>
    <b>Email Validation</b>
    <p>Email: <input type="text" name="email" value="<?php echo $email; ?>" size=25 maxlength="100" autofocus required />
    <p align="right"><input type="Submit" name="submit" value="Validate">
</td></tr></table>
  </form>
