//
//  Endpoints.swift
//  Toast Delivery
//

import Networking

class NetworkConfig: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://api.sumup.com/v0.1")!
    var headers: [String : String] = [:]
    var queryParameters: [String : String] = [:]
}

struct Endpoints {
    struct Checkouts {
        static let base = "/checkouts"
    }
}

extension Endpoints.Checkouts {
    static func processCheckout(
        with id: String,
        request: ProcessCheckoutRequestDTO
    ) -> Endpoint<ProcessCheckoutResponseDTO> {
        Endpoint(
            path: base + "/" + id,
            method: .put,
            bodyParameters: request
        )
    }
}
