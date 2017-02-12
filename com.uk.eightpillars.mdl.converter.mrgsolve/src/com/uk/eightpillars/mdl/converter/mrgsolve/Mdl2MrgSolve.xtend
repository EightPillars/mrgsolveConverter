package com.uk.eightpillars.mdl.converter.mrgsolve

import eu.ddmore.mdl.mdl.Mcl
import eu.ddmore.mdl.mdl.MclObject
import eu.ddmore.mdl.mdl.PropertyStatement
import eu.ddmore.mdl.mdl.Statement
import eu.ddmore.mdl.mdl.ValuePair
import eu.ddmore.mdl.provider.MogDefinitionProvider
import eu.ddmore.mdl.utils.DomainObjectModelUtils
import eu.ddmore.mdl.utils.MdlUtils
import java.util.ArrayList
import java.util.List
import org.eclipse.xtext.EcoreUtil2
import com.uk.eightpillars.mdl.converter.mrgsolve.treerewrite.TreeRewriteUtils

class Mdl2MrgSolve {
//	static val mdlVersion = "6.0"
	
	extension MdlUtils mu = new MdlUtils
	extension DomainObjectModelUtils domu = new DomainObjectModelUtils
	extension MogDefinitionProvider mrp = new MogDefinitionProvider
//	extension ModelDefinitionPrinter mdp = new ModelDefinitionPrinter
//	extension ModellingStepsPrinter msp = new ModellingStepsPrinter
//	extension FunctionDefinitionPrinter fdp = new FunctionDefinitionPrinter
//	extension ExpressionUtils eu = new ExpressionUtils
	extension TreeRewriteUtils tru = new TreeRewriteUtils

	var Mcl mdlRoot

	def writeDefaultName(MclObject it)'''
		<ct:Name>Generated from MDL. MOG ID: «name»</ct:Name>
	'''
	
	def getAllProperties(List<Statement> stmts){
		val retVal = new ArrayList<ValuePair>
		stmts.forEach[s|
			if(s instanceof PropertyStatement) s.properties.forEach[p|
									retVal.add(p)
								]
		]
		retVal
	}
	
//	def private getPharmMLInfoHeader(MclObject it)'''
//		«IF getBlocksByName(BlockDefinitionTable::MOG_INFO_BLK) != null»
//			«IF getBlocksByName(BlockDefinitionTable::MOG_INFO_BLK).isEmpty»
//				«writeDefaultName»
//			«ELSE»
//				«IF getBlocksByName(BlockDefinitionTable::MOG_INFO_BLK).head.nonBlockStatements.allProperties.exists[argumentName == 'name']»
//					<ct:Name>«getBlocksByName(BlockDefinitionTable::MOG_INFO_BLK).head.nonBlockStatements.allProperties.findFirst[argumentName == 'name'].expression.stringValue»</ct:Name>
//				«ELSE»
//					«writeDefaultName»
//				«ENDIF»
//				«IF getBlocksByName(BlockDefinitionTable::MOG_INFO_BLK).head.nonBlockStatements.allProperties.exists[argumentName == 'problemStmt']»
//					<ct:Description>
//						«getBlocksByName(BlockDefinitionTable::MOG_INFO_BLK).head.nonBlockStatements.allProperties.findFirst[argumentName == 'problemStmt'].expression.stringValue»
//					</ct:Description>
//				«ENDIF»
//			«ENDIF»
//		«ENDIF»
//	'''
	

	def convertToMrgSolve(MclObject mogInput){
  		mdlRoot = rewriteTree(EcoreUtil2.getContainerOfType(mogInput.eContainer, Mcl))
  		val mog = mdlRoot.getMogObj(mogInput.name)
  		
		val mObj = mog.mdlObj
		
		''''''		
	}


//  	def convertToPharmML(MclObject mogInput) {
//  		convertToPharmML(mogInput, null)
//  	}
  	
//  	def convertToPharmML(MclObject mogInput, String mdlParentPath) {
//  		mdlRoot = rewriteTree(EcoreUtil2.getContainerOfType(mogInput.eContainer, Mcl))
//  		val mog = mdlRoot.getMogObj(mogInput.name)
//		val mObj = mog.mdlObj
//  		
//		val paramWriter = if(mog.isParamObjDefined){
//			new StandardParameterWriter(mog.mdlObj)//, idLambda)
//		}
//		else{
//			new PriorParameterWriter(mObj, mog.priorObj) //, idLambda)
//		}
//		val TrialDesignObjectPrinter trialDesignWriter = if(mog.isDesignObjDefined)
//									new TrialDesignDesignObjectPrinter(mog, paramWriter)
//								else
//									new TrialDesignDataObjectPrinter(mog, paramWriter, if(mdlParentPath != null) Paths.get(mdlParentPath) else null)
//		'''
//			<?xml version="1.0" encoding="UTF-8"?>
//			<PharmML 
//				«printPharmMlNameSpaces»
//				writtenVersion="«writtenVersion»">
//				«mog.pharmMLInfoHeader»
//				<IndependentVariable symbId="«mObj.mdlIdv?.name ?: "T"»"/>
//				«mObj.writeFunctionDefinitions»	
//				«mObj.writeModelDefinition(if(mog.isParamObjDefined) mog.paramObj	else mog.priorObj, paramWriter)»
//				«trialDesignWriter.writeTrialDesign»
//				«writeModellingSteps(mObj, if(mog.isParamObjDefined) mog.paramObj else mog.priorObj,
//					if(mog.isDesignObjDefined) mog.designObj else mog.dataObj, mog.taskObj)»
//			</PharmML>
//		'''			
//	}

//	//+ Print PharmML namespaces
//	protected def printPharmMlNameSpaces()
//		'''
//		xmlns:xsi="«xsi»" 
//		xmlns="«xmlns_pharmML»"
//		xsi:schemaLocation="«xsi_schemaLocation»"
//		xmlns:math="«xmlns_math»"
//		xmlns:ct="«xmlns_ct»"
//		xmlns:ds="«xmlns_ds»"
//		xmlns:mdef="«xmlns_mdef»"
//		xmlns:mstep="«xmlns_mstep»"
//		xmlns:design="«xmlns_design»"
//		'''
}