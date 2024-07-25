//
//  PortfolioDataService.swift
//  Crypro
//
//  Created by Antomated on 04.04.2024.
//

import CoreData

final class PortfolioDataService {
    @Published var savedEntities = [Portfolio]()
    private let container: NSPersistentContainer
    private let containerName = "PortfolioContainer"
    private let entityName = "Portfolio"

    init() {
        container = NSPersistentContainer(name: containerName)
        container.loadPersistentStores { _, error in
            if let error = error {
                AppLogger.log(tag: .error, "Error loading Core Data: \(error)")
            }
            self.getPortfolio()
        }
    }
}

// MARK: - PortfolioDataServiceProtocol

extension PortfolioDataService: PortfolioDataServiceProtocol {
    var savedEntitiesPublisher: Published<[Portfolio]>.Publisher { $savedEntities }
    var savedEntitiesPublished: Published<[Portfolio]> { _savedEntities }

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

    func getPortfolio() {
        let request = NSFetchRequest<Portfolio>(entityName: entityName)
        do {
            savedEntities = try container.viewContext.fetch(request)
        } catch {
            AppLogger.log(tag: .error, "Error Fetching Portfolio Entities: \(error)")
        }
    }
}

// MARK: - Private methods

private extension PortfolioDataService {
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
        } catch {
            AppLogger.log(tag: .error, "Error Saving to Core Data: \(error)")
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
