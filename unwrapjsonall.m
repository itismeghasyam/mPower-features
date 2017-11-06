%% unwrapjson

% Code to unwrap the accelometer json data and output the x,y,z
% accelerometer data and the timestamp values

function [xA,yA,zA,xG,yG,zG,timestamp] = unwrapjsonall(filename)

% loading the json file
acceldata = loadjson(filename);

% initializing x,y,z and timestamp vectors
xA = zeros([1,length(acceldata)]);
yA = xA;
zA = xA;
xG = xA;
yG = yA;
zG = zA;
timestamp = xA;

for i=1:length(acceldata)
    timestamp(i) = acceldata{i}.timestamp;
    [xA(i), yA(i), zA(i)] = quaternionrotate(acceldata{i});
    xG(i) = acceldata{i}.rotationRate.x;
    yG(i) = acceldata{i}.rotationRate.y;
    zG(i) = acceldata{i}.rotationRate.z;
end

end