%% unwrapjson

% Code to unwrap the accelometer json data and output the x,y,z
% accelerometer data and the timestamp values


function [x,y,z,timestamp] = unwrapjson(filename)

% loading the json file
acceldata = loadjson(filename);

% initializing x,y,z and timestamp vectors
x = zeros([1,length(acceldata)]);
y = x;
z = x;
timestamp = x;

% initializing the quaternion values
q1_attitude = x;
q2_attitude = x;
q3_attitude = x;
q0_attitude = x;



for i=1:length(acceldata)
    timestamp(i) = acceldata{i}.timestamp;
    [x(i), y(i), z(i)] = quaternionrotate(acceldata{i});
end



end