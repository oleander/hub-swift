import Quick
import Foundation
import Nimble

@testable import Hub

class HubTests: QuickSpec {
  override func spec() {
    describe("GET") {
      describe("dynamic") {
        let hub = Hub(
          host: URL(string: "http://example.com")!
        )

        it("handles raw string") {
          expect { try hub.get(path: "/").raw() }
            .to(contain("Example Domain"))
        }

        it("handles HTML") {
          expect { try hub.get(path: "/").html().css("body").first?.text }
            .to(contain("Example Domain"))
        }
      }

      describe("static") {
        it("handles raw string") {
          expect { try Hub.get(url: "http://example.com").raw() }
            .to(contain("Example Domain"))
        }
      }
    }
  }
}
