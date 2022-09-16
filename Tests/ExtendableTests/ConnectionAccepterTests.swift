import XCTest
@testable import Extendable

enum PhonyError: Error {
	case boom
}

final class ConnectionAccepterTests: XCTestCase {
    func testThrowsDuringAccept() throws {
		let connection = NSXPCConnection()
		
		let accepter = ConnectionAccepter({ _ in
			throw PhonyError.boom
		})

		XCTAssertFalse(accepter.accept(connection: connection))
    }
}
