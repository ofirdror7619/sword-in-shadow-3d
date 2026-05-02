extends Node
class_name SISMissionSystem

signal missions_changed(area: String, missions: Array[Dictionary])
signal mission_completed(area: String, mission: Dictionary)
signal mission_action_requested(area: String, action: Dictionary, mission: Dictionary)

const MISSIONS_ROOT := "res://missions"

var _completed_by_area: Dictionary = {}
var _unlocked_by_area: Dictionary = {}
var _missions_by_area: Dictionary = {}
var _mission_file_by_area: Dictionary = {}
var _current_area := ""

func set_area(area: String) -> void:
	_current_area = area
	reload_area(area)

func reload_area(area: String) -> void:
	_missions_by_area[area] = _load_area_missions(area)
	missions_changed.emit(area, get_active_missions(area))

func get_active_missions(area: String = "") -> Array[Dictionary]:
	var area_to_use := area
	if area_to_use.is_empty():
		area_to_use = _current_area
	var missions := _missions_for_area(area_to_use)
	var active: Array[Dictionary] = []
	for mission in missions:
		var mission_id := String(mission.get("id", ""))
		if mission_id.is_empty() or _is_completed(area_to_use, mission_id):
			continue
		if bool(mission.get("locked", false)) and not _is_unlocked(area_to_use, mission_id):
			continue
		active.append(mission.duplicate(true))
	return active

func complete_mission(area: String, mission_id: String) -> bool:
	if area.is_empty() or mission_id.is_empty() or _is_completed(area, mission_id):
		return false
	var missions := _missions_for_area(area)
	var completed_mission: Dictionary = {}
	for mission in missions:
		if String(mission.get("id", "")) == mission_id:
			completed_mission = mission.duplicate(true)
			break
	if completed_mission.is_empty():
		completed_mission = {"id": mission_id, "title": mission_id, "text": mission_id}
	_mark_completed(area, mission_id)
	mission_completed.emit(area, completed_mission)
	_run_complete_actions(area, completed_mission)
	missions_changed.emit(area, get_active_missions(area))
	return true

func unlock_mission(area: String, mission_id: String) -> bool:
	if area.is_empty() or mission_id.is_empty():
		return false
	var was_unlocked := _is_unlocked(area, mission_id)
	_unlock_mission(area, mission_id)
	if not was_unlocked:
		missions_changed.emit(area, get_active_missions(area))
	return not was_unlocked

func set_area_mission_file(area: String, mission_file: String) -> bool:
	var clean_area := area.strip_edges()
	var clean_file := mission_file.strip_edges()
	if clean_area.is_empty() or clean_file.is_empty():
		return false
	var path := _resolve_mission_file_path(clean_file)
	if path.is_empty() or not FileAccess.file_exists(path):
		push_warning("Missing next mission file for %s: %s" % [clean_area, clean_file])
		return false
	_mission_file_by_area[clean_area] = path
	_missions_by_area.erase(clean_area)
	if clean_area == _current_area:
		reload_area(clean_area)
	return true

func complete_matching(area: String, event_key: String, context: Dictionary = {}) -> Array[Dictionary]:
	var completed: Array[Dictionary] = []
	for mission in get_active_missions(area):
		if _mission_matches_event(mission, event_key, context):
			var mission_id := String(mission.get("id", ""))
			if complete_mission(area, mission_id):
				completed.append(mission.duplicate(true))
	return completed

func get_active_matching_missions(area: String, event_key: String, context: Dictionary = {}) -> Array[Dictionary]:
	var matches: Array[Dictionary] = []
	for mission in get_active_missions(area):
		if _mission_matches_event(mission, event_key, context):
			matches.append(mission.duplicate(true))
	return matches

func _missions_for_area(area: String) -> Array[Dictionary]:
	if area.is_empty():
		return []
	if not _missions_by_area.has(area):
		_missions_by_area[area] = _load_area_missions(area)
	return _missions_by_area[area]

