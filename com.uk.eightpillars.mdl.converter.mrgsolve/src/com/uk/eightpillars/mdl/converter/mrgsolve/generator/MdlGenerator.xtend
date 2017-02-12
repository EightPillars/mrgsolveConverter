/*
 * generated by Xtext
 */
package com.uk.eightpillars.mdl.converter.mrgsolve.generator

import eu.ddmore.mdl.mdl.Mcl
import eu.ddmore.mdl.provider.MogDefinitionProvider
import org.eclipse.emf.ecore.resource.Resource
import org.eclipse.xtext.generator.IFileSystemAccess
import org.eclipse.xtext.generator.IGenerator
import java.nio.file.Paths
import com.uk.eightpillars.mdl.converter.mrgsolve.Mdl2MrgSolve

//import static extension EcoreUtils2

/**
 * Generates code from your model files on save.
 * 
 * see http://www.eclipse.org/Xtext/documentation.html#TutorialCodeGeneration
 */
class MdlGenerator implements IGenerator {
	
	override void doGenerate(Resource resource, IFileSystemAccess fsa) {
		val resFileStr = resource.URI.toString 
		val mdlFileName = Paths.get(resFileStr)
        val mcl = resource.getContents().head as Mcl;
        
        val mogs = new MogDefinitionProvider().getMogObj(mcl);
        
        // TODO: We're currently making an assumption that there will be a single MOG
        // in the provided file.  This should be fine for Product 4.
        // This will be addressed under DDMORE-1221
        val mogsIt = mogs.iterator();
        if (!mogsIt.hasNext()) {
            throw new IllegalStateException("Must be (at least) one MOG defined in the provided MCL file"); 
        }
        val mog = mogsIt.next();
        

        val xtendConverter = new Mdl2MrgSolve();
        
//        final CharSequence converted = xtendConverter.convertToPharmML(mog);
//       	val newDest = dest.removeFileExtension().addFileExtension("xml");

		fsa.generateFile('output.xml', xtendConverter.convertToMrgSolve(mog)) //(mog, mdlFileName.parent.toAbsolutePath.normalize.toString))
	}
}
