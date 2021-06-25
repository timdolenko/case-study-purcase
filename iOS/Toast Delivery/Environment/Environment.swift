import Foundation
import DITranquillity

var env = Environment()

class Environment {
    var container = DIContainer()
    
    var currencyService: CurrencyFormatService {
        container.resolve()
    }
    
    func injectLive() {
        container
            .register(CurrencyFormatServiceLive.init)
            .as(CurrencyFormatService.self)
            .lifetime(.perContainer(.strong))
    }
}
