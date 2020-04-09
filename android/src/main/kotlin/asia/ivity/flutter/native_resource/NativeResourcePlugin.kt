package asia.ivity.flutter.native_resource

import android.content.Context
import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** NativeResourcePlugin */
public class NativeResourcePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "asia.ivity.flutter/native_resource/methods")
        channel.setMethodCallHandler(this);
        applicationContext = flutterPluginBinding.applicationContext
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "native_resource")
            val plugin = NativeResourcePlugin()
            plugin.applicationContext = registrar.context()

            channel.setMethodCallHandler(plugin)
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method == "read") {
            handleRead(call, result)
        } else {
            result.notImplemented()
        }
    }

    private fun handleRead(call: MethodCall, result: Result) {
        val key = call.argument<String>("android-resource-name")
        if (key == null) {
            result.error("invalid-params", null, null)
            return
        }

        val identifier = applicationContext.resources.getIdentifier(key, "string", applicationContext.packageName)
        if (identifier == 0) {
            result.error("invalid-params", null, null)
            return
        }

        result.success(applicationContext.getString(identifier))
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
