//
//  AnalyticService.swift
//  Tracker
//
//  Created by Андрей Тапалов on 18.07.2024.
//

import YandexMobileMetrica

struct AnalyticService {
    
    static func activate() {
        guard let configuration = YMMYandexMetricaConfiguration(apiKey: "c9450fde-2b74-4adf-9f2b-ae26fc891655") else { return }
        YMMYandexMetrica.activate(with: configuration)
    }
    
    func report(event: String, params : [AnyHashable : Any]) {
        YMMYandexMetrica.reportEvent(event, parameters: params, onFailure: { error in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
}
