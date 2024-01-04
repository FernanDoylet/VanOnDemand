<?php
/**
 * Description of cambio
 *
 * @author ferna
 */
class cambio {
    protected $tabla;//varchar 15
    protected $fecha;//datetime
    protected $usuario;//integer
    protected $causa;//varchar 225

    public function get_tabla() {
        return $this->tabla;
    }

    public function get_fecha() {
        return $this->fecha;
    }

    public function get_usuario() {
        return $this->usuario;
    }

    public function get_causa() {
        return $this->causa;
    }

    public function set_tabla($tabla) {
        $this->tabla = $tabla;
        return $this;
    }

    public function set_fecha($fecha) {
        $this->fecha = $fecha;
        return $this;
    }

    public function set_usuario($usuario) {
        $this->usuario = $usuario;
        return $this;
    }

    public function set_causa($causa) {
        $this->causa = $causa;
        return $this;
    }

}