func _load_area_missions(area: String) -> Array[Dictionary]:
	var missions: Array[Dictionary] = []
	var path := _mission_file_path_for_area(area)
	if not FileAccess.file_exists(path):
		return missions
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Could not open missions file: %s" % path)
		return missions
	var current: Dictionary = {}
	for raw_line in file.get_as_text().split("\n", false):
		var line := String(raw_line).replace("\r", "").strip_edges()
		if line.is_empty():
			_append_mission_if_valid(missions, current, path)
			current = {}
			continue
		if line.begins_with("#") or line.begins_with(";"):
			continue
		var directive := _parse_directive(line)
		if directive.is_empty():
			push_warning("Ignored malformed mission line in %s: %s" % [path, line])
			continue
		var key := String(directive.get("key", "")).to_upper()
		var value := String(directive.get("value", "")).strip_edges()
		match key:
			"MISSION":
				_append_mission_if_valid(missions, current, path)
				current = {
					"id": value,
					"title": "",
					"text": "",
					"objective": "",
					"objective_type": "",
					"objective_target": "",
					"dialogue_file": "",
					"given": [],
					"giver_npc_id": "",
					"giver_npc_name": "",
					"incomplete_replies_file": "",
					"on_complete": [],
					"locked": false
				}
			"TITLE":
				if current.is_empty():
					push_warning("TITLE before MISSION in %s: %s" % [path, line])
					continue
				current["title"] = value
				current["text"] = value
			"OBJECTIVE":
				if current.is_empty():
					push_warning("OBJECTIVE before MISSION in %s: %s" % [path, line])
					continue
				var objective := _parse_typed_value(value)
				current["objective"] = value
				current["objective_type"] = String(objective.get("type", ""))
				current["objective_target"] = String(objective.get("target", ""))
			"DIALOGUE_FILE", "USING_DIALOGUE", "DIALOGUE":
				if current.is_empty():
					push_warning("%s before MISSION in %s: %s" % [key, path, line])
					continue
				current["dialogue_file"] = value
			"GIVEN", "GIVE", "GIVES":
				if current.is_empty():
					push_warning("%s before MISSION in %s: %s" % [key, path, line])
					continue
				var given: Array = current.get("given", [])
				given.append(_parse_typed_value(value))
				current["given"] = given
			"GIVER_NPC", "MISSION_GIVER", "GIVEN_BY":
				if current.is_empty():
					push_warning("%s before MISSION in %s: %s" % [key, path, line])
					continue
				var giver := _parse_named_npc(value)
				current["giver_npc_id"] = String(giver.get("id", ""))
				current["giver_npc_name"] = String(giver.get("name", ""))
			"INCOMPLETE_REPLIES_FILE", "UNFINISHED_REPLIES_FILE", "REMINDER_FILE":
				if current.is_empty():
					push_warning("%s before MISSION in %s: %s" % [key, path, line])
					continue
				current["incomplete_replies_file"] = value
			"ON_COMPLETE":
				if current.is_empty():
					push_warning("ON_COMPLETE before MISSION in %s: %s" % [path, line])
					continue
				var actions: Array = current.get("on_complete", [])
				actions.append(_parse_typed_value(value))
				current["on_complete"] = actions
			"NEXT_MISSION_FILE":
				if current.is_empty():
					push_warning("NEXT_MISSION_FILE before MISSION in %s: %s" % [path, line])
					continue
				var next_actions: Array = current.get("on_complete", [])
				next_actions.append({
					"type": "set_area_mission_file",
					"target": value
				})
				current["on_complete"] = next_actions
			"LOCKED":
				if current.is_empty():
					push_warning("LOCKED before MISSION in %s: %s" % [path, line])
					continue
				current["locked"] = _parse_bool(value)
			_:
				push_warning("Unknown mission directive in %s: %s" % [path, line])
	_append_mission_if_valid(missions, current, path)
	return missions

func _mission_file_path_for_area(area: String) -> String:
	if _mission_file_by_area.has(area):
		var override_path := _resolve_mission_file_path(String(_mission_file_by_area[area]))
		if not override_path.is_empty() and FileAccess.file_exists(override_path):
			return override_path
	var area_slug := area.replace("_", "-")
	var candidate_names := [
		"%s.txt" % area,
		"%s-first.txt" % area,
		"%s.txt" % area_slug,
		"%s-first.txt" % area_slug,
		"the-%s.txt" % area_slug
	]
	for candidate_name in candidate_names:
		var candidate_path := "%s/%s" % [MISSIONS_ROOT, candidate_name]
		if FileAccess.file_exists(candidate_path):
			return candidate_path
	return "%s/%s.txt" % [MISSIONS_ROOT, area]

