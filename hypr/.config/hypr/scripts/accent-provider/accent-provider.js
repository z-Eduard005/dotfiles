const dbus = require("dbus-native");
const bus = dbus.sessionBus();

const SERVICE_NAME = "org.freedesktop.impl.portal.desktop.custom";
const OBJECT_PATH = "/org/freedesktop/portal/desktop";
const INTERFACE_NAME = "org.freedesktop.impl.portal.Settings";

const accentRgb = [0.44, 0.5, 0.56];

bus.requestName(SERVICE_NAME, 0x4);

const interfaceDesc = {
  name: INTERFACE_NAME,
  methods: {
    Read: ["ss", "v", ["namespace", "key"], ["value"]],
    ReadAll: ["as", "a{sa{sv}}", ["namespaces"], ["results"]],
  },
  signals: {
    SettingChanged: ["ssv", ["namespace", "key", "value"]],
  },
};

const impl = {
  Read: function (namespace, key) {
    if (namespace === "org.freedesktop.appearance") {
      if (key === "accent-color") {
        return [["(ddd)", accentRgb]];
      }

      if (key === "color-scheme") {
        return [["u", 1]];
      }
    }

    throw new Error("org.freedesktop.DBus.Error.UnknownProperty");
  },

  ReadAll: function (namespaces) {
    return {
      "org.freedesktop.appearance": {
        "accent-color": ["(ddd)", accentRgb],
        "color-scheme": ["u", 1],
      },
    };
  },
};

bus.exportInterface(impl, OBJECT_PATH, interfaceDesc);

function broadcastAccent() {
  try {
    bus.sendSignal(OBJECT_PATH, INTERFACE_NAME, "SettingChanged", "ssv", [
      "org.freedesktop.appearance",
      "accent-color",
      ["(ddd)", accentRgb],
    ]);
    console.log("Success: Broadcasted accent color.");
  } catch (e) {
    console.error("Broadcast failed:", e);
  }
}

console.log("Mock Portal running. Listening for apps...");
setTimeout(broadcastAccent, 1000);
