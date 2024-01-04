<?php
  include("../inc/header.inc");
  include("../inc/emailValidation.inc");
  unset ($_SESSION["byPass"]);
  unset ($_SESSION["email"]);
  unset ($_SESSION["wrongEmail"]);
  unset ($_SESSION["changeEmail"]);
  // var_dump($_SESSION);
?>
<p>&nbsp;
<table width=100%><tr><td align=center>
<div id="header">Password Change Request</div>
</td></tr></table>
        <p align=center>
        <table border=1 width=250 align=left cellpadding=10><tr><td>
        <form action="..\control\loginControl.php" name="loginForm" onsubmit="return ValidateEmail(document.loginForm.email)" method="post">
          <b>Special Link Request</b>
          <p>Email: <input type="text" name="email" required />
          <p align="right"><input type="Submit" name="submit" value="Send">
        </form>
        </td></tr></table>
