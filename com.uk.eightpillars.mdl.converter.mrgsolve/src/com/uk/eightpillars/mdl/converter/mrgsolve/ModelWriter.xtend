package com.uk.eightpillars.mdl.converter.mrgsolve

import eu.ddmore.mdl.mdl.MclObject
import eu.ddmore.mdl.utils.MdlObjectHelper
import eu.ddmore.mdl.utils.MdlPredictionHelper

class ModelWriter {
	extension MdlObjectHelper moh = new MdlObjectHelper
	extension MdlPredictionHelper mph = new MdlPredictionHelper
	
	def writeModel(MclObject mdlObj){
		val predBlks = mdlObj.modelPrediction
		'''
			$CMT
			«FOR p : predBlks»
				«FOR v : p.variables»
					«v.name»
				«ENDFOR»
			«ENDFOR»
			
			$ODE
			
			«FOR p : predBlks»
				«FOR v : p.derivativeVariables»
					«v.name»
				«ENDFOR»
			«ENDFOR»
			
			
		'''
	}
	
	
}