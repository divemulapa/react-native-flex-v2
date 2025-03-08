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
  func createToken(_ options: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
    let service = FlexService()
    // Extract the JWT and card information
    let captureContext = options["jwt"] as! String
    let cardInfo = options["cardInfo"] as! NSDictionary
    let cardNumber = cardInfo["cardNumber"] as! String
    let expiryMonth = cardInfo["cardExpirationMonth"] as! String
    let expiryYear = cardInfo["cardExpirationYear"] as! String
    let cvv = cardInfo["cardCVV"] as! String

    // Build payload with nested structure
    var payload = [String: String]()
    payload["paymentInformation.card.number"] = cardNumber
    payload["paymentInformation.card.securityCode"] = cvv
    payload["paymentInformation.card.expirationMonth"] = expiryMonth
    payload["paymentInformation.card.expirationYear"] = expiryYear

    service.createTransientToken(from: captureContext, data: payload) { (result) in
      switch result {
        case .success(let tokenResponse):
          // Pass the token ID back to JavaScript (using NSNull for no error)
          callback([NSNull(), tokenResponse])
        case .failure(let error):
          // On failure, pass an error code and message.
          callback(["TOKENIZATION_FAILED", error.localizedDescription])
      }
    }
  }
}
