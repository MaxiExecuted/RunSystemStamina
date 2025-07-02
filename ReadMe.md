# Roblox Stamina-Based Running System

This project implements a running system for Roblox games, where players consume stamina when running. The system is split into two scripts:

## 1. Server Script (`RunSystemServer.luau`)
- **Location:** Place in `ServerScriptService`.
- **Purpose:**
  - Sets up a `leaderstats` folder with a `Stamina` value for each player.
  - Listens for run requests from clients via a `RemoteEvent`.
  - Tracks if each player is running and only regenerates stamina when the player is not running.
  - Decreases stamina when the player runs and notifies the client of stamina changes.

## 2. Client Script (`RunSystemClient.luau`)
- **Location:** Place in `StarterPlayerScripts` or `StarterCharacterScripts` as a `LocalScript`.
- **Purpose:**
  - Listens for player input (Shift key) to start running.
  - Notifies the server when the player starts and stops running.
  - Sends run requests to the server while running.
  - Updates the player's walk speed based on stamina.
  - Receives stamina updates from the server and disables running when stamina is depleted.

## How It Works
1. When the player holds Shift, the client notifies the server that running has started and repeatedly requests to run.
2. The server checks and decreases stamina, then informs the client.
3. If stamina reaches zero, running is disabled until stamina is restored (regeneration only happens when not running).
4. When the player releases Shift, the client notifies the server that running has stopped, and stamina begins to regenerate.

## Error Checking
- Both scripts (`RunSystemServer.luau` and `RunSystemClient.luau`) have no syntax errors as of the latest check.
- If you do find an error, Direct Message @MaxiExecuted on Discord

## Notes
- The system can be extended with UI feedback, anti-exploit checks, or custom stamina regeneration rates.
- Always split the code into two scripts as described above for proper Roblox operation.


# P.S.

- The System kind of.. jams?? If you keep running until you no longer can, twice, you'll be softlocked and you can't run anymore.