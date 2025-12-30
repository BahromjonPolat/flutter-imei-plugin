import Flutter
import UIKit

public class ImeiPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "imei", binaryMessenger: registrar.messenger())
    let instance = ImeiPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getImei":
      result(FlutterError(code: "UNAVAILABLE",
                         message: "IMEI is not available on iOS. Apple removed access to IMEI/UDID for privacy reasons.",
                         details: nil))
    case "getImeiList":
      result([])
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
