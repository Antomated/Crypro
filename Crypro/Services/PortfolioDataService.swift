//
//  PortfolioDataService.swift
//  Crypro
//
//  Created by Anton Petrov on 04.04.2024.
//

import Foundation
import CoreData

class PortfolioDataService {

    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "Portfolio"

    @Published var savedEntities = [Portfolio]()

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                print("Error loading Core Data: \(error)")
            }
            self.getPortfolio()
        }
    }

}

// MARK: - Public methods

extension PortfolioDataService {
    func updatePortfolio(coin: Coin, amount: Double) {
        if let entity = savedEntities.first(where: { $0.coinID == coin.id }) {
            if amount > 0 {
                update(entity: entity, amount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            add(coin: coin, amount: amount)
        }
    }
}

// MARK: - Private methods

private extension PortfolioDataService {
    func getPortfolio() {
        let request = NSFetchRequest<Portfolio>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch let error {
            print("Error Fetching Portfolio Entities: \(error)")
        }
    }

    func add(coin: Coin, amount: Double) {
        let entity = Portfolio(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        applyChanges()
    }

    func update(entity: Portfolio, amount: Double) {
        entity.amount = amount
        applyChanges()
    }

    func save() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error Saving to Core Data: \(error)")
        }
    }

    func delete(entity: Portfolio) {
        container.viewContext.delete(entity)
        applyChanges()
    }

    func applyChanges() {
        save()
        getPortfolio()
    }
}
