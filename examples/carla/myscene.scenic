param port = 3001
param map = localPath('../../tests/formats/opendrive/maps/CARLA/Town05.xodr')
param carla_map = 'Town05'
param time_step = 1.0/10

model scenic.simulators.carla.model
param EGO_SPEED = VerifaiRange(7, 10)

MODEL = 'vehicle.volkswagen.t2'
PED_MIN_SPEED = 1.0
EGO_SPEED = 10

# param EGO_INIT_DIST = VerifaiRange(-30, -20)
# param SAFETY_DIST = VerifaiRange(10, 15)


# EGO_BRAKE = 1.0
# PED_THRESHOLD = 20

# BUFFER_DIST = 75
# CRASH_DIST = 5
# TERM_DIST = 50

# behavior EgoBehavior():
#     try:
#         do FollowLaneBehavior(target_speed=globalParameters.EGO_SPEED)
#     interrupt when withinDistanceToObjsInLane(self, globalParameters.SAFETY_DIST) and (ped in network.drivableRegion):
#         take SetBrakeAction(EGO_BRAKE)
#     interrupt when withinDistanceToAnyObjs(self, CRASH_DIST):
#         terminate

# lane = Uniform(*network.lanes)
# spawnPt = OrientedPoint on lane.centerline


# ego = Car following roadDirection from spawnPt for globalParameters.EGO_INIT_DIST,
#     with blueprint MODEL,
#     with behavior EgoBehavior()

# ped = Pedestrian right of spawnPt by 7,
#     with heading 90 deg relative to spawnPt.heading,
#     with regionContainedIn None,
#     with behavior CrossingBehavior(ego, PED_MIN_SPEED, PED_THRESHOLD)

# require (distance to intersection) > BUFFER_DIST
# require always (ego.laneSection._slowerLane is None)
# require always (ego.laneSection._fasterLane is None)
# terminate when (distance to spawnPt) > TERM_DIST


########################################################################################################################


# param render = 0
# model scenic.simulators.carla.model

# THRESHOLD = 17

# behavior PedestrianBehavior(min_speed=1, threshold=10):
#     while (ego.speed <= 0.1):
#         wait

#     do CrossingBehavior(ego, min_speed, threshold)

# lane = Uniform(*network.lanes)

# spot = OrientedPoint on lane.centerline
# vending_spot = OrientedPoint following roadDirection from spot for -3

# pedestrian = Pedestrian right of spot by 3,
#     with heading 90 deg relative to spot.heading,
#     with regionContainedIn None,
#     with behavior PedestrianBehavior(PED_MIN_SPEED, THRESHOLD)

# vending_machine = VendingMachine right of vending_spot by 3,
#     with heading -90 deg relative to vending_spot.heading,
#     with regionContainedIn None

# ego = Car following roadDirection from spot for Range(-30, -20),
#     with blueprint MODEL,
#     with rolename "hero"

# require (distance to intersection) > 50
# require always (ego.laneSection._slowerLane is None)
# terminate when (distance to spot) > 50



########################################################################################################################

# EGO_INIT_DIST = [20, 25]
# param EGO_SPEED = VerifaiRange(7, 10)
# EGO_BRAKE = 1.0

# PED_MIN_SPEED = 1.0
# PED_THRESHOLD = 20

# param SAFETY_DIST = VerifaiRange(10, 15)
# CRASH_DIST = 5
# TERM_DIST = 50


# behavior EgoBehavior(trajectory):
#     flag = True
#     try:
#         do FollowTrajectoryBehavior(target_speed=globalParameters.EGO_SPEED, trajectory=trajectory)
#     interrupt when withinDistanceToAnyObjs(self, globalParameters.SAFETY_DIST) and (ped in network.drivableRegion) and flag:
#         flag = False
#         while withinDistanceToAnyObjs(self, globalParameters.SAFETY_DIST + 3):
#             take SetBrakeAction(EGO_BRAKE)
#     interrupt when withinDistanceToAnyObjs(self, CRASH_DIST):
#         terminate

# intersection = Uniform(*filter(lambda i: i.is4Way or i.is3Way, network.intersections))

# egoManeuver = Uniform(*filter(lambda m: m.type is ManeuverType.RIGHT_TURN, intersection.maneuvers))
# egoInitLane = egoManeuver.startLane
# egoTrajectory = [egoInitLane, egoManeuver.connectingLane, egoManeuver.endLane]
# egoSpawnPt = OrientedPoint in egoInitLane.centerline

# tempSpawnPt = egoInitLane.centerline[-1]

# ego = Car at egoSpawnPt,
#     with blueprint MODEL,
#     with behavior EgoBehavior(egoTrajectory)

# ped = Pedestrian right of tempSpawnPt by 5,
#     with heading ego.heading,
#     with regionContainedIn None,
#     with behavior CrossingBehavior(ego, PED_MIN_SPEED, PED_THRESHOLD)

# require EGO_INIT_DIST[0] <= (distance to intersection) <= EGO_INIT_DIST[1]
# terminate when (distance to egoSpawnPt) > TERM_DIST

########################################################################################################################

# EGO_INIT_DIST = [20, 25]
# param EGO_SPEED = VerifaiRange(7, 10)
# param EGO_BRAKE = VerifaiRange(0.5, 1.0)

# ADV_INIT_DIST = [15, 20]
# param ADV_SPEED = VerifaiRange(7, 10)

