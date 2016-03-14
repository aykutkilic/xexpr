package com.kilic.xexpr.semantics

import com.kilic.xexpr.XexprFactory
import com.kilic.xexpr.Type
import com.kilic.xexpr.Attribute

class XexprUtils {
	def createNumberType(String number) {
		if(number.contains('.')) XexprFactory::eINSTANCE.createRealType
		else XexprFactory::eINSTANCE.createIntegerType
	}
	
	def createFunctionType( Type returnType, Attribute [] paramTypes ) {
		var result = XexprFactory::eINSTANCE.createFunctionType
		result.^return = returnType
		result.params.addAll( paramTypes )
		result
	}
}