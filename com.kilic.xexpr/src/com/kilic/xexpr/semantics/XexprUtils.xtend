package com.kilic.xexpr.semantics

import com.kilic.xtype.Type
import com.kilic.xtype.Attribute
import com.kilic.xtype.XtypeFactory

class XexprUtils {

	def createNumberType(String number) {
		if(number.contains('.')) XtypeFactory::eINSTANCE.createRealType
		else XtypeFactory::eINSTANCE.createIntegerType
	}
	
	def createFunctionType( Type returnType, Attribute [] paramTypes ) {
		var result = XtypeFactory::eINSTANCE.createFunctionType
		result.^return = returnType
		result.params.addAll( paramTypes )
		result
	}

}