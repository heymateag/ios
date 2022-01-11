import Starscream
import WalletConnectSwift
import ContactListUI
import Ramp
import Foundation

public struct BlockchainTest {
    public func decode() {
        let json = try? JSONDecoder().decode(RampPurchase.self, from: Data())
    }
}
