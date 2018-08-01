/**
 * Copyright IBM Corporation 2018
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import Kitura
import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import KituraOpenAPI

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()
    
    public init() throws {
        // Run the metrics initializer
        initializeMetrics(router: router)
        KituraOpenAPI.addEndpoints(to: router)
    }
    
    func postInit() throws {
        // Endpoints
        initializeHelloRoutes(app: self)
        initializeMultiHandlerRoutes(app: self)
        initializeStencilRoutes(app: self)
        initializeMarkdownRoutes(app: self)
        initializeErrorRoutes(app: self)
        initializeCodableRoutes(app: self)
        initializeHealthRoutes(app: self)
        initializeStaticFileServers(app: self)
        initializeMiscRoutes(app: self)
        initializeNotFoundRoute(app: self)
    }
    
    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: cloudEnv.port, with: router)
        Kitura.run()
    }
}
