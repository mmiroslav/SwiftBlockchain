# Blockchain implementation in Swift 

## Compatibility with Swift

The master branch of this project currently compiles with **Xcode 9** or the **Swift 4.0** toolchain on Ubuntu.

## Compile

To compile project with Xcode do the following:

```
$ cd Blockchain
$ swift package init --type executable
$ swift package generate-xcodeproj
```

Than build and run project with `Cmd+R` form Xcode

## Building & Running without Xcode

The following will launch the server on port 8181.

```
swift build
.build/debug/Blockchain
```

You should see the following output:

```
[INFO] Starting HTTP server localhost on 0.0.0.0:8181
```
Hit control-c to terminate the server.

## API

### `GET /blockchain`

### `GET /mine`

### `POST /transaction/new`

Params:

```
sender:{address}
recipient:{address}
amount:{amount}
```


