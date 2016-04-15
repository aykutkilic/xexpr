package com.kilic.xexpr.interpreter

import com.google.inject.Inject

import com.kilic.xexpr.AssignmentExpr
import com.kilic.xexpr.IfExpr
import com.kilic.xexpr.SwitchExpr
import com.kilic.xexpr.ForEachExpr
import com.kilic.xexpr.ForLoopExpr
import com.kilic.xexpr.WhileExpr
import com.kilic.xexpr.DoWhileExpr
import com.kilic.xexpr.BlockExpr
import com.kilic.xexpr.VarDecl
import com.kilic.xexpr.UnaryOperation
import com.kilic.xexpr.BinaryOperation
import com.kilic.xexpr.CastedExpr
import com.kilic.xexpr.ClosureExpr
import com.kilic.xexpr.ReturnExpr
import com.kilic.xexpr.MemberFeatureCall
import com.kilic.xexpr.StringLiteralExpr
import com.kilic.xexpr.NumberLiteralExpr
import com.kilic.xexpr.BooleanLiteralExpr
import com.kilic.xexpr.NullLiteralExpr
import com.kilic.xexpr.CallExpr
import com.kilic.xexpr.MatrixExpr
import com.kilic.xexpr.ListExpr
import com.kilic.xexpr.VariableRefLiteral
import com.kilic.xexpr.UnaryOperatorEnum
import com.kilic.xexpr.Expr
import com.kilic.xexpr.BinaryOperatorEnum
import com.kilic.xdigital.BinaryTypeExpr
import com.kilic.xdigital.PointerTypeExpr
import com.kilic.xexpr.semantics.Types
import com.kilic.xtype.StringTypeExpr
import com.kilic.xtype.IntegerTypeExpr
import com.kilic.xtype.NumberTypeExpr
import com.kilic.xtype.BooleanTypeExpr
import com.kilic.xtype.RealTypeExpr
import com.kilic.xtype.CompositeTypeExpr

class Interpreter {
	@Inject protected Types types;
	
	var CallStack callStack
	
	def dispatch eval(AssignmentExpr expr) {
	}
	
	def dispatch eval(IfExpr expr) {
		if(expr.^if.eval == true)  {
			return expr.then.eval
		} else {
			if( expr.^else != null ){
				return expr.^else.eval
			}
		}
	}
	
	def dispatch eval(SwitchExpr expr) {
		val value = eval(expr.^switch)
		var matchedCase = expr.cases.findFirst[it.^case.eval == value]
		
		if( matchedCase != null ) {
			return matchedCase.body.eval
		} else if(expr.^default != null ) {
			return expr.^default.eval
		}
	}
	
	def dispatch eval(ForEachExpr expr) {
		
	}
	
	def dispatch eval(ForLoopExpr expr) {
		expr.init.forEach[it.eval]
		
		while(expr.predicate.eval == true) {
			expr.body.eval
			expr.update.forEach[it.eval]
		}
	}
	
	def dispatch eval(WhileExpr expr) {
		while(expr.predicate.eval == true) {
			expr.body.eval
		}
	}
	
	def dispatch eval(DoWhileExpr expr) {
		do {
			expr.body.eval
		} while( expr.predicate.eval == true )
	}
	
	def dispatch eval(BlockExpr expr) {
		expr.exprs.forEach[it.eval]
	}
	
	def dispatch eval(VarDecl expr) {
		
	}
	
	def dispatch eval(UnaryOperation expr) {
		switch( expr.operator ) {
			case UnaryOperatorEnum.LOGIC_NOT: expr.expr.eval.opLogicNot
			case UnaryOperatorEnum.BINARY_NOT: (expr.expr.eval as Integer).bitwiseNot
			
			case UnaryOperatorEnum.NEGATION: expr.expr.eval.opNegate
			case UnaryOperatorEnum.POSITIVE: expr.expr.eval.opPositive
			
			case UnaryOperatorEnum.INCREMENT: expr.expr.opIncrement
			case UnaryOperatorEnum.DECREMENT: expr.expr.opDecrement
		}
	}
	
	def opLogicNot(Object value) {
		if(value instanceof Boolean) return !value
		if(value instanceof Integer) return value == 0
		
		throw new Exception("Type mismatch: expected bool")
	}
	
