<?php

include("../model/usuario.php");

class unUsuario extends usuario {

    public function __construct() {

    }

    public function listAll() {
        $cdb = new Dbclass(); // create a new object, class db()
        $sql = "SELECT * FROM usuario";
        $result = $cdb->getAll($sql, 'U');
        return $result;
    }

    public function load($user_id) {
        $cdb = new Dbclass(); // create a new object, class db()
        $sql = "SELECT * FROM usuario WHERE user_id = " . $user_id;
        $myrow = $cdb->getOne($sql, 'U');
        return $myrow;
    }

    public function find($email) {
        $cdb = new Dbclass(); // create a new object, class db()
        $sql = "SELECT * FROM usuario WHERE email = '" . $email . "'";
        $result = $cdb->getOne($sql, 'U');
        if ($result) {
            return $result;
        }
        return '';
    }

    public function updatePass($user_id, $pass) {
        $cdb = new Dbclass(); // create a new object, class db()
        $sql = "UPDATE usuario SET pass = '" . $pass . "' WHERE user_id = " . $user_id;
        $result = $cdb->execute($sql);
        return $result;
    }

    public function insert() {
        $cdb = new Dbclass(); // create a new object, class db()
        $secNum = $_SERVER['REQUEST_TIME'];
        $sql = "INSERT INTO usuario (user_id,email,pass,nivel,nombres,apellidos,birthmonth,birthday,hack,ssn,direccion1,direccion2,city,state,zip,telefonos,ingreso,secNum,padrino,supervisor,signDCdate,signDCinitials,carrier) VALUES ($this->user_id,'$this->email','$this->pass','$this->nivel','$this->nombres','$this->apellidos',$this->birthmonth,$this->birthday,'$this->hack','$this->ssn','$this->direccion1','$this->dirreccion2','$this->city','$this->state','$this->zip','$this->telefonos','$this->ingreso','$this->secNum',$this->padrino,$this->supervisor,'$this->signDCdate','$this->signDCinitials',$this->carrier);";
        $result = $cdb->execute($sql);
        $id = 0;
        if ($result) {
            $sql = "SELECT MAX(user_id) AS user_id FROM usuario";
            $user_id = $cdb->getOne($sql, '');
        }
        return $user_id;
    }

    public function updater($user) {
        $cdb = new Dbclass();
        $sql = "UPDATE usuario SET email = '$user->email', pass = '$user->pass', nivel = '$user->nivel', nombres = '$user->nombres', apellidos = '$user->apellidos', birthmonth = $user->birthmonth, birthday = $user->birthday, hack = '$user->hack', ssn = '$user->ssn', direccion1 = '$user->direccion1', direccion2 = '$user->direccion2', city = '$user->city', state = '$user->state', zip = '$user->zip', telefonos = '$user->telefonos', ingreso = '$user->ingreso', secNum = '$user->secNum', padrino = $user->padrino, supervisor = '$user->supervisor, signDCdate = '$user->signDCdate', signDCinitials = '$user->signDCinitials', carrier = $user->carrier WHERE user_id = $user->user_id";
        $result = $cdb->execute($sql);
        return $result;
    }

}