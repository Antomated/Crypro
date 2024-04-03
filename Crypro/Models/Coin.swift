//
//  Coin.swift
//  Crypro
//
//  Created by Anton Petrov on 02.04.2024.
//
// TODO: Remove mock

import Foundation

struct Coin: Decodable,
             Identifiable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let currentPrice: Double?
    let marketCap: Double?
    let marketCapRank: Double?
    let fullyDilutedValuation: Double?
    let totalVolume: Double?
    let high24H: Double?
    let low24H: Double?
    let priceChange24: Double?
    let priceChangePercentage24H: Double?
    let marketCapChange24H: Double?
    let marketCapChangePercentage24H: Double?
    let circulatingSupply: Double?
    let totalSupply: Double?
    let maxSupply: Double?
    let ath: Double?
    let athChangePercentage: Double?
    let athDate: String?
    let atl: Double?
    let atlChangePercentage: Double?
    let atlDate: String?
    let lastUpdated: String?
    let sparklineIn7D: Sparkline?
    let priceChangePercentage24HInCurrency: Double?
    let currentHoldings: Double?

    func updateHoldings(amount: Double) -> Coin {
        return Coin(id: id,
                    symbol: symbol,
                    name: name,
                    image: image,
                    currentPrice: currentPrice,
                    marketCap: marketCap,
                    marketCapRank: marketCapRank,
                    fullyDilutedValuation: fullyDilutedValuation,
                    totalVolume: totalVolume,
                    high24H: high24H,
                    low24H: low24H,
                    priceChange24: priceChange24,
                    priceChangePercentage24H: priceChangePercentage24H,
                    marketCapChange24H: marketCapChange24H,
                    marketCapChangePercentage24H: marketCapChangePercentage24H,
                    circulatingSupply: circulatingSupply,
                    totalSupply: totalSupply,
                    maxSupply: maxSupply,
                    ath: ath,
                    athChangePercentage: ath,
                    athDate: athDate,
                    atl: atl,
                    atlChangePercentage: atlChangePercentage,
                    atlDate: atlDate,
                    lastUpdated: lastUpdated,
                    sparklineIn7D: sparklineIn7D,
                    priceChangePercentage24HInCurrency: priceChangePercentage24HInCurrency,
                    currentHoldings: amount)
    }

    var currentHoldingsValue: Double {
        (currentHoldings ?? 0) * (currentPrice ?? 0)
    }

    var rank: Int {
        Int(marketCapRank ?? 0)
    }
}

struct Sparkline: Decodable {
    let price: [Double]
}

// MARK: - Coin Mock Data

