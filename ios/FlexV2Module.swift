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
  @objc func createToken(_ options: NSDictionary, callback: @escaping RCTResponseSenderBlock) {
      let service = FlexService()
    // Extract the JWT and card information
    guard let jwt = options["jwt"] as? String,
          let cardInfo = options["cardInfo"] as? NSDictionary,
          let cardNumber = cardInfo["cardNumber"] as? String,
          let expiryMonth = cardInfo["cardExpirationMonth"] as? String,
          let expiryYear = cardInfo["cardExpirationYear"] as? String,
          let cvv = cardInfo["cardCVV"] as? String else {
      callback(["TOKENIZATION_FAILED", "Invalid parameters"])
      return
    }

    // Build payload with nested structure
    let payload: [String: Any] = [
      "paymentInformation.card.number": cardNumber,
      "paymentInformation.card.securityCode": cvv,
      "paymentInformation.card.expirationMonth": expiryMonth,
      "paymentInformation.card.expirationYear": expiryYear
    ]

    do {
      // The capture context is actually a JWT itself
      let captureContext = jwt

      // Create the token asynchronously.
      // Here, we assume FlexService has a singleton `shared` and a method `createToken`
      // that accepts the capture context, payload, and a completion handler.
    service.createTransientToken(from: captureContext, data: payload) { (result) in
        switch result {
        case .success(let tokenResponse):
          // Pass the token ID back to JavaScript (using NSNull for no error)
          callback([NSNull(), tokenResponse.id])
        case .failure(let error):
          // On failure, pass an error code and message.
          callback(["TOKENIZATION_FAILED", error.localizedDescription])
        }
      }
    } catch let error {
      // Handle any errors thrown during the creation of the capture context.
      callback(["TOKENIZATION_FAILED", error.localizedDescription])
    }
  }
}
