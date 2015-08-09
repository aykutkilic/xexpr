package com.kilic.xexpr.interpreter

import java.util.Stack
import java.util.Set
import com.kilic.xexpr.VarDecl

class CallStack {
	var Set<Instance> global
	var Stack<Set<Instance>> callStack
	
	def getTopEntry() {
		callStack.head
	}
	
	def addVariable( Instance ^var) {
		if(callStack.size>0) {
			topEntry.add(^var)
		} else {
			global.add(^var)
		}
	}
	
	def getVariable( VarDecl ^var ) {
		topEntry.findFirst[it.^var == ^var]
	}
}