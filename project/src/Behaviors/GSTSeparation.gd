# Calculates an acceleration that repels the agent from its neighbors in the
# given `GSTProximity`.
#
# The acceleration is an average based on all neighbors, multiplied by a
# strength decreasing by the inverse square law in relation to distance, and it
# accumulates.
class_name GSTSeparation
extends GSTGroupBehavior


# The coefficient to calculate how fast the separation strength decays with distance.
var decay_coefficient := 1.0

var _acceleration: GSTTargetAcceleration


func _init(agent: GSTSteeringAgent, proximity: GSTProximity).(agent, proximity) -> void:
	pass


func _calculate_steering(acceleration: GSTTargetAcceleration) -> void:
	acceleration.set_zero()
	self._acceleration = acceleration
	proximity._find_neighbors(_callback)


# Callback for the proximity to call when finding neighbors. Determines the amount of
# acceleration that `neighbor` imposes based on its distance from the owner agent.
# tags: virtual
func _report_neighbor(neighbor: GSTSteeringAgent) -> bool:
	var to_agent := agent.position - neighbor.position

	var distance_squared := to_agent.length_squared()
	var acceleration_max := agent.linear_acceleration_max

	var strength := decay_coefficient / distance_squared
	if strength > acceleration_max:
		strength = acceleration_max

	_acceleration.linear += to_agent * (strength / sqrt(distance_squared))

	return true
