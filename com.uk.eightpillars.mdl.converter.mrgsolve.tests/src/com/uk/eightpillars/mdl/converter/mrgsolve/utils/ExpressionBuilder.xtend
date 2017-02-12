package com.uk.eightpillars.mdl.converter.mrgsolve.utils

import eu.ddmore.mdl.mdl.MdlFactory
import eu.ddmore.mdllib.mdllib.Expression
import eu.ddmore.mdllib.mdllib.SymbolDefinition

class ExpressionBuilder {
	
	def createMultiplication(String op, Expression lhs, Expression rhs){
		val expr = MdlFactory.eINSTANCE.createMultiplicativeExpression
		expr.feature = op
		expr.leftOperand = lhs
		expr.rightOperand = rhs
		
		expr
	}
	
	def createAddition(String op, Expression lhs, Expression rhs){
		val expr = MdlFactory.eINSTANCE.createAdditiveExpression
		expr.feature = op
		expr.leftOperand = lhs
		expr.rightOperand = rhs
		
		expr
	}
	
	def createPower(Expression lhs, Expression rhs){
		val expr = MdlFactory.eINSTANCE.createPowerExpression
		expr.feature = "^"
		expr.leftOperand = lhs
		expr.rightOperand = rhs
		
		expr
	}
	
	def createParen(Expression parExpr){
		val expr = MdlFactory.eINSTANCE.createParExpression
		expr.expr = parExpr
		
		expr
	}
	
	def createUnary(String op, Expression operand){
		val expr = MdlFactory.eINSTANCE.createUnaryExpression
		expr.feature = op
		expr.operand = operand
		
		expr
	}
	
	def createInt(int intVal){
		val expr = MdlFactory.eINSTANCE.createIntegerLiteral
		expr.value = intVal
		
		expr
	}
	
	def createReal(double realVal){
		val expr = MdlFactory.eINSTANCE.createRealLiteral
		expr.value = realVal
		
		expr
	}
	
	def createString(String strVal){
		val expr = MdlFactory.eINSTANCE.createStringLiteral
		expr.value = strVal
		
		expr
	}
	
	def createBool(boolean isTrue){
		val expr = MdlFactory.eINSTANCE.createBooleanLiteral
		expr.isTrue = isTrue
		
		expr
	}
	
	def createSymbRef(SymbolDefinition symbDefn){
		val expr = MdlFactory.eINSTANCE.createSymbolReference
		expr.ref = symbDefn
		
		expr
	}
	
	def createVariable(String name){
		val expr = MdlFactory.eINSTANCE.createEquationDefinition
		expr.name = name
		
		expr
	}
	
}