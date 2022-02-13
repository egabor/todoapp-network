import Foundation
import Swinject
import todoapp_network
import Logging

struct TestUtilAssembly: Assembly {

    func assemble(container: Container) {

        container.register(Logger.self) { _ in
            var logger = Logger(label: "todoapp.network.unit-test")
            logger.logLevel = Logger.Level.info
            return logger
        }
    }
}