extension Coin {
    static let coin = Coin(
        id: "bitcoin",
        symbol: "btc",
        name: "Bitcoin",
        image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1696501400",
        currentPrice: 34192,
        marketCap: 667681654599,
        marketCapRank: 1,
        fullyDilutedValuation: 718039067934,
        totalVolume: 7467888918,
        high24H: 34373,
        low24H: 33950,
        priceChange24: 86.44,
        priceChangePercentage24H: 0.25345,
        marketCapChange24H: 1692282611,
        marketCapChangePercentage24H: 0.2541,
        circulatingSupply: 19527231.0,
        totalSupply: 21000000.0,
        maxSupply: 21000000.0,
        ath: 69045,
        athChangePercentage: 50.43888,
        athDate: "2021-11-10T14:24:11.849Z",
        atl: 67.81,
        atlChangePercentage: 50364.33374,
        atlDate: "2013-07-06T00:00:00.000Z",
        lastUpdated: "2023-10-29T10:13:53.528Z",
        sparklineIn7D: Sparkline(price: [
            30120.723845554643,
            29834.450247866767,
            29861.053470348448,
            29912.84513484603,
            29918.60990099258,
            29937.507106612047,
            29908.980915511478,
            29944.684536614674,
            29889.040842759936,
            29842.520579018714,
            29877.048790502897,
            29923.31943790576,
            29901.42449962285,
            29847.223723902178,
            29867.521959614132,
            29795.80438453275,
            29990.24756414851,
            30019.38050086351,
            30070.415637098926,
            30313.594071401127,
            30393.740462033857,
            30618.601977486273,
            30683.559263865387,
            30803.426405976563,
            30744.52331641732,
            30521.49730293795,
            30623.40681647576,
            30462.831763136153,
            30588.815714918404,
            30655.669046519935,
            30653.03562485807,
            30636.29231846089,
            30811.52972662852,
            30983.046800305456,
            31269.635517177252,
            31053.870425966048,
            31131.197078208203,
            31383.24904740796,
            31554.29712765209,
            31650.316640122837,
            33264.32768202586,
            32953.262760830985,
            33678.11942112208,
            33953.84784502067,
            34565.81280890615,
            34199.15724414233,
            34457.151589588946,
            34108.852462329225,
            33962.815803659796,
            34015.40358362411,
            34114.12331664621,
            34504.74226105354,
            34427.63076431406,
            34549.823192164884,
            34606.40663867492,
            34271.57965002467,
            34443.238870819885,
            33689.13389920468,
            33924.8125258236,
            33901.728040094444,
            33827.211987975745,
            33778.03673907698,
            33697.71193307675,
            34255.84700481297,
            34080.896772114276,
            33846.72425733224,
            34024.383140308826,
            34181.96667693515,
            34041.4078441213,
            33999.691409338295,
            34149.697520078706,
            34020.427380281406,
            34125.840776602345,
            33832.05989098268,
            33920.34877602841,
            34119.33095423452,
            34223.46629282618,
            34184.31955450562,
            34306.24590645088,
            34500.39950445031,
            34794.064294617725,
            34977.14917229203,
            34566.84669192482,
            34585.649270686525,
            34669.810155632666,
            34695.25689112283,
            34678.581491268335,
            34554.45704005894,
            34579.238189685086,
            34498.18414928194,
            34560.07735883247,
            34700.21210209115,
            34762.25600105437,
            34799.81951265261,
            34689.55138581278,
            34539.26331513439,
            34585.51754083313,
            34669.20048243959,
            34558.157533936625,
            34443.088552374844,
            34262.28229370022,
            34065.44522512412,
            34263.92160001575,
            34211.8998198967,
            34176.74777625217,
            34033.104374738556,
            33770.84081549448,
            33914.59488361607,
            33968.614846032244,
            34022.61393169833,
            34155.79511547591,
            34117.28146334639,
            34249.251206485445,
            34174.451552912586,
            33982.06706691499,
            33811.24275719445,
            34094.37861521169,
            34141.98316939835,
            34134.54785209992,
            34088.8952849728,
            34214.93736870389,
            33950.22191771048,
            34115.97198871094,
            34149.99902697573,
            34095.366687660164,
            34025.831912125635,
            34092.23886225304,
            34157.590829847795,
            33882.49540765278,
            33963.86892309777,
            33905.64181616615,
            33610.02693718559,
            33615.544337132786,
            33669.51273974943,
            33782.09349945729,
            33840.39395402028,
            33816.06934849948,
            33899.09305644032,
            33900.58995062194,
            33904.51103450244,
            34082.93895259495,
            34082.11023386474,
            34093.50647683378,
            34107.42141094718,
            34063.848628556356,
            34056.35890307521,
            34080.478619453665,
            34101.02661613586,
            34089.8772386167,
            34183.782924578,
            34012.7407062676,
            34083.1249839345,
            34095.33287935734,
            34227.92376720186,
            34130.04283424462,
            34112.7550582817,
            34188.02286594119,
            34119.260363113375,
            34116.98041021088,
            34191.840975173545,
            34113.21446355799,
            34092.630932838576,
            34103.79359791367,
            34019.65936489062,
            34024.53766456724,
            33982.87227589427,
            34045.17602616784,
            34038.11381558912
        ]),
        priceChangePercentage24HInCurrency: 0.2534541422958784,
        currentHoldings: 1.5
    )
}

