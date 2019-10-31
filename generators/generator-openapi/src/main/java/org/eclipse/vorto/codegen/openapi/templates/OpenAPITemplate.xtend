/**
 * Copyright (c) 2019 Contributors to the Eclipse Foundation
 *
 * See the NOTICE file(s) distributed with this work for additional
 * information regarding copyright ownership.
 *
 * This program and the accompanying materials are made available under the
 * terms of the Eclipse Public License 2.0 which is available at
 * https://www.eclipse.org/legal/epl-2.0
 *
 * SPDX-License-Identifier: EPL-2.0
 */
package org.eclipse.vorto.codegen.openapi.templates

import org.eclipse.vorto.codegen.openapi.Utils
import org.eclipse.vorto.core.api.model.datatype.ConstraintIntervalType
import org.eclipse.vorto.core.api.model.datatype.ConstraintRule
import org.eclipse.vorto.core.api.model.datatype.ObjectPropertyType
import org.eclipse.vorto.core.api.model.datatype.PrimitivePropertyType
import org.eclipse.vorto.core.api.model.datatype.PrimitiveType
import org.eclipse.vorto.core.api.model.functionblock.Event
import org.eclipse.vorto.core.api.model.functionblock.FunctionblockModel
import org.eclipse.vorto.core.api.model.functionblock.Operation
import org.eclipse.vorto.core.api.model.functionblock.PrimitiveParam
import org.eclipse.vorto.core.api.model.functionblock.RefParam
import org.eclipse.vorto.core.api.model.functionblock.ReturnObjectType
import org.eclipse.vorto.core.api.model.functionblock.ReturnPrimitiveType
import org.eclipse.vorto.core.api.model.informationmodel.InformationModel
import org.eclipse.vorto.plugin.generator.InvocationContext
import org.eclipse.vorto.plugin.generator.utils.IFileTemplate

/**
 * Creates an OpenAPI v3 Specification for an Information Model. Supports configuration, status properties as well as operations
 * 
 */
class OpenAPITemplate implements IFileTemplate<InformationModel> {
			
	override getFileName(InformationModel model) {
		'''«model.name»-openapi-v3.yml'''
	}
	
	override getPath(InformationModel context) {
		return null
	}
	
