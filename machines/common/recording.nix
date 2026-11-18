{ lib, ... }:

{
  options.recording = {
    has-capture-card = lib.mkEnableOption "Whether this machine has a capture card installed";
    has-stream-deck = lib.mkEnableOption "Whether this machine has a Stream Deck installed";
  };
}
