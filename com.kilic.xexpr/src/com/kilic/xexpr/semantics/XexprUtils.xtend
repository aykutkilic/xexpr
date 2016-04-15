package com.kilic.xexpr.semantics

import com.kilic.xtype.TypeExpr
import com.kilic.xtype.Attribute
import com.kilic.xtype.XtypeFactory

class XexprUtils {

	def createNumberType(String number) {
		if(number.contains('.')) XtypeFactory::eINSTANCE.createRealTypeExpr
		else XtypeFactory::eINSTANCE.createIntegerTypeExpr
	}
	
	def createFunctionType( TypeExpr returnType, Attribute [] paramTypes ) {
		var result = XtypeFactory::eINSTANCE.createFunctionTypeExpr
		result.^return = returnType
		result.params.addAll( paramTypes )
		result
	}

}