	override getContent(InformationModel infomodel, InvocationContext context) {
		'''
		### Generated by Eclipse Vorto OpenAPI Generator from Model '«infomodel.namespace»:«infomodel.name»:«infomodel.version»'
		openapi: 3.0.0
		info:
		  title: Bosch Smart Home Local API for «infomodel.name» 
		  description: |- 
		    This descriptions focus on the JSON-based, REST-like API for a «infomodel.name».
		    
		    By using this documentation, the developer accepts and agrees to be bound by our [Terms and Conditions](https://github.com/BoschSmartHome/bosch-shc-api-docs#terms-and-conditions).
		    
		    This documentation is subject to the [Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International Public License](https://creativecommons.org/licenses/by-nc-nd/4.0/legalcode).
		    
		    Please report any trouble you might have with this documentation in our [GitHub tracker](https://github.com/BoschSmartHome/bosch-shc-api-docs/issues).
		  version: "0.1"
		servers:
		  - url: https://192.168.0.10:8443/smarthome
		    description: "Bosch Smart Home Controller URL"
		tags:
		  - name: Devices
		    description: List every Device
		  - name: Services
		    description: Services of your «infomodel.name»
		  - name: Update State
		    description: Update a state of your «infomodel.name»
		paths:
		  ###
		  ### Devices
		  ###
		  '/devices':
		    get:
		      summary: List all available Devices
		      description: >-
		          Returns all Devices.
		      tags:
		      - Devices
		      responses:
		        '200':
		          description: >-
		            The successfully completed request contains as its result the first
		            200 for the user available Devices.
		          content:
		            application/json:
		              schema:
		                type: array
		                items:
		                  $ref: '#/components/schemas/Device'
		        '404':
		          description: >-
		            The entity could not be found. One of the defined query parameters was invalid.
		          content:
		            application/json:
		              schema:
		                $ref: '#/components/schemas/AdvancedError'
		  '/devices/{id}':
		    get:
		      summary: Retrieve a specific Device
		      description: >-
		          Returns the Device identified by the `id` path parameter. The
		          response includes details about the Device.
		      tags:
		      - Devices
		      parameters:
		      - $ref: '#/components/parameters/deviceIdPathParam'
		      responses:
		        '200':
		          description: The request successfully returned the specific Device.
		          content:
		            application/json:
		              schema:
		                $ref: '#/components/schemas/Device'
		        '404':
		          description: >-
		            The entity could not be found. One of the defined query parameters was invalid.
		          content:
		            application/json:
		              schema:
		                $ref: '#/components/schemas/AdvancedError'
		  ###
		  ### «infomodel.name» Services
		  ###
		  '/devices/{id}/services':
		    get:
		      summary: List all services of a «infomodel.name» 
		      description: >-
		        Returns all services of the «infomodel.name» identified by the `id` path parameter.
		      tags:
		      - Services
		      parameters:
		      - $ref: '#/components/parameters/deviceIdPathParam'
		      responses:
		        '200':
		          description: >-
		            The list of services of the «infomodel.name» were successfully retrieved.
		          content:
		            application/json:
		              schema:
		                type: array
		                items:
		                  $ref: '#/components/schemas/«infomodel.name»Services'
		        '404':
		          description: >-
		            The entity could not be found. One of the defined query parameters was invalid.
		          content:
		            application/json:
		              schema:
		                $ref: '#/components/schemas/AdvancedError'
		  «FOR fbProperty : infomodel.properties»
		  '/devices/{id}/services/«fbProperty.name»':
		    get:
		      summary: Retrieve the «fbProperty.name» service of the «infomodel.name»
		      description: >-
		        Returns the «fbProperty.name» service of the «infomodel.name» identified by the
		        `id` path parameter.
		      tags:
		      - Services
		      parameters:
		      - $ref: '#/components/parameters/deviceIdPathParam'
		      responses:
		        '200':
		          description: The «fbProperty.name» was successfully retrieved.
		          content:
		            application/json:
		              schema:
		                $ref: '#/components/schemas/«fbProperty.type.name»'
		        '404':
		          description: >-
		            The entity could not be found. One of the defined query parameters was invalid.
		          content:
		            application/json:
		              schema:
		                $ref: '#/components/schemas/AdvancedError'
		  '/devices/{id}/services/«fbProperty.name»/state':
		    get:
		      summary: Retrieve the state of «fbProperty.name» service
		      description: >-
		        Returns the «fbProperty.name» state of the «infomodel.name» identified by the
		        `id` path parameter.
		      tags:
		      - Services
		      parameters:
		      - $ref: '#/components/parameters/deviceIdPathParam'
		      responses:
		        '200':
		          description: The «fbProperty.name» was successfully retrieved.
		          content:
		            application/json:
		              schema:
		                $ref: '#/components/schemas/«fbProperty.type.name»'
		        '404':
		          description: >-
		            The entity could not be found. One of the defined query parameters was invalid.
		          content:
		            application/json:
		              schema:
		                $ref: '#/components/schemas/AdvancedError'
		  «FOR event : fbProperty.type.functionblock.events»
		  '/devices/{id}/features/«fbProperty.name»/outbox/messages/«event.name»':
		    post:
		      summary: Receive «event.name» emitted by the device
		      description: |-
		        Send a message with the subject `«event.name»` `FROM` the Thing
		        identified by the `thingId` path parameter. The request body contains
		        the device event payload and the `Content-Type` header defines its type.
		        
		        In order to send a message, the user needs `WRITE` permission at the
		        Thing level.
		        
		        The HTTP request blocks until a response to the message is available
		        or until the `timeout` is expired. If many clients respond to
		        the issued message, the first response will complete the HTTP request.
		        
		        In order to handle the message in a fire and forget manner, add
		        a query-parameter `timeout=0` to the request.
		      tags:
		        - Messages
		      parameters:
		      - $ref: '#/components/parameters/devicesIdPathParam'
		      responses:
		        '202':
		          description: The message was sent and received by the Feature.
		        '404':
		          description: >-
		            The entity could not be found. One of the defined query parameters was invalid.
		          content:
		            application/json:
		              schema:
		                $ref: '#/components/schemas/AdvancedError'
		      «IF !event.properties.empty»
		      requestBody:
		        $ref: '#/components/requestBodies/«fbProperty.type.name»«event.name.toFirstUpper»EventPayload'
		      «ENDIF»
		  «ENDFOR»
		  «FOR operation : fbProperty.type.functionblock.operations»
		  '/devices/{id}/services/«fbProperty.name»/state/«operation.name»/':
		    put:
		      summary: Executes the «operation.name» on the device
		      description: |-
		        «IF operation.description !== null»«operation.description»«ELSE»Executes the «operation.name» on the device.«ENDIF»
		      tags:
		        - Update State
		      parameters:
		        - $ref: '#/components/parameters/deviceIdPathParam'
		      responses:
		        '202':
		          description: |-
		            The message was sent and received by the Feature.
		          «IF operation.returnType !== null»
		          content:
		            application/json:
		              schema:
		                «IF operation.returnType instanceof ReturnPrimitiveType»
		                «wrapIfMultiple(getPrimitive((operation.returnType as ReturnPrimitiveType).returnType).toString,(operation.returnType as ReturnPrimitiveType).multiplicity)»
		                «ELSEIF operation.returnType instanceof ReturnObjectType»
		                «wrapIfMultiple("$ref: '#/components/schemas/"+(operation.returnType as ReturnObjectType).returnType.name+"'",(operation.returnType as ReturnObjectType).multiplicity)»
		                «ENDIF»
		          «ENDIF»
		        '404':
		          description: >-
		            The entity could not be found. One of the defined query parameters was invalid.
		          content:
		            application/json:
		              schema:
		                $ref: '#/components/schemas/AdvancedError'
		      «IF !operation.params.empty»
		      requestBody:
		        $ref: '#/components/requestBodies/«fbProperty.type.name»«operation.name.toFirstUpper»Payload'
		      «ENDIF»
		  «ENDFOR»
		«ENDFOR»
		components:
		  schemas:
		    AdvancedError:
		      type: object
		      properties:
		        '@type':
		          type: string
		          description: The type of the object
		        errorCode:
		          type: string
		          description: The error code of the occurred exception
		        statusCode:
		          type: integer
		          description: The HTTP status of the error
		    Device:
		      type: object
		      properties:
		        '@type':
		          type: string
		          description: The type of the object
		        rootDeviceId:
		          type: string
		          description: The MAC of the Smart Home Controller
		        id:
		          type: string
		          description: The id of the device
		        deviceServiceIds:
		          $ref: '#/components/schemas/ServiceDefinition'		          
		        manufacturer:
		          type: string
		          description: The manufacturer of the device
		        roomId:
		          type: string
		          description: The id of the corresponding room
		        deviceModel:
		          type: string
		          description: The model of the device
		        serial:
		          type: string
		          description: The serial of the device
		        profile:
		          type: string
		          description: The profile of the device
		        name:
		          type: string
		          description: The name of the device
		        status:
		          type: string
		          description: Indicates if the device is available
		          enum: [AVAILABLE,UNAVAILABLE]
		    ServiceDefinition:
		      type: array
		      minItems: 1
		      uniqueItems: true
		      items:
		        type: string
		        description: "A single fully qualified identifier of a Service."
		    «FOR fb : Utils.getReferencedFunctionBlocks(infomodel)»
		    «IF fb.functionblock.configuration !== null»
		    «FOR configurationProperty : fb.functionblock.configuration.properties»
		    «fb.name»«configurationProperty.name.toFirstUpper»ConfigurationValue:
		      «IF configurationProperty.type instanceof PrimitivePropertyType»
		      «wrapIfMultiple(getPrimitive((configurationProperty.type as PrimitivePropertyType).type).toString,configurationProperty.multiplicity)»
		      «IF configurationProperty.constraintRule !== null»
		      «handleConstraints(configurationProperty.constraintRule)»
		      «ENDIF»
		      «ELSEIF configurationProperty.type instanceof ObjectPropertyType»
		      «wrapIfMultiple("$ref: '#/components/schemas/"+(configurationProperty.type as ObjectPropertyType).type.name+"'",configurationProperty.multiplicity)»
		      «ENDIF»
		    «ENDFOR»
		    «ENDIF»
		    «FOR operation : fb.functionblock.operations»
		    «IF !operation.params.empty»
		    «fb.name»«operation.name.toFirstUpper»Payload:
		      type: object
		      properties:
		        «FOR param : operation.params»
		        «param.name»:
		          «IF param.description !== null»description: «param.description»«ENDIF»
		          «IF param instanceof PrimitiveParam»
		          «wrapIfMultiple(getPrimitive((param as PrimitiveParam).type).toString,param.multiplicity)»
		          «IF param.constraintRule !== null»
		          «handleConstraints(param.constraintRule)»
		          «ENDIF»
		          «ELSEIF param instanceof RefParam»
		          «wrapIfMultiple("$ref: '#/components/schemas/"+(param as RefParam).type.name+"'",param.multiplicity)»
		          «ENDIF»
		        «ENDFOR»
		    «ENDIF»
		    «ENDFOR»
		    «fb.name»States:
		      type: object
		      description: «fb.name» states of «infomodel.name»
		      «IF (fb.functionblock.status !== null && !fb.functionblock.status.properties.isEmpty) || 
		      	  (fb.functionblock.configuration !== null && !fb.functionblock.configuration.properties.isEmpty)»
		      properties:
		      «ENDIF»
		        «IF fb.functionblock.status !== null && !fb.functionblock.status.properties.isEmpty»
		        status:
		          type: object
		          properties:
		            «FOR statusProperty : fb.functionblock.status.properties»
		            «statusProperty.name»:
		              «IF statusProperty.description !== null»description: «statusProperty.description»«ENDIF»
		              «IF statusProperty.type instanceof PrimitivePropertyType»
		              «wrapIfMultiple(getPrimitive((statusProperty.type as PrimitivePropertyType).type).toString,statusProperty.multiplicity)»
		              «IF statusProperty.constraintRule !== null»
		              «handleConstraints(statusProperty.constraintRule)»
		              «ENDIF»
		              «ELSEIF statusProperty.type instanceof ObjectPropertyType»
		              «wrapIfMultiple("$ref: '#/components/schemas/"+(statusProperty.type as ObjectPropertyType).type.name+"'",statusProperty.multiplicity)»
		            «ENDIF»
		            «ENDFOR»
		          «Utils.calculateRequired(fb.functionblock.status.properties)»
		        «ENDIF»
		        «IF fb.functionblock.configuration !== null && !fb.functionblock.configuration.properties.isEmpty»
		        configuration:
		          type: object
		          properties:
		            «FOR configProperty : fb.functionblock.configuration.properties»
		            «configProperty.name»:
		              «IF configProperty.description !== null»description: «configProperty.description»«ENDIF»
		              «IF configProperty.type instanceof PrimitivePropertyType»
		              «wrapIfMultiple(getPrimitive((configProperty.type as PrimitivePropertyType).type).toString,configProperty.multiplicity)»
		              «IF configProperty.constraintRule !== null»
		              «handleConstraints(configProperty.constraintRule)»
		              «ENDIF»
		              «ELSEIF configProperty.type instanceof ObjectPropertyType»
		              «wrapIfMultiple("$ref: '#/components/schemas/"+(configProperty.type as ObjectPropertyType).type.name+"'",configProperty.multiplicity)»
		            «ENDIF»
		            «ENDFOR»
		          «Utils.calculateRequired(fb.functionblock.configuration.properties)»
		        «ENDIF»
		    «fb.name»:
		      type: object
		      properties:
		        definition:
		          $ref: '#/components/schemas/ServiceDefinition'
		          description: The Definition of this «fb.name»
		        properties:
		          $ref: '#/components/schemas/«fb.name»States'
		          description: The State Object of this «fb.name» service
		    «ENDFOR»
		    «infomodel.name»Services:
		      type: object
		      description: >-
		        List all Services of the «infomodel.name»
		      properties:
		        «FOR fbProperty : infomodel.properties»
		        «fbProperty.name»:
		          «IF fbProperty.description !== null»description: «fbProperty.description»«ENDIF»
		          allOf:
		            - $ref: '#/components/schemas/«fbProperty.type.name»'
		        «ENDFOR»
		    «FOR entity : Utils.getReferencedEntities(infomodel)»
		    «entity.name»:
		      type: object
		      properties:
		        «FOR property : entity.properties»
		        «property.name»:
		          «IF property.description !== null»description: «property.description»«ENDIF»
		          «IF property.type instanceof PrimitivePropertyType»
		          «wrapIfMultiple(getPrimitive((property.type as PrimitivePropertyType).type).toString,property.multiplicity)»
		          «IF property.constraintRule !== null»
		          «handleConstraints(property.constraintRule)»
		          «ENDIF»
		          «ELSEIF property.type instanceof ObjectPropertyType»
		          «wrapIfMultiple("$ref: '#/components/schemas/"+(property.type as ObjectPropertyType).type.name+"'",property.multiplicity)»
		          «ENDIF»
		        «ENDFOR»
		      «Utils.calculateRequired(entity.properties)»
		    «ENDFOR»
		    «FOR enumeration : Utils.getReferencedEnums(infomodel)»
		    «enumeration.name»:
		      type: string
		      enum: [«FOR literal: enumeration.enums SEPARATOR ','»«literal.name»«ENDFOR»]
		    «ENDFOR»
		  
		  «IF hasRequestBodiesContent(infomodel)»requestBodies:«ENDIF»
		    «FOR fb : Utils.getReferencedFunctionBlocks(infomodel)»
		    «FOR event : fb.functionblock.events»
		    «IF !event.properties.empty»
		    «fb.name»«event.name.toFirstUpper»EventPayload:
		      content:
		        application/json:
		          schema:
		            type: object
		            properties:
		              «FOR eventProperty : event.properties»
		              «eventProperty.name»:
		                «IF eventProperty.description !== null»description: «eventProperty.description»«ENDIF»
		                «IF eventProperty.type instanceof PrimitivePropertyType»
		                «wrapIfMultiple(getPrimitive((eventProperty.type as PrimitivePropertyType).type).toString,eventProperty.multiplicity)»
		                «IF eventProperty.constraintRule !== null»
		                «handleConstraints(eventProperty.constraintRule)»
		                «ENDIF»
		                «ELSEIF eventProperty.type instanceof ObjectPropertyType»
		                «wrapIfMultiple("$ref: '#/components/schemas/"+(eventProperty.type as ObjectPropertyType).type.name+"'",eventProperty.multiplicity)»
		                «ENDIF»
		              «ENDFOR»
		            «Utils.calculateRequired(event.properties)»
		    «ENDIF»
		    «ENDFOR»
		    «IF fb.functionblock.configuration !== null»
		      «FOR configurationProperty : fb.functionblock.configuration.properties»
		        «fb.name»«configurationProperty.name.toFirstUpper»ConfigurationValue:
		          content:
		            application/json:
		              schema:
		                «IF configurationProperty.type instanceof PrimitivePropertyType»
		                «wrapIfMultiple(getPrimitive((configurationProperty.type as PrimitivePropertyType).type).toString,configurationProperty.multiplicity)»
		                «IF configurationProperty.constraintRule !== null»
		                «handleConstraints(configurationProperty.constraintRule)»
		                «ENDIF»
		                «ELSEIF configurationProperty.type instanceof ObjectPropertyType»
		                «wrapIfMultiple("$ref: '#/components/schemas/"+(configurationProperty.type as ObjectPropertyType).type.name+"'",configurationProperty.multiplicity)»
		                «ENDIF»
		      «ENDFOR»
		    «ENDIF»
		    «FOR operation : fb.functionblock.operations»
		    «IF !operation.params.empty»
		    «fb.name»«operation.name.toFirstUpper»Payload:
		      content:
		        application/json:
		          schema:
		            type: object
		            properties:
		              «FOR param : operation.params»
		              «param.name»:
		                «IF param.description !== null»description: «param.description»«ENDIF»
		                «IF param instanceof PrimitiveParam»
		                «wrapIfMultiple(getPrimitive((param as PrimitiveParam).type).toString,param.multiplicity)»
		                «IF param.constraintRule !== null»
		                «handleConstraints(param.constraintRule)»
		                «ENDIF»
		                «ELSEIF param instanceof RefParam»
		                «wrapIfMultiple("$ref: '#/components/schemas/"+(param as RefParam).type.name+"'",param.multiplicity)»
		                «ENDIF»
		              «ENDFOR»
		    «ENDIF»
		    «ENDFOR»
		  «ENDFOR»
		  parameters:
		    deviceIdPathParam:
		      name: id
		      in: path
		      description: The ID of the Device
		      required: true
		      schema:
		        type: string
		    propertyPathPathParam:
		      name: propertyPath
		      in: path
		      description: The path to the Property
		      required: true
		      schema:
		        type: string
		'''
	}
		
