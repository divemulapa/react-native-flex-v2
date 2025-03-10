#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(FlexV2Module, NSObject)

RCT_EXTERN_METHOD(createToken:(NSDictionary *)options withCallback:(RCTResponseSenderBlock)callback)

+ (BOOL)requiresMainQueueSetup
{
  return NO;
}

@end
