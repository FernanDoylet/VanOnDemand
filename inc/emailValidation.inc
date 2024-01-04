<script type="text/javascript">
function ValidateEmail(mail)
{ 
  var filter = /^\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*$/;
  if (filter.test(mail.value))
  {
    var remember = document.getElementById('checker');
    if (remember.checked) {
      toMem(); 
    }else{
      eraseCookie('w4spemail');
      eraseCookie('w4spclave');
    }
    return (true);
  } 
  var email = mail.value;
  alert("You have entered an invalid email address! " + email);
  return (false);
}
<!-- Cookie script - Scott Andrew -->
<!-- Popup script, Copyright 2005, Sandeep Gangadharan --> 
<!-- For more free scripts go to http://www.sivamdesign.com/scripts/ -->
<!--
function newCookie(name,value,days) {
 var days = 120;   // the number at the left reflects the number of days for the cookie to last
                 // modify it according to your needs
 if (days) {
   var date = new Date();
   date.setTime(date.getTime()+(days*24*60*60*1000));
   var expires = "; expires="+date.toGMTString(); }
   else var expires = "";
   document.cookie = name+"="+value+expires+"; path=/"; }

function readCookie(name) {
   var nameSG = name + "=";
   var nuller = '';
  if (document.cookie.indexOf(nameSG) == -1)
    return nuller;

   var ca = document.cookie.split(';');
  for(var i=0; i<ca.length; i++) {
    var c = ca[i];
    while (c.charAt(0)==' ') c = c.substring(1,c.length);
  if (c.indexOf(nameSG) == 0) return c.substring(nameSG.length,c.length); }
    return null; }

function eraseCookie(name) {
  newCookie(name,"",1); }

function toMem() {
    newCookie('w4spemail', document.loginForm.email.value);     // add a new cookie as shown at left for every
    newCookie('w4spclave', document.loginForm.clave.value);     // field you wish to have the script remember
}

function delMem(a) {
  eraseCookie('theName');   // make sure to add the eraseCookie function for every field
  eraseCookie('theEmail');

   document.form.name.value = '';   // add a line for every field
   document.form.email.value = ''; }
//-->
</script>
