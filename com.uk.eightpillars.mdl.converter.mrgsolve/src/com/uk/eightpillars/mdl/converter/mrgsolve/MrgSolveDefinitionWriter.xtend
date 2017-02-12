package com.uk.eightpillars.mdl.converter.mrgsolve

import eu.ddmore.mdl.mdl.EquationDefinition
import eu.ddmore.mdl.mdl.ListDefinition
import eu.ddmore.mdl.utils.MdlPredictionHelper

class MrgSolveDefinitionWriter {
	extension InfixMathsExpressionBuilder imeb = new InfixMathsExpressionBuilder
	extension MdlPredictionHelper mpd = new MdlPredictionHelper 
	
	def dispatch write(EquationDefinition ed){
		'''double «ed.name» = «ed.expression.infixExpr»'''
	}
	
	def dispatch write(ListDefinition ld){
		'''«IF ld.isDerivativeVariable»dxdt_«ld.name» = «ld.derivativeExpr.infixExpr»«ENDIF»'''
	}	
}