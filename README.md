# native_resource

A tiny plugin that helps in retrieving resource values stored in the native side of an iOS or Android App.

Helps when you need to centralize app configuration (e.g. via Plist or resource strings) that's used by other native SDKs.

The values read from the platform will pass through the native resource filtering like locale or orientation (Android only).

This allows you to ship with optimized App bundles that don't include unused resources.