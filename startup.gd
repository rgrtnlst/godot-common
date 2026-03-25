@tool
extends EditorScript

var _tree: SceneTree

func _run() -> void:
	_tree = Engine.get_main_loop() as SceneTree
	if not _tree:
		print("Startup script: No Scene Tree.")
		return
	
	# HACK: Add reference to script
	_tree.root.set_meta("projectstartupscript", self)
	
	if ProjectSettings.get_setting("startup/init_script_has_run", false):
		print("Already ran, skipping.")
		return
	
	ProjectSettings.set_setting("startup/init_script_has_run", true)
	ProjectSettings.save()
	

	_create_file_structure()
	print("Startup Script: FileStructure Finished.")
	_configure_project()
	print("Startup Script: ProjectSettings Finished.")
	
	# HACK: Remove reference to script
	_tree.root.remove_meta("projectstartupscript")


func _create_file_structure() -> void:
	_make_folder("res://addons/")
	_make_folder("res://assets/")
	_make_folder("res://common/")
	_make_folder("res://entities/")
	_make_folder("res://stages/")
	_make_folder("res://utilities/")


func _configure_project() -> void:
	ProjectSettings.set_setting("debug/gdscript/warnings/exclude_addons", false)
	ProjectSettings.set_setting("debug/gdscript/warnings/untyped_declaration", 1)
	ProjectSettings.set_setting("debug/gdscript/warnings/inferred_declaration", 1)
	ProjectSettings.set_setting("window/size/viewport_width", 1920)
	ProjectSettings.set_setting("window/size/viewport_height", 1080)
	ProjectSettings.set_setting("window/stretch/mode", "canvas_items")
	ProjectSettings.set_setting("window/stretch/aspect", "expand")
	
	ProjectSettings.set_setting("editor/naming/node_name_num_separator", 3) # Node name numbers are added with a dash
	ProjectSettings.set_setting("editor/naming/scene_name_casing", 2) 	# snake_case
	ProjectSettings.set_setting("editor/naming/script_name_casing", 2) 	# snake_case
	
	ProjectSettings.set_setting("import/blender/enabled", false)
	ProjectSettings.set_setting("environment/defaults/default_clear_color", Color(0.1, 0.1, 0.1, 1))

	ProjectSettings.save()


func _make_folder(path: String) -> void:
	if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(path)):
		return
	else:
		DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(path))
		print("Startup script: Create Folder - %s" % path)
