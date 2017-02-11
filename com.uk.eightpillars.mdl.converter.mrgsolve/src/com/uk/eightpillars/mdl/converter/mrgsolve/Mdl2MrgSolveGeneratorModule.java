package com.uk.eightpillars.mdl.converter.mrgsolve;

import org.eclipse.xtext.service.AbstractGenericModule;

import com.uk.eightpillars.mdl.converter.mrgsolve.generator.MdlGenerator;

public class Mdl2MrgSolveGeneratorModule extends AbstractGenericModule {
	public Class<? extends org.eclipse.xtext.generator.IGenerator> bindIGenerator() {
        return MdlGenerator.class;
    }
}
