class_name PlayerReactions

static func kill_if_player(maybe_player: Node) -> void:
	if is_player(maybe_player):
		(maybe_player as Player).die()

static func is_player(maybe_player: Node) -> bool:
	return is_instance_of(maybe_player, Player)
