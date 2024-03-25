kit.Thread.Server
============================================================

The module for client server architecture with nvim headless.


This modules provides the way to communicate with neovim headless process via JSON-RPC.


### Special protocol

##### `$/error` -> `{ error: string }`

If the unexpected error is occurred, the server will fire `$/error` notification for client.