func _resolve_mission_file_path(mission_file: String) -> String:
	var clean_file := mission_file.strip_edges().replace("\\", "/")
	if clean_file.is_empty():
		return ""
	var candidates: Array[String] = [clean_file]
	if clean_file.get_extension().is_empty():
		candidates.append("%s.txt" % clean_file)
	elif clean_file.get_extension().to_lower() != "txt":
		candidates.append("%s.txt" % clean_file.get_basename())
	for candidate in candidates:
		var path := candidate
		if not path.begins_with("res://"):
			if path.begins_with("missions/"):
				path = path.trim_prefix("missions/")
			path = "%s/%s" % [MISSIONS_ROOT, path]
		if FileAccess.file_exists(path):
			return path
	return ""

func _append_mission_if_valid(missions: Array[Dictionary], mission: Dictionary, path: String) -> void:
	if mission.is_empty():
		return
	var mission_id := String(mission.get("id", "")).strip_edges()
	if mission_id.is_empty():
		push_warning("Ignored mission without id in %s" % path)
		return
	var objective_type := String(mission.get("objective_type", "")).strip_edges()
	if objective_type.is_empty():
		push_warning("Ignored mission without OBJECTIVE in %s: %s" % [path, mission_id])
		return
	var title := String(mission.get("title", "")).strip_edges()
	if title.is_empty():
		title = _title_from_id(mission_id)
	mission["id"] = mission_id
	mission["title"] = title
	mission["text"] = title
	mission["objective_type"] = objective_type.to_lower()
	mission["objective_target"] = String(mission.get("objective_target", "")).strip_edges()
	missions.append(mission.duplicate(true))

func _parse_directive(line: String) -> Dictionary:
	var separator := _first_whitespace_index(line)
	if separator < 0:
		return {"key": line, "value": ""}
	return {
		"key": line.substr(0, separator).strip_edges(),
		"value": line.substr(separator + 1).strip_edges()
	}

func _first_whitespace_index(text: String) -> int:
	for index in range(text.length()):
		var character := text.substr(index, 1)
		if character == " " or character == "\t":
			return index
	return -1

func _parse_typed_value(value: String) -> Dictionary:
	var separator := value.find(":")
	if separator < 0:
		return {
			"type": value.strip_edges().to_lower(),
			"target": ""
		}
	return {
		"type": value.substr(0, separator).strip_edges().to_lower(),
		"target": value.substr(separator + 1).strip_edges()
	}

func _parse_named_npc(value: String) -> Dictionary:
	var clean_value := value.strip_edges()
	var separator := clean_value.find(":")
	if separator < 0:
		return {
			"id": clean_value,
			"name": clean_value.replace("_", " ")
		}
	return {
		"id": clean_value.substr(0, separator).strip_edges(),
		"name": clean_value.substr(separator + 1).strip_edges()
	}

func _parse_bool(value: String) -> bool:
	var normalized := value.strip_edges().to_lower()
	return normalized in ["true", "yes", "1", "on", "locked"]

func _title_from_id(mission_id: String) -> String:
	var words := mission_id.replace("_", " ").split(" ", false)
	var titled: Array[String] = []
	for word in words:
		if word.is_empty():
			continue
		titled.append(word.substr(0, 1).to_upper() + word.substr(1).to_lower())
	return " ".join(titled)

func _mission_matches_event(mission: Dictionary, event_key: String, context: Dictionary) -> bool:
	var objective_type := String(mission.get("objective_type", "")).to_lower()
	var event_type := event_key.strip_edges().to_lower()
	if event_type == "talk_vendor":
		event_type = "talk_to_npc"
	elif event_type == "use_teleport_device":
		event_type = "use_relic"
	if event_type == "kill":
		return _mission_matches_kill_objective(objective_type, context)
	if objective_type != event_type:
		return false
	var objective_target := _normalize_mission_key(String(mission.get("objective_target", "")))
	if objective_target.is_empty():
		return true
	var candidates := _event_target_candidates(event_key, context)
	return candidates.has(objective_target)

func _event_target_candidates(event_key: String, context: Dictionary) -> Array[String]:
	var candidates: Array[String] = []
	for key in ["target", "npc_id", "npc_name", "vendor_id", "relic_id", "item_id", "destination_id"]:
		var value := _normalize_mission_key(String(context.get(key, "")))
		if not value.is_empty() and not candidates.has(value):
			candidates.append(value)
	if event_key.strip_edges().to_lower() == "use_teleport_device" and not candidates.has("teleport_device"):
		candidates.append("teleport_device")
	return candidates

