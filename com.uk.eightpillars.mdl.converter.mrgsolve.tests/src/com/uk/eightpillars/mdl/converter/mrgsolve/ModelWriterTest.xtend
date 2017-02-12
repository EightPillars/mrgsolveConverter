package com.uk.eightpillars.mdl.converter.mrgsolve

import com.google.inject.Inject
import org.eclipse.xtext.junit4.InjectWith
import org.junit.runner.RunWith
import org.eclipse.xtext.junit4.XtextRunner
import eu.ddmore.mdl.MdlAndLibInjectorProvider
import org.eclipse.xtext.junit4.validation.ValidationTestHelper
import org.junit.Test
import static org.junit.Assert.*
import eu.ddmore.mdl.mdl.Mcl
import com.uk.eightpillars.mdl.converter.mrgsolve.utils.MdlTestHelper

@RunWith(typeof(XtextRunner))
@InjectWith(typeof(MdlAndLibInjectorProvider))
class ModelWriterTest {
	@Inject extension MdlTestHelper<Mcl>
	@Inject extension ValidationTestHelper
	
	val static CODE_SNIPPET = '''
parameterObjectName = parObj {
	# By default a parameter is to be estimated if fix is omitted
 	STRUCTURAL {
 		CL_POP : { value=1 }
 		VC_POP : { value=20 }
 		KA1_POP : { value=1 }
 		KA2_POP : { value=1 }
 		VMAX_POP : { value= 0 }
 		KM_POP : { value= 2 }
	} # end STRUCTURAL
	VARIABILITY {
 		CL_OMEGA : { value=0.4 }
 		VC_OMEGA : { value=2.8 }
 		KA1_OMEGA : { value=0.11 }
 		KA2_OMEGA : { value=0.1 }
 		VMAX_OMEGA : { value= 0.909 }
 		KM_OMEGA : { value= 0.2 }
	} # end VARIABILITY
} # end of parameter object 
modelObjectName = mdlObj {
	# Independent variable of model
	IDV{ T }

	STRUCTURAL_PARAMETERS{
 		CL_POP
 		VC_POP
 		KA1_POP
 		KA2_POP
 		VMAX_POP
 		KM_POP
	}

	VARIABILITY_PARAMETERS{
 		CL_OMEGA
 		VC_OMEGA
 		KA1_OMEGA
 		KA2_OMEGA
 		VMAX_OMEGA
 		KM_OMEGA
	}


	# Levels of random variability define here
	VARIABILITY_LEVELS{
		ID : { level=2, type is parameter }
		DV : { level=1, type is observation }
	}

	# Define individual parameters
	INDIVIDUAL_VARIABLES {
		# For maximum interoperability with a linear covariate model use this form.
	    CL : {type is linear, pop = CL_POP, ranEff = [CL_ETA]}
	    VC : {type is linear, pop = VC_POP, ranEff = [VC_ETA]}
	    KA1 : {type is linear, pop = KA1_POP, ranEff = [KA1_ETA]}
	    KA2 : {type is linear, pop = KA2_POP, ranEff = [KA2_ETA]}
	    VMAX : {type is linear, pop = VMAX_POP, ranEff = [VMAX_ETA]}
	    KM : {type is linear, pop = KM_POP, ranEff = [KM_ETA]}
	}

	RANDOM_VARIABLE_DEFINITION(level=ID){
		CL_ETA ~ Normal1(mean = 0, stdev = CL_OMEGA)
		VC_ETA ~ Normal1(mean = 0, stdev = VC_OMEGA)
		KA1_ETA ~ Normal1(mean = 0, stdev = KA1_OMEGA)
		KA2_ETA ~ Normal1(mean = 0, stdev = KA2_OMEGA)
		VMAX_ETA ~ Normal1(mean = 0, stdev = VMAX_OMEGA)
		KM_ETA ~ Normal1(mean = 0, stdev = KM_OMEGA)
	}

	# Define the model
	MODEL_PREDICTION {
		# ODEs can go in the DEQ block
		DEQ{
			EV1 : { deriv = -KA1*EV1 }
			EV2 : { deriv = -KA2*EV2 }
			CENT : { deriv = KA1*EV1 + KA2*EV2 - (CL+CLNL)*CP }
		}
#		CT = PERIPH/VP
		CLNL = VMAX/(KM+CP)
		CP = CENT/VC
	}
	
	# Define observations here
	OBSERVATION {
		CP_obs : { type is userDefined, prediction=CP, value=CP, weight=0 }
	}
}
	'''
	@Test
	def void testParsing(){
		CODE_SNIPPET.parse.assertNoErrors
		
	}
	
	@Test
	def void testModelWriter(){
		val mcl = CODE_SNIPPET.parse
		
		val parObj = mcl.objects.get(0)
		val mdlObj = mcl.objects.get(1)
		val testInstance = new ModelWriter
		
		val actualVal = testInstance.writeModel(mdlObj, parObj)
		val expectedVal = '''
$PROB
# Model: `pk1cmt`
  - One-compartment PK model
      - Dual first-order absorption
      - Optional nonlinear clearance from `CENT`
  - Source: `mrgsolve` internal library
  - Date: `r Sys.Date()`
  - Version: `r packageVersion("mrgsolve")`
  

# Demo
```{r,echo=TRUE}
mod %>% 
  ev(object="e") %>% 
  mrgsim(end=288, delta=0.1) %>% 
  plot
```

$PARAM @annotated
CL   :  1  : Clearance (volume/time)
VC   : 20  : Central volume (volume)
KA1  :  1  : Absorption rate constant 1 (1/time)
KA2  :  1  : Absorption rate constant 2 (1/time)
VMAX :  0  : Maximum velocity (mass/time)
KM   :  2  : Michaelis Constant (mass/volume)

$CMT @annotated
EV1  : First extravascular compartment
CENT : Central compartment
EV2  : Second extravascular compartment

$GLOBAL
#define CP (CENT/VC)
#define CT (PERIPH/VP)
#define CLNL (VMAX/(KM+CP))

$ODE
dxdt_EV1 = -KA1*EV1;
dxdt_EV2 = -KA2*EV2;
dxdt_CENT = KA1*EV1 + KA2*EV2 - (CL+CLNL)*CP;

$CAPTURE @annotated
CP : Plasma concentration (mass/volume)

$ENV
e <- ev(amt=100, ii=24, addl=9)

cama <- function(mod,...) {
  mod %>% 
    update(...) %>%
    mrgsim(events=e,end=288,delta=0.1) 
}
		'''
		
		System.out.println(actualVal)
		assertEquals(expectedVal, actualVal)
	}
}