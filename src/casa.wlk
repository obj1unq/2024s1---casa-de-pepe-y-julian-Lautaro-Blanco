//CASA

object casaDePepeYJulian {
	
	var property viveres = 50
	var property reparaciones = 0
	var property cuenta = cuentaCorriente
	var property estrategiaDeAhorro = minimoEIndispensable
	
	method tieneViveresSuficientes(){
		return viveres > 40
	}
	
	method hayQueHacerReparaciones(){
		return reparaciones > 0
	}
	
	method laCasaEstaEnOrden(){
		return not self.hayQueHacerReparaciones() and self.tieneViveresSuficientes()
	}
	
	method romperAlgo(costoReparaciones){
		reparaciones += costoReparaciones
	}
	
	method reparar(){
		cuenta.extraer(reparaciones)
		reparaciones = 0
	}
	
	method mantener(){
		estrategiaDeAhorro.mantener(self)
	}
	
	method comprarViveres(porcentaje, calidad){
		viveres += porcentaje
		cuenta.extraer(porcentaje * calidad)
	}
	
	method puedePagarReparaciones(){
		return cuenta.saldo() >= reparaciones
	}
	
	method sobranteAlReparar(){
		return cuenta.saldo() - reparaciones
	}
	
}

//CUENTAS

object cuentaCorriente {
	
	var property saldo = 0
	
	method depositar(cantidad){
		saldo += cantidad
	}
	
	method extraer(cantidad){
		saldo -= cantidad
	}
	
}

object cuentaConGastos {
	
	var property saldo = 0
	var property costoPorOperacion = 0
	
	method depositar(cantidad){
		saldo += cantidad - costoPorOperacion
	}
	
	method extraer(cantidad){
		saldo -= cantidad
	}
	
}

object cuentaCombinada {
	
	var property cuentaPrimaria = cuentaConGastos
	var property cuentaSecundaria = cuentaCorriente
	
	method saldo(){
		return cuentaPrimaria.saldo() + cuentaSecundaria.saldo()
	}
	
	method depositar(cantidad){
		cuentaPrimaria.depositar(cantidad)
	}
	
	method extraer(cantidad){
		if(cuentaPrimaria.saldo() > cantidad){
			cuentaPrimaria.extraer(cantidad)
		} else {
			cuentaSecundaria.extraer(cantidad)
		}
	}
	
}

//ESTRATEGIAS DE AHORRO

object minimoEIndispensable {
	
	const calidad = 5
	
	method mantener(casa){
		if(not casa.tieneViveresSuficientes()){
			const viveresFaltantes = 40 - casa.viveres()
			casa.comprarViveres(viveresFaltantes, calidad)
		}
	}
}

object full {
	
	const calidad = 5
	
	method mantener(casa){
		var viveresALlenar = 0
		if(casa.laCasaEstaEnOrden()){
			viveresALlenar = 100 - casa.viveres()
		} else {
			viveresALlenar = 40
		}
		casa.comprarViveres(viveresALlenar, calidad)
		if(casa.puedePagarReparaciones() and casa.sobranteAlReparar() > 1000){
			casa.reparar()
		}
	}
}