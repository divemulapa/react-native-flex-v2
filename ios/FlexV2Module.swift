import Foundation
import React
import flex_api_ios_sdk

@objc(FlexV2Module)
class FlexV2Module: RCTEventEmitter {

  // MARK: - React Native Module Setup

  @objc
  override static func requiresMainQueueSetup() -> Bool {
    // Our module does not require the main thread for init
    return false
  }

  @objc
  override func supportedEvents() -> [String]! {
    return []
  }

  // Expose the module name to React Native
  @objc
  override func constantsToExport() -> [AnyHashable: Any]! {
    return ["moduleName": "FlexV2Module"]
  }

  // MARK: - Methods

  /// Creates a transient token using the provided options.
  ///
  /// - Parameters:
  ///   - options: A dictionary containing "jwt" and "cardInfo".
  /// - Returns: Promise resolving to token string or rejecting with an error.
  @objc(createToken:resolver:rejecter:)
  func createToken(
    _ options: NSDictionary,
    resolver resolve: @escaping RCTPromiseResolveBlock,
    rejecter reject: @escaping RCTPromiseRejectBlock
  ) {
    // 1. Extract JWT and card info
    guard let captureContext = options["jwt"] as? String,
          let cardInfo     = options["cardInfo"] as? [String: String],
          let number       = cardInfo["number"],
          let expiryMonth  = cardInfo["expiryMonth"],
          let expiryYear   = cardInfo["expiryYear"],
          let cvv          = cardInfo["cvv"]
    else {
      reject("E_INVALID_PARAMS", "Missing or invalid parameters", nil)
      return
    }

    // 2. Prepare the payload
    let payload: [String: String] = [
      "number":          number,
      "securityCode":    cvv,
      "expirationMonth": expiryMonth,
      "expirationYear":  expiryYear
    ]

    // 3. Call the FlexService
    FlexService().createTransientToken(from: captureContext, data: payload) { result in
      switch result {
      case .success(let tokenResponse):
        resolve(["token": tokenResponse.token])
      case .failure(let error):
        // Map specific status codes if needed
        let status = error.responseStatus.status
        if status == 3000 {
          print(error.responseStatus.message)
        } else {
          reject("E_TOKENIZE_FAILED", error.localizedDescription, error)
        }
      }
    }
  }
}
