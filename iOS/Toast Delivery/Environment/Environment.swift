import Foundation
import DITranquillity

var env = Environment()

class Environment {
    var container = DIContainer()
    
    var currencyService: CurrencyFormatService {
        container.resolve()
    }
    
    var secrets = Secrets.self
    
    func injectLive() {
        container
            .register(CurrencyFormatServiceLive.init)
            .as(CurrencyFormatService.self)
            .lifetime(.perContainer(.strong))
    }
}
