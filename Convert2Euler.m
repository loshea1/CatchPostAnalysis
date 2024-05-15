clearvars -except ALL

angle = zeros(140, length(ALL));

for i = 1: length(ALL)
    for j = 1:length(ALL(i).Data.Ypos)
        q(j, :) = [1, 0, 0, ALL(i).Data.Ypos(j)]; %Construct the full orientation quaternion
    end
    
    eulerAngles = quat2eul(q);
    eulerAngles(:, 3) = [];
    eulerAngles(:, 2) = [];
    eulerAngles = vertcat(eulerAngles, zeros(length(angle)-length(eulerAngles), 1));
    
    angle(:, i) = eulerAngles;
end

%%
close all
% Constants for quaternion conversion
g = [0; 0; 1];  % Gravity vector in sensor frame
e1 = [1; 0; 0];  % Unit vector in world frame along x-axis

data = readmatrix('G12_ROM.xlsx');

% Loop through each y position point
for i = 1:length(data)
    % Convert y position to quaternion
    %q = [event.orientation.w, event.orientation.x, event.orientation.y, event.orientation.z];
    q = [1, data(i, 3), data(i,4), data(i, 5)];
    
    % Convert quaternion to rotation matrix
    R = quat2rotm(q);
    
    % Calculate pitch angle
    g_world = R * g;  % Gravity vector in world frame
    pitch(i) = atan2d(dot(g_world, cross(R * e1, g_world)), dot(cross(R * e1, g_world), cross(R * e1, g_world)));
    roll(i) = atan2d(dot(g_world, cross(R * [0; 1; 0], g_world)), dot(cross(R * [0; 1; 0], g_world), cross(R * [0; 1; 0], g_world)));
    yaw(i) = atan2d(dot(R * [0; 0; 1], [0; 0; 1]), dot(R * [1; 0; 0], [0; 0; 1]));
end

plot(pitch)
hold on
plot(roll)
plot(yaw)
legend ('pitch', 'roll', 'yaw')
