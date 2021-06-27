//
//  CardDetailsViewModelTest.swift
//  Toast DeliveryTests
//

@testable import ToastDelivery
import Foundation
import XCTest
import Combine
import DITranquillity

class ToastCheckoutServiceMock: ToastCheckoutService {
    
    var processCheckoutHistory: [(Card,CheckoutResponse)] = []
    
    func createCheckout(toast: ToastItem) -> AnyPublisher<CheckoutResponse, Error> {
        Empty(completeImmediately: true)
            .eraseToAnyPublisher()
    }
    
    var result: PaymentResult = .successful
    
    func processCheckout(with card: Card, checkout: CheckoutResponse) -> AnyPublisher<PaymentResult, Error> {
        processCheckoutHistory.append((card, checkout))
        return Just(result)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    
}

class CardDetailsViewModelTest: XCTestCase {
    
    var sut: CardDetailsViewModel!
    var container: DIContainer!
    private var bindings = Set<AnyCancellable>()
    
    var checkoutService: ToastCheckoutServiceMock {
        container.resolve()
    }
    
    override func setUp() {
        container = DIContainer()
        container.register(ToastCheckoutServiceMock.init)
            .as(ToastCheckoutService.self)
            .lifetime(.perContainer(.strong))
        
        env.container = container
        
        bindings = .init()
        
        sut = CardDetailsViewModel(toast: [ToastItem].stub.first!)
    }
    
    func test_whenDidTapDoneWithCardAndCheckoutAndSuccess_shouldReturnSuccessResult() {
        sut.validatedCard = .stub
        sut.checkout.send(.stub)
        
        let receivedResult = expectation(description: "result received")
        
        sut.result.sink { [unowned self] result in
            XCTAssertEqual(self.checkoutService.processCheckoutHistory.count, 1)
            XCTAssertEqual(result, .successful)
            receivedResult.fulfill()
        }
        .store(in: &bindings)
        
        sut.didTapDone.send(())
        
        waitForExpectations(timeout: 0.1, handler: nil)
    }
}
