{ pkgs, ... }:
let
  mod = "alt";
in
{
  services.skhd.enable = true;
  services.skhd.skhdConfig = ''
    ${mod} - h : yabai -m window --focus west &> /dev/null \
        || yabai -m window --focus stack.prev &> /dev/null || yabai -m display --focus west
    ${mod} - j : yabai -m window --focus south &> /dev/null \
        || yabai -m window --focus stack.prev &> /dev/null || yabai -m display --focus south
    ${mod} - k : yabai -m window --focus north &> /dev/null \
        || yabai -m window --focus stack.next &> /dev/null || yabai -m display --focus north
    ${mod} - l : yabai -m window --focus east &> /dev/null \
        || yabai -m window --focus stack.next &> /dev/null || yabai -m dipslay --focus east

    ${mod} + shift - j : yabai -m window --swap west
    ${mod} + shift - k : yabai -m window --swap east
    ${mod} + shift + ctrl - j : yabai -m window --space next
    ${mod} + shift + ctrl - k : yabai -m window --space prev

    ${mod} - 0x12 : yabai -m space --focus 1 2>/dev/null
    ${mod} - 0x13 : yabai -m space --focus 2 2>/dev/null
    ${mod} - 0x14 : yabai -m space --focus 3 2>/dev/null
    ${mod} - 0x15 : yabai -m space --focus 4 2>/dev/null
    ${mod} - 0x17 : yabai -m space --focus 5 2>/dev/null
    ${mod} - 0x16 : yabai -m space --focus 6 2>/dev/null
    ${mod} - 0x1A : yabai -m space --focus 7 2>/dev/null
    ${mod} - 0x1C : yabai -m space --focus 8 2>/dev/null
    ${mod} - 0x19 : yabai -m space --focus 9 2>/dev/null

    ${mod} + shift - return : kitty --single-instance --working-directory /Users/god
    ${mod} - space : yabai -m space --layout `yabai -m query --spaces | jq -r 'map(select(."has-focus")) | .[0].type as $current | {layouts: ["bsp", "stack", "float"]} | { layouts: .layouts, next: (.layouts | (index($current) + 1) % 3)} | nth(.next; .layouts[])'`
  '';

}
