/**
 * Copyright (c) 2018 Contributors to the Eclipse Foundation
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
package org.eclipse.vorto.plugin.generator.utils;

import org.eclipse.vorto.plugin.generator.InvocationContext;

/**
 * A {@link ICodeGeneratorTask} use generation templates which contain the context specific outcome
 * logic
 * 
 * @author Alexander Edelmann - Robert Bosch (SEA) Pte. Ltd.
 * 
 */
public interface ITemplate<Element> {

  /**
   * gets the generation template for the specified context
   * 
   * @param element the information model element to be converted by the template
   * @param context
   * @return generated content for the specified context
   */
  String getContent(Element element, InvocationContext context);

}
