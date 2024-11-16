class Local{
    const property ventas

    method cantVentas() = ventas.size()
    method cantVentasProdProm(){
        ventas.count{venta => venta.tieneProductoEnPromocion()}
    }
    method ventasEnFecha(fecha){
        return ventas.filter{venta => venta.fecha() == fecha}
    }
    method dineroMovido(){ventas.sum{venta => venta.monto()}}
    method esDeTacanios(){
        ventas.all{venta => venta.todosSusProductosTienenPromocion()}
    }
}

class Venta{
    const property productos
    const property fecha
    const property lugar

    method monto() = productos.sum{producto => producto.costo()}
    method tieneProductoEnPromocion() = productos.any{producto => producto.estaEnPromocion()}
    method todosSusProductosTienenPromocion() { productos.all{producto => producto.estaEnPromocion()}}
}

class Producto{
    var property estaEnPromocion
    var property descuento1

    method descuento(){if(estaEnPromocion) descuento1 else 0
    }
    method ahorrado(){if(estaEnPromocion)self.costo()}
}
class Prendas inherits Producto{
    const property talle
    const property factorConversionPesos

    method costo(){
        if(estaEnPromocion) talle * factorConversionPesos*descuento1 else talle *factorConversionPesos
    }
    
}

class Electronica inherits Producto{
    method factor() = factorConversion.factor()
    method cambiarFactor(nuevoFactor){factorConversion.factor(nuevoFactor)}
    method costo() {
        if(estaEnPromocion) 15 * factorConversion.factor()*descuento1 else 15*factorConversion}
}

object factorConversion{
    var property factor = 15 
}

class Decoracion inherits Producto{
    const property alto
    const property ancho
    const property peso
    const property materiales

    method agregarMaterial(material){return materiales.add(material)}
    method costo(){if(estaEnPromocion) alto*ancho*peso + materiales.sum{material => material.valor()}*descuento1 else alto*ancho*peso + materiales.sum{material => material.valor()}}
}

class Shopping{
    const property locales
    var property criterio = criterioCantidadVentas

    method cantVentas(){criterio.cantidad(locales)}
    method esDeTacanios(){locales.all{local => local.esDeTacanios()}}
}

object criterioCantidadVentas{
    method cantidad(locales) = locales.sum{local => local.cantVentas()}
}

object criterioDineroMovido{
    method cantidad(locales){locales.sum{local => local.dineroMovido()}}
}

class Lugar{
    const property propiedades

    method mayorVentas(){
        propiedades.max{propiedad => propiedad.cantVentas()}
    }
    method esDeTacanios(){propiedades.all{propiedad => propiedad.esDeTacanios()}}

}