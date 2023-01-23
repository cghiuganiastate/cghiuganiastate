function [quat] = eul2quat(e)
%Function eul2quat takes as input euler angles in ZYX order
%Outputs a quaternion of format "w x y z" (JPL convention)
%Should be functionally equivalent to matlabs eul2quat with only one input
  s1 = sin(e(:,1)/2);
  s2 = sin(e(:,2)/2);
  s3 = sin(e(:,3)/2);
  c1 = cos(e(:,1)/2);
  c2 = cos(e(:,2)/2);
  c3 = cos(e(:,3)/2);
  %quat = [cos(e(:,1)/2);sin(e(:,1)/2);0;0]'.*([cos(e(:,3)/2);0;0;sin(e(:,3)/2)].*[cos(e(:,2)/2);0;sin(e(:,2)/2);0]');
  quat = [...
  c3.*c2.*c1+s3.*s2.*s1,...
  s3.*c2.*c1-c3.*s2.*s1,...
  c3.*s2.*c1+s3.*c2.*s1,...
  c3.*c2.*s1-s3.*s2.*c1];
  %test cases
  %e = [0 pi/2 0; pi/2 0 0; 0 0 pi/2];
end
