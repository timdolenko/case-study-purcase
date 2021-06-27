import Foundation
import DITranquillity

var env = Environment()

class Environment {
    var container = DIContainer()
    
    var currencyService: CurrencyFormatService { resolve() }
    var loginService: LoginService { resolve() }
    var cardValidator: CardValidator { resolve() }
    var checkoutService: ToastCheckoutService { resolve() }
    
    var secrets = Secrets.self
    var translations = Translations()
    var style = Style()
    
    func injectLive() {
        container
            .register(CurrencyFormatServiceLive.init)
            .as(CurrencyFormatService.self)
            .lifetime(.perContainer(.strong))
        
        container
            .register(LoginServiceLive.init)
            .as(LoginService.self)
            .lifetime(.perContainer(.strong))
        
        container
            .register(CardValidatorLive.init)
            .as(CardValidator.self)
            .lifetime(.perContainer(.strong))
        
        container
            .register(ToastCheckoutServiceLive.init)
            .as(ToastCheckoutService.self)
            .lifetime(.perContainer(.strong))
        
        injectLiveNetworking()
        
        container
            .register(CheckoutRepositoryLive.init)
            .as(CheckoutRepository.self)
            .lifetime(.perContainer(.strong))
    }
}

extension Environment: Assembly {}
