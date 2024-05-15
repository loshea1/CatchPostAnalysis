% Create BNO055 object
bno = serialport("COM4", 115200);
configureTerminator(bno, "CR/LF");

% Initialize BNO055
write(bno, hex2dec('55'), "uint8");
write(bno, hex2dec('F4'), "uint8");
write(bno, hex2dec('0B'), "uint8");
write(bno, hex2dec('00'), "uint8");

% Time step between data points (in seconds)
dt = 0.01;

% Collect acceleration and gyroscope data
numSamples = 200;
accel = zeros(numSamples, 3);
gyro = zeros(numSamples, 3);
for i = 1:numSamples
    % Read acceleration and gyroscope data from BNO055
    write(bno, "a", "char");
    accelData = read(bno, 6, "uint8");
    
    if ~isempty(accelData)
    accel(i,:) = typecast(uint8([accelData(1) accelData(2) accelData(3)]), 'int16')'./100.0;
    end
    
    gyroData = read(bno, 6, "uint8");
    
    if ~isempty(gyroData)
    gyro(i,:) = typecast(uint8([gyroData(1) gyroData(2) gyroData(3)]), 'int16')'./16.0;
    end
    % Wait for next data point
    pause(dt);
end

% Transform acceleration data to world frame
quaternion = [1 0 0 0];
worldAccel = zeros(size(accel));
for i = 1:numSamples
    % Get orientation quaternion from BNO055
    write(bno, "o", "char");
    quatData = read(bno, 8, "uint8");
    w = typecast(uint8([quatData(1) quatData(2)]), 'int16');
    x = typecast(uint8([quatData(3) quatData(4)]), 'int16');
    y = typecast(uint8([quatData(5) quatData(6)]), 'int16');
    z = typecast(uint8([quatData(7) quatData(8)]), 'int16');
    quaternion = [w x y z]./2^14;
    % Rotate acceleration vector to world frame
    worldAccel(i,:) = quaternRotate([0 0 -9.81], quaternion);
end

% Plot acceleration and gyroscope data
t = (0:numSamples-1)*dt;
figure;
subplot(2,1,1);
plot(t, accel(:,1), 'r', t, accel(:,2), 'g', t, accel(:,3), 'b');
xlabel('Time (s)');
ylabel('Acceleration (m/s^2)');
legend('X', 'Y', 'Z');
subplot(2,1,2);
plot(t, gyro(:,1), 'r', t, gyro(:,2), 'g', t, gyro(:,3), 'b');
xlabel('Time (s)');
ylabel('Angular Velocity (deg/s)');
legend('X', 'Y', 'Z');

% Close serial port
clear bno;
