package schemas;

import Enums.EstadoMaterial;

public class Material {
    private EstadoMaterial estado;

    public EstadoMaterial getEstado() {
        return estado;
    }

    public void setEstado(EstadoMaterial estado) {
        this.estado = estado;
    }
}
