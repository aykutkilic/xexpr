package com.kilic.xexpr.semantics

import com.kilic.xexpr.XexprFactory
import com.kilic.xexpr.Type
import com.kilic.xexpr.TypeWithName

class XexprUtils {
	def createNumberType(String number) {
		if(number.contains('.')) XexprFactory::eINSTANCE.createRealType
		else XexprFactory::eINSTANCE.createIntegerType
	}
	
	def createFunctionType( Type returnType, TypeWithName [] paramTypes ) {
		var result = XexprFactory::eINSTANCE.createFunctionType
		result.^return = returnType
		result.params.addAll( paramTypes )
		result
	}
}