import Foundation
import React
import flex_api_ios_sdk

@objc(FlexV2Module)
class FlexV2Module: NSObject, RCTBridgeModule {

  // MARK: - React Native Module Setup

  static func moduleName() -> String! {
    return "FlexV2Module"
  }

  static func requiresMainQueueSetup() -> Bool {
    // If your module needs to run on the main thread, return true.
    return true
  }

  // MARK: - Public Methods

  /// Creates a transient token using the provided options.
  ///
  /// - Parameters:
  ///   - options: A dictionary containing "jwt" and "cardInfo".
  ///   - callback: A callback block where the first element is an error (or NSNull if none) and the second is the token ID.
  @objc(createToken:withCallback:)
  func createToken(_ options: NSDictionary, withCallback callback: @escaping RCTResponseSenderBlock) {
    let service = FlexService()
    // Extract the JWT and card information
    let captureContext = options["jwt"] as! String
    let cardInfo = options["cardInfo"] as! NSDictionary
    let cardNumber = cardInfo["number"] as! String
    let expiryMonth = cardInfo["expiryMonth"] as! String
    let expiryYear = cardInfo["expiryYear"] as! String
    let cvv = cardInfo["cvv"] as! String

    // Build payload with nested structure
    var payload = [String: String]()
    payload["number"] = cardNumber
    payload["securityCode"] = cvv
    payload["expirationMonth"] = expiryMonth
    payload["expirationYear"] = expiryYear

    service.createTransientToken(from: captureContext, data: payload) { (result) in
      switch result {
        case .success(let tokenResponse):
          // Pass the token ID back to JavaScript (using NSNull for no error)
          callback([NSNull(), tokenResponse.token])
        case .failure(let error):
          // On failure, pass an error code and message.

          let status = error.responseStatus.status
          switch status {
          case 3000:
              print(error.responseStatus.message)
          default:
              callback(["UNKNOWN_ERROR", error.localizedDescription])
          }
      }
    }
  }
}