	def opBitwiseNot(Object value) {
		if(value instanceof Integer) return value.bitwiseNot
		throw new Exception("Type mismatch: expected integer")
	}
	
	def opNegate(Object value) {
		if(value instanceof Integer) return -value
		if(value instanceof Double)  return -value
		
		throw new Exception("Type mismatch: expected number")
	}
	
	def opPositive(Object value) {
		if(value instanceof Integer) return value
		if(value instanceof Double)  return value
		
		throw new Exception("Type mismatch: expected number")
	}
	
	def opIncrement(Expr e) {
		if(e instanceof VariableRefLiteral) {
			return
		}
		
		throw new Exception("Type mismatch: expected variable")
	}
	
	def opDecrement(Expr e) {
		if(e instanceof VariableRefLiteral) {
			return
		}
		
		throw new Exception("Type mismatch: expected variable")
	}
	
	def dispatch eval(BinaryOperation expr) {
		switch(expr.operator) {
			case BinaryOperatorEnum.ASSIGN: 			opAssign(expr.left, expr.right)
				
			case BinaryOperatorEnum.ADD: 				opAdd(expr.left, expr.right)
			case BinaryOperatorEnum.SUB:				opSub(expr.left, expr.right)
			case BinaryOperatorEnum.MUL:				opMul(expr.left, expr.right)
			case BinaryOperatorEnum.DIV:				opDiv(expr.left, expr.right)
			case BinaryOperatorEnum.BITWISE_AND: 		opBitwiseAnd(expr.left, expr.right)
			case BinaryOperatorEnum.BITWISE_OR:	 		opBitwiseOr(expr.left, expr.right)
			
			case BinaryOperatorEnum.SHIFT_RIGHT: 		opShiftRight(expr.left, expr.right)
			case BinaryOperatorEnum.SHIFT_LEFT:  		opShiftLeft(expr.left, expr.right)
			
			case BinaryOperatorEnum.MOD:				opMod(expr.left, expr.right)
			
			case BinaryOperatorEnum.IS_EQUAL:			opIsEqual(expr.left, expr.right)
			case BinaryOperatorEnum.NOT_EQUAL:			opNotEqual(expr.left, expr.right)
			case BinaryOperatorEnum.GREATER:			opGreater(expr.left, expr.right)
			case BinaryOperatorEnum.GREATER_OR_EQUAL: 	opGreaterOrEqual(expr.left, expr.right)
			case BinaryOperatorEnum.LESS: 				opLess(expr.left, expr.right)
			case BinaryOperatorEnum.LESS_OR_EQUAL:		opLessOrEqual(expr.left, expr.right)
	
			case BinaryOperatorEnum.LOGIC_AND:			opLogicAnd(expr.left, expr.right)
			case BinaryOperatorEnum.LOGIC_OR:			opLogicOr(expr.left, expr.right)
		}
	}
	
	def opAssign(Expr left, Expr right) {
		if(left instanceof VariableRefLiteral) {
			var r = types.type(right)
		}
		throw new Exception("Error: lvalue must be variable")
	}
	
	def opAdd(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			StringTypeExpr:	
				switch(rtype) {
					BinaryTypeExpr,  NumberTypeExpr, StringTypeExpr, PointerTypeExpr: 
						return lval as String + rval.toString
				}
			
			BinaryTypeExpr,
			IntegerTypeExpr:
				switch(rtype) {
					BooleanTypeExpr:
						return lval as Integer + if(rval as Boolean) 1 else 0
						
					BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr:
						return lval as Integer + rval as Integer

					RealTypeExpr:
						return lval as Integer + rval as Double
												
					StringTypeExpr:
						return lval.toString + rval as String
				}
			
			RealTypeExpr:
				switch(rtype) {
					BooleanTypeExpr:
						return lval as Double + if(rval as Boolean) 1 else 0
						
					BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr:
						return lval as Double + rval as Integer
					
					RealTypeExpr:
						return lval as Double - rval as Double
						
					StringTypeExpr:
						return lval.toString + rval as String
				}
			
			PointerTypeExpr:
				switch(rtype) {
					BinaryTypeExpr, NumberTypeExpr:
						// return (lval as Integer) + sizeof(ltype.getMemoryLayout) * (rval as Integer)
						return (lval as Integer) + 4 * (rval as Integer)
				}
		}
		
