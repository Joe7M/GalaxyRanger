t = 0:0.1:4000;

XA =  400;  %639;
XB =  -0.00000003;     %-0.0002;
XC =  2000;  %0;
XD =  3;      %2;
x = XA + XB*(t - XC).^XD;

YA = 300;
YB = -0.1;
YC = 0;
YD = 1;
y = YA + YB*(t - YC).^YD;



figure(1)
subplot(2,2,1)
plot(x,y)
subplot(2,2,2)
plot (x,y)
xlim([0,639])
ylim([0,480])
subplot(2,2,3)
plot (t,x)
ylim([0,640])
subplot(2,2,4)
plot (t,y)
ylim([0,480])


disp(x(1))
disp(y(1))