# param SAFETY_DIST = VerifaiRange(10, 20)
# CRASH_DIST = 5
# TERM_DIST = 70

# behavior EgoBehavior(trajectory):
# 	# try:
# 		# do FollowTrajectoryBehavior(target_speed=globalParameters.EGO_SPEED, trajectory=trajectory)
# 	do FollowTrajectoryBehavior(target_speed=globalParameters.EGO_SPEED, trajectory=trajectory) # for simulating accidents
# 	# interrupt when withinDistanceToAnyObjs(self, globalParameters.SAFETY_DIST):
# 		# take SetBrakeAction(globalParameters.EGO_BRAKE)
# 	# interrupt when withinDistanceToAnyObjs(self, CRASH_DIST):
# 	# 	terminate

# intersection = Uniform(*filter(lambda i: i.is4Way, network.intersections))

# advInitLane = Uniform(*intersection.incomingLanes)
# advManeuver = Uniform(*filter(lambda m: m.type is ManeuverType.STRAIGHT, advInitLane.maneuvers))
# advTrajectory = [advInitLane, advManeuver.connectingLane, advManeuver.endLane]
# advSpawnPt = OrientedPoint in advInitLane.centerline

# egoInitLane = Uniform(*filter(lambda m:
# 		m.type is ManeuverType.STRAIGHT,
# 		advManeuver.reverseManeuvers)
# 	).startLane
# egoManeuver = Uniform(*filter(lambda m: m.type is ManeuverType.LEFT_TURN, egoInitLane.maneuvers))
# egoTrajectory = [egoInitLane, egoManeuver.connectingLane, egoManeuver.endLane]
# egoSpawnPt = OrientedPoint in egoInitLane.centerline

# ego = Car at egoSpawnPt,
# 	with blueprint MODEL,
# 	with behavior EgoBehavior(egoTrajectory)

# adversary = Car at advSpawnPt,
# 	with blueprint MODEL,
# 	with behavior FollowTrajectoryBehavior(target_speed=globalParameters.ADV_SPEED, trajectory=advTrajectory)

# require EGO_INIT_DIST[0] <= (distance to intersection) <= EGO_INIT_DIST[1]
# require ADV_INIT_DIST[0] <= (distance from adversary to intersection) <= ADV_INIT_DIST[1]
# terminate when (distance to egoSpawnPt) > TERM_DIST


########################################################################################################################


param EGO_SPEED = VerifaiRange(7, 10)
param EGO_BRAKE = VerifaiRange(0.7, 1.0)

param ADV_DIST = VerifaiRange(10, 15)
param ADV_INIT_SPEED = VerifaiRange(2, 4)
param ADV_END_SPEED = 2 * VerifaiRange(7, 10)
ADV_BUFFER_TIME = 5

LEAD_DIST = globalParameters.ADV_DIST + 10
LEAD_SPEED = globalParameters.EGO_SPEED - 4

BYPASS_DIST = [15, 10]
SAFE_DIST = 15
INIT_DIST = 50
TERM_DIST = 70
TERM_TIME = 10


behavior DecelerateBehavior(brake):
	take SetBrakeAction(brake)

behavior EgoBehavior():
	try:
		do FollowLaneBehavior(target_speed=globalParameters.EGO_SPEED)
	interrupt when (distance to adversary) < BYPASS_DIST[0]:
		fasterLaneSec = self.laneSection.fasterLane
		do LaneChangeBehavior(
				laneSectionToSwitch=fasterLaneSec,
				target_speed=globalParameters.EGO_SPEED)
		try:
			do FollowLaneBehavior(
					target_speed=globalParameters.EGO_SPEED,
					laneToFollow=fasterLaneSec.lane) \
				until (distance to adversary) > BYPASS_DIST[1]
		interrupt when (distance to lead) < SAFE_DIST:
			try:
				do DecelerateBehavior(globalParameters.EGO_BRAKE)
			interrupt when (distance to lead) > SAFE_DIST:
				do FollowLaneBehavior(target_speed=LEAD_SPEED) for TERM_TIME seconds
				terminate 

behavior AdversaryBehavior():
	do FollowLaneBehavior(target_speed=globalParameters.ADV_INIT_SPEED) \
		until self.lane is not ego.lane
	do FollowLaneBehavior(target_speed=globalParameters.ADV_END_SPEED)

behavior LeadBehavior():
	fasterLaneSec = self.laneSection.fasterLane
	do LaneChangeBehavior(
			laneSectionToSwitch=fasterLaneSec,
			target_speed=LEAD_SPEED)
	do FollowLaneBehavior(target_speed=LEAD_SPEED)

initLane = Uniform(*network.lanes)
egoSpawnPt = OrientedPoint in initLane.centerline

ego = Car at egoSpawnPt,
	with blueprint MODEL,
	with behavior EgoBehavior()

adversary = Car following roadDirection for globalParameters.ADV_DIST,
	with blueprint MODEL,
	with behavior AdversaryBehavior()

lead = Car following roadDirection for LEAD_DIST,
	with blueprint MODEL,
	with behavior LeadBehavior()

require (distance to intersection) > INIT_DIST
require (distance from adversary to intersection) > INIT_DIST
require (distance from lead to intersection) > INIT_DIST
require always (adversary.laneSection._fasterLane is not None)
terminate when (distance to egoSpawnPt) > TERM_DIST
