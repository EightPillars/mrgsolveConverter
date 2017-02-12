package com.uk.eightpillars.mdl.converter.mrgsolve

import eu.ddmore.mdl.mdl.MclObject
import eu.ddmore.mdl.utils.MdlObjectHelper
import eu.ddmore.mdl.utils.MdlPredictionHelper
import eu.ddmore.mdl.mdl.EquationDefinition

class ModelWriter {
	extension MdlObjectHelper moh = new MdlObjectHelper
	extension MdlPredictionHelper mph = new MdlPredictionHelper
	extension InfixMathsExpressionBuilder imeb = new InfixMathsExpressionBuilder
	
	def writeModel(MclObject mdlObj){
		val predBlks = mdlObj.modelPrediction
		'''
			$CMT
			«FOR p : predBlks»
				«FOR v : p.variables»
					«IF v instanceof EquationDefinition»
						double «v.name» = «v.expression.infixExpr»
					«ENDIF»
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