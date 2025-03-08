class_name Level
extends Resource

@export var display_name : String
@export var progress_key : String
@export var progress_level : int
@export_file("*.tscn") var scene : String
@export_file("*.tscn") var intro_scene : String
@export_multiline var description : String
@export var stars : Array[StarData]
@export var ls_texture : Texture2D
@export var ls_highlight : Texture2D
@export var pausable : bool

enum { LOCKED, UNLOCKED, VISITED }
