import Foundation

@objc(CDVNativeStorage)
class CDVNativeStorage : CDVPlugin {
    var _suiteName: String?
    var _appGroupUserDefaults: UserDefaults?

    override
    func pluginInitialize() {
    }

    @objc(initWithSuiteName:)
    func initWithSuiteName(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let suiteName: String = command.arguments[0] as? String else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Reference or SuiteName was null")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        self._suiteName = suiteName
        self._appGroupUserDefaults = UserDefaults(suiteName: suiteName)

        pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }
    
    func getUserDefault() -> UserDefaults? {
        if (self._suiteName != nil) {
            return self._appGroupUserDefaults
        } else {
            return UserDefaults.standard
        }
    }

    @objc(remove:)
    func remove(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let reference: String = command.arguments[0] as? String else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Reference was null")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        let userDefaults: UserDefaults? = self.getUserDefault()
        userDefaults?.removeObject(forKey: reference)
        let success = userDefaults?.synchronize()

        if (success != nil && success == true) {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
        } else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Reference was null")
        }
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }
    
    @objc(clear:)
    func clear(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let bundleIdentifier: String = Bundle.main.bundleIdentifier as String? else {
            let pluginResult: CDVPluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to gain Bundle Identifier")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        let userDefaults: UserDefaults? = self.getUserDefault()
        userDefaults?.removePersistentDomain(forName: bundleIdentifier)
        let success = userDefaults?.synchronize()

        if (success != nil && success == true) {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
        } else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to synchronize UserDefaults")
        }
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }
    
    func putValue(value: Any?, forKey: String) -> Bool? {
        let userDefaults: UserDefaults? = self.getUserDefault()
        userDefaults?.set(value, forKey: forKey)
        return userDefaults?.synchronize()
    }

    @objc(putBoolean:)
    func putBoolean(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let reference: String = command.arguments[0] as? String,
              let val: Bool = command.arguments[1] as? Bool else {
            let pluginResult: CDVPluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Invalid parameter")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        let success = self.putValue(value: val, forKey: reference)

        if (success != nil && success == true) {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
        } else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to synchronize UserDefaults")
        }
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }
    
    @objc(getBoolean:)
    func getBoolean(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let reference: String = command.arguments[0] as? String else {
            let pluginResult: CDVPluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Invalid parameter")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }
        
        guard let val: Bool = self.getUserDefault()?.bool(forKey: reference) as? Bool else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to get value")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        pluginResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAs: val)
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }
    
    @objc(putInt:)
    func putInt(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let reference: String = command.arguments[0] as? String,
              let val: Int = command.arguments[1] as? Int else {
            let pluginResult: CDVPluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Invalid parameter")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        let success = self.putValue(value: val, forKey: reference)

        if (success != nil && success == true) {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
        } else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to synchronize UserDefaults")
        }
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }

    @objc(getInt:)
    func getInt(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let reference: String = command.arguments[0] as? String else {
            let pluginResult: CDVPluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Invalid parameter")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }
        
        guard let val: Int = self.getUserDefault()?.integer(forKey: reference) as? Int else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to get value")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        pluginResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAs: val)
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }
    
    @objc(putDouble:)
    func putDouble(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let reference: String = command.arguments[0] as? String,
              let val: Double = command.arguments[1] as? Double else {
            let pluginResult: CDVPluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Invalid parameter")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        let success = self.putValue(value: val, forKey: reference)

        if (success != nil && success == true) {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
        } else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to synchronize UserDefaults")
        }
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }

    @objc(getDouble:)
    func getDouble(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let reference: String = command.arguments[0] as? String else {
            let pluginResult: CDVPluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Invalid parameter")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }
        
        guard let val: Double = self.getUserDefault()?.double(forKey: reference) as? Double else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to get value")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        pluginResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAs: val)
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }
    
    @objc(putString:)
    func putString(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let reference: String = command.arguments[0] as? String,
              let val: String = command.arguments[1] as? String else {
            let pluginResult: CDVPluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Invalid parameter")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        let success = self.putValue(value: val, forKey: reference)

        if (success != nil && success == true) {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
        } else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to synchronize UserDefaults")
        }
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }

    @objc(getString:)
    func getString(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let reference: String = command.arguments[0] as? String else {
            let pluginResult: CDVPluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Invalid parameter")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }
        
        guard let val: String = self.getUserDefault()?.string(forKey: reference) as? String else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to get value")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        pluginResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAs: val)
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }
    
    @objc(setItem:)
    func setItem(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let reference: String = command.arguments[0] as? String,
              let val: String = command.arguments[1] as? String else {
            let pluginResult: CDVPluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Invalid parameter")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        let success = self.putValue(value: val, forKey: reference)

        if (success != nil && success == true) {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_OK)
        } else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to synchronize UserDefaults")
        }
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }

    @objc(getItem:)
    func getItem(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        guard let reference: String = command.arguments[0] as? String else {
            let pluginResult: CDVPluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Invalid parameter")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }
        
        guard let val: String = self.getUserDefault()?.string(forKey: reference) as? String else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to get value")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        pluginResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAs: val)
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }
    
    @objc(keys:)
    func keys(command: CDVInvokedUrlCommand) {
        var pluginResult: CDVPluginResult? = nil

        var keys: [String] = []
        guard let dict: [String : Any] = self.getUserDefault()?.dictionaryRepresentation() else {
            pluginResult = CDVPluginResult(status:CDVCommandStatus_ERROR, messageAs: "Failed to get keys")
            self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
            return
        }

        for key in dict.keys {
            keys.append(key)
        }

        pluginResult = CDVPluginResult(status:CDVCommandStatus_OK, messageAs: keys)
        self.commandDelegate.send(pluginResult, callbackId:command.callbackId)
    }
}
