package com.kilic.xexpr.dsl;

import java.util.Set;

import org.eclipse.xtext.Grammar;
import org.eclipse.xtext.generator.BindFactory;
import org.eclipse.xtext.generator.Binding;
import org.eclipse.xtext.generator.exporting.QualifiedNamesFragment;
import org.eclipse.xtext.naming.IQualifiedNameProvider;

public class PhasedQualifiedNamesFragment extends QualifiedNamesFragment {
	@Override
	public Set<Binding> getGuiceBindingsRt(Grammar grammar) {
		return new BindFactory().addTypeToType(IQualifiedNameProvider.class.getName(),
				PhasedStringQualifiedNameProvider.class.getName()).getBindings();
	}
}
