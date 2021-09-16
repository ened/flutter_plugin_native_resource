package asia.ivity.flutternative_resource

import android.content.Context
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

enum class ResourceType {
    string,
    raw
}

private val ResourceType.defType: String
    get() = when (this) {
        ResourceType.string -> "string"
        ResourceType.raw -> "raw"
    }

private fun ResourceType.identifier(context: Context, key: String): Int? {
    val identifier = context.resources.getIdentifier(key, defType, context.packageName)

    if (identifier == 0) return null

    return identifier
}

fun ResourceType.read(context: Context, key: String): Any? {
    val identifier = identifier(context, key) ?: return null

    return when (this) {
        ResourceType.string -> context.resources.getString(identifier)
        ResourceType.raw -> context.resources.openRawResource(identifier).readBytes()
    }
}

/** NativeResourcePlugin */
public class NativeResourcePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var applicationContext: Context

    override fun onAttachedToEngine(
        @NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding
    ) {
        channel = MethodChannel(
            flutterPluginBinding.binaryMessenger,
            "asia.ivity.flutter/native_resource/methods"
        )
        channel.setMethodCallHandler(this)
        applicationContext = flutterPluginBinding.applicationContext
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

        val type: ResourceType
        try {
            type = ResourceType.valueOf(
                call.argument<String>("resource-type") ?: ResourceType.string.name
            )
        } catch (e: Throwable) {
            result.error("invalid-params", "resource-type invalid", null)
            return
        }

        val value = type.read(applicationContext, key)

        if (value == null) {
            result.error("invalid-params", null, null)
            return
        }

        result.success(value)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