		// how to extend?
		
		throw new Exception('''Type error: '+' operator is not defined for «ltype.toString» and «rtype.toString»''')
	}
	
	def opSub(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			BinaryTypeExpr, IntegerTypeExpr:
				switch(rtype) {
					BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr:
						return lval as Integer - rval as Integer
						
					RealTypeExpr:
						return lval as Integer - rval as Double
				}
			
			RealTypeExpr:
				switch(rtype) {
					BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr:
						return lval as Double - rval as Integer
						
					RealTypeExpr:
						return lval as Double - rval as Double
				}
				
			PointerTypeExpr:
				switch(rtype) {
					BinaryTypeExpr, IntegerTypeExpr:
						//return (lval as Integer) - sizeof(ltype.getMemoryLayout) * (rval as Integer)
						return (lval as Integer) - 4 * (rval as Integer)
				}
		}
		
		throw new Exception('''Type error: '-' operator is not defined for «ltype.toString» and «rtype.toString»''')			
	}
	
	def opMul(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			BinaryTypeExpr, NumberTypeExpr:
				switch(rtype) {
					BinaryTypeExpr, IntegerTypeExpr:
						return lval as Integer * rval as Integer 
				}
		}
		
		throw new Exception('''Type error: '*' operator is not defined for «ltype.toString» and «rtype.toString»''')
	}
	
	def opDiv(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			BinaryTypeExpr, IntegerTypeExpr:
				switch(rtype) {
					BinaryTypeExpr, IntegerTypeExpr:
						return lval as Integer / rval as Integer
					
					RealTypeExpr:
						return lval as Integer / rval as Double
				}
				
			RealTypeExpr:
				switch(rtype) {
					BinaryTypeExpr, IntegerTypeExpr:
						return lval as Double / rval as Integer
						
					RealTypeExpr:
						return lval as Double / rval as Double
				}
		}
		
		throw new Exception('''Type error: '/' operator is not defined for «ltype.toString» and «rtype.toString»''')
	}
	
	def opBitwiseAnd(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			BinaryTypeExpr:
				switch(rtype) {
					BinaryTypeExpr:
						return (lval as Integer).bitwiseAnd( rval as Integer )
				}
		}
		
		throw new Exception('''Type error: '&&' operator is not defined for «ltype.toString» and «rtype.toString»''')		
	}
	
	def opBitwiseOr(Expr left, Expr right) {
				var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			BinaryTypeExpr:
				switch(rtype) {
					BinaryTypeExpr:
						return (lval as Integer).bitwiseOr( rval as Integer )
				}
		}
		
		throw new Exception('''Type error: '||' operator is not defined for «ltype.toString» and «rtype.toString»''')	
	}
	
	def opShiftRight(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			BinaryTypeExpr:
				switch(rtype) {
					IntegerTypeExpr:
						return (lval as Integer) >> (rval as Integer)
				}
		}
		
		throw new Exception('''Type error: '>>' operator is not defined for «ltype.toString» and «rtype.toString»''')
	}
	
	def opShiftLeft(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			BinaryTypeExpr:
				switch(rtype) {
					IntegerTypeExpr:
						return (lval as Integer) << (rval as Integer)
				}
		}
		
		throw new Exception('''Type error: '<<' operator is not defined for «ltype.toString» and «rtype.toString»''')		
	}
	
	def opMod(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			IntegerTypeExpr, BinaryTypeExpr:
				switch(rtype) {
					IntegerTypeExpr, BinaryTypeExpr:
						return (lval as Integer) % (rval as Integer)
					RealTypeExpr:
						return (lval as Double) % (rval as Double)
				}
				
			RealTypeExpr:
				return (lval as Double) % (rval as Double)
				
			StringTypeExpr:
				switch(rtype) {
					StringTypeExpr:
						return (lval as String).split(rval as String)
				}
		}
		
		throw new Exception('''Type error: '%' operator is not defined for «ltype.toString» and «rtype.toString»''')	
	}
	
	def opIsEqual(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr:
				switch(rtype) {
					BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr:
						return (lval as Integer) == (rval as Integer)
				}
				
			RealTypeExpr:
				switch(rtype) {
					case BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr, RealTypeExpr:
						return (lval as Double) == (rval as Double)					
				}
				
			StringTypeExpr:
				switch(rtype) {
					StringTypeExpr:
						return (lval as String).equals((rval as String))
				}
		}
		
		throw new Exception('''Type error: '==' operator is not defined for «ltype.toString» and «rtype.toString»''')
	}
	
	def opNotEqual(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first
		
		try {
			return !opIsEqual(left,right)
		} catch(Exception e) {
			throw new Exception('''Type error: '!=' operator is not defined for «ltype.toString» and «rtype.toString»''')	
		}
	}
	
	def opGreater(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr:
				switch(rtype) {
					BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr:
						return (lval as Integer) > (rval as Integer)
				}
				
			RealTypeExpr:
				switch(rtype) {
					case BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr, RealTypeExpr:
						return (lval as Double) > (rval as Double)					
				}
		}
		
		throw new Exception('''Type error: '>' operator is not defined for «ltype.toString» and «rtype.toString»''')
	}
	
	def opLess(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr:
				switch(rtype) {
					BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr:
						return (lval as Integer) < (rval as Integer)
				}
				
			RealTypeExpr:
				switch(rtype) {
					case BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr, RealTypeExpr:
						return (lval as Double) < (rval as Double)					
				}
		}
		
		throw new Exception('''Type error: '<' operator is not defined for «ltype.toString» and «rtype.toString»''')
	}
	
	def opGreaterOrEqual(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first
		
		try {
			return !opLess(left,right)
		} catch(Exception e) {
			throw new Exception('''Type error: '>=' operator is not defined for «ltype.toString» and «rtype.toString»''')	
		}
	}
	
	def opLessOrEqual(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first
		
		try {
			return !opGreater(left,right)
		} catch(Exception e) {
			throw new Exception('''Type error: '<=' operator is not defined for «ltype.toString» and «rtype.toString»''')	
		}
	}

	def opLogicAnd(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			BooleanTypeExpr:
				switch(rtype) {
					BooleanTypeExpr:
						return (lval as Boolean) && (rval as Boolean)					
				}	
		}
		
		throw new Exception('''Type error: '&&' operator is not defined for «ltype.toString» and «rtype.toString»''')
	}
	
	def opLogicOr(Expr left, Expr right) {
		var ltype = types.type(left).first
		var rtype = types.type(right).first

		var lval = left.eval
		var rval = right.eval
		
		switch(ltype) {
			BooleanTypeExpr:
				switch(rtype) {
					BooleanTypeExpr:
						return (lval as Boolean) || (rval as Boolean)
				}	
		}
		
		throw new Exception('''Type error: '||' operator is not defined for «ltype.toString» and «rtype.toString»''')
	}
	
	def dispatch eval(CastedExpr expr) {
		val value = expr.target.eval
		
		switch(expr.typeExpr) {
			BinaryTypeExpr, IntegerTypeExpr, PointerTypeExpr: return value as Integer
			StringTypeExpr: return value as String
			RealTypeExpr: return value as Double
			
		}
	}
	
	def dispatch eval(ClosureExpr expr) {
		
	}
	
	def dispatch eval(ReturnExpr expr) {
		
	}
	
	def dispatch eval(MemberFeatureCall expr) {
		
	}
	
	def dispatch eval(StringLiteralExpr expr) {
		return expr.value
	}
	
	def dispatch eval(NumberLiteralExpr expr) {
		var type = types.type(expr).value
		switch(type) {
			IntegerTypeExpr: return Integer.parseInt(expr.value)
			RealTypeExpr: return Double.parseDouble(expr.value)
		}
		
		throw new Exception('''Error - unrecognised number literal type «type.toString»''')
	}
	
	def dispatch eval(BooleanLiteralExpr expr) {
	}
	
	def dispatch eval(NullLiteralExpr expr) {
	}
	
	def dispatch eval(CallExpr expr) {
	}
	
	def dispatch eval(MatrixExpr expr) {
	}
	
	def dispatch eval(ListExpr expr) {
	}
	
	def dispatch eval(VariableRefLiteral expr) {
	}
	
	def dispatch int sizeof(CompositeTypeExpr t) {
		return 1;		
	}
	
	def dispatch int sizeof(StringTypeExpr t) {
		return 1;
	}
	
	def dispatch int sizeof(PointerTypeExpr t) {
		return 1;
	}
}