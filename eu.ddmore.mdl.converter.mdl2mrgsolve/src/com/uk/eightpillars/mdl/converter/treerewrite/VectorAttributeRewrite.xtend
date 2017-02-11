package com.uk.eightpillars.mdl.converter.treerewrite

import eu.ddmore.mdl.mdl.MdlPackage
import eu.ddmore.mdl.mdl.ValuePair
import eu.ddmore.mdl.mdl.util.MdlSwitch
import eu.ddmore.mdl.type.TypeSystemProvider
import eu.ddmore.mdl.type.VectorTypeInfo

class VectorAttributeRewrite extends MdlSwitch<Boolean> {
	
	extension TypeSystemProvider tsp = new TypeSystemProvider
	
	// this assumes that the AST is valid 
	override caseValuePair(ValuePair it){
		val argType = typeFor
		if(argType instanceof VectorTypeInfo){
			if(!(expression.typeFor.underlyingType instanceof VectorTypeInfo)){
				val fact = MdlPackage.eINSTANCE.mdlFactory
				val vect = fact.createVectorLiteral
				val el = fact.createVectorElement
				el.element = expression
				vect.expressions.add(el)
				expression = vect
				Boolean::TRUE
			}
		}
		
	}
		
}