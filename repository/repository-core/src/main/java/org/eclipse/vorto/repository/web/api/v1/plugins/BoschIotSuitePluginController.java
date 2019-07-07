/**
 * Copyright (c) 2018 Contributors to the Eclipse Foundation
 *
 * See the NOTICE file(s) distributed with this work for additional information regarding copyright
 * ownership.
 *
 * This program and the accompanying materials are made available under the terms of the Eclipse
 * Public License 2.0 which is available at https://www.eclipse.org/legal/epl-2.0
 *
 * SPDX-License-Identifier: EPL-2.0
 */
package org.eclipse.vorto.repository.web.api.v1.plugins;

import java.util.HashMap;
import java.util.Map;
import javax.servlet.http.HttpServletResponse;
import org.eclipse.vorto.repository.plugin.generator.GeneratorPluginConfiguration;
import org.eclipse.vorto.repository.web.api.v1.AbstractGeneratorController;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.ApiResponse;
import io.swagger.annotations.ApiResponses;

/**
 * @author Alexander Edelmann - Robert Bosch (SEA) Pte. Ltd.
 */
@Api(value = "/generate")
@RestController
@RequestMapping(value = "/api/v1/plugins/generators/boschiotsuite")
public class BoschIotSuitePluginController extends AbstractGeneratorController {

  @ApiOperation(
      value = "Generates device code to send telemetry data via MQTT to the Bosch Iot Suite IoT Platform")
  @ApiResponses(value = {@ApiResponse(code = 200, message = "Code was successfully generated."),
      @ApiResponse(code = 400, message = "Wrong input"),
      @ApiResponse(code = 404, message = "Model or generator not found")})
  @RequestMapping(value = "/models/{modelId:.+}/connectivity",
      method = RequestMethod.GET)
  public void generateBoschIoTSuiteDeviceConnectivity(
      @ApiParam(value = "the vorto model ID, e.g. com.acme:Thermostat:1.0.0",
          required = true) final @PathVariable String modelId, @RequestParam(value="language",required=true) Language language, final HttpServletResponse response) {
    Map<String, String> params = new HashMap<>();
    params.put("language", language.name());
    generateAndWriteToOutputStream(modelId, "boschiotsuite", params, response);
  }

  @ApiOperation(
      value = "Generates device provisioning script that registers device in the Bosch Iot Suite IoT Platform")
  @ApiResponses(value = {@ApiResponse(code = 200, message = "Code was successfully generated."),
      @ApiResponse(code = 400, message = "Wrong input"),
      @ApiResponse(code = 404, message = "Model or generator not found")})
  @RequestMapping(value = "/models/{modelId:.+}/provision",
      method = RequestMethod.GET)
  public void generateBoschIoTSuitePostman(
      @ApiParam(value = "the vorto model ID, e.g. com.acme:Thermostat:1.0.0",
          required = true) final @PathVariable String modelId, final HttpServletResponse response) {
    Map<String, String> params = new HashMap<>();
    params.put("provision", "true");
    generateAndWriteToOutputStream(modelId, "boschiotsuite", params, response);
  }

  @ApiOperation(
      value = "Returns meta information about the OpenAPI Plugin")
  @RequestMapping(value = "/", method = RequestMethod.GET,
      produces = MediaType.APPLICATION_JSON_VALUE)
  public GeneratorPluginConfiguration getBoschIoTSuiteInfo() {
    return this.generatorService.getPluginInfo("boschiotsuite", true);
  }
  
  public enum Language {
    python, arduino, java
  }
  
}
