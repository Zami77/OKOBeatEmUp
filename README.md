# Godot4Template
 
This is a basic Godot 4 template in GDScript. I got tired of implementing the same basic logic for my game jams, so I decided to make this template to cut out a lot of the fluff!

It contains

## Game Manager
- The default scene of the project and how all scenes are loaded
- You connect to signals as each scene is loaded
- Hub for overarching game logic

## Data Manager
- Singleton
- Basic save and load functionality

## Audio Manager
- Singleton
- Separate functionality for playing background music and sound effects
- Designed to be called throughout your code via specific functions like `play_menu_theme()`

## Settings Manager
- Singleton
- Fullscreen and Volume sliders

## Main Menu
- Basic menu with a DefaultButton class
- DefaultButton allows you to have custom functionality or effects on all buttons

## Transition Screen
- Basic node that transitions between scenes loading
