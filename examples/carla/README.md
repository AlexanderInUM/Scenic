1. Default options for loading car models inside CarlaUE4:
```
vehicle.tesla.model3
vehicle.volkswagen.t2
vehicle.lincoln.mkz_2017
vehicle.mini.cooper_s
vehicle.ford.mustang
vehicle.audi.tt
```





2. Run vehicles in sandbox:
```
ssh agilex@agent1

roslaunch limo_bringup limo_swarm.launch

ssh agilex@agent1

roslaunch limo_bringup limo_navigation_diff_agent.launch


-----------------------------------------------

cd ~/carla-ros-limo-holo-old/carla/imad

./CarlaUE4.sh -prefernvidia



source carla_ws/devel/setup.bash

roslaunch carla_ros_bridge run_car_sim_real_swarm.launch


cd carla_ws/src/ros-bridge/sync
python3 sync_transform_swarm.py


source scan_ws/devel/setup.bash
roslaunch pointcloud_to_laserscan pt2_to_scan_swarm.launch 

source catkin_ws/devel/setup.bash
roslaunch agilex_pure_pursuit pure_pursuit_carla_swarm.launch
```
