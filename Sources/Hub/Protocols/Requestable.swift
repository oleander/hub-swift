public protocol Requestable {
  func onWillSend(request: Request) throws
  func onDidSend(response: HTTPData) throws
  func onFailure(response: HTTPData) -> FailureAction
}

public extension Requestable {
  func onFailure(response: HTTPData) -> FailureAction {
    return .fail
  }

  func onDidSend(response: HTTPData) throws {}
}
