/*******************************************************************************
 * Copyright (c) 2015 Bosch Software Innovations GmbH and others.
 * All rights reserved. This program and the accompanying materials
 * are made available under the terms of the Eclipse Public License v1.0
 * and Eclipse Distribution License v1.0 which accompany this distribution.
 *   
 * The Eclipse Public License is available at
 * http://www.eclipse.org/legal/epl-v10.html
 * The Eclipse Distribution License is available at
 * http://www.eclipse.org/org/documents/edl-v10.php.
 *   
 * Contributors:
 * Bosch Software Innovations GmbH - Please refer to git log
 *******************************************************************************/
package org.eclipse.vorto.codegen.templates.java

import org.eclipse.vorto.codegen.api.ITemplate
import org.eclipse.vorto.core.api.model.informationmodel.FunctionblockProperty
import org.eclipse.vorto.core.api.model.informationmodel.InformationModel
import org.eclipse.vorto.codegen.api.InvocationContext

/**
 * Use Plugin SDK API instead!
 */
@Deprecated
class JavaInformationModelTemplate implements ITemplate<InformationModel>{
	
	var String classPackage
	var String[] imports
	var String interfacePrefix
	var String implSuffix
	var ITemplate<FunctionblockProperty> propertyTemplate
	var ITemplate<FunctionblockProperty> getterTemplate
	var ITemplate<FunctionblockProperty> setterTemplate
	
	new(String classPackage, 
		String interfacePrefix,
		String implSuffix,
		String[] imports,
		ITemplate<FunctionblockProperty> propertyTemplate, 
		ITemplate<FunctionblockProperty> getterTemplate, 
		ITemplate<FunctionblockProperty> setterTemplate) {
			this.classPackage=classPackage
			this.interfacePrefix = interfacePrefix
			this.implSuffix=implSuffix
			this.imports = imports
			this.propertyTemplate = propertyTemplate
			this.getterTemplate = getterTemplate
			this.setterTemplate = setterTemplate
	}
	
	override getContent(InformationModel im,InvocationContext invocationContext) {
		'''
			/*
			*****************************************************************************************
			* The present code has been generated by the Eclipse Vorto Java Code Generator.
			*
			* The basis for the generation was the Information Model which is uniquely identified by:
			* Name:			«im.name»
			* Namespace:	«im.namespace»
			* Version:		«im.version»
			*****************************************************************************************
			*/
			
			package «classPackage»;
			
			«FOR imprt :imports»
				import «imprt».*;
			«ENDFOR»
			
			/**
			* «im.description»
			*/
			public class «im.name.toFirstUpper» implements «interfacePrefix»«im.name.toFirstUpper» {
				«FOR fbProperty : im.properties»
					«propertyTemplate.getContent(fbProperty,invocationContext)»
					
				«ENDFOR»

				/**
				* The default constructor for «im.name.toFirstUpper».
				*/
				public «im.name.toFirstUpper»() {
					«FOR fbProperty : im.properties»
						// Use the standard implementation to initialize the «fbProperty.type.name».
						«fbProperty.name» = new «fbProperty.type.name»«implSuffix»();
						
				«ENDFOR»
				}
				«FOR fbProperty : im.properties»
					«getterTemplate.getContent(fbProperty,invocationContext)»
					
					«setterTemplate.getContent(fbProperty,invocationContext)»
										
				«ENDFOR»
			}
		'''
	}
}