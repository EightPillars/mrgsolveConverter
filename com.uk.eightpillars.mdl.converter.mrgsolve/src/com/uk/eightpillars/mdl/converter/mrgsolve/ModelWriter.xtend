package com.uk.eightpillars.mdl.converter.mrgsolve

import eu.ddmore.mdl.mdl.ListDefinition
import eu.ddmore.mdl.mdl.MclObject
import eu.ddmore.mdl.mdl.RandomVariableDefinition
import eu.ddmore.mdl.mdl.SymbolReference
import eu.ddmore.mdl.mdl.VectorLiteral
import eu.ddmore.mdl.provider.BuiltinFunctionProvider
import eu.ddmore.mdl.provider.ListDefinitionProvider
import eu.ddmore.mdl.utils.ConstantEvaluation
import eu.ddmore.mdl.utils.ExpressionUtils
import eu.ddmore.mdl.utils.MdlObjectHelper
import eu.ddmore.mdl.utils.MdlPredictionHelper
import eu.ddmore.mdl.utils.MdlUtils
import eu.ddmore.mdllib.mdllib.SymbolDefinition

class ModelWriter {
	extension MdlObjectHelper moh = new MdlObjectHelper
	extension MdlPredictionHelper mph = new MdlPredictionHelper
	extension InfixMathsExpressionBuilder imeb = new InfixMathsExpressionBuilder
	extension MrgSolveDefinitionWriter msdw = new MrgSolveDefinitionWriter
	extension MdlUtils mu = new MdlUtils
	extension ListDefinitionProvider ldp = new ListDefinitionProvider
	extension ExpressionUtils eu = new ExpressionUtils
	extension BuiltinFunctionProvider bfp = new BuiltinFunctionProvider
	extension ConstantEvaluation ce = new ConstantEvaluation
	
	
	def parObjDefnWriter(SymbolDefinition paramList){
		if(paramList instanceof ListDefinition){
			val listType = paramList.firstAttributeList.listDefinition.get_ltd.name
			val valueAtt = switch(listType){
				case("StructuralEstimateReal"), case("VarEstimateReal"): "value"
				default: "unk"
			}
			paramList.firstAttributeList.getAttributeExpression(valueAtt)?.infixExpr
		}
		else null
	}
	
	def writeInitialOmegaValue(MclObject parObj, ListDefinition indivParamDefn){
		val ranEffVect = indivParamDefn.firstAttributeList.getAttributeExpression("ranEff")
		if(ranEffVect instanceof VectorLiteral){
			val ranEff = ranEffVect.vector.head?.symbolRef?.ref
			if(ranEff instanceof RandomVariableDefinition){
				val dist = ranEff.distn
				if(dist instanceof SymbolReference){
					val meanArg = switch(dist.ref.name){
						case "Normal": "sd"
		 				case "Normal1":
		 					"stdev"
		 				case "Normal2":
		 					"var"
		 				case "Normal3":
							"precision"
						default: "unk"
					}
					val meanVarRef = dist.getArgumentExpression(meanArg)?.symbolRef
					val parDefn = parObj.findMdlSymbolDefn(meanVarRef.ref.name)
					if(parDefn != null){
						val value = parObjDefnWriter(parDefn)
						'''«indivParamDefn.name» : «value»'''
					}
					else{
						'''«indivParamDefn.name»'''
					}
				}
				else null
			}
			else null
		}
		else null
	}
	
	def writeInitialValue(MclObject parObj, ListDefinition indivParamDefn){
		val popExpr = indivParamDefn.firstAttributeList.getAttributeExpression("pop")
		if(popExpr instanceof SymbolReference){
			val parDefn = parObj.findMdlSymbolDefn(popExpr.ref.name)
			if(parDefn != null){
				val value = parObjDefnWriter(parDefn)
				'''«indivParamDefn.name» : «value»'''
			}
			else{
				'''«indivParamDefn.name»'''
			}
		}
		else{
			val mathsEval = popExpr.evaluateMathsExpression
			if(mathsEval != null){
				'''«indivParamDefn.name» : «mathsEval»'''
			}
			else{
				'''«indivParamDefn.name»'''
			}
		}
	}
	
	def writeModel(MclObject mdlObj, MclObject parObj){
		val predBlks = mdlObj.modelPrediction
		val indivParamBlks = mdlObj.indivParameters
		'''
			$PARAM
			«FOR p : indivParamBlks»
				«FOR v : p.symbolDefs»
					«IF v instanceof ListDefinition»
						«parObj.writeInitialValue(v)»
					«ENDIF»
				«ENDFOR»
			«ENDFOR»
		
			$CMT
			«FOR p : predBlks»
				«FOR v : p.derivativeVariables»
					«v.name»
				«ENDFOR»
			«ENDFOR»
			
			$OMEGA @annotated
			«FOR p : indivParamBlks»
				«FOR v : p.symbolDefs»
					«IF v instanceof ListDefinition»
						«parObj.writeInitialOmegaValue(v)»
					«ENDIF»
				«ENDFOR»
			«ENDFOR»
			
			$ODE
			«FOR p : predBlks»
				«FOR v : p.symbolDefs»
					«v.write»;
				«ENDFOR»
			«ENDFOR»
			
			$CAPTURE
			«FOR p : mdlObj.observations»
				«FOR v : p.symbolDefs»
					«v.name»
				«ENDFOR»
			«ENDFOR»
		'''
	}
	
	
}