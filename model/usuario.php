<?php

class usuario {
    protected $user_id; //int(11)
    protected $email; //varchar(100)
    protected $pass; //varchar(50)
    protected $nivel; //char(1)
    protected $nombres; //varchar(100)
    protected $apellidos; //varchar(100)
    protected $birthmonth; //tinyint(2)
    protected $birthday; //tinyint(2)
    protected $hack; //varchar(10)
    protected $ssn; //varchar(10)
    protected $direccion1; //varchar(100)
    protected $direccion2; //varchar(100)
    protected $city; //varchar(50)
    protected $state; //varchar(2)
    protected $zip; //varchar(5)
    protected $telefonos; //varchar(100)
    protected $ingreso; //datetime DEFAULT NULL
    protected $secNum; //varchar(20)
    protected $padrino; //int(11)
    protected $supervisor; //int(11)
    protected $signDCdate; //date DEFAULT NULL
    protected $signDCinitials; //varchar(2)
    protected $carrier; //int(11) DEFAULT NULL

    public function get_user_id() { return $this->user_id; }
    public function get_email() { return $this->email; }
    public function get_pass() { return $this->pass; }
    public function get_nivel() { return $this->nivel; }
    public function get_nombres() { return $this->nombres; }
    public function get_apellidos() { return $this->apellidos; }
    public function get_birthmonth() { return $this->birthmonth; }
    public function get_birthday() { return $this->birthday; }
    public function get_hack() { return $this->hack; }
    public function get_ssn() { return $this->ssn; }
    public function get_direccion1() { return $this->direccion1; }
    public function get_direccion2() { return $this->direccion2; }
    public function get_city() { return $this->city; }
    public function get_state() { return $this->state; }
    public function get_zip() { return $this->zip; }
    public function get_telefonos() { return $this->telefonos; }
    public function get_ingreso() { return $this->ingreso; }
    public function get_secNum() { return $this->secNum; }
    public function get_padrino() { return $this->padrino; }
    public function get_supervisor() { return $this->supervisor; }
    public function get_signDCdate() { return $this->signDCdate; }
    public function get_signDCinitials() { return $this->signDCinitials; }
    public function get_carrier() { return $this->carrier; }

    public function set_user_id($user_id) { $this->user_id = $user_id; return $this; }
    public function set_email($email) { $this->email = $email; return $this; }
    public function set_pass($pass) { $this->pass = $pass; return $this; }
    public function set_nivel($nivel) { $this->nivel = $nivel; return $this; }
    public function set_nombres($nombres) { $this->nombres = $nombres; return $this; }
    public function set_apellidos($apellidos) { $this->apellidos = $apellidos; return $this; }
    public function set_birthmonth($birthmonth) { $this->birthmonth = $birthmonth; return $this; }
    public function set_birthday($birthday) { $this->birthday = $birthday; return $this; }
    public function set_hack($hack) { $this->hack = $hack; return $this; }
    public function set_ssn($ssn) { $this->ssn = $ssn; return $this; }
    public function set_direccion1($direccion1) { $this->direccion1 = $direccion1; return $this; }
    public function set_direccion2($direccion2) { $this->direccion2 = $direccion2; return $this; }
    public function set_city($city) { $this->city = $city; return $this; }
    public function set_state($state) { $this->state = $state; return $this; }
    public function set_zip($zip) { $this->zip = $zip; return $this; }
    public function set_telefonos($telefonos) { $this->telefonos = $telefonos; return $this; }
    public function set_ingreso($ingreso) { $this->ingreso = $ingreso; return $this; }
    public function set_secNum($secNum) { $this->secNum = $secNum; return $this; }
    public function set_padrino($padrino) { $this->padrino = $padrino; return $this; }
    public function set_supervisor($supervisor) { $this->supervisor = $supervisor; return $this; }
    public function set_signDCdate($signDCdate) { $this->signDCdate = $signDCdate; return $this; }
    public function set_signDCinitials($signDCinitials) { $this->signDCinitials = $signDCinitials; return $this; }
    public function set_carrier($carrier) { $this->carrier = $carrier; return $this; }
}