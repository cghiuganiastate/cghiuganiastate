urlwrite("https://raw.githubusercontent.com/cghiuganiastate/cghiuganiastate/main/quaternion2.csv","quaternion2.csv");
urlwrite("https://raw.githubusercontent.com/cghiuganiastate/cghiuganiastate/main/quat2eul.m","quat2eul.m");
urlwrite("https://raw.githubusercontent.com/cghiuganiastate/cghiuganiastate/main/eul2quat.m","eul2quat.m");
q = csvread("quaternion2.csv");
e = quat2eul(q);
q2 = eul2quat(e);
plot(q);
figure;
plot(q2);
