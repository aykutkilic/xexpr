package com.kilic.xexpr.dsl;

import org.eclipse.emf.ecore.EObject;
import org.eclipse.emf.ecore.EStructuralFeature;
import org.eclipse.xtext.naming.IQualifiedNameProvider;
import org.eclipse.xtext.naming.QualifiedName;

import com.kilic.xexpr.Expr;
import com.kilic.xtype.PhasedString;

public class PhasedStringQualifiedNameProvider extends IQualifiedNameProvider.AbstractImpl {

	@Override
	public QualifiedName getFullyQualifiedName(EObject obj) {
		EStructuralFeature nameFeature = obj.eClass().getEStructuralFeature("name");
		if(nameFeature == null)
			return null;
		
		Object nameValue = obj.eGet(nameFeature);

		String name = null;

		if(nameValue instanceof PhasedString) {
			PhasedString ps = (PhasedString)nameValue;
			
			if( ps.getValue() != null ) {
				name = ps.getValue();
			} else if(ps.getValueExpr() != null) {
				Expr expr = ps.getValueExpr();
			}
		}
		
		if(name == null) return null;
		QualifiedName qn = QualifiedName.create(name);
		
		if(obj.eContainer()!=null) {
		}
		
		return qn;
	}
}
