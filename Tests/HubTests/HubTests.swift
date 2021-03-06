import Quick
import Foundation
import SwiftyJSON
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

      describe("JSON") {
        it("headers") {
          let cookies: [String: String] = [
            "key1": "value1",
            "key2": "value2"
          ]

          let headers: [String: String] = [
            "h1": "value1",
            "h2": "value2",
            "Content-Type": "application/json"
          ]

          let hub = Hub(
            host: URL(string: "http://localhost:4567")!,
            headers: headers,
            cookies: cookies
          )

          expect {
            try hub.get(path: "/ping.json").json()["cookies"]
          }.to(equal(JSON(cookies)))

          expect {
            try hub.get(path: "/ping.json").json()["headers"]
          }.to(equal(JSON(headers)))
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
