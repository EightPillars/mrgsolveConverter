package com.uk.eightpillars.mdl.converter.mrgsolve.treerewrite

import eu.ddmore.mdl.mdl.Mcl
import org.eclipse.emf.ecore.util.EcoreUtil

class TreeRewriteUtils {
	

	def Mcl rewriteTree(Mcl orig){
		val mdlRoot = EcoreUtil.copy(orig)
		val vectArgR = new VectorAttributeRewrite
		var cntr = 0
		val iter = mdlRoot.eAllContents
		while(iter.hasNext){
			val node = iter.next
			if(vectArgR.doSwitch(node) != null) cntr++	
		}
		mdlRoot
	}
	
	
}