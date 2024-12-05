class_name Level
extends Resource

export var display_name : String
export var progress_key : String
export var progress_level : int
export(String, FILE, "*.tscn") var scene
export(String, FILE, "*.tscn") var intro_scene
export(String, MULTILINE) var description : String
export(Array, Resource) var stars
export var ls_texture : Texture
export var ls_highlight : Texture
export var pausable : bool

enum { LOCKED, UNLOCKED, VISITED }
