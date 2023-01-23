urlwrite("https://raw.githubusercontent.com/cghiuganiastate/cghiuganiastate/main/quaternion2.csv","quaternion2.csv");
urlwrite("https://raw.githubusercontent.com/cghiuganiastate/cghiuganiastate/main/quat2eul.m","quat2eul.csv");
q = csvread("quaternion2.csv");
e = quat2eul(q);
plot(e);
