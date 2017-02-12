package com.uk.eightpillars.mdl.converter.mrgsolve

import com.uk.eightpillars.mdl.converter.mrgsolve.utils.ExpressionBuilder
import org.eclipse.xtext.junit4.XtextRunner
import org.junit.Before
import org.junit.Test
import org.junit.runner.RunWith

import static org.junit.Assert.assertEquals

@RunWith(typeof(XtextRunner))
class InfixMathsExpressionBuilderTest {
	extension ExpressionBuilder eb = new ExpressionBuilder
	
	var InfixMathsExpressionBuilder testInstance
	
	@Before
	def void setUp(){
		testInstance = new InfixMathsExpressionBuilder
	}
	
	@Test
	def void testWriteSimpleMutiplication(){
		val expr = createMultiplication('*', createInt(1), createReal(2.3))
				
		val expected = '''
			1 * 2.3'''
		assertEquals("Output as expected", expected, testInstance.getInfixExpr(expr).toString)
	}

	@Test
	def void testWriteSimpleMutiplicationWithSymb(){
		val expr = createMultiplication('*', createSymbRef(createVariable("x")), createReal(2.3))
				
		val expected = '''
			x * 2.3'''
		assertEquals("Output as expected", expected, testInstance.getInfixExpr(expr).toString)
	}

	@Test
	def void testWriteSimpleUnaryExpression(){
		val expr = createUnary('-', createSymbRef(createVariable("x")))
				
		val expected = '''
			-x'''
		assertEquals("Output as expected", expected, testInstance.getInfixExpr(expr).toString)
	}

	@Test
	def void testWriteSimpleMutiplicationWithSymbAndParen(){
		val expr = createMultiplication(
						'*',
						createSymbRef(createVariable("x")),
						createParen(
							createAddition("-", createReal(2.3), createInt(23))
						)
					)
				
		val expected = '''
			x * (2.3 - 23)'''
		assertEquals("Output as expected", expected, testInstance.getInfixExpr(expr).toString)
	}




}