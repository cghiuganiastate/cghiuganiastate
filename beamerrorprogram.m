clear,clc
close
%Note: Code was tested with gnu octave 7.1.0
%you will at minimum have to move functions to the end
digitsOld = digits(500);
E = 70e9 % Youungs modulus, Pa
L = 1 %Length of bar
A = .02*.02 %area of beam, 2cm by 2cm
vpa(I)  = 4/3/100000000 %moment of inertia of beam

%------Code for running one beam------
%Pa %m %m^2 %m^4
b = [E L A I;]; %beams  %[e l a i]
%force vector %x y theta for each node
fd = [0,0,0, 0,1500,0]'; %N node 1 2 3 %direct force
fe = [0]; %equivalent forces for moments/distrubuted loads
f = fd+fe;
%Boundary Condition, specify free nodes, x y theta for each node
bc = [4:6]; %nodes by 3s
[kg,u1,up,ffin] = beamcalc(b,f,bc); %storing as u1,so we can compare later.
%u is displacement/rotation vector, ffin is force/moment vector
u1
%------Code for running many beams------
startingdivisions = 100
divisionincrement = 10
enddivisions = 1000
%preallocating vector
sv = zeros((enddivisions-startingdivisions+divisionincrement)/divisionincrement,5);
%tic
for i = startingdivisions:divisionincrement:enddivisions
  tic
  l_i = L/i; % divides element to keep length constant
  lastelem=(i+1)*3;
  b = [repmat([E l_i A I;],[i,1])];
  f = [repmat([0,0,0],[1,i]),0,1500,0]';
  bc = [4:lastelem];
  [kg,u,up,ffin] = beamcalc(b,f,bc);
  sv((i-startingdivisions+divisionincrement)/divisionincrement,:)= [i,u(lastelem),u(lastelem-1),l_i,toc]; %stores values, add more to store more lol
  (i-startingdivisions+divisionincrement)/divisionincrement%uncomment to print loop number
end
sizeans=size(sv);
plot(sv(:,1),sv(:,3)-u1(5),'-o')
hold on
plot(sv(:,1),zeros([1,sizeans(1)]),'DisplayName','Zero Line')
ylabel('Signed Displacement Error (m)')
xlabel('Number of Elements')
title('Displacement Error vs Number of Elements')
axis tight
legend('Displacement Error (m)','Zero Line')
hold off
function [kl] = kl_f(b) %kl frame
  %[e l a i]
  e=b(1); %local beam frame
  l=b(2);
  a=b(3);
  i=b(4);

  vpa(v) = e*a/l;
  vpa(w) = e*i*12/l^3;
  vpa(x) = e*i*6/l^2;
  vpa(y) = e*i*4/l;
  vpa(z) = e*i*2/l;
  vpa(kl) =[...
  v  0  0 -v  0  0; %also includes x direciton v constant.
  0  w -x  0 -w -x;
  0 -x  y  0  x  z;
  -v 0  0  v  0  0;
  0 -w  x  0  w  x;
  0 -x  z  0  x  y;];
end
function [t] = t_f(theta) %t frame
  vpa(theta = deg2rad(theta)); %rotating beams to global coordinate system
  vpa(a = [cos(theta),sin(theta),0;...
  -sin(theta),cos(theta),0;...
   0, 0, 1]);
  vpa(z = zeros(3));
  vpa(t = [a,z;z,a]);
end
function [kg] = kg_f(theta,b,a) %kg frame
   kg = t_f(theta)^-1*kl_f(b(a,:))*t_f(theta); %helper function to rotate frame
end
function [kg,u,up,ffin]= beamcalc(b,f,bc)
  %beamcalc takes as input the beam parameters, force column vector, and boundry condition vectorize
  %function returns the global k matrix, the displacement matrix, the bound displacment matrix
  %and the force matrix
  %(theta,b,a)
  beamamount = size(b); %number of beams in problem
  beamamount = beamamount(1);
  for i = 1:beamamount
    kgu(:,:,i)= kg_f(0,b,i); %kg unified matrix with all the values in the global CS
  end
  %------assembly------
  %note:currently, program is set so that each point is in line with the next
  %if you want to use it otherwise, you will have to manually assemble the matrix. Good luck!
  kgsize=(beamamount+1)*3;%all the points plus 1
  kg=zeros(kgsize); %size of final assembled matrix. all bars have two sides, plus the end
  kgusize = size(kgu); %unfortunate naming, but necessary to be matlab compatible
  kgusize = kgusize(1); %x1 y1 theta1 x2 y2 theta2 %kg matrix size of each local matrix
  range = kgusize; %always dividable by 2(its the first point and the second point, each a vector with 3 values)
  ai=1:range;
  for i=1:beamamount %how many trusses
    kg(ai,ai) = kg(ai,ai)+kgu(:,:,i); %add values from kg unified matrix
    ai = ai+range/2*ones(1,range);%shifts the window over by 3
  end
  kg; %verify this by hand
  %------apply bc------
  kgp = kg; %kg prime
  kgp = kgp(bc,bc);%extracting valid rows/columns(ones that arent constrained)
  %------calculate diplacements of kgp matrix------
  up = kgp^-1*f(bc); %solving displacement from force %u prime
  %------post processing------
  u = zeros(kgsize,1);
  u(bc) = u(bc)+up; %mm
  ffin= kg*u; %final force, useful for checking against f up^
end