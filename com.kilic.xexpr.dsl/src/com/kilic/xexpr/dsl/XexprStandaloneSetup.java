/*
 * generated by Xtext
 */
package com.kilic.xexpr.dsl;

/**
 * Initialization support for running Xtext languages 
 * without equinox extension registry
 */
public class XexprStandaloneSetup extends XexprStandaloneSetupGenerated{

	public static void doSetup() {
		new XexprStandaloneSetup().createInjectorAndDoEMFRegistration();
	}
}