func _mission_matches_kill_objective(objective_type: String, context: Dictionary) -> bool:
	if objective_type.begins_with("kill_all_"):
		return _mission_matches_kill_all_objective(objective_type, context)
	if not objective_type.begins_with("kill_"):
		return false
	var objective_body := objective_type.trim_prefix("kill_")
	var area_split := objective_body.split("_in_", false, 1)
	var count_part := String(area_split[0])
	if area_split.size() > 1:
		var objective_area := _normalize_mission_key(String(area_split[1]))
		var current_area := _normalize_mission_key(String(context.get("area", "")))
		if not objective_area.is_empty() and current_area != objective_area:
			return false
	var target_kills := 0
	if count_part.contains("_out_of_"):
		target_kills = int(count_part.get_slice("_out_of_", 0))
	else:
		target_kills = int(count_part)
	if target_kills <= 0:
		target_kills = int(context.get("required", 0))
	return int(context.get("kills", 0)) >= target_kills

func _mission_matches_kill_all_objective(objective_type: String, context: Dictionary) -> bool:
	var objective_body := objective_type.trim_prefix("kill_all_")
	var area_split := objective_body.split("_in_", false, 1)
	if area_split.size() < 2:
		return false
	var raw_target_kind := _normalize_mission_key(String(area_split[0]))
	var target_kind := raw_target_kind.trim_suffix("s")
	var objective_area := _normalize_mission_key(String(area_split[1]))
	var current_area := _normalize_mission_key(String(context.get("area", "")))
	var killed_kind := _normalize_mission_key(String(context.get("enemy_kind", ""))).trim_suffix("s")
	if not objective_area.is_empty() and current_area != objective_area:
		return false
	var accepts_any_enemy := raw_target_kind in ["enemies", "enemy", "hostiles", "hostile"]
	if not accepts_any_enemy and not target_kind.is_empty() and killed_kind != target_kind:
		return false
	return int(context.get("remaining", 1)) <= 0

func _normalize_mission_key(value: String) -> String:
	return value.strip_edges().to_lower().replace(" ", "_").replace("-", "_")

func _run_complete_actions(area: String, mission: Dictionary) -> void:
	var actions: Array = mission.get("on_complete", [])
	for action_variant in actions:
		if not (action_variant is Dictionary):
			continue
		var action := (action_variant as Dictionary).duplicate(true)
		var action_type := String(action.get("type", "")).to_lower()
		if action_type == "unlock_mission":
			_unlock_mission(area, String(action.get("target", "")))
		elif action_type == "unlock_area_mission":
			var target := String(action.get("target", "")).strip_edges()
			var parts := target.split(":", false, 1)
			if parts.size() == 2:
				_unlock_mission(String(parts[0]).strip_edges(), String(parts[1]).strip_edges())
		elif action_type == "set_mission_file" or action_type == "set_area_mission_file" or action_type == "next_mission_file":
			var target := String(action.get("target", "")).strip_edges()
			var parts := target.split(":", false, 1)
			if parts.size() == 2:
				set_area_mission_file(String(parts[0]).strip_edges(), String(parts[1]).strip_edges())
			else:
				set_area_mission_file(area, target)
		mission_action_requested.emit(area, action, mission.duplicate(true))

func _completed_array_for_area(area: String) -> Array:
	if not _completed_by_area.has(area):
		_completed_by_area[area] = []
	return _completed_by_area[area]

func _unlocked_array_for_area(area: String) -> Array:
	if not _unlocked_by_area.has(area):
		_unlocked_by_area[area] = []
	return _unlocked_by_area[area]

func _is_completed(area: String, mission_id: String) -> bool:
	return _completed_array_for_area(area).has(mission_id)

func _is_unlocked(area: String, mission_id: String) -> bool:
	return _unlocked_array_for_area(area).has(mission_id)

func _mark_completed(area: String, mission_id: String) -> void:
	var completed := _completed_array_for_area(area)
	if not completed.has(mission_id):
		completed.append(mission_id)
	_completed_by_area[area] = completed

func _unlock_mission(area: String, mission_id: String) -> void:
	if area.is_empty() or mission_id.is_empty():
		return
	var unlocked := _unlocked_array_for_area(area)
	if not unlocked.has(mission_id):
		unlocked.append(mission_id)
	_unlocked_by_area[area] = unlocked