	/*
	 * Checks if the information has elements that requires request body to be set
	 */
	def hasRequestBodiesContent(InformationModel infomodel) {
		var boolean flag = false;
		
		for (FunctionblockModel fb : Utils.getReferencedFunctionBlocks(infomodel)) {
			for (Event event : fb.functionblock.events) {
				if (!event.properties.empty) {
					flag = true;
				}
			}
			
			if (fb.functionblock.configuration !== null && !fb.functionblock.configuration.properties.empty) {
				flag = true;
			}
			
			for (Operation operation : fb.functionblock.operations) {
				if (!operation.params.isEmpty) {
					flag = true;
				}
			}
		}
		return flag;
	}
	
	def handleConstraints(ConstraintRule rule) {
	'''
	«FOR constraint : rule.constraints»
	«getConstraint(constraint.type)»«constraint.constraintValues»
	«ENDFOR»
	'''
	}
		
	def wrapIfMultiple(String type, boolean isArray) {
		'''
		«IF isArray»
		type: array
		items:
		  «type»
		«ELSE»
		«type»
		«ENDIF»
		'''
	}
	
	def getPrimitive(PrimitiveType primitiveType) {
		'''
		«IF primitiveType == PrimitiveType.BASE64_BINARY»
		type: string
		«ELSEIF primitiveType == PrimitiveType.BOOLEAN»
		type: boolean
		«ELSEIF primitiveType == PrimitiveType.BYTE»
		type: string
		«ELSEIF primitiveType == PrimitiveType.DATETIME»
		type: string
		«ELSEIF primitiveType == PrimitiveType.DOUBLE»
		type: number
		«ELSEIF primitiveType == PrimitiveType.FLOAT»
		type: number
		«ELSEIF primitiveType == PrimitiveType.INT»
		type: integer
		«ELSEIF primitiveType == PrimitiveType.LONG»
		type: number
		«ELSEIF primitiveType == PrimitiveType.SHORT»
		type: integer
		«ELSE»
		type: string
		«ENDIF»
		'''
	}
	
	def getConstraint(ConstraintIntervalType type) {
		if(type == ConstraintIntervalType.STRLEN){
			return '''maxLength: '''
		} else if(type == ConstraintIntervalType.REGEX) {
			return '''pattern: '''
		} else if(type == ConstraintIntervalType.MIN) {
			return '''minimum: '''
		} else if(type == ConstraintIntervalType.MAX) {
			return '''maximum: '''
		} else if(type == ConstraintIntervalType.SCALING) {
			return '''multipleOf: '''
		} else if(type == ConstraintIntervalType.DEFAULT) {
			return '''default: '''
		}
		
		return null
	}	
	
}