<?php

set_include_path("../inc");

if (!isset($_SESSION)) {
    include("sessionStart.inc");
}

class Dbclass {

    private $conn;
    private $host;
    private $user;
    private $password;
    private $baseName;
    private $port;
    private $Debug;

    function __construct($params = array()) {
        $dbhost = $_SESSION['dbhost'];
        $dbuser = $_SESSION["dbuser"];
        $dbpass = $_SESSION['dbpass'];
        $dbname = $_SESSION["dbname"];
        $this->conn = false;
        $this->host = $dbhost; //hostname
        $this->user = $dbuser; //username
        $this->password = $dbpass; //password
        $this->baseName = $dbname; //name of your database
        $this->port = '3306';
        $this->debug = true;
        $this->connect();
    }

    function __destruct() {
        $this->disconnect();
    }

    function connect() {
        if (!$this->conn) {
            try {
                $this->conn = new PDO('mysql:host=' . $this->host . ';dbname=' . $this->baseName . '', $this->user, $this->password, array(PDO::MYSQL_ATTR_INIT_COMMAND => 'SET NAMES utf8'));
            } catch (Exception $e) {
                die('Erreur : ' . $e->getMessage());
            }

            if (!$this->conn) {
                $this->status_fatal = true;
                echo 'Connection BDD failed';
                die();
            } else {
                $this->status_fatal = false;
            }
        }
        return $this->conn;
    }

    function disconnect() {
        if ($this->conn) {
            $this->conn = null;
        }
    }

    function getOne($query, $table) {
        $result = $this->conn->prepare($query);
        $ret = $result->execute();
        if (!$ret) {
            echo 'PDO::errorInfo():';
            echo '<br />';
            echo 'error SQL: ' . $query;
            die();
        }
        switch ($table) {
            case '': $result->setFetchMode(PDO::FETCH_ASSOC);
                break;
            case 'U': $result->setFetchMode(PDO::FETCH_CLASS, 'Usuario');
                break;
            case 'P': $result->setFetchMode(PDO::FETCH_CLASS, 'Proveedor');
                break;
            case 'R': $result->setFetchMode(PDO::FETCH_CLASS, 'Producto');
                break;
            case 'E': $result->setFetchMode(PDO::FETCH_CLASS, 'Pedido');
                break;
            case 'A': $result->setFetchMode(PDO::FETCH_CLASS, 'Participante');
                break;
            case 'N': $result->setFetchMode(PDO::FETCH_CLASS, 'Nota');
                break;
            case 'S': $result->setFetchMode(PDO::FETCH_CLASS, 'Estado');
                break;
            case 'C': $result->setFetchMode(PDO::FETCH_CLASS, 'Cambio');
                break;
        }
        $reponse = $result->fetch();
        return $reponse;
    }

    function getAll($query, $table) {
        $result = $this->conn->prepare($query);
        $ret = $result->execute();
        if (!$ret) {
            echo 'PDO::errorInfo():';
            echo '<br />';
            echo 'error SQL: ' . $query;
            die();
        }
        switch ($table) {
            case '': $result->setFetchMode(PDO::FETCH_ASSOC);
                break;
            case 'U': $result->setFetchMode(PDO::FETCH_CLASS, 'Usuario');
                break;
            case 'P': $result->setFetchMode(PDO::FETCH_CLASS, 'Proveedor');
                break;
            case 'R': $result->setFetchMode(PDO::FETCH_CLASS, 'Producto');
                break;
            case 'E': $result->setFetchMode(PDO::FETCH_CLASS, 'Pedido');
                break;
            case 'A': $result->setFetchMode(PDO::FETCH_CLASS, 'Participante');
                break;
            case 'N': $result->setFetchMode(PDO::FETCH_CLASS, 'Nota');
                break;
            case 'S': $result->setFetchMode(PDO::FETCH_CLASS, 'Estado');
                break;
            case 'C': $result->setFetchMode(PDO::FETCH_CLASS, 'Cambio');
                break;
        }
        $reponse = $result->fetchAll();

        return $reponse;
    }

    function execute($query) {
        $response = $this->conn->exec($query);
        if ($response >= 0) {}else{
            echo 'PDO::errorInfo():';
            echo '<br />';
            echo 'error SQL: ' . $query;
            die();
        }
        return $response;
    }

}
