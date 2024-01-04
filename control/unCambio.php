<?php

include("../model/cambio.php");

/**
 * Description of unCambio
 *
 * @author ferna
 */
class unCambio extends cambio {

    public function __construct() {

    }

    public function listAll() {
        $cdb = new Dbclass(); // create a new object, class db()
        $sql = "SELECT * FROM cambio";
        $result = $cdb->getAll($sql, 'C');
        return $result;
    }

    public function load($fecha) {
        $cdb = new Dbclass(); // create a new object, class db()
        $sql = "SELECT * FROM cambio WHERE fecha = '" . $fecha . "'";
        $myrow = $cdb->getOne($sql, 'C');
        return $myrow;
    }

    public function loadBypass($fecha) {
        $cdb = new Dbclass(); // create a new object, class db()
        $sql = "SELECT * FROM cambio WHERE causa = 'byPass' AND fecha = '" . $fecha . "'";
        $myrow = $cdb->getOne($sql, 'C');
        return $myrow;
    }

    public function delBypass($numero) {
        $cdb = new Dbclass(); // create a new object, class db()
        $sql = "DELETE FROM cambio WHERE causa = 'byPass' AND usuario = " . $numero;
        $result = $cdb->execute($sql);
        return $result;
    }

    public function delCambio($fecha) {
        $cdb = new Dbclass(); // create a new object, class db()
        $sql = "DELETE FROM cambio WHERE fecha = '" . $fecha . "'";
        $result = $cdb->execute($sql);
        return $result;
    }

    public function insert() {
        $cdb = new Dbclass(); // create a new object, class db()
        $sql = 'INSERT INTO cambio (tabla,fecha,usuario,causa) VALUES ("' . $this->get_tabla() . '",NOW(),"' . $this->get_usuario() . '","' . $this->get_causa() . '");';
        $result = $cdb->execute($sql);
        return $result;
    }

    public function getSecNum($numero) {
        $cdb = new Dbclass(); // create a new object, class db()
        $sql = "SELECT * FROM cambio WHERE tabla = 'usuario' AND causa = 'byPass' AND usuario = $numero ORDER BY fecha DESC LIMIT 1";
// print "sql:"; print $sql; print "<<<<p>"; exit;
        $result = $cdb->getOne($sql, 'C');
        if ($result) {
            return $result->get_fecha();
        } else
            return null;
    }

}
