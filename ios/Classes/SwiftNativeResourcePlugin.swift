import Flutter
import UIKit

public class SwiftNativeResourcePlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "asia.ivity.flutter/native_resource/methods", binaryMessenger: registrar.messenger())
        let instance = SwiftNativeResourcePlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "read":
            handleRead(call, result)
            break
        case "readRaw":
            handleReadRaw(call, result)
            break
        default:
            result(FlutterMethodNotImplemented)
            break
        }
    }
    
    func handleReadRaw(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let path = Bundle.main.path(forResource: call.arguments as? String, ofType: nil) else {
            result(FlutterError(code: "invalid-params", message: nil, details: nil))
            return
        }
        
        result(NSData(contentsOfFile: path))
    }
    
    func handleRead(_ call: FlutterMethodCall, _ result: @escaping FlutterResult) {
        guard let map: [String: Any] = call.arguments as? [String:Any],
            let key = map["ios-plist-key"] as? String else {
                result(FlutterError(code: "invalid-params", message: nil, details: nil))
                return
        }
        
        if let infoFile = map["ios-plist-file"] as? String {
            guard let path = Bundle.main.path(forResource: infoFile, ofType: "plist") else {
                result(FlutterError(code: "invalid-file-path", message: infoFile, details: nil))
                return
            }
            
            guard let dictionary = NSDictionary.init(contentsOfFile: path) else {
                result(FlutterError(code: "invalid-file", message: infoFile, details: nil))
                return
            }
            
            guard let value = dictionary[key] else {
                result(FlutterError(code: "invalid-key", message: infoFile, details: nil))
                return
            }
            
            result("\(value)")
        } else {
            guard let dictionary = Bundle.main.infoDictionary else {
                result(FlutterError(code: "invalid-file", message: "", details: nil))
                return
            }
            
            guard let value = dictionary[key] else {
                result(FlutterError(code: "invalid-key", message: "", details: nil))
                return
            }
            
            result("\(value)")
        }
    }
}
