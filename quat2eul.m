function [eul] = quat2eul(q)
%Function quat2eul takes as input a quaternion of format "w x y z" (JPL convention)
%Outputs euler angles in ZYX order
%Should be functionally equivalent to matlabs quat2eul with only one input
  q = q./sqrt(sum(q.^2,2));
  %q=q/norm(q);
  eul = [atan2(2*(q(:,1).*q(:,4)+q(:,2).*q(:,3)),1-2*(q(:,3).^2+q(:,4).^2)),...
  asin(2*(q(:,1).*q(:,3).-q(:,2).*q(:,4))),...
  atan2(2*(q(:,1).*q(:,2)+q(:,3).*q(:,4)),1-2*(q(:,2).^2+q(:,3).^2))];
  %test cases
  %q = [1 1 0 0; 1 0 1 1; 1 1 1 1;0 pi/2 0 0];
end
%urlwrite("https://raw.githubusercontent.com/cghiuganiastate/cghiuganiastate/main/quaternion2.csv","quaternion2.csv")
