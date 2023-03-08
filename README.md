# wifind

WiFind ist eine App, welche dir immer das nächste Free Wifi auf einer Map anzeigt. Als
Benutzer kannst du, falls du ein neues Free Wifi entdeckt hast, dieses hinzufügen. Wenn du
näher als 50m zu einem WiFi bist, wirst du benachrichtigt.

Weiter hat die Map eine Clusterfunktion, welche Wifis welche nahe zueinander sind, clustert;

## Getting Started

- Execute the apk
- normally it asks for the permissions and it works

but sometimes:

__Be aware that if the application does not asks for the permission that you have to set it manually in the settings (you see that if it keeps displaying the Circle and the text "map initializing")__

To run the Flutter App execute:

```
flutter run -d <device-id>
```

When the app is startet it promts you to enable notification and Location otherwise the app will not work.

## Lint the WiFind App

````
flutter analyze
````

## Build apk

````
flutter build apk  
````

## Repo link

Here is the repository link:

[Repository](https://github.com/jorishaenseler15/wifind)
