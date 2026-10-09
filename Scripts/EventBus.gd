extends Node
## Global signals for things that happen in one part of the game and matter to
## another part that should not need a direct reference to it.

@warning_ignore_start("unused_signal")

## An item was picked up, e.g. from a chest. The inventory listens to this.
signal itemReceived(item: GlobalConstants.ItemIndices, amount: int)

## A player's hp reached zero.
signal playerDied(playerIndex: int)

@warning_ignore_restore("unused_signal